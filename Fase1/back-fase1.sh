#Script para el Back-End de la Fase 1#

#!/bin/bash

#Ver los comandos ejecutados
set -x

# ---------------------------------------
# Variables de configuración MySQL
# ---------------------------------------
DB_NAME=wordpress_db
DB_USER=wordpress_user
DB_PASSWORD=wordpress_password
IP_PRIVADA_FRONTEND=172.31.95.53
#-----------------------------------------
# Variables de configuración MySQL
# ----------------------------------------

# Actualizar los repositorios
apt update

# Instalar servidor MySQL
apt install mysql-server -y

# Crear la base de datos y usuario para conectarse a Wordpress
mysql -u root <<< "DROP DATABASE IF EXISTS $DB_NAME;"
mysql -u root <<< "CREATE DATABASE $DB_NAME;"
mysql -u root <<< "CREATE USER $DB_USER@$IP_PRIVADA_FRONTEND IDENTIFIED BY '$DB_PASSWORD';"
mysql -u root <<< "GRANT ALL PRIVILEGES ON $DB_NAME.* TO $DB_USER@$IP_PRIVADA_FRONTEND;"
mysql -u root <<< "FLUSH PRIVILEGES;"

#Añadir archivo mysqld.cnf
cp mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf

#Reiniciar servidor MySQL
systemctl restart mysql
