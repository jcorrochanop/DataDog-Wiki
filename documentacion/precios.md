# Guía Definitiva de Datadog - Documento Final Completo

**Fuente Oficial:** https://www.datadoghq.com/pricing/[1][2]

***

## Tabla Comparativa Completa de Todos los Planes

| Característica | Infrastructure Pro | DevSecOps Pro | Infrastructure Enterprise | DevSecOps Enterprise |
|----------------|-------------------|---------------|--------------------------|---------------------|
| **💰 Precio (anual)** | **$15**/host/mes [3][4] | **$22**/host/mes [3][5] | **$23**/host/mes [3][4] | **$34**/host/mes [3][5] |
| **💰 Precio (mensual)** | $18/host/mes [4] | $27/host/mes [5] | $27/host/mes [4] | $41/host/mes [5] |
| **📊 Monitorización de Infraestructura** | ✅ Completo [4] | ✅ Completo [6] | ✅ Completo [4] | ✅ Completo [6] |
| **📈 Retención de datos** | 15 meses [4] | 15 meses [6] | 15 meses [4] | 15 meses [6] |
| **🔌 Integraciones (GCP, AWS, etc.)** | +850 incluidas [4] | +850 incluidas [6] | +850 + custom [4] | +850 + custom [6] |
| **📏 Métricas personalizadas** | 100/host [4] | 100/host [6] | 500/host [4] | 500/host [6] |
| **🎨 Dashboards** | Personalizables [4] | Personalizables [6] | Totalmente custom [4] | Totalmente custom [6] |
| **🤖 Alertas con IA/Machine Learning** | ❌ | ❌ | ✅ [4] | ✅ [6] |
| **👁️ Monitorización de Procesos en Vivo** | ❌ | ❌ | ✅ [4] | ✅ [6] |
| **🔐 CSPM (Seguridad Cloud)** | ❌ | ✅ [3][7] | ❌ | ✅ [3] |
| **☸️ KSPM (Seguridad Kubernetes)** | ❌ | ✅ [3] | ❌ | ✅ [3] |
| **🐛 Escaneo de Vulnerabilidades** | ❌ | ✅ [3] | ❌ | ✅ [3] |
| **🔑 CIEM (Control de Permisos)** | ❌ | ✅ [3] | ❌ | ✅ [3] |
| **📋 Compliance Automático** | ❌ | ✅ [8][7] | ❌ | ✅ [8] |
| **🔒 Monitorización de Archivos Críticos** | ❌ | ❌ | ❌ | ✅ [3][5] |
| **🛡️ Protección contra Amenazas** | ❌ | ❌ | ❌ | ✅ [3] |
| **📦 Contenedores incluidos** | 5 | 5 | 10 [5] | 20 [5] |
| **🆘 Tipo de Soporte** | Estándar [3] | Estándar [3] | Premium [3] | Premium [3] |

***

## ¿Qué Significa Cada Plan? Explicación Simple

### 🔵 Infrastructure Pro - $15/host/mes

**¿Qué es un "host"?** Es cada servidor, máquina virtual o instancia de Google Cloud que quieras monitorizar.[9]

**¿Qué hace este plan?**
Imagina que tienes varias máquinas virtuales corriendo en Google Cloud. Este plan te permite:[4]

- **Ver en tiempo real** cuánto CPU, memoria y disco están usando tus máquinas
- **Crear gráficas bonitas** (dashboards) para visualizar todo de un vistazo
- **Recibir alertas** cuando algo va mal (ejemplo: "La máquina X tiene el disco al 95% lleno")
- **Conectar con Google Cloud** automáticamente (y más de 850 servicios diferentes)
- **Guardar histórico** de 15 meses para comparar cómo ha ido evolucionando tu infraestructura

**¿Qué NO incluye?**
No incluye nada de seguridad. Es decir, te dice si tus máquinas están funcionando, pero NO te avisa si tienes configuraciones peligrosas o vulnerabilidades de seguridad.[4]

**¿Para quién es?**
Para equipos que solo quieren "ver" cómo funcionan sus máquinas, sin preocuparse (aún) de seguridad.[4]

***

### 🟢 DevSecOps Pro - $22/host/mes ⭐ RECOMENDADO

