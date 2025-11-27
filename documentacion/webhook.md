# Ejercicio Práctico: Autoscalado por Webhook entre Datadog y GKE

**Introducción:**  
Este ejercicio muestra cómo montar un flujo automático de monitorización y respuesta en Kubernetes:  
- Desplegar un clúster GKE  
- Añadir monitorización con Datadog  
- Automatizar el escalado de pods vía webhook y Google Cloud Function si se dispara una alerta de CPU alta

---

## Lista de pasos

1. Crea un clúster GKE de pruebas (mínimo 2 nodos)
2. Despliega un deployment (nginx) con réplicas mínimas
3. Instala el agente de Datadog mediante Helm
4. Crea un monitor en Datadog que detecte >80% uso de CPU en los pods
5. Configura un webhook en Datadog hacia Cloud Functions
6. Programa y despliega una Google Cloud Function que escale el deployment al recibir el webhook
7. Provoca carga en el pod para disparar la alerta y prueba que el escalado es automático
8. Comprueba que las réplicas del deployment han aumentado y revisa el resultado esperado

---

## Ejemplo paso a paso

### 1. Desplegar nginx con Helm

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm install mi-nginx bitnami/nginx --set replicaCount=1
kubectl get deployments
kubectl get pods
```

---

### 2. Crear los recursos en Datadog con Terraform: alerta & webhook

En este apartado se crean todos los recursos necesarios en Datadog para que el flujo funcione:

- **El monitor** es el que vigila el estado del deployment (por ejemplo, el uso de CPU alto)
- **El webhook** es el canal de acción: se dispara automáticamente cuando el monitor detecta una incidencia y envía la alerta a la Cloud Function de GCP, que hará el autoscalado

```hcl
# Monitor de Datadog: define la alerta sobre el uso de CPU
resource "datadog_monitor" "nginx_cpu_monitor" {
  name    = "CPU alto en mi-nginx"
  type    = "metric alert"
  query   = "avg(last_5m):avg:kubernetes.cpu.usage.total{kube_deployment:mi-nginx} > 300000"
  message = "El pod {{pod_name}} tiene CPU > 0.3 cores (300k microcores). @webhook-nombrewebhook"

  monitor_thresholds {
    warning  = 250000
    critical = 300000
  }

  notify_no_data    = true
  no_data_timeframe = 15
  tags              = ["env:test", "monitor:nginx-cpu"]
}

# Webhook de Datadog: endpoint que recibe la alerta y escala el deployment
resource "datadog_webhook" "scale_deployment" {
  name    = "webhook-nombrewebhook"
  url     = google_cloudfunctions_function.datadog_webhook.https_trigger_url
  payload = "{\"alert\": \"{{state}}\", \"msg\": \"{{message}}\"}"
}
```

- **El nombre del webhook ('webhook-nombrewebhook')** debe coincidir exactamente en el mensaje del monitor, usando la sintaxis `@webhook-nombrewebhook`.  
- El payload puede adaptarse para enviar más información según tus necesidades, usando variables de evento de Datadog.

De este modo, cuando la alerta salta, Datadog automáticamente invoca la Cloud Function vía webhook y desencadena el flujo de escalado sin intervención manual.

---

### 3. Subir la CPU en el pod (simular incidencia)

```bash
kubectl exec -it mi-nginx-58657d787d-nkrpq -- /bin/bash
yes > /dev/null &
```

---

### 4. Detener la carga cuando quieras volver a estado normal

```bash
pkill yes
```


