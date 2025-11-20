# 1. Detener el servicio
sudo systemctl stop datadog-agent

# 2. Desinstalar el paquete
sudo apt-get remove datadog-agent -y
sudo apt-get purge datadog-agent -y

# 3. Borrar todos los directorios y configuraciones
sudo rm -rf /etc/datadog-agent/
sudo rm -rf /opt/datadog-agent/
sudo rm -rf /var/log/datadog/
sudo rm -rf /opt/datadog-packages/

# 4. Eliminar usuario y grupo (si existen)
sudo userdel dd-agent 2>/dev/null
sudo groupdel dd-agent 2>/dev/null

# 5. Verificar que no queda nada
dpkg -l | grep datadog
ps aux | grep datadog

# 6. Borrar hasta las claves de firma
sudo apt-get remove datadog-signing-keys -y

##################################
## Log collection Configuration ##
##################################

## @param logs_enabled - boolean - optional - default: false
## @env DD_LOGS_ENABLED - boolean - optional - default: false
## Enable Datadog Agent log collection by setting logs_enabled to true.
#
logs_enabled: true

## @param logs_config - custom object - optional
## Enter specific configurations for your Log collection.
## Uncomment this parameter and the one below to enable them.
## See https://docs.datadoghq.com/agent/logs/
#
logs_config:

#   # @param container_collect_all - boolean - optional - default: false
#   # @env DD_LOGS_CONFIG_CONTAINER_COLLECT_ALL - boolean - optional - default: false
#   # Enable container log collection for all the containers (see ac_exclude to filter out containers)
#
    container_collect_all: false



# Descomentar y habilitar logs_enabled
sudo sed -i 's/^# logs_enabled: false/logs_enabled: true/' /etc/datadog-agent/datadog.yaml

# Descomentar logs_config
sudo sed -i 's/^# logs_config:/logs_config:/' /etc/datadog-agent/datadog.yaml

# Descomentar y habilitar container_collect_all
sudo sed -i '/logs_config:/,/container_collect_all:/ s/^#   container_collect_all: false/  container_collect_all: true/' /etc/datadog-agent/datadog.yaml


sudo systemctl daemon-reload
sudo systemctl restart datadog-agent