**¿Qué es?**
Es el plan anterior (Infrastructure Pro) **MÁS** un montón de herramientas de seguridad. Todo incluido en el mismo precio.[6]

**¿Qué hace este plan?**
Todo lo de Infrastructure Pro + te protege contra problemas de seguridad:[7][6]

**CSPM (Cloud Security Posture Management):**
Es como tener un inspector de seguridad revisando tus proyectos de Google Cloud 24/7. Te avisa si:[7]
- Alguien dejó un bucket de almacenamiento público por error
- Tienes firewalls mal configurados
- Hay contraseñas débiles
- Cualquier configuración peligrosa

**KSPM (Kubernetes Security Posture Management):**
Lo mismo pero para tus contenedores y Kubernetes. Si usas GKE (Google Kubernetes Engine), esto es vital.[3]

**Vulnerability Management (Escaneo de Vulnerabilidades):**
Escanea tus contenedores Docker y máquinas buscando software desactualizado con bugs de seguridad conocidos.[5][3]

**Ejemplo:** "Tu imagen Docker tiene nginx versión 1.18.0 que tiene una vulnerabilidad crítica CVE-2021-XXXX. Actualiza a la versión 1.20.1".

**CIEM (Cloud Infrastructure Entitlement Management):**
Controla "quién puede hacer qué" en tu cloud.[3]

**Ejemplo:** Te avisa si hay una cuenta de servicio con permisos de "administrador total" cuando solo necesita leer archivos.

**Compliance Automático:**
Si tu empresa necesita cumplir normativas como GDPR, ISO 27001, SOC 2 o PCI-DSS, este plan automáticamente revisa tus recursos y te genera informes diciendo qué cumples y qué te falta.[8][7]

**¿Para quién es?**
Para empresas que trabajan con múltiples proyectos en la nube y necesitan asegurar que todo está bien configurado y seguro.[6][7]

***

### 🔴 Infrastructure Enterprise - $23/host/mes

**¿Qué es?**
Es Infrastructure Pro con "superpoderes" para empresas grandes.[4]

**¿Qué añade de extra?**

**Alertas con Inteligencia Artificial:**
En lugar de solo avisar cuando algo ya está mal, la IA predice problemas antes de que ocurran.[4]

**Ejemplo:** "La tendencia de uso de disco indica que en 3 días te quedarás sin espacio".

**Live Process Monitoring:**
Ves en tiempo real qué procesos están corriendo en tus máquinas y cuántos recursos consume cada uno.[4]

**500 métricas personalizadas:**
Puedes crear muchas más métricas específicas de tu negocio (vs 100 en Pro).[4]

**Más contenedores:**
10 contenedores incluidos por cada host (vs 5 en Pro).[5]

**¿Qué NO incluye?**
Nada de seguridad. Tienes features avanzadas de monitorización, pero sin CSPM, KSPM, ni escaneo de vulnerabilidades.[4]

**¿Para quién es?**
Para empresas grandes que ya tienen otras herramientas de seguridad pero necesitan monitorización muy avanzada.[4]

***

### 🟣 DevSecOps Enterprise - $34/host/mes

**¿Qué es?**
La combinación de TODO: Infrastructure Enterprise + toda la seguridad de DevSecOps Pro + features de seguridad aún más avanzadas.[6]

**¿Qué añade sobre DevSecOps Pro?**

**File Integrity Monitoring (Monitorización de Archivos Críticos):**
Detecta si alguien modifica archivos importantes del sistema.[3][5]

**Ejemplo:** Si un atacante consigue entrar y modifica `/etc/passwd` para crear un usuario backdoor, te alerta inmediatamente.

**Workload Protection (Protección de Cargas de Trabajo):**
Monitoriza en tiempo real qué hacen tus aplicaciones y detecta comportamientos sospechosos.[10][3]

**Ejemplo:** Si de repente un contenedor empieza a minar criptomonedas o intenta conectarse a servidores sospechosos en Rusia, lo detecta y puede bloquearlo.

**Alertas con IA:**
Igual que Infrastructure Enterprise, predicciones inteligentes.[6]

**20 contenedores por host:**
El doble que DevSecOps Pro.[5]

