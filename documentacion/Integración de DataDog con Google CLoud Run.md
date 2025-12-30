## 1. Métodos de Integración

A la hora de integrar Datadog con Google Cloud Run en aplicaciones containerizadas, existen **dos métodos de instrumentación**: In-Container y Sidecar. Ambos utilizan la imagen `datadog/serverless-init` y la librería `ddtrace`, pero cambian completamente en su arquitectura de despliegue.

![[Pasted image 20251230095157.png]]

### **1.1 Método In-Container**
En In-Container desplegamos **un único contenedor** que incluye tanto nuestro código Python con ddtrace como el serverless-init copiado durante el build. Todo está empaquetado junto: la aplicación captura trazas con ddtrace,  los logs se escriben a stdout/stderr y el serverless-init los captura automáticamente para enviar todo a Datadog. Es simple, rápido de implementar, pero genera imágenes más pesadas.
### **1.2 Método Sidecar:**
En Sidecar se despliegan **dos contenedores separados** que corren en paralelo. El Contenedor 1 tiene solo nuestra aplicación y expone el puerto 8080 al exterior. El Contenedor 2 ejecuta serverless-init como agente independiente. Se comunican mediante tres canales: métricas custom por `localhost:8125`, logs a través de un volumen compartido en `/shared-volume/logs/`, y trazas automáticamente. Más complejo, pero imágenes más ligeras y mejor separación de responsabilidades.

---
## 2. Dockerfiles
A continuación se van a mostrar los **Dockerfiles necesarios para cada método de integración**, de forma que se vean claramente las diferencias entre In-Container y Sidecar a nivel de imagen y configuración de la aplicación.

- En el caso de **In-Container**, el Dockerfile copia el binario `serverless-init` dentro de la imagen con `COPY --from=datadog/serverless-init:1`, configura variables de entorno de Datadog (`DD_SITE`, `DD_SERVICE`, `DD_LOGS_ENABLED`), y usa `ENTRYPOINT ["/app/datadog-init"]` para que serverless-init actúe como wrapper: envuelve la aplicación, captura automáticamente logs de stdout/stderr y trazas, y los envía a Datadog. Todo en un solo contenedor.

```Dockerfile
FROM python:3.13-slim

WORKDIR /app

# Instalar ca-certificates (requerido para slim images)
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates

# Instalar dependencias Python
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

ENV PORT=8080
EXPOSE 8080

# Copiar serverless-init desde la imagen de Datadog
COPY --from=datadog/serverless-init:1 /datadog-init /app/datadog-init

COPY . .

# Configurar variables de entorno de Datadog
ARG DD_SERVICE
ENV DD_SITE=datadoghq.com \
    DD_SERVICE=${DD_SERVICE} \
    DD_SOURCE=python \
    DD_LOGS_ENABLED=true \
    PYTHONUNBUFFERED=1

# ENTRYPOINT usa serverless-init como wrapper
ENTRYPOINT ["/app/datadog-init"]

# CMD ejecuta tu aplicación con ddtrace-run
CMD ["ddtrace-run", "python", "app.py"]
```

- El caso de **Sidecar** es más simple: solo instala dependencias y ejecuta la aplicación con `ddtrace-run`. **No incluye `serverless-init`** ni variables de Datadog porque el agente va en un contenedor separado que se añade después durante el despliegue. La imagen solo ejecuta la app.

```Dockerfile
FROM python:3.13-slim

WORKDIR /app

# Instalar dependencias Python
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

ENV PORT=8080
EXPOSE 8080

# SIN serverless-init - Dockerfile más simple
CMD ["ddtrace-run", "python", "app.py"]
```

---
### 3. Código fuente
En este apartado se muestra el código fuente Python de las aplicaciones de ejemplo proporcionadas por Datadog para cada método de instrumentación.

- El código de In‑Container es más simple: usa `structlog` para escribir logs en formato JSON directamente a `sys.stdout` (salida estándar), que `serverless-init` captura automáticamente. La función `tracer_injection` añade automáticamente datos de correlación de trazas (trace_id, span_id) a cada log usando `tracer.get_log_correlation_context()`. No necesita configurar rutas de archivos ni inicializar DogStatsD manualmente porque todo lo gestiona el wrapper de `serverless-init`.

