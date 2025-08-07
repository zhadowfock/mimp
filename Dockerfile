FROM php:8.3-apache

# Instala dependencias necesarias
RUN apt-get update && apt-get install -y \
    unzip \
    libzip-dev \
    libonig-dev \
    libxml2-dev \
    libssl-dev \
    libaio1 \
    wget \
    gnupg \
    libicu-dev \
    libcurl4-openssl-dev \
    zlib1g-dev \
    && docker-php-ext-configure zip \
    && docker-php-ext-install zip mbstring json fileinfo intl curl

# Habilita SSL para Apache
RUN a2enmod ssl

# Instala oci8
COPY oracle/instantclient-basic-linux.x64-19.28.0.0.0dbru.zip /tmp/
COPY oracle/instantclient-sdk-linux.x64-19.28.0.0.0dbru.zip /tmp/
RUN unzip /tmp/instantclient-basic-linux.x64-19.28.0.0.0dbru.zip -d /opt/oracle \
    && unzip /tmp/instantclient-sdk-linux.x64-19.28.0.0.0dbru.zip -d /opt/oracle \
    && ln -s /opt/oracle/instantclient_19_23 /opt/oracle/instantclient \
    && echo /opt/oracle/instantclient > /etc/ld.so.conf.d/oracle-instantclient.conf \
    && ldconfig \
    && docker-php-ext-configure oci8 --with-oci8=instantclient,/opt/oracle/instantclient \
    && docker-php-ext-install oci8

# Limpieza
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/*.zip