**¿Para quién es?**
Para organizaciones con requisitos de seguridad muy estrictos: bancos, hospitales, gobierno, empresas que manejan datos muy sensibles.[7][3]

***

## Productos Adicionales (Opcionales)

Estos se pueden añadir a **cualquier plan** que elijas:[11][4]

### APM (Application Performance Monitoring) - $31/host/mes

**¿Qué hace?**
Monitoriza cómo funcionan tus aplicaciones por dentro.[12]

**Ejemplo simple:**
Tienes una API REST que tarda 8 segundos en responder. Con Infrastructure sabes que el servidor está bien (CPU OK, RAM OK). Pero con APM ves exactamente QUÉ está tardando:
- 0.5 segundos: recibir la petición
- 0.2 segundos: procesar los datos
- 7 segundos: consultar la base de datos ← **AQUÍ ESTÁ EL PROBLEMA**
- 0.3 segundos: devolver respuesta

APM te dice la línea de código exacta que es lenta.[12]

**¿Lo necesitas?**
Solo si tienes aplicaciones corriendo (APIs, microservicios, backends). No lo necesitas para servidores que solo alojan archivos o bases de datos simples.[12]

**Importante:** No tienes que activarlo en TODOS los hosts, solo en los que tengan aplicaciones.[4]

***

### Log Management - $0.10 por GB

**¿Qué hace?**
Centraliza todos los "registros" (logs) de tus aplicaciones en un solo sitio.[13][4]

**¿Qué son los logs?**
Cada vez que alguien accede a tu web, cada error, cada acción, se guarda un registro. Por ejemplo:
```
[2025-12-18 10:15:23] Usuario juan@empresa.com inició sesión
[2025-12-18 10:15:45] ERROR: Conexión a base de datos falló
[2025-12-18 10:16:02] Pago procesado: 59.99€
```

**¿Cómo se cobra?**
Por la cantidad de datos. Si tus aplicaciones generan 200 GB de logs al mes, pagas $20/mes (200 × $0.10).[13]

**Coste adicional de indexación** (para poder buscar en ellos):[13]
- 7 días de retención: $1.27 por millón de eventos
- 15 días: $1.70 por millón de eventos
- 30 días: $2.50 por millón de eventos

**Tip:** No hace falta indexar todos los logs, solo los importantes (errores, eventos críticos).[13]

***

### Network Performance Monitoring - $5/host/mes

Monitoriza el tráfico de red entre tus servicios. Útil si tienes microservicios hablando entre ellos.[4]

***

### Synthetic Monitoring - $5 por 10,000 tests

Hace tests automáticos a tus APIs cada X minutos para asegurar que están disponibles. Como tener un robot que prueba tu web constantemente.[4]

***

## Mi Recomendación para Tu Caso

**Tu situación:** Vas a implementar Datadog en varios proyectos de Google Cloud en tu empresa [memory].

### ✅ PLAN RECOMENDADO: DevSecOps Pro ($22/host/mes con facturación anual)

**¿Por qué este y no los otros?**

**1. Solo $7 más que Infrastructure Pro, pero obtienes TODO el stack de seguridad**
Por $7 adicionales por host al mes, obtienes CSPM, KSPM, escaneo de vulnerabilidades, control de permisos y compliance automático. Si comprases esto por separado, costaría mucho más.[3][5]

**2. Múltiples proyectos GCP = Mayor superficie de ataque**
Con varios proyectos, aumentan las probabilidades de que alguien configure algo mal. DevSecOps Pro te protege revisando automáticamente TODOS los proyectos.[7]

**3. Probablemente usen Kubernetes (GKE)**
Es muy común en GCP [memory]. KSPM es esencial para asegurar tus contenedores.[3]

**4. Compliance es obligatorio en empresas**
Tarde o temprano necesitarás demostrar que cumples normativas. El auto-mapping de DevSecOps Pro te ahorra semanas de trabajo manual.[8][7]

**5. Proactividad en seguridad**
Implementar seguridad desde el día 1 demuestra profesionalidad y te evita problemas futuros.[7]

**¿Por qué NO Infrastructure Pro?**
Porque te quedas sin nada de seguridad. En un entorno empresarial con múltiples proyectos, es arriesgado.[4]

