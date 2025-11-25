# Instalación del Agente de Datadog en un Clúster Kubernetes

Este documento describe los pasos necesarios para instalar y configurar el agente de Datadog en un clúster Kubernetes, incluyendo la preparación del entorno, la autenticación con Google Cloud, y el despliegue del agente mediante Helm.

---

## 1. Configurar el repositorio del SDK de Google Cloud

```bash
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
```

Este comando añade el repositorio oficial de Google Cloud SDK al listado de orígenes de paquetes de APT. Es necesario para poder instalar herramientas relacionadas con Google Cloud actualizadas.

---

## 2. Importar la clave GPG del repositorio

```bash
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg
```

Aquí se descarga la clave pública GPG que asegura la integridad y autenticidad del repositorio añadido. La clave se convierte al formato compatible con el sistema de paquetes APT.

---

## 3. Actualizar repositorios e instalar plugins necesarios

```bash
sudo apt-get update
sudo apt-get install google-cloud-sdk-gke-gcloud-auth-plugin
```

Con estos comandos se actualiza la lista de paquetes disponibles y se instala el plugin de autenticación para Google Kubernetes Engine (GKE), necesario para la conexión y gestión del clúster.

---

## 4. Autenticación y configuración del clúster Kubernetes

```bash
gcloud container clusters get-credentials my-datadog-cluster --zone=us-south1-b --project=balmy-mile-452912-p6
```

Este comando configura tu entorno local para conectarse al clúster Kubernetes llamado "my-datadog-cluster" en la zona especificada, importando las credenciales necesarias para operar con kubectl y otros clientes.

---

## 5. Añadir y actualizar el repositorio Helm de Datadog

```bash
helm repo add datadog https://helm.datadoghq.com
helm repo update
```

Se agrega el repositorio oficial de charts de Helm para Datadog y se actualizan los repositorios locales para obtener la última versión de los charts.

---

## 6. Exportar la variable de entorno para la API Key de Datadog

```bash
echo 'export DD_API_KEY=7246...' >> ~/.bashrc
source ~/.bashrc
```

Aquí se establece la clave API de Datadog en una variable de entorno para facilitar su reutilización en la instalación del agente y se recarga la configuración del shell para que el cambio surta efecto inmediato.

---

## 7. Crear el namespace de Kubernetes para Datadog

```bash
kubectl create namespace datadog
```

Se crea un namespace dedicado en Kubernetes para aislar los recursos relacionados con Datadog, mejorando la organización y la gestión del clúster.

---

## 8. Instalar el agente de Datadog con Helm

```bash
helm install datadog-agent datadog/datadog \
  --namespace datadog \
  --set datadog.apiKey=$DD_API_KEY \
  --set datadog.site=datadoghq.eu \
  --set datadog.logs.enabled=true \
  --set datadog.logs.containerCollectAll=true \
  --set datadog.apm.enabled=true \
  --set datadog.processAgent.enabled=true \
  --set datadog.containerExclude="name:datadog-agent" \
  --set datadog.tags[0]="env:gke" \
  --set datadog.tags[1]="project:datadog-monitoring" \
  --set datadog.tags[2]="owner:jcorrochano"
```

Este comando despliega el agente de Datadog en el namespace previamente creado, pasando variables de configuración como la API key, la región del sitio Datadog, habilitación de logs, APM, y procesos, además de excluir el propio agente y asociar etiquetas para facilitar la gestión y filtrado desde Datadog.

