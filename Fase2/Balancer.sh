#!/bin/bash

#--CAMBIAR LAS IP POR LAS DE LOS FRONT END--
FRONT1=34.227.163.58
FRONT2=18.212.19.124
#--CAMBIAR LAS IP POR LAS DE LOS FRONT END--

#Mostrar comandos
set -x

#Actualizar repositorios
apt update

#Instalar apache2
apt install apache2 -y

#Cambiar parámetros 000-default.conf
sed -i s#IPFRONT1#$IPFRONT1# balancer-000-default.conf
sed -i s#IPFRONT1#$IPFRONT2# balancer-000-default.conf

#Copiar archivo 000-default.conf
cp balancer-000-default.conf /etc/apache2/sites-available/000-default.conf

#Activar los módulos necesarios de Apache2
a2enmod proxy
a2enmod proxy_http
a2enmod proxy_ajp
a2enmod rewrite
a2enmod deflate
a2enmod headers
a2enmod proxy_balancer
a2enmod proxy_connect
a2enmod proxy_html
a2enmod lbmethod_byrequests

#Reiniciar el servicio de Apache2
sudo systemctl restart apache2
