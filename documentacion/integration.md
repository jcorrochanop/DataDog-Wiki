# Integración con GCP

La integración nativa GCP te da visibilidad “desde fuera” de los recursos cloud (métricas de plataforma), y el Agent añade una capa “desde dentro” de cada host/servicio (SO, procesos, apps, logs, APM y métricas custom).

## Concepto: integración vs Agent

- **Integración GCP**: Datadog se conecta a la API de Cloud Monitoring y consulta métricas de los recursos GCP (GCE, Cloud Run, Pub/Sub, Cloud SQL, LB, etc.), más metadata/labels y estados de esos recursos.
- **Datadog Agent**: es un proceso que corre dentro de la VM, contenedor o pod, y desde ahí colecciona métricas de sistema, integra software (Nginx, DBs, etc.), envía logs y trazas, y permite métricas custom; es una capa adicional que ve lo que la plataforma cloud no expone.

Con una sola VM de GCP puedes pensar en 3 capas: plataforma GCP, sistema operativo y aplicación. La integración nativa solo cubre la primera; el Agent añade la segunda, y con integraciones/APM llegas a la tercera.

## Capa 1: solo integración GCP (sin Agent)

Aquí Datadog “mira” la VM desde fuera, a través de Cloud Monitoring.
En una VM concreta puedes ver:
- Si la VM está encendida/apagada, en qué zona/proyecto está y sus labels de GCP.
- CPU global de la instancia, tráfico de red, I/O de disco, uptime y errores/reportes que GCE exponga como métrica.

Esta capa te sirve para saber si la VM existe, está viva, cuánto CPU/IO consume y cómo se comporta como recurso de infraestructura cloud.

## Capa 2: integración GCP + Datadog Agent en la VM

Al instalar el Agent, Datadog entra “dentro” del sistema operativo.
En esa misma VM pasas a ver:
- Memoria real usada/libre, swap, cache, uso de disco por partición, load average, procesos que consumen CPU, etc. (`system.*`).
- Detalle de contenedores/pods locales (si la VM corre Docker/K8s), y tags propios del host como env, service, owner.

Con esta capa ya puedes responder “qué proceso está comiendo la RAM/CPU de esta VM” y no solo “esta VM usa mucha CPU desde el punto de vista de GCP”.

## Capa 3: integración GCP + Agent + integraciones/APM

Si además configuras integraciones y APM en esa VM, Datadog ve “la lógica” de tus servicios.
En esa VM podrías ver:
- Métricas específicas de Nginx, Postgres, Redis, JVM, etc. (requests, queries, conexiones, caches, errores).
- Trazas de tus aplicaciones (APM): qué endpoints se llaman, cuánto tardan, dónde se producen errores, cuántas peticiones por segundo pasan por cada servicio.
- Métricas de negocio custom (pedidos/minuto, jobs en cola, usuarios activos) que tú mandas al Agent o a la API.

## Resumen

Resumiendo con una VM:  
- Solo integración GCP → “la VM como recurso de GCP” (estado, CPU/IO/red, uptime).
- + Agent → “la VM por dentro” (memoria, disco, procesos, contenedores, logs básicos).
- + integraciones/APM → “lo que hace la app en esa VM” (endpoints, queries, negocio, errores).

## Flujo de comunicación DataDog<->VM

La persona que crea la service account necesita permisos para crear identidades, darles roles y habilitar APIs; la propia service account necesita permisos de solo lectura sobre métricas y recursos GCP para que Datadog pueda ver tu proyecto.

## Roles del usuario que crea la service account

| Rol en GCP (usuario humano)       | Propósito principal                                                                                 |
|-----------------------------------|------------------------------------------------------------------------------------------------------|
| `roles/iam.serviceAccountAdmin`   | Crear, actualizar y borrar service accounts (por ejemplo, `datadog-integration`).  |
| `roles/resourcemanager.projectIamAdmin` | Conceder roles IAM sobre el proyecto a la nueva service account (añadir `compute.viewer`, etc.).  |
| `roles/serviceusage.admin`        | Habilitar y deshabilitar APIs del proyecto (Monitoring, Compute, Cloud Asset, Cloud Resource Manager).  |
| (Opcional) `roles/browser`        | Ver recursos del proyecto en la consola para depurar/validar la integración.  |

## Roles de la service account usada por Datadog

| Rol en GCP (service account Datadog)      | Propósito dentro de la integración GCP ↔ Datadog                                                   |
|------------------------------------------|-----------------------------------------------------------------------------------------------------|
| `roles/monitoring.viewer`                | Leer todas las métricas de Cloud Monitoring del proyecto (CPU GCE, Cloud Run, Pub/Sub, etc.).  |
| `roles/compute.viewer`                   | Ver instancias de Compute Engine, metadatos, etiquetas, discos y redes asociadas.  |
| `roles/cloudasset.viewer`                | Descubrir y listar recursos del proyecto (inventario GCP) para mapearlos en Datadog.  |
| `roles/browser`                          | Permiso de lectura genérico sobre recursos del proyecto (complementa al resto para navegación).  |
| `roles/serviceusage.serviceUsageConsumer`| Consumir APIs ya habilitadas (Cloud Monitoring, Compute, Cloud Asset, etc.) sin necesidad de admin.  |
| `roles/iam.serviceAccountTokenCreator` (en la SA de Datadog STS) | Permite que el principal de Datadog genere tokens de acceso “asumiendo” tu service account, en modo STS.  |


## Comunicación de la VM con Datadog cuando hay Agent

Con el Agent instalado en la VM, el flujo es siempre “saliente” desde la máquina hacia Datadog, no al revés.

- El Agent corre como proceso local en la VM, recoge métricas de sistema (`system.*`), integraciones y logs.
- El Agent abre conexiones **salientes HTTPS (TCP 443)** a los endpoints de Datadog de tu site (por ejemplo `api.datadoghq.eu`, `agent-http-intake.datadoghq.eu`), y por ahí envía métricas, logs y trazas.
- Opcionalmente, la app habla con el Agent por puertos locales (8125/UDP para DogStatsD, 8126/TCP para APM) dentro de la misma VM o red privada; el Agent vuelve a enviar todo a Datadog vía HTTPS saliente.
- No hace falta abrir puertos de **entrada** hacia la VM solo para Datadog; lo único crítico es permitir salida a Internet (o a un proxy corporativo) hacia los dominios de Datadog en el puerto 443.


