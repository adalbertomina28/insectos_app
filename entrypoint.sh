#!/bin/sh

# Obtener la URL de la API desde la variable de entorno o usar el valor predeterminado
API_URL=${API_URL:-https://api.insectlab.app}

# Imprimir información para depuración
echo "Configurando API URL: ${API_URL}"

# Reemplazar variables de entorno en index.html
echo "Sustituyendo variables de entorno en index.html..."
envsubst '$API_URL' < /usr/share/nginx/html/index.html > /usr/share/nginx/html/index.tmp.html
mv /usr/share/nginx/html/index.tmp.html /usr/share/nginx/html/index.html

# Buscar y reemplazar en los archivos JavaScript principales
echo "Buscando archivos JavaScript principales..."
for jsfile in /usr/share/nginx/html/main.dart.js /usr/share/nginx/html/flutter.js /usr/share/nginx/html/*.part.js
do
  if [ -f "$jsfile" ]; then
    echo "Reemplazando API_URL en $jsfile"
    sed -i "s|https://api.insectlab.app|${API_URL}|g" "$jsfile"
    sed -i "s|http://api.insectlab.app|${API_URL}|g" "$jsfile"
    # También buscar cualquier URL generada por Coolify
    sed -i "s|http://[a-z0-9]*\.[0-9]*\.[0-9]*\.[0-9]*\.sslip\.io/api|${API_URL}/api|g" "$jsfile"
  fi
done

# Verificar si existen las carpetas de assets
echo "Verificando carpetas de assets..."
if [ ! -d "/usr/share/nginx/html/assets" ]; then
  echo "Carpeta de assets no encontrada, creando estructura de directorios..."
  mkdir -p /usr/share/nginx/html/assets/images
  mkdir -p /usr/share/nginx/html/assets/icons
  mkdir -p /usr/share/nginx/html/assets/animations
  
  # Si hay assets copiados en otra ubicación, moverlos
  if [ -d "/usr/share/nginx/html/images" ]; then
    echo "Moviendo imágenes a la carpeta de assets..."
    cp -r /usr/share/nginx/html/images/* /usr/share/nginx/html/assets/images/
  fi
  
  if [ -d "/usr/share/nginx/html/icons" ]; then
    echo "Moviendo iconos a la carpeta de assets..."
    cp -r /usr/share/nginx/html/icons/* /usr/share/nginx/html/assets/icons/
  fi
  
  if [ -d "/usr/share/nginx/html/animations" ]; then
    echo "Moviendo animaciones a la carpeta de assets..."
    cp -r /usr/share/nginx/html/animations/* /usr/share/nginx/html/assets/animations/
  fi
fi

# Establecer permisos correctos para los assets
echo "Estableciendo permisos para los assets..."
chmod -R 755 /usr/share/nginx/html/assets

# Iniciar Nginx
echo "Iniciando Nginx..."
exec nginx -g 'daemon off;'
