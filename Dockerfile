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

# Definir argumentos para variables de entorno
ARG SEARCH_API_URL=https://api.insectlab.app

# Asegurar que el index.html tenga la etiqueta base href correcta y configurar variables de entorno
RUN if grep -q "\$FLUTTER_BASE_HREF" web/index.html; then \
    sed -i 's|<base href="\$FLUTTER_BASE_HREF">|<base href="/">|g' web/index.html; \
  else \
    sed -i 's|<head>|<head>\n  <base href="/">|g' web/index.html; \
  fi && \
  sed -i "s|__SEARCH_API_URL__|${SEARCH_API_URL}|g" web/index.html

# Obtener dependencias y construir para web
RUN flutter pub get && \
    flutter build web --release

# Etapa 2: Servir la aplicación con Nginx
FROM nginx:alpine

# Pasar la variable de entorno del build al runtime
ARG SEARCH_API_URL
ENV SEARCH_API_URL=${SEARCH_API_URL}

# Copiar archivos de construcción web de Flutter
COPY --from=build /app/build/web /usr/share/nginx/html

# Crear estructura de directorios y copiar assets para asegurar compatibilidad con múltiples rutas
RUN mkdir -p /usr/share/nginx/html/images/home \
    /usr/share/nginx/html/images/crops \
    /usr/share/nginx/html/images/insects \
    /usr/share/nginx/html/images/tech \
    /usr/share/nginx/html/images/rna \
    /usr/share/nginx/html/icons \
    /usr/share/nginx/html/animations \
    && find /usr/share/nginx/html/assets -type f -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.gif" -o -name "*.svg" | while read file; do \
       relpath=$(echo "$file" | sed 's|/usr/share/nginx/html/assets/||'); \
       mkdir -p "/usr/share/nginx/html/$(dirname "$relpath")"; \
       cp "$file" "/usr/share/nginx/html/$relpath"; \
    done \
    && cp -r /usr/share/nginx/html/assets/images/home/* /usr/share/nginx/html/images/home/ 2>/dev/null || true \
    && cp -r /usr/share/nginx/html/assets/images/crops/* /usr/share/nginx/html/images/crops/ 2>/dev/null || true \
    && cp -r /usr/share/nginx/html/assets/images/insects/* /usr/share/nginx/html/images/insects/ 2>/dev/null || true \
    && cp -r /usr/share/nginx/html/assets/images/tech/* /usr/share/nginx/html/images/tech/ 2>/dev/null || true \
    && cp -r /usr/share/nginx/html/assets/images/rna/* /usr/share/nginx/html/images/rna/ 2>/dev/null || true \
    && cp -r /usr/share/nginx/html/assets/icons/* /usr/share/nginx/html/icons/ 2>/dev/null || true \
    && cp -r /usr/share/nginx/html/assets/animations/* /usr/share/nginx/html/animations/ 2>/dev/null || true

# Copiar configuración personalizada de Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copiar y dar permisos al script de entrada
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Exponer puerto
EXPOSE 80

# Usar el script de entrada como punto de inicio
ENTRYPOINT ["/entrypoint.sh"]