**¿Por qué NO Enterprise?**
Porque las features enterprise (alertas ML, live processes) son "nice to have" pero no esenciales para empezar. Siempre puedes actualizar después.[4]

**¿Por qué NO DevSecOps Enterprise?**
File Integrity Monitoring y Workload Protection son para casos muy específicos (banca, gobierno). Para la mayoría de empresas, DevSecOps Pro es más que suficiente.[3]

***

## Estimación de Precios: Tu Caso Real

Voy a calcular con **20 hosts** como ejemplo (ajusta según tu número real):

### OPCIÓN 1: Infrastructure Pro (No Recomendado)
```
Plan: Infrastructure Pro
- 20 hosts × $15/mes = $300/mes
- TOTAL: $300/mes ($3,600/año)
```
**✅ Tienes:** Monitorización completa  
**❌ No tienes:** Nada de seguridad

***

### OPCIÓN 2: DevSecOps Pro - SOLO BASE (Recomendado Mínimo)
```
Plan: DevSecOps Pro
- 20 hosts × $22/mes = $440/mes
- TOTAL: $440/mes ($5,280/año)
```
**✅ Tienes:** Monitorización + Seguridad completa (CSPM, KSPM, VM, CIEM, Compliance)  
**❌ No tienes:** APM, Logs centralizados

**Diferencia vs Infra Pro:** +$140/mes (+$1,680/año)  
**¿Vale la pena?** SÍ, totalmente.[5][3]

***

### OPCIÓN 3: DevSecOps Pro + APM Parcial (Recomendado Real)
```
Plan: DevSecOps Pro
- 20 hosts × $22/mes = $440/mes

APM (solo en 12 hosts con aplicaciones críticas)
- 12 hosts × $31/mes = $372/mes

TOTAL: $812/mes ($9,744/año)
```
**✅ Tienes:** Monitorización + Seguridad + Rendimiento de aplicaciones críticas  
**❌ No tienes:** Logs centralizados (pero puedes usar Cloud Logging de GCP de momento)

***

### OPCIÓN 4: DevSecOps Pro + APM + Logs (Stack Completo)
```
Plan: DevSecOps Pro
- 20 hosts × $22/mes = $440/mes

APM (15 hosts con aplicaciones)
- 15 hosts × $31/mes = $465/mes

Log Management
- Ingesta: 400 GB/mes × $0.10 = $40/mes
- Indexación (solo críticos, 30 días, 5M eventos): $12.50/mes

TOTAL: $957.50/mes ($11,490/año)
```
**✅ Tienes:** TODO - Solución completa end-to-end  
**Ideal para:** Producción enterprise con requisitos completos

***

### OPCIÓN 5: DevSecOps Enterprise (Máxima Seguridad)
```
Plan: DevSecOps Enterprise
- 20 hosts × $34/mes = $680/mes
- TOTAL: $680/mes ($8,160/año)
```
**✅ Tienes:** Monitorización enterprise + Seguridad máxima  
**Solo si:** Requisitos de seguridad muy estrictos (banca, salud)

***

## Resumen de Costes: Tabla Rápida (20 hosts)

| Configuración | Coste Mensual | Coste Anual | ¿Para quién? |
|---------------|---------------|-------------|--------------|
| Infrastructure Pro | $300 | $3,600 | ❌ No recomendado (sin seguridad) |
| **DevSecOps Pro** ⭐ | **$440** | **$5,280** | ✅ **Mínimo recomendado** |
| DevSecOps Pro + APM (12 hosts) | $812 | $9,744 | ✅ Recomendado real |
| DevSecOps Pro + APM (15) + Logs | $957 | $11,490 | ✅ Stack completo |
| DevSecOps Enterprise | $680 | $8,160 | Solo si seguridad extrema |

***

## Mi Recomendación Final Específica

### Para Empezar (Fase 1)
**Plan: DevSecOps Pro ($440/mes para 20 hosts)**

**Por qué:**
- Te da todo lo necesario: monitorización + seguridad[6][7]
- Empiezas con una base sólida[7]
- Puedes validar el servicio sin gastar mucho

***

