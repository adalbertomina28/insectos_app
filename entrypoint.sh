#!/bin/sh

# Obtener la URL de la API desde la variable de entorno o usar el valor predeterminado
SEARCH_API_URL=${SEARCH_API_URL:-https://api.insectlab.app}

# Reemplazar el marcador en el archivo index.html
sed -i "s|__SEARCH_API_URL__|${SEARCH_API_URL}|g" /usr/share/nginx/html/index.html

# Imprimir información para depuración
echo "Configurando API URL: ${SEARCH_API_URL}"

# Iniciar Nginx
exec nginx -g 'daemon off;'