```python
from ddtrace import tracer
from flask import Flask
import structlog
import sys

# Configurar structlog para logs en formato JSON
def tracer_injection(logger, log_method, event_dict):
    event_dict.update(tracer.get_log_correlation_context())
    return event_dict

structlog.configure(
    processors=[
        tracer_injection,
        structlog.processors.EventRenamer("msg"),
        structlog.processors.JSONRenderer()
    ],
    logger_factory=structlog.WriteLoggerFactory(file=sys.stdout),
)

logger = structlog.get_logger()
app = Flask(__name__)

@app.route('/')
def hello_world():
    logger.info("Hello world!")
    return 'Hello World!', 200

if __name__ == '__main__':
    logger.info("starting server on port 8080")
    app.run(host='0.0.0.0', port=8080)

```

- El código de Sidecar requiere más configuración manual: primero inicializa `datadog.initialize()` apuntando a `localhost:8125` para enviar métricas al contenedor sidecar. Luego configura el logging con dos handlers: uno escribe a un archivo en `/shared-volume/logs/app.log` que el sidecar leerá, y otro a `stdout` para logs de Cloud Run. El formato de log incluye manualmente los campos de correlación (`dd.trace_id`, `dd.span_id`, `dd.service`, `dd.env`, `dd.version`). Además, envía métricas custom explícitamente con `datadog.statsd.distribution()` al puerto 8125 del sidecar.

```python
import logging
import sys
import os
import datadog
from flask import Flask

# Inicializar DogStatsD apuntando al sidecar
datadog.initialize(
    statsd_host="127.0.0.1",  # localhost (mismo pod)
    statsd_port=8125,         # Puerto del sidecar
)

app = Flask(__name__)

# Logs van a un ARCHIVO en volumen compartido
LOG_FILE = os.environ.get(
    "DD_SERVERLESS_LOG_PATH", "/shared-volume/logs/*.log"
).replace("*.log", "app.log")

# Crear directorio si no existe
os.makedirs(os.path.dirname(LOG_FILE), exist_ok=True)

# Formato con correlación trace/log
FORMAT = ('%(asctime)s %(levelname)s [%(name)s] [%(filename)s:%(lineno)d] '
          '[dd.service=%(dd.service)s dd.env=%(dd.env)s dd.version=%(dd.version)s '
          'dd.trace_id=%(dd.trace_id)s dd.span_id=%(dd.span_id)s] - %(message)s')

# Logs van a ARCHIVO + stdout
logging.basicConfig(
    level=logging.INFO,
    format=FORMAT,
    handlers=[
        logging.FileHandler(LOG_FILE),  # Para el sidecar
        logging.StreamHandler(sys.stdout)  # Para Cloud Run logs
    ]
)

logger = logging.getLogger(__name__)

@app.route('/')
def home():
    logger.info("Hello world!")
    
    # Enviar métrica custom al sidecar
    datadog.statsd.distribution("our-sample-app.sample-metric", 1)
    return 'Hello World!', 200

if __name__ == '__main__':
    logger.info("starting server on port 8080")
    app.run(host='0.0.0.0', port=8080)
```

---
## 4. Scripts
Finalmente, en este apartado se muestran los scripts de despliegue de cada método.

- El script de In‑Container es directo: valida variables, construye la imagen Docker que ya incluye `serverless-init`, la sube a Artifact Registry y despliega con un único comando `gcloud run deploy` pasando todas las variables de Datadog (`DD_API_KEY`, `DD_SITE`, `DD_ENV`, `DD_VERSION`) mediante `--set-env-vars`. Son solo 3 pasos: build, push y deploy. No requiere herramientas adicionales más allá de `gcloud` y `docker`.

