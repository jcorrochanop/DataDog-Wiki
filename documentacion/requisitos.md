# Requisitos DataDog Agent

## Requisitos de recursos para instalar Datadog Agent

| Recurso           | Linux / VM / Nodo típico     | Windows                    | Kubernetes Nodos          | Notas                                        |
|-------------------|-----------------------------|----------------------------|--------------------------|----------------------------------------------|
| CPU               | Aproximadamente 0.08% uso   | Aproximadamente 0.08% uso  | Standard Agent: 53m CPU   | DogStatsD puede usar más CPU en picos        |
| Memoria RAM       | Mínimo 256MB                | Mínimo 256MB               | Variable, recomendado >256MB | Consumo alrededor de 130MB RAM típico      |
| Espacio en disco  | Recomendado 200MB           | Recomendado 200MB          | No específico            | Para logs y archivos temporales               |
| Acceso administrador | Root o sudo (Linux)          | Permisos de administrador  | Permisos para DaemonSets  | Permisos para configuración e inicio         |
| Puertos de red    | HTTPS salida puerto 443     | HTTPS salida puerto 443    | Puerto 443 y otros según configuración | Salida HTTPS necesaria hacia Datadog        |
| Sistema operativo | Linux moderno, macOS, Windows Server 2008r2 o superior | Windows Server 2008r2 o superior | Linux con kubelet activo    | Diversas distribuciones y versiones soportadas |

## Versiones mínimas y aspectos técnicos para Datadog Agent

| Aspecto                  | Versión mínima / requisito                       | Notas                                    |
|--------------------------|------------------------------------------------|------------------------------------------|
| Versión Agent            | Agent v7 (última major release)                 | Soporte solo Python 3 para plugins       |
| Kubernetes versión       | 1.4+ (Datadog soporta 1.4 o superior)           | Chart por defecto para 1.10+              |
| Lenguajes para tracing   | Python 3, Go, otros conforme a documentación    | Agente con instrumentación APM habilitada |
| Contenedores soportados  | Linux, Windows (1809, 1909, 2004, 20h2)         | Arquitecturas amd64 y arm64               |
| Dependencias             | Python 2.7+ (para algunos casos), sysstat       | Para servidores con conectividad limitada|
| Instalación              | Paquetes DEB, RPM para Linux, MSI para Windows  | Requiere configuraciones específicas y claves API |



