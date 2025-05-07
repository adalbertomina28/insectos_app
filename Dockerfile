# Stage 1: build Flutter web
FROM ghcr.io/cirruslabs/flutter:3.29.3 AS build
WORKDIR /app

# Cache dependencies
COPY pubspec.* ./
RUN flutter pub get

# Copy source and build
COPY . .
# Asegurar que la base href esté configurada correctamente
RUN sed -i 's|<base href=".*">|<base href="/">|g' web/index.html || true
# Reforzar la URL de la API hardcodeada
RUN grep -l "API_BASE_URL" lib/config/* | xargs sed -i 's|API_BASE_URL = .*|API_BASE_URL = \'https://api.insectlab.app\';|g' || true
# Construir la aplicación con la URL base correcta
RUN flutter build web --release --no-tree-shake-icons --base-href="/" --dart-define=API_BASE_URL=https://api.insectlab.app

# Stage 2: serve with Nginx
FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html

# Configurar Nginx para SPA
COPY <<EOF /etc/nginx/conf.d/default.conf
server {
    listen 80;
    server_name _;
    root /usr/share/nginx/html;
    index index.html;
    
    location / {
        try_files \$uri \$uri/ /index.html;
    }
}
EOF

# Copy assets to public directories (if they exist)
RUN mkdir -p /usr/share/nginx/html/images /usr/share/nginx/html/icons /usr/share/nginx/html/animations \
    && if [ -d "/usr/share/nginx/html/assets/images" ]; then cp -a /usr/share/nginx/html/assets/images/. /usr/share/nginx/html/images/ 2>/dev/null || true; fi \
    && if [ -d "/usr/share/nginx/html/assets/icons" ]; then cp -a /usr/share/nginx/html/assets/icons/. /usr/share/nginx/html/icons/ 2>/dev/null || true; fi \
    && if [ -d "/usr/share/nginx/html/assets/animations" ]; then cp -a /usr/share/nginx/html/assets/animations/. /usr/share/nginx/html/animations/ 2>/dev/null || true; fi

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
