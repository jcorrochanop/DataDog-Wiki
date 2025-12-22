# Guía Resumida de Datadog - Versión Ejecutiva

**Fuente Oficial:** https://www.datadoghq.com/pricing/

---

## Tabla Comparativa de Planes


| Característica | Infrastructure Pro | DevSecOps Pro | Infrastructure Enterprise | DevSecOps Enterprise |
|----------------|-------------------|---------------|--------------------------|---------------------|
| **💰 Precio (anual)** | **$15**/host/mes | **$22**/host/mes | **$23**/host/mes | **$34**/host/mes |
| **💰 Precio (mensual)** | $18/host/mes | $27/host/mes | $27/host/mes | $41/host/mes |
| **📊 Monitorización de Infraestructura** | ✅ Completo | ✅ Completo | ✅ Completo | ✅ Completo |
| **📈 Retención de datos** | 15 meses | 15 meses | 15 meses | 15 meses |
| **🔌 Integraciones (GCP, AWS, etc.)** | +850 incluidas | +850 incluidas | +850 + custom | +850 + custom |
| **📏 Métricas personalizadas** | 100/host | 100/host | 500/host | 500/host |
| **🎨 Dashboards** | Personalizables | Personalizables | Totalmente custom | Totalmente custom |
| **🤖 Alertas con IA/Machine Learning** | ❌ | ❌ | ✅ | ✅ |
| **👁️ Monitorización de Procesos en Vivo** | ❌ | ❌ | ✅ | ✅ |
| **🔐 CSPM (Seguridad Cloud)** | ❌ | ✅ | ❌ | ✅ |
| **☸️ KSPM (Seguridad Kubernetes)** | ❌ | ✅ | ❌ | ✅ |
| **🐛 Escaneo de Vulnerabilidades** | ❌ | ✅ | ❌ | ✅ |
| **🔑 CIEM (Control de Permisos)** | ❌ | ✅ | ❌ | ✅ |
| **📋 Compliance Automático** | ❌ | ✅ | ❌ | ✅ |
| **🔒 Monitorización de Archivos Críticos** | ❌ | ❌ | ❌ | ✅ |
| **🛡️ Protección contra Amenazas** | ❌ | ❌ | ❌ | ✅ |
| **📦 Contenedores incluidos** | 5 | 5 | 10 | 20 |
| **🆘 Tipo de Soporte** | Estándar | Estándar | Premium | Premium |

---

### Explicación de Características Clave

**🤖 Alertas con IA/Machine Learning**
Detección automática de anomalías usando algoritmos de aprendizaje automático. Identifica patrones anormales en métricas (CPU, memoria, latencia) sin configurar umbrales manualmente. Reduce falsas alarmas y detecta problemas antes de que sean críticos.

**👁️ Monitorización de Procesos en Vivo**
Visualización en tiempo real de todos los procesos ejecutándose en cada host. Muestra consumo de recursos por proceso individual, comandos activos y jerarquía de procesos. Te ayuda a identificar qué aplicaciones están consumiendo recursos cuando algo va mal, y a detectar programas que se estén ejecutando sin tu permiso (malware, scripts maliciosos, o servicios no autorizados).

**🔐 CSPM (Cloud Security Posture Management)**
Escaneo continuo de la configuración de tu infraestructura cloud (GCP, AWS, Azure). Detecta configuraciones inseguras como buckets públicos, firewalls mal configurados, o recursos sin cifrado. Proporciona recomendaciones de remediación automáticas.

**☸️ KSPM (Kubernetes Security Posture Management)**
Similar a CSPM pero específico para clústeres Kubernetes. Analiza configuraciones de pods, deployments, servicios y RBAC. Identifica contenedores privilegiados, políticas de red débiles o secrets expuestos.

**🐛 Escaneo de Vulnerabilidades**
Análisis automático de imágenes de contenedores y dependencias de software buscando CVEs conocidos. Prioriza vulnerabilidades críticas y sugiere versiones parcheadas. Se integra con registros como Docker Hub o GCR.

**🔑 CIEM (Cloud Infrastructure Entitlement Management)**
Control y auditoría de permisos IAM en cloud. Detecta permisos excesivos, cuentas sin usar, y privilegios que violan el principio de mínimo privilegio. Mapea quién tiene acceso a qué recursos.