```bash
#!/bin/bash
set -e

# Validar variables requeridas
PROJECT_ID=${PROJECT_ID:?required but not set}
GCP_PROJECT_NAME=${GCP_PROJECT_NAME:?required but not set}
DD_SERVICE=${DD_SERVICE:?required but not set}
REPO_NAME=${REPO_NAME:?required but not set}
DD_API_KEY=${DD_API_KEY:?required but not set}
DD_SITE=${DD_SITE:-datadoghq.com}
REGION=${REGION:-us-central1}
DD_ENV=${DD_ENV:-dev}
DD_VERSION=${DD_VERSION:-latest}

IMAGE_NAME="${REGION}-docker.pkg.dev/${PROJECT_ID}/${REPO_NAME}/${GCP_PROJECT_NAME}:${DD_VERSION}"

# Build y push
echo "====== Building Docker image ======"
docker build --platform linux/amd64 --build-arg DD_SERVICE=${DD_SERVICE} -t ${IMAGE_NAME} .
docker push ${IMAGE_NAME}

# Deploy a Cloud Run con TODAS las variables de Datadog
echo "====== Deploying to Cloud Run ======"
gcloud run deploy $GCP_PROJECT_NAME \
  --image=$IMAGE_NAME \
  --region=$REGION \
  --platform=managed \
  --allow-unauthenticated \
  --memory=1024Mi \
  --cpu=1 \
  --port=8080 \
  --set-env-vars=DD_API_KEY=$DD_API_KEY,DD_SITE=$DD_SITE,DD_ENV=$DD_ENV,DD_VERSION=$DD_VERSION \
  --update-labels=service=$DD_SERVICE,env=$DD_ENV \
  --project=$PROJECT_ID

echo "====== Deployment completed ======"
```

- El script de Sidecar es más complejo: después de construir y desplegar la imagen de la aplicación (sin `serverless-init`), añade dos pasos críticos. Primero exporta `DATADOG_API_KEY` y `DATADOG_SITE` como variables de entorno del shell y ejecuta `npx @datadog/datadog-ci cloud-run instrument` para añadir el contenedor sidecar al servicio existente. Segundo, ejecuta `gcloud run services update` con `--update-env-vars` para configurar todas las variables de Datadog en ambos contenedores. Son 5 pasos en total y requiere la herramienta `datadog-ci` (via npx).

```bash
#!/bin/bash
set -e

# Validar variables requeridas
PROJECT_ID=${PROJECT_ID:?required but not set}
GCP_PROJECT_NAME=${GCP_PROJECT_NAME:?required but not set}
DD_SERVICE=${DD_SERVICE:?required but not set}
REPO_NAME=${REPO_NAME:?required but not set}
DD_API_KEY=${DD_API_KEY:?required but not set}
DD_SITE=${DD_SITE:?required but not set}
REGION=${REGION:-us-central1}
DD_ENV=${DD_ENV:-dev}
DD_VERSION=${DD_VERSION:-1.0.0}

IMAGE_NAME="${REGION}-docker.pkg.dev/${PROJECT_ID}/${REPO_NAME}/${GCP_PROJECT_NAME}:${DD_VERSION}"

# Build y push (sin serverless-init)
echo "====== Building Docker image ======"
docker build --platform linux/amd64 -t ${IMAGE_NAME} .
docker push ${IMAGE_NAME}

# Deploy inicial (sin Datadog)
echo "====== Deploying to Cloud Run ======"
gcloud run deploy $GCP_PROJECT_NAME \
  --image=$IMAGE_NAME \
  --region=$REGION \
  --platform=managed \
  --allow-unauthenticated \
  --memory=1024Mi \
  --cpu=1 \
  --port=8080 \
  --update-labels=service=$DD_SERVICE \
  --project=$PROJECT_ID

# PASO ADICIONAL: Instrumentar con datadog-ci (añade sidecar)
echo "====== Instrumenting with datadog-ci ======"
export DATADOG_API_KEY=$DD_API_KEY
export DATADOG_SITE=$DD_SITE

npx -y @datadog/datadog-ci cloud-run instrument \
  --project=$PROJECT_ID \
  --region=$REGION \
  --service=$GCP_PROJECT_NAME \
  --sidecar-image=datadog/serverless-init:1

# Configurar variables en ambos contenedores
echo "====== Configuring Datadog environment variables ======"
gcloud run services update $GCP_PROJECT_NAME \
  --region=$REGION \
  --update-env-vars=DD_API_KEY=$DD_API_KEY,DD_SITE=$DD_SITE,DD_SERVICE=$DD_SERVICE,DD_ENV=$DD_ENV,DD_VERSION=$DD_VERSION

echo "====== Deployment completed with SIDECAR ======"
```

