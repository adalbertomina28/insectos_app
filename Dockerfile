# Etapa 1: Construir la aplicación Flutter
FROM ubuntu:20.04 AS build

# Evitar interacciones durante la instalación de paquetes
ENV DEBIAN_FRONTEND=noninteractive

# Instalar dependencias necesarias
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    openjdk-11-jdk \
    wget \
    build-essential \
    libsqlite3-dev \
    libssl-dev \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# Configurar variables de entorno para Flutter
ENV FLUTTER_HOME=/usr/local/flutter
ENV FLUTTER_VERSION=3.29.3
ENV PATH=$FLUTTER_HOME/bin:$PATH

# Descargar e instalar Flutter
RUN git clone -b stable https://github.com/flutter/flutter.git $FLUTTER_HOME && \
    cd $FLUTTER_HOME && \
    git checkout $FLUTTER_VERSION

# Verificar la instalación de Flutter y pre-descargar dependencias
RUN flutter precache && \
    flutter doctor

# Configurar directorio de trabajo
WORKDIR /app

# Copiar archivos del proyecto
COPY . .

# Obtener dependencias
RUN flutter pub get

# Configurar para compilación web
RUN flutter config --enable-web

# Construir la aplicación web
RUN flutter build web --release

# Etapa 2: Servir la aplicación con Nginx
FROM nginx:alpine

# Instalar herramientas necesarias para el reemplazo de variables
RUN apk add --no-cache bash gettext

# Copiar archivos de construcción web de Flutter
COPY --from=build /app/build/web /usr/share/nginx/html

# Copiar configuración personalizada de Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copiar script de entrada
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Definir variable de entorno para la URL de la API
ENV API_BASE_URL=https://api.insectlab.app

# Exponer puerto
EXPOSE 80

# Usar script de entrada para reemplazar variables y iniciar Nginx
CMD ["/entrypoint.sh"]