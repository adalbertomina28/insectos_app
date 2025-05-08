#!/bin/sh

# Obtener la URL de la API desde la variable de entorno o usar el valor predeterminado
API_BASE_URL=${API_BASE_URL:-https://api.insectlab.app}

# Imprimir información para depuración
echo "Configurando API URL: ${API_BASE_URL}"

# Reemplazar variables de entorno en index.html
echo "Sustituyendo variables de entorno en index.html..."
envsubst '$API_BASE_URL' < /usr/share/nginx/html/index.html > /usr/share/nginx/html/index.tmp.html
mv /usr/share/nginx/html/index.tmp.html /usr/share/nginx/html/index.html

# Buscar y reemplazar en los archivos JavaScript principales
echo "Buscando archivos JavaScript principales..."
for jsfile in /usr/share/nginx/html/main.dart.js /usr/share/nginx/html/flutter.js /usr/share/nginx/html/*.part.js
do
  if [ -f "$jsfile" ]; then
    echo "Reemplazando API_BASE_URL en $jsfile"
    sed -i "s|https://api.insectlab.app|${API_BASE_URL}|g" "$jsfile"
    sed -i "s|http://api.insectlab.app|${API_BASE_URL}|g" "$jsfile"
    # También buscar cualquier URL generada por Coolify
    sed -i "s|http://[a-z0-9]*\.[0-9]*\.[0-9]*\.[0-9]*\.sslip\.io/api|${API_BASE_URL}/api|g" "$jsfile"
  fi
done

# Iniciar Nginx
exec nginx -g 'daemon off;'
