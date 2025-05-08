FROM ubuntu:20.04

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

# Comando por defecto para ejecutar la aplicación en modo web
CMD ["flutter", "run", "--release", "--web-port", "8080", "--web-renderer", "html", "--no-sound-null-safety", "--web-hostname", "0.0.0.0"]