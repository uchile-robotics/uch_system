# uch_system [WORK IN PROGRESS.. new arch and migrating from bitbucket ...]

## Overview


## Instalación del sistema

Ejecutar en terminal (`Ctrl+Alt+T`)

```bash
## Pre-requisitos

# ROS Keys
# Evite instalar la versión full (sudo apt-get install ros-indigo-desktop-full) o alguna de las otras variantes.
# ver: http://wiki.ros.org/indigo/Installation/Ubuntu
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116

# actualizar base de software
sudo apt-get update

# ROS: ros-indigo-ros-base
# git/hooks: git python-flake8 shellcheck libxml2-utils python-yaml cppcheck
# install: curl openssl pv python-rosinstall python-pip
# conectividad: openssh-client openssh-server
sudo apt-get install ros-indigo-ros-base git python-flake8 shellcheck libxml2-utils python-yaml cppcheck curl openssl pv python-rosinstall python-pip openssh-client openssh-server


## Instalación

# directorio "sano" y con permisos de escritura.
cd "$HOME"

# descargar bender_system
git clone https://bitbucket.org/uchile-robotics-die/bender_system.git tmp_repo
cd tmp_repo/install

# Obtener repositorios y crear workspaces
bash bender_ws_installer.bash

# limpiar
cd "$HOME"
rm -rf ~/tmp_repo


## Habilitar workspace para uso en consola

# sólo usuarios de bash
echo '' >> ~/.bashrc
echo '# Bender Workspace settings: location, configs and setup script.' >> ~/.bashrc
echo 'export BENDER_WS="$HOME"/bender_ws'        >> ~/.bashrc
echo 'export BENDER_SHELL_CFG="$HOME"/bender.sh' >> ~/.bashrc
echo '. "$BENDER_WS"/bender_system/setup.bash'    >> ~/.bashrc

# sólo usuarios de zsh
echo '' >> ~/.zshrc
echo '# Bender Workspace settings: location, configs and setup script.' >> ~/.zshrc
echo 'export BENDER_WS="$HOME"/bender_ws'        >> ~/.zshrc
echo 'export BENDER_SHELL_CFG="$HOME"/bender.sh' >> ~/.zshrc
echo '. "$BENDER_WS"/bender_system/setup.zsh'    >> ~/.zshrc


# inicializar rosdep
sudo rosdep init
rosdep update
```
Al terminar la instalación debes reabrir el terminal.


## Configuraciones recomendadas

Ejecutar en terminal (`Ctrl+Alt+T`)

```bash
# configurar ~/.gitconfig global: usuario, mail, colores y aliases para comandos git.
# - tras copiar el .gitconfig, al menos se debe configurar "name" y "email"!!!
# - setear herramienta meld para ver los git diffs
sudo apt-get install meld
cp -bfS.bkp "$BENDER_SYSTEM"/templates/default.gitconfig ~/.gitconfig
cp "$BENDER_SYSTEM"/templates/gitconfig_meld_launcher.py "$HOME"/.gitconfig_meld_launcher.py
gedit ~/.gitconfig

# configurar ~/.bash_aliases: esto configura el prompt PS1 para git. 
cp -bfS.bkp "$BENDER_SYSTEM"/templates/bash_aliases ~/.bash_aliases

# variable utilizada por "rosed" y algunos utilitarios de bender.
echo 'export EDITOR="gedit"' >> ~/.bashrc

# En orden:
# - agrega opción "abrir terminal" al click derecho
# - shell más moderno. permite subdivisiones en cada pestaña.
# - utilitario gráfico para git
sudo apt-get install nautilus-open-terminal terminator gitk

# Trabajar en rama "develop" de cada repositorio
# - si tras correr el comando algún repositorio no está en tal rama,
#   debes cambiarlo manualmente.
#   ej:
#   > cdb soft
#   > git checkout develop
bgit checkout develop
```


## Compilación de workspaces

En esta fase es importante el orden de compilación.


### Instalación de `forks_ws`

Ejecutar en terminal (`Ctrl+Alt+T`)

```bash
# Abrir workspace
cdb forks && cd ..

# Instalar dependencias
rosdep install --from-paths . --ignore-src --rosdistro=indigo -y

# Compilar
catkin_make
```


### Instalación de `base_ws`

Ejecutar en terminal (`Ctrl+Alt+T`)

```bash
# instalar dependencias
cdb base
rosdep install --from-paths . --ignore-src --rosdistro=indigo -y

# install bender_description
cdb bender_description
bash install/install.sh
bash scripts/update_models.sh

# install bender_base
cdb bender_base
bash install/install.sh

# install bender_head
cdb bender_head
bash install/install.sh

# install bender_joy
cdb bender_joy
bash install/install.sh

# install bender_tts
cdb bender_tts
bash install/install.sh

# install bender_fieldbus
cdb bender_fieldbus
bash install/install.sh

# install bender_sensors
cdb bender_sensors
bash install/install.sh

# install bender_turning_base
cdb bender_turning_base
bash install/install.sh

# Compilar
cdb base && cd ..
catkin_make
```


### Instalación de `soft_ws`

Ejecutar en terminal (`Ctrl+Alt+T`)

```bash
# instalar dependencias
cdb soft
rosdep install --from-paths . --ignore-src --rosdistro=indigo -y

# instalar dependencias de speech
cdb bender_speech
bash install/install.sh

# instalar dependencias de navegación
cdb bender_nav
bash install/install.sh

# instalar dependencias de bender_arm_planning
cdb bender_arm_planning
bash install/install.sh

# instalar dependencias para deep learning
# [AVISO] puede tomar un par de horas !!
# [WARNING] Sólo testeado en consola bash. Puede haber problemas con pip. Ver: https://bitbucket.org/uchile-robotics-die/bender_system/issues/9/importerror-no-module-named
# [NOTA] No instalar no afecta en compilar bender
cdb bender_perception_utils
bash install/install.sh


# Compilar
cdb soft && cd ..
catkin_make
```

### Instalación de `high_ws`

Ejecutar en terminal (`Ctrl+Alt+T`)

```bash
# instalar dependencias
cdb high
rosdep install --from-paths . --ignore-src --rosdistro=indigo -y

# Compilar
cdb high && cd ..
catkin_make
```

### Configuración del simulador Gazebo

Para configurar una versión adecuada del simulador Gazebo debes seguir la documentación del package [bender_gazebo](https://bitbucket.org/uchile-robotics-die/bender_system/wiki/doc/packages/bender_gazebo.md).
