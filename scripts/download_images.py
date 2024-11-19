import os
import requests
from PIL import Image
from io import BytesIO
import sys

# Headers para las solicitudes HTTP
HEADERS = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
}

# URLs de las imágenes (usando Pexels como fuente principal)
INSECT_IMAGES = {
    'monarch_butterfly.jpg': 'https://images.pexels.com/photos/2614/nature-butterfly-flying-spring.jpg',
    'honey_bee.jpg': 'https://images.pexels.com/photos/2289909/pexels-photo-2289909.jpeg',
    'maize_weevil.jpg': 'https://images.pexels.com/photos/1108499/pexels-photo-1108499.jpeg',
    'whitefly.jpg': 'https://images.pexels.com/photos/1912176/pexels-photo-1912176.jpeg',
    'fall_armyworm.jpg': 'https://images.pexels.com/photos/1386644/pexels-photo-1386644.jpeg',
    'western_flower_thrips.jpg': 'https://images.pexels.com/photos/1828875/pexels-photo-1828875.jpeg',
    'green_peach_aphid.jpg': 'https://images.pexels.com/photos/1080696/pexels-photo-1080696.jpeg',
    'white_grub.jpg': 'https://images.pexels.com/photos/587840/pexels-photo-587840.jpeg',
    'pepper_weevil.jpg': 'https://images.pexels.com/photos/1099265/pexels-photo-1099265.jpeg',
    'tobacco_hornworm.jpg': 'https://images.pexels.com/photos/1089440/pexels-photo-1089440.jpeg',
    'red_spider_mite.jpg': 'https://images.pexels.com/photos/1108598/pexels-photo-1108598.jpeg',
    'sugarcane_borer.jpg': 'https://images.pexels.com/photos/1178822/pexels-photo-1178822.jpeg',
    'green_stink_bug.jpg': 'https://images.pexels.com/photos/1099242/pexels-photo-1099242.jpeg',
    'leafminer.jpg': 'https://images.pexels.com/photos/1212487/pexels-photo-1212487.jpeg',
    'diamondback_moth.jpg': 'https://images.pexels.com/photos/1057315/pexels-photo-1057315.jpeg',
    'beet_armyworm.jpg': 'https://images.pexels.com/photos/1178908/pexels-photo-1178908.jpeg',
    'cotton_boll_weevil.jpg': 'https://images.pexels.com/photos/1108503/pexels-photo-1108503.jpeg',
    'greenhouse_whitefly.jpg': 'https://images.pexels.com/photos/1178919/pexels-photo-1178919.jpeg',
    'corn_earworm.jpg': 'https://images.pexels.com/photos/1108473/pexels-photo-1108473.jpeg',
    'avocado_thrips.jpg': 'https://images.pexels.com/photos/1178914/pexels-photo-1178914.jpeg',
}

# Imagen de respaldo en caso de que falle la descarga
FALLBACK_IMAGES = {
    'default': 'https://images.pexels.com/photos/1912176/pexels-photo-1912176.jpeg'
}

def create_placeholder_image(size=(800, 800), color='#f0f0f0'):
    """Crea una imagen placeholder con un ícono de insecto."""
    img = Image.new('RGB', size, color)
    # Aquí podrías agregar un ícono o texto si lo deseas
    return img

def optimize_image(image_data, max_size=(800, 800), quality=85):
    """Optimiza la imagen para uso móvil."""
    try:
        img = Image.open(BytesIO(image_data))
        
        # Convertir a RGB si es necesario
        if img.mode in ('RGBA', 'P'):
            img = img.convert('RGB')
        
        # Redimensionar manteniendo la proporción
        img.thumbnail(max_size, Image.Resampling.LANCZOS)
        
        # Guardar en memoria
        output = BytesIO()
        img.save(output, format='JPEG', quality=quality, optimize=True)
        return output.getvalue()
    except Exception as e:
        print(f"Error optimizing image: {e}")
        return None

def download_and_save_image(url, filename, output_dir):
    """Descarga y guarda una imagen optimizada."""
    try:
        print(f"Downloading {filename}...")
        response = requests.get(url, headers=HEADERS)
        if response.status_code == 200:
            # Optimizar la imagen
            optimized_image = optimize_image(response.content)
            if optimized_image:
                # Guardar la imagen optimizada
                output_path = os.path.join(output_dir, filename)
                with open(output_path, 'wb') as f:
                    f.write(optimized_image)
                print(f"Successfully saved {filename}")
                return True
        else:
            print(f"Failed to download {filename}: HTTP {response.status_code}")
            # Intentar con la imagen de respaldo
            fallback_response = requests.get(FALLBACK_IMAGES['default'], headers=HEADERS)
            if fallback_response.status_code == 200:
                optimized_image = optimize_image(fallback_response.content)
                if optimized_image:
                    output_path = os.path.join(output_dir, filename)
                    with open(output_path, 'wb') as f:
                        f.write(optimized_image)
                    print(f"Saved fallback image for {filename}")
                    return True
    except Exception as e:
        print(f"Error downloading {filename}: {e}")
        
    # Si todo falla, crear un placeholder
    try:
        placeholder = create_placeholder_image()
        output_path = os.path.join(output_dir, filename)
        placeholder.save(output_path, 'JPEG', quality=85)
        print(f"Created placeholder for {filename}")
        return True
    except Exception as e:
        print(f"Error creating placeholder for {filename}: {e}")
    
    return False

def main():
    # Directorio de salida
    output_dir = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), 
                             'assets', 'images', 'insects')
    
    # Crear directorio si no existe
    os.makedirs(output_dir, exist_ok=True)
    
    # Descargar y optimizar cada imagen
    success_count = 0
    for filename, url in INSECT_IMAGES.items():
        if download_and_save_image(url, filename, output_dir):
            success_count += 1
    
    total_images = len(INSECT_IMAGES)
    print(f"\nDownload complete: {success_count}/{total_images} images processed successfully")

if __name__ == "__main__":
    main()
