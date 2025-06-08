# InsectLab - Aplicación Educativa de Entomología

InsectLab es una aplicación móvil desarrollada con Flutter que proporciona una plataforma educativa completa sobre entomología, con un enfoque especial en la identificación y clasificación de insectos, así como en el control biológico de plagas mediante tecnología de ARN.

## Características Principales

### 1. Base de Datos de Insectos
- Catálogo extenso de especies de insectos
- Búsqueda por nombre, familia o características
- Información detallada sobre cada especie
- Enlaces a recursos externos como Wikipedia

### 2. Educación Entomológica
- Introducción a la entomología
- Información sobre anatomía de insectos
- Ciclos de vida y comportamientos
- Importancia ecológica y económica

### 3. Control Biológico y ARN
- Explicación de la tecnología de ARN para control de plagas
- Ejemplos prácticos en cultivos importantes (arroz, café, plátano, sandía)
- Información sobre efectividad y procesos de implementación

### 4. Características Técnicas
- Interfaz de usuario intuitiva y atractiva
- Soporte multilingüe (Español e Inglés)
- Modo oscuro/claro adaptable
- Diseño responsivo para diferentes tamaños de pantalla

## PROXIMAMENTE

### 1. Identificación de Insectos con IA
- Captura de fotos para identificación automática
- Integración con servicios de geolocalización para mejorar la precisión
- Visualización de resultados con nivel de confianza

### 2. Juegos Educativos
- Actividades interactivas para aprender sobre insectos
- Cuestionarios y retos de identificación

## Tecnologías Utilizadas

- **Framework**: Flutter
- **Gestión de Estado**: GetX
- **Internacionalización**: GetX Translation
- **Persistencia de Datos**: SharedPreferences
- **Servicios de Ubicación**: Geolocator
- **Captura de Imágenes**: Camera Plugin

## Estructura del Proyecto

```
lib/
├── main.dart                # Punto de entrada de la aplicación
├── routes/                  # Configuración de rutas de navegación
├── models/                  # Modelos de datos
├── screens/                 # Pantallas de la aplicación
│   ├── home/                # Pantalla principal
│   ├── search/              # Búsqueda de insectos
│   ├── identification/      # Identificación con IA
│   ├── about/               # Acerca de la aplicación
│   ├── rna/                 # Control biológico y ARN
│   └── games/               # Juegos educativos
├── widgets/                 # Widgets reutilizables
├── services/                # Servicios de la aplicación
├── theme/                   # Configuración de temas
└── translations/            # Archivos de traducción (es, en)
```

## Instalación

1. Asegúrate de tener Flutter instalado en tu sistema
2. Clona este repositorio
3. Ejecuta `flutter pub get` para instalar las dependencias
4. Conecta un dispositivo o inicia un emulador
5. Ejecuta `flutter run` para iniciar la aplicación
flutter run -d web-server -d chrome --web-port=3000

## Contribuciones

Las contribuciones son bienvenidas. Si eres entomólogo, biólogo o entusiasta de los insectos y te gustaría contribuir con contenido para la aplicación, ¡nos encantaría escucharte!

## Licencia

Este proyecto está licenciado bajo la Licencia MIT - ver el archivo LICENSE para más detalles.

## Contacto

Para más información, contacta con el equipo de desarrollo en insectlabapp@gmail.com
