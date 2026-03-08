# ใช้ PHP 8.2 พร้อม Apache
FROM php:8.2-apache

# ติดตั้ง Extension PDO และ MySQLi
RUN apt-get update && docker-php-ext-install pdo pdo_mysql mysqli

RUN a2enmod rewrite && sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf
