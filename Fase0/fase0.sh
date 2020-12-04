#Script para la Fase 0#

#!/bin/bash

set -x

# ---------------------------------------
# Variables de configuración
# ---------------------------------------
DB_NAME=wordpress_db
DB_USER=wordpress_user
DB_PASSWORD=wordpress_password
IP_PRIVADA_FRONTEND=localhost
IP_MYSQL_SERVER=localhost
#-----------------------------------------
# Variables de configuración
# ---------------------------------------


# Actualizar los repositorios
apt update

# Instalar servidor Apache
apt install apache2 -y

# Instalar servidor MySQL
apt install mysql-server -y

# Instalar módulos PHP
apt install php libapache2-mod-php php-mysql -y

# Reiniciar servidor Apache
systemctl restart apache2

# Copiar el archivo info.php a la carpeta de la página web
cp info.php /var/www/html

# Descargar última versión de Wordpress
cd /var/www/html
wget http://wordpress.org/latest.tar.gz

# Descomprimir Wordpress
tar -xzvf latest.tar.gz

# Eliminar el archivo comprimido
rm latest.tar.gz

# Crear la base de datos y usuario para conectarse a Wordpress
mysql -u root <<< "DROP DATABASE IF EXISTS $DB_NAME;"
mysql -u root <<< "CREATE DATABASE $DB_NAME;"
mysql -u root <<< "CREATE USER $DB_USER@$IP_PRIVADA_FRONTEND IDENTIFIED BY '$DB_PASSWORD';"
mysql -u root <<< "GRANT ALL PRIVILEGES ON $DB_NAME.* TO $DB_USER@$IP_PRIVADA_FRONTEND;"
mysql -u root <<< "FLUSH PRIVILEGES;"

# Editar el archivo de configuración de Wordpress
cd /var/www/html/wordpress
mv wp-config-sample.php wp-config.php
sed -i "s/database_name_here/$DB_NAME/" wp-config.php
sed -i "s/username_here/$DB_USER/" wp-config.php
sed -i "s/password_here/$DB_PASSWORD/" wp-config.php
sed -i "s/localhost/$IP_MYSQL_SERVER/" wp-config.php
