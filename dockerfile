# Usa la imagen oficial de PHP con Apache
FROM php:8.3-apache

# Obtener argumentos para UID y GID
ARG UID=1000
ARG GID=1000
ARG USER=appuser

# Solo crear usuario si no es root
RUN if [ ${UID} -ne 0 ] && [ ${GID} -ne 0 ]; then \
        # Crear grupo solo si no existe
        if ! getent group ${USER} >/dev/null; then \
            groupadd -g ${GID} ${USER}; \
        fi && \
        # Crear usuario solo si no existe
        if ! getent passwd ${USER} >/dev/null; then \
            useradd -u ${UID} -g ${GID} -m -s /bin/bash ${USER}; \
        fi; \
    fi

# Instala dependencias del sistema
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    libpq-dev \
    libzip-dev \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    nodejs \
    npm \
    sudo \
    && docker-php-ext-install pdo pdo_pgsql zip gd mbstring bcmath xml \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Instala Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Instalar Laravel installer globalmente
RUN composer global require laravel/installer

# Agregar el directorio de Composer al PATH de forma permanente
ENV PATH="/root/.config/composer/vendor/bin:/root/.composer/vendor/bin:${PATH}"

# Verificar que laravel esté disponible
RUN which laravel || echo "Laravel installer not in PATH"

# Configura Apache para Laravel
RUN a2enmod rewrite
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Establece el directorio de trabajo
WORKDIR /var/www/html

# Script de inicialización
COPY init-laravel.sh /usr/local/bin/init-laravel.sh
RUN chmod +x /usr/local/bin/init-laravel.sh

# Expone el puerto de Apache
EXPOSE 80

RUN npm i -g pnpm@9

# Comando para inicializar Laravel si no existe
CMD ["/usr/local/bin/init-laravel.sh"]