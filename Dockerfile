# Etapa 1: Construir la aplicación Flutter
FROM debian:bullseye-slim AS build

# Evitar interacciones durante la instalación de paquetes
ENV DEBIAN_FRONTEND=noninteractive

# Instalar dependencias mínimas necesarias
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    && rm -rf /var/lib/apt/lists/*

# Descargar Flutter
RUN git clone --depth 1 --branch stable https://github.com/flutter/flutter.git /flutter

# Agregar Flutter al PATH
ENV PATH="/flutter/bin:/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Verificar instalación y precalentar
RUN flutter doctor -v && flutter precache

# Configurar directorio de trabajo
WORKDIR /app

# Copiar archivos del proyecto
COPY . .

# Asegurar que el index.html tenga la etiqueta base href correcta
RUN if grep -q "\$FLUTTER_BASE_HREF" web/index.html; then \
    sed -i 's|<base href="\$FLUTTER_BASE_HREF">|<base href="/">|g' web/index.html; \
  else \
    sed -i 's|<head>|<head>\n  <base href="/">|g' web/index.html; \
  fi

# Obtener dependencias y construir para web
RUN flutter pub get && \
    flutter build web --release

# Etapa 2: Servir la aplicación con Nginx
FROM nginx:alpine

# Copiar archivos de construcción web de Flutter
COPY --from=build /app/build/web /usr/share/nginx/html

# Crear enlaces simbólicos para compatibilidad con rutas de assets
RUN mkdir -p /usr/share/nginx/html/images && \
    mkdir -p /usr/share/nginx/html/images/home && \
    mkdir -p /usr/share/nginx/html/images/crops && \
    mkdir -p /usr/share/nginx/html/images/insects && \
    mkdir -p /usr/share/nginx/html/images/tech && \
    mkdir -p /usr/share/nginx/html/images/rna && \
    mkdir -p /usr/share/nginx/html/icons && \
    mkdir -p /usr/share/nginx/html/animations && \
    cp -r /usr/share/nginx/html/assets/images/home/* /usr/share/nginx/html/images/home/ || true && \
    cp -r /usr/share/nginx/html/assets/images/crops/* /usr/share/nginx/html/images/crops/ || true && \
    cp -r /usr/share/nginx/html/assets/images/insects/* /usr/share/nginx/html/images/insects/ || true && \
    cp -r /usr/share/nginx/html/assets/images/tech/* /usr/share/nginx/html/images/tech/ || true && \
    cp -r /usr/share/nginx/html/assets/images/rna/* /usr/share/nginx/html/images/rna/ || true && \
    cp -r /usr/share/nginx/html/assets/icons/* /usr/share/nginx/html/icons/ || true && \
    cp -r /usr/share/nginx/html/assets/animations/* /usr/share/nginx/html/animations/ || true

# Copiar configuración personalizada de Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Exponer puerto
EXPOSE 80

# Comando para iniciar Nginx
CMD ["nginx", "-g", "daemon off;"]