### Configuración Ideal (Fase 2)
**Plan: DevSecOps Pro + APM selectivo ($750-900/mes para 20 hosts)**

**Por qué:**
- Añades APM solo en hosts críticos con aplicaciones[4]
- No pagas APM en hosts que solo hacen tareas de infraestructura
- Balance perfecto costo/beneficio

***

### Si Tienes Presupuesto (Producción Full)
**Plan: DevSecOps Pro + APM + Logs ($950-1,000/mes para 20 hosts)**

**Por qué:**
- Solución completa de observabilidad[13][4]
- Logs centralizados facilitan debugging
- Listo para escalar sin problemas

***

## Pasos a Seguir

### 1. Hacer Inventario Exacto
- ¿Cuántos hosts/VMs totales en TODOS los proyectos GCP?
- ¿Cuántos tienen aplicaciones que necesiten APM?
- ¿Usan Kubernetes/GKE?

### 2. Estimar Volumen de Logs
- Revisar Cloud Logging en GCP
- Ver cuántos GB/mes generan actualmente
- Decidir qué logs necesitan indexarse

### 3. Solicitar Cotización Oficial
- Contactar sales de Datadog con números exactos
- Pedir descuento por volumen (si >50 hosts, puedes conseguir 10-20% descuento)[4]
- Solicitar trial gratuito para probar

### 4. Implementar en Fases
- **Semana 1-2:** Piloto con DevSecOps Pro en 1 proyecto crítico
- **Semana 3-4:** Añadir APM en hosts con aplicaciones
- **Semana 5-6:** Validar costes reales
- **Mes 2:** Desplegar en resto de proyectos

***

## Preguntas Frecuentes

**¿Puedo cambiar de plan después?**
Sí, puedes actualizar o degradar en cualquier momento.[4]

**¿Facturación anual es obligatoria?**
No, pero ahorras $3-5 por host/mes vs mensual. Con 20 hosts son $60-100/mes de ahorro.[4]

**¿Puedo negociar el precio?**
Sí, especialmente con +50 hosts. Datadog suele dar descuentos del 10-20% por volumen.[4]

**¿Hay periodo de prueba?**
Sí, Datadog ofrece trial gratuito de 14 días con todas las features.[9]

**¿Qué pasa si paso del límite de contenedores?**
DevSecOps Pro incluye 5 contenedores por host. Si tienes más, se cobra extra (~$1-2 por contenedor adicional).[5]

***

## Conclusión

**Para tu caso de múltiples proyectos GCP en empresa:**

✅ **Empieza con DevSecOps Pro** ($22/host/mes)  
✅ **Añade APM selectivamente** según necesidad real  
✅ **Logs Management** solo si necesitas centralización avanzada  

**Presupuesto realista para 20 hosts: $750-950/mes ($9,000-11,400/año)**

Esto te da una solución profesional, segura y escalable que cubre monitorización + seguridad + rendimiento de aplicaciones.[6][7]

**Fuente Oficial:** https://www.datadoghq.com/pricing/[2][1]

***

**¡Éxito con la implementación!** 🚀

[1](https://www.datadoghq.com/pricing/)
[2](https://www.datadoghq.com/pricing/list/)
[3](https://underdefense.com/industry-pricings/datadog-pricing-ultimate-guide-for-security-products/)
[4](https://datadog.criticalcloud.ai/checklist-for-evaluating-datadog-pricing-plans/)
[5](https://www.capterra.com/p/135453/Datadog-Cloud-Monitoring/pricing/)
[6](https://docs.datadoghq.com/getting_started/devsecops/)
[7](https://cytas.io/datadog-cloud-security-management-a-complete-guide-for-devsecops-teams/)
[8](https://cytas.io/datadog-for-cloud-security-is-it-the-right-choice/)
[9](https://www.cloudeagle.ai/blogs/datadog-pricing-guide)
[10](https://devops.com/datadog-cloud-security-platform-advances-devsecops/)
[11](https://holori.com/datadog-pricing-in-2025-the-complete-guide-to-cost-management-and-optimization/)
[12](https://www.cloudzero.com/blog/datadog-pricing/)
[13](https://coralogix.com/blog/datadog-pricing-explained-with-real-world-scenarios/)