---

## 5. Variables de entorno
A continuación se detalla la configuración de variables de entorno necesarias para cada método de instrumentación. Estas variables controlan el comportamiento del agente de Datadog, la captura de trazas, el envío de logs y la identificación del servicio.

| Variable                   | Descripción                                                                                                    | In-Container               | Sidecar        | Contenedor                                   |
| -------------------------- | -------------------------------------------------------------------------------------------------------------- | -------------------------- | -------------- | -------------------------------------------- |
| **DD_API_KEY**             | Clave de autenticación de Datadog para enviar datos a tu cuenta.                                               | ✅ Requerida                | ✅ Requerida    | Principal (In-Container) / Sidecar (Sidecar) |
| **DD_SITE**                | Región de Datadog donde se envían los datos (ej: `datadoghq.com`, `datadoghq.eu`).                             | ✅ Requerida                | ✅ Requerida    | Principal (In-Container) / Sidecar (Sidecar) |
| **DD_SERVICE**             | Nombre del servicio en Datadog. Identifica tu aplicación en el catálogo de servicios y dashboards              | ✅ Requerida                | ✅ Requerida    | Ambos                                        |
| **DD_ENV**                 | Entorno de ejecución (dev, staging, prod).                                                                     | 🟡 Recomendada             | 🟡 Recomendada | Ambos                                        |
| **DD_VERSION**             | Versión del código desplegado. Permite comparar performance entre versiones y detectar regresiones             | 🟡 Recomendada             | 🟡 Recomendada | Ambos                                        |
| **DD_LOGS_ENABLED**        | Activa el envío de logs desde stdout/stderr a Datadog. Por defecto es `false`                                  | ✅ Requerida (Dockerfile)   | ❌ No necesaria | Principal (In-Container)                     |
| **DD_SERVERLESS_LOG_PATH** | Ruta del archivo donde el sidecar lee los logs. Por defecto `/shared-volume/logs/app.log`                      | ❌ No necesaria             | 🟡 Recomendada | Sidecar                                      |
| **DD_LOGS_INJECTION**      | Enriquece logs con datos de trazas (trace_id, span_id) para correlación automática                             | 🟡 Recomendada             | 🟡 Recomendada | Principal (In-Container) / App (Sidecar)     |
| **DD_SOURCE**              | Define el origen de logs para aplicar pipeline de parsing específico (ej: `python`). Por defecto es `cloudrun` | ✅ Recomendada (Dockerfile) | 🟡 Recomendada | Principal (In-Container) / Sidecar (Sidecar) |
| **PYTHONUNBUFFERED**       | Fuerza a Python a escribir logs inmediatamente sin buffer, evitando pérdida de logs en crashes                 | ✅ Requerida (Dockerfile)   | ✅ Recomendada  | Principal (ambos)                            |
| **DD_TAGS**                | Etiquetas personalizadas en formato `key:value` separadas por comas para categorizar datos                     | 🟡 Opcional                | 🟡 Opcional    | Principal (In-Container) / Sidecar (Sidecar) |

---
## 6. Fuentes utilizadas
A continuación se detallan las fuentes oficiales utilizadas para la elaboración de esta documentación. Todos los ejemplos de código, configuraciones y mejores prácticas provienen de la documentación oficial de Datadog y del repositorio de aplicaciones de ejemplo en GitHub.

- **Método In-Container para Python**: [https://docs.datadoghq.com/serverless/google_cloud_run/containers/in_container/python/](https://docs.datadoghq.com/serverless/google_cloud_run/containers/in_container/python/)
- **Método Sidecar para Python**: [https://docs.datadoghq.com/serverless/google_cloud_run/containers/sidecar/python/?tab=datadogcli](https://docs.datadoghq.com/serverless/google_cloud_run/containers/sidecar/python/?tab=datadogcli)
- **Repositorio GitHub de Datadog**: [https://github.com/DataDog/serverless-gcp-sample-apps/tree/main/cloud-run](https://github.com/DataDog/serverless-gcp-sample-apps/tree/main/cloud-run)