**📋 Compliance Automático**
Datadog revisa automáticamente que tu infraestructura cumple con las normativas de seguridad y privacidad que exigen las leyes y estándares internacionales.

**🔒 Monitorización de Archivos Críticos (FIM - File Integrity Monitoring)**
Rastrea cambios en archivos del sistema críticos (configuraciones, binarios, logs). Alerta cuando se modifica, elimina o crea un archivo sensible. Detecta manipulación de archivos por malware o atacantes.

**🛡️ Protección contra Amenazas (Threat Protection)**
Detección y respuesta ante amenazas en tiempo real. Incluye análisis de comportamiento para identificar actividad maliciosa, intentos de intrusión, movimiento lateral y exfiltración de datos. Proporciona contexto completo del ataque.


---

## ¿Qué es Cada Plan?

### Infrastructure Pro - $15/host/mes
Monitorización básica: CPU, RAM, disco, red, dashboards, alertas. **Sin seguridad**.

### DevSecOps Pro - $22/host/mes ⭐
Infrastructure Pro + Seguridad completa (escaneo configuraciones, vulnerabilidades, compliance). **Todo incluido**.

### Infrastructure Enterprise - $23/host/mes
Infrastructure Pro + alertas IA + monitorización avanzada. **Sin seguridad**.

### DevSecOps Enterprise - $34/host/mes
Infrastructure Enterprise + Seguridad máxima + protección en tiempo real.

---

## Productos Adicionales (Opcionales)

| Producto | Precio | ¿Para qué? |
|----------|--------|------------|
| **APM** | $31/host/mes | Rendimiento de aplicaciones (APIs, microservicios) |
| **Log Management** | $0.10/GB | Centralizar logs |
| **Network Monitoring** | $5/host/mes | Tráfico entre servicios |

---

## Recomendación para Tu Caso

**Varios proyectos GCP en empresa:**

### Plan Base: DevSecOps Pro ($22/host/mes)
**Razones:**
- Solo $7 más que Infrastructure Pro
- Incluye toda la seguridad (CSPM, KSPM, VM, CIEM, Compliance)
- Esencial para múltiples proyectos GCP
- Protege contra configuraciones incorrectas

### Añadir APM según necesidad
- Solo en hosts con aplicaciones críticas
- No necesario en todos los hosts

---

## Estimación de Precios (20 hosts)

| Configuración | Mensual | Anual |
|---------------|---------|-------|
| **DevSecOps Pro (solo base)** ⭐ | **$440** | **$5,280** |
| DevSecOps Pro + APM (12 hosts) | $812 | $9,744 |
| DevSecOps Pro + APM (15) + Logs | $957 | $11,490 |

**Cálculo DevSecOps Pro:**
- 20 hosts × $22/mes = $440/mes ($5,280/año)

**Cálculo con APM (ejemplo 12 hosts):**
- DevSecOps Pro: 20 × $22 = $440/mes
- APM: 12 × $31 = $372/mes
- **Total: $812/mes**

**Cálculo Stack Completo (ejemplo 15 hosts + logs):**
- DevSecOps Pro: $440/mes
- APM (15 hosts): $465/mes
- Logs (400 GB): $52.50/mes
- **Total: $957/mes**

---

## Decisión Rápida

### ¿Qué necesitas?
- **Solo monitorización** → Infrastructure Pro ($15/host)
- **Monitorización + Seguridad** → DevSecOps Pro ($22/host) ⭐ **RECOMENDADO**
- **Features enterprise sin seguridad** → Infrastructure Enterprise ($23/host)
- **Seguridad máxima** → DevSecOps Enterprise ($34/host)

---

## Próximos Pasos

1. **Contar hosts exactos** en todos los proyectos GCP
2. **Identificar** cuáles tienen aplicaciones (necesitan APM)
3. **Solicitar cotización** oficial a Datadog
4. **Negociar descuento** por volumen (10-20% si >50 hosts)
5. **Empezar con piloto** en 1-2 proyectos

---

## Resumen Ultra-Corto

**Para múltiples proyectos GCP:**

✅ **Plan:** DevSecOps Pro  
✅ **Precio:** $22/host/mes (anual)  
✅ **Presupuesto estimado (20 hosts):** $440-950/mes según extras  
✅ **Incluye:** Monitorización + Seguridad completa  

**Fuente:** https://www.datadoghq.com/pricing/
