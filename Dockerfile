# Stage 1: build Flutter web
FROM ghcr.io/cirruslabs/flutter:3.29.3 AS build
WORKDIR /app

# Cache dependencies
COPY pubspec.* ./
RUN flutter pub get

# Copy source and build
COPY . .
RUN flutter build web --release --no-tree-shake-icons

# Stage 2: serve with Nginx
FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html

# Copy assets to public directories (if they exist)
RUN mkdir -p /usr/share/nginx/html/images /usr/share/nginx/html/icons /usr/share/nginx/html/animations \
    && if [ -d "/usr/share/nginx/html/assets/images" ]; then cp -a /usr/share/nginx/html/assets/images/. /usr/share/nginx/html/images/ 2>/dev/null || true; fi \
    && if [ -d "/usr/share/nginx/html/assets/icons" ]; then cp -a /usr/share/nginx/html/assets/icons/. /usr/share/nginx/html/icons/ 2>/dev/null || true; fi \
    && if [ -d "/usr/share/nginx/html/assets/animations" ]; then cp -a /usr/share/nginx/html/assets/animations/. /usr/share/nginx/html/animations/ 2>/dev/null || true; fi

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
