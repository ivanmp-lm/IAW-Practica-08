#Script para el Back-End de la Fase 1#

#!/bin/bash

#Ver los comandos ejecutados
set -x

#--VARIABLES PARA MYSQL--
DB_ROOT_PASSWD=root
#--VARIABLES PARA MYSQL--

# ---------------------------------------
# Variables de configuración MySQL
# ---------------------------------------
DB_NAME=wordpress_db
DB_USER=wordpress_user
DB_PASSWORD=wordpress_password
IP_FRONTEND=34.227.163.58
#-----------------------------------------
# Variables de configuración MySQL
# ----------------------------------------

# Actualizar los repositorios
apt update

# Instalar servidor MySQL
apt install mysql-server -y

#Cambiar contraseña en MySQL
mysql -u root -p$DB_ROOT_PASSWD <<< "ALTER USER 'root'@'localhost' IDENTIFIED WITH caching_sha2_password BY '$DB_ROOT_PASSWD';"
mysql -u root -p$DB_ROOT_PASSWD <<< "FLUSH PRIVILEGES;"

# Crear la base de datos y usuario para conectarse a Wordpress
mysql -u root -p$DB_ROOT_PASSWD <<< "DROP DATABASE IF EXISTS $DB_NAME;"
mysql -u root -p$DB_ROOT_PASSWD <<< "CREATE DATABASE $DB_NAME;"
mysql -u root -p$DB_ROOT_PASSWD <<< "CREATE USER $DB_USER@$IP_PRIVADA_FRONTEND IDENTIFIED BY '$DB_PASSWORD';"
mysql -u root -p$DB_ROOT_PASSWD <<< "GRANT ALL PRIVILEGES ON $DB_NAME.* TO $DB_USER@$IP_PRIVADA_FRONTEND;"
mysql -u root -p$DB_ROOT_PASSWD <<< "FLUSH PRIVILEGES;"

#Añadir archivo mysqld.cnf
cp mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf

#Reiniciar servidor MySQL
systemctl restart mysql
