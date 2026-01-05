# Generación de application_id y client_token en integración RUM en DataDog

En el siguiente documento se explicará cómo obtener automáticamente el `application_id` y el `client_token` de cada uno de los proyectos mediante Terraform.

## Requisitos previos

- Terraform instalado
- Credenciales de Datadog (API Key y Application Key)
- Archivo CSV con la lista de aplicaciones

## Estructura del proyecto

```
rum/
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
├── applications.csv             # CSV de entrada con las aplicaciones
└── rum_applications_tokens.csv  # CSV generado automáticamente
```

## CSV de entrada (applications.csv)

El archivo `applications.csv` debe contener las aplicaciones a crear en Datadog. La estructura es la siguiente:

| App ID | RUM - Name | App Name |
|--------|-----------|----------|
| IOS223-01 | Text Designer | Text Designer - Font Keyboard |
| GPS282-01 | Be Closer | Be Closer: Family location |
| IOS201-01 | Smart Switch my Phone | Smart Switch my Phone |

**Columnas importantes:**
- **App ID**: Identificador del proyecto (determina el tipo: IOS → ios, GPS → android)
- **RUM - Name**: Nombre de la aplicación en RUM

El script solo utiliza las dos primeras columnas para generar el nombre de la aplicación RUM con el formato: `{App ID}-{RUM - Name}`.

Los espacios en el nombre se reemplazan automáticamente por guiones. Ejemplo: `IOS201-01-Smart-Switch-my-Phone`.

## Configuración

1. Edita el archivo `terraform.tfvars` con tus credenciales de Datadog:

```hcl
datadog_api_key = "tu_api_key_aqui"
datadog_app_key = "tu_app_key_aqui"
```

1. Asegúrate de que `applications.csv` está en el mismo directorio que `main.tf`.

## Ejecución

Ejecuta los siguientes comandos para crear las aplicaciones RUM:

```bash
terraform init
terraform plan
terraform apply
```

Si encuentras errores de rate limiting, limita el paralelismo:

```bash
terraform apply -parallelism=3
```

## Resultados

### Archivo CSV generado automáticamente

Tras ejecutar `terraform apply`, se generará automáticamente el archivo **`rum_applications_tokens.csv`** con la siguiente estructura:

| Application Name | Type | Application ID | Client Token |
|-----------------|------|----------------|--------------|
| GPS209-01-Poker-Live | android | c3c7f918-606c-47a0-8c7a-b02652e1db63 | pub8a9f2c3d1e4b5a6c7d8e9f0a1b2c3d4 |
| IOS201-01-Smart-Switch-my-Phone | ios | 251e30b0-aa1e-407c-a2e5-06a44f9c4fa6 | puba1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6 |
| IOS227-01-Wallpapers-for-Dynamic-Island | ios | 6c1359bb-0b41-4296-a3f5-84860b6c1574 | pubc2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7 |

**Columnas del CSV de salida:**
- **Application Name**: Nombre completo de la aplicación en Datadog
- **Type**: Tipo de aplicación (`ios` o `android`)
- **Application ID**: ID único de la aplicación RUM
- **Client Token**: Token público para instrumentar la aplicación

Este archivo se puede abrir directamente en Excel para gestionar los tokens.

### Consultar tokens desde terminal (opcional)

También puedes consultar los tokens directamente desde la terminal:

```bash
# Ver todos los tokens
terraform output rum_applications_tokens

# Exportar a JSON
terraform output -json rum_applications_tokens > tokens.json
```

## Tipos de aplicaciones

El tipo de aplicación se determina automáticamente según el prefijo del App ID:

| Prefijo | Tipo |
|---------|------|
| IOS* | ios |
| GPS* | android |

## Notas adicionales

- Las aplicaciones creadas aparecerán en Datadog en: **UX Monitoring → Setup & Configuration → RUM Applications**
- URL directa: `https://app.datadoghq.eu/rum/list`
- El estado inicial será "NOT INSTRUMENTED" hasta que se integre el SDK en las aplicaciones móviles
