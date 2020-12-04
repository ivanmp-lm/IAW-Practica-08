#Script para el Front-End de la Fase 1#

#---Variables configuración Wordpress---#
DB_NAME=wordpress_db
DB_USER=wordpress_user
DB_PASSWORD=wordpress_password
IP_PRIVADA_FRONTEND=
IP_MYSQL_SERVER=
#---Variables configuración Wordpress---#

#!/bin/bash

#Ver los comandos ejecutados
set -x

# Actualizar los repositorios
apt update

# Instalar servidor Apache
apt install apache2 -y

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

# Editar el archivo de configuración de Wordpress
cd /var/www/html/wordpress
mv wp-config-sample.php wp-config.php
sed -i "s/database_name_here/$DB_NAME/" wp-config.php
sed -i "s/username_here/$DB_USER/" wp-config.php
sed -i "s/password_here/$DB_PASSWORD/" wp-config.php
sed -i "s/localhost/$IP_MYSQL_SERVER/" wp-config.php
