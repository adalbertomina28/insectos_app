# Stage 1: build Flutter web
FROM ghcr.io/cirruslabs/flutter:3.19.3 AS build
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

# Copy assets to public directories
RUN mkdir -p /usr/share/nginx/html/images \
    && cp -a /usr/share/nginx/html/assets/images/. /usr/share/nginx/html/images/ \
    && mkdir -p /usr/share/nginx/html/icons \
    && cp -a /usr/share/nginx/html/assets/icons/. /usr/share/nginx/html/icons/ \
    && mkdir -p /usr/share/nginx/html/animations \
    && cp -a /usr/share/nginx/html/assets/animations/. /usr/share/nginx/html/animations/

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
