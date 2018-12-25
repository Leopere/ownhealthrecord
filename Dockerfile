FROM php:7.0-apache

LABEL maintainer="Pedro Henrique Braga<pedrohenriquebraga735@gmail.com>"

ADD ./src  /var/www/html/
WORKDIR /var/www/html

RUN docker-php-ext-install mysqli