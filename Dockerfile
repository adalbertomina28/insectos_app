# Etapa 1: Construir la aplicación Flutter
FROM debian:bullseye-slim AS build

# Ya no usamos argumentos para la URL de la API porque ahora está hardcodeada en el código
# Esto evita que Coolify pueda manipular la URL durante la construcción

# Evitar interacciones durante la instalación de paquetes
ENV DEBIAN_FRONTEND=noninteractive

# Instalar dependencias mínimas necesarias
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    && rm -rf /var/lib/apt/lists/*

# Configurar variables de entorno para Flutter
ENV FLUTTER_HOME=/opt/flutter
ENV PATH=$FLUTTER_HOME/bin:$PATH

# Descargar e instalar Flutter (versión estable)
RUN git clone -b stable --depth 1 https://github.com/flutter/flutter.git $FLUTTER_HOME

# Configurar Flutter para web
RUN flutter config --no-analytics && \
    flutter config --enable-web

# Configurar directorio de trabajo
WORKDIR /app

# Copiar archivos del proyecto
COPY . .

# Obtener dependencias y construir para web sin usar variables de entorno
# Esto asegura que se usen las URLs hardcodeadas en el código
RUN flutter clean && \
    flutter pub get && \
    flutter build web --release

# Etapa 2: Servir la aplicación con Nginx
FROM nginx:alpine

# Copiar archivos de construcción web de Flutter
COPY --from=build /app/build/web /usr/share/nginx/html

# Copiar configuración personalizada de Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Exponer puerto
EXPOSE 80

# Comando para iniciar Nginx
CMD ["nginx", "-g", "daemon off;"]