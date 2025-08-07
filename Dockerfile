FROM php:8.3-apache

# Instalar dependencias necesarias
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
    && docker-php-ext-install zip mbstring json fileinfo openssl

# Configurar Oracle Instant Client
ENV LD_LIBRARY_PATH=/usr/lib/oracle/19.22/client64/lib/${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}
ENV ORACLE_HOME=/usr/lib/oracle/19.22/client64

RUN mkdir -p /opt/oracle \
    && cd /opt/oracle \
    && wget https://download.oracle.com/otn_software/linux/instantclient/1919000/instantclient-basic-linux.x64-19.19.0.0.0dbru.zip \
    && wget https://download.oracle.com/otn_software/linux/instantclient/1919000/instantclient-sdk-linux.x64-19.19.0.0.0dbru.zip \
    && unzip instantclient-basic-linux.x64-*.zip -d /opt/oracle \
    && unzip instantclient-sdk-linux.x64-*.zip -d /opt/oracle \
    && ln -s /opt/oracle/instantclient_19_19 /usr/lib/oracle/19.22/client64 \
    && echo /usr/lib/oracle/19.22/client64/lib > /etc/ld.so.conf.d/oracle-instantclient.conf \
    && ldconfig

# Instalar oci8
RUN echo "instantclient,/usr/lib/oracle/19.22/client64/lib" | pecl install oci8 \
    && docker-php-ext-enable oci8
