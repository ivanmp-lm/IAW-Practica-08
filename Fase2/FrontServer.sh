#Script para el Front-End Server de la Fase 2#

#---Variables NFS---#
IPFRONTCLIENTE=18.212.19.124
#---Variables NFS---#

#---Variables configuración Wordpress---#
DB_NAME=wordpress_db
DB_USER=wordpress_user
DB_PASSWORD=wordpress_password
IP_BALANCER=3.89.7.149
IP_MYSQL_SERVER=54.146.184.225
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

# Añadir IP del sitio
echo "define('WP_SITEURL', 'http://$IP_BALANCER/wordpress');" >> wp-config.php
echo "define('WP_HOME', 'http://$IP_BALANCER');" >> wp-config.php

# Copiar archivo index.php a /var/www/html
cp index.php /var/www/html

# Editar index.php
sed -i "s#wp-blog-header.php#wordpress/wp-blog-header.php#" /var/www/html/index.php

# Habilitar módulo rewrite de apache
a2enmod rewrite
systemctl restart apache2

# Copiar archivo htaccess a /var/www/html
cp /home/ubuntu/IAW-Practica-08/Fase2/htaccess /var/www/html/.htaccess

# Copiar archivo 000-default a /etc/apache2/sites-available/
cp /home/ubuntu/IAW-Practica-08/Fase2/000-default.conf /etc/apache2/sites-available/

#Reiniciar apache
systemctl restart apache2

#---PUERTO 2049 DEBE ESTAR ABIERTO PARA NFS---#

#Instalar servidor NFS
sudo apt-get install nfs-kernel-server

#Cambiar permiso directorio compartido por NFS
chown nobody:nogroup /var/www/html/wordpress/wp-content

#Editar archivo /etc/exports
echo "/var/www/html/wp-content      $IPFRONTCLIENTE:(rw,sync,no_root_squash,no_subtree_check)/" >> /etc/exports

#Reiniciar servidor NFS
/etc/init.d/nfs-kernel-server restart
