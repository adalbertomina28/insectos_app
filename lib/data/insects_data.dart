import '../models/insect.dart';

final List<Insect> allInsects = [
  Insect(
    name: 'Abeja Melífera',
    scientificName: 'Apis mellifera',
    emoji: '🐝',
    description: 'La abeja melífera es uno de los insectos más importantes para la agricultura y los ecosistemas. Son expertas polinizadoras y viven en colonias altamente organizadas.',
    imageUrl: 'assets/images/insects/honey_bee.jpg',
    characteristics: [
      'Cuerpo rayado negro y amarillo',
      'Alas transparentes',
      'Aguijón defensivo',
      'Comportamiento social',
    ],
    impact: 'Fundamental para la polinización de cultivos y plantas silvestres. La producción de miel y otros productos apícolas tiene gran valor económico.',
    categories: ['Polinizadores', 'Benéficos'],
    habitat: ['Terrestre', 'Aéreo'],
    size: '12-15 mm',
    diet: ['Néctar', 'Polen'],
    activity: ['Diurno'],
    distribution: ['Mundial'],
    lifecycle: ['Huevo', 'Larva', 'Pupa', 'Adulto'],
  ),
  Insect(
    name: 'Mariposa Monarca',
    scientificName: 'Danaus plexippus',
    emoji: '🦋',
    description: 'La mariposa monarca es conocida por su increíble migración anual y sus distintivos colores naranja y negro. Es un símbolo de la conservación de insectos.',
    imageUrl: 'assets/images/insects/monarch.jpg',
    characteristics: [
      'Alas naranja con venas negras',
      'Puntos blancos en bordes negros',
      'Gran envergadura',
      'Vuelo planificado',
    ],
    impact: 'Importante polinizador y bioindicador ambiental. Su migración es un fenómeno natural único.',
    categories: ['Polinizadores', 'Benéficos'],
    habitat: ['Terrestre', 'Aéreo'],
    size: '8.9-10.2 cm de envergadura',
    diet: ['Néctar'],
    activity: ['Diurno'],
    distribution: ['América del Norte', 'América Central'],
    lifecycle: ['Huevo', 'Oruga', 'Crisálida', 'Adulto'],
  ),
  Insect(
    name: 'Escarabajo Mariquita',
    scientificName: 'Coccinella septempunctata',
    emoji: '🐞',
    description: 'Las mariquitas son pequeños escarabajos conocidos por sus colores brillantes y su papel en el control natural de plagas.',
    imageUrl: 'assets/images/insects/ladybug.jpg',
    characteristics: [
      'Élitros rojos con puntos negros',
      'Forma semiesférica',
      'Pequeño tamaño',
      'Vuelo ágil',
    ],
    impact: 'Control biológico natural de áfidos y otros insectos dañinos para las plantas.',
    categories: ['Benéficos', 'Depredadores'],
    habitat: ['Terrestre', 'Aéreo'],
    size: '5-8 mm',
    diet: ['Áfidos', 'Cochinillas'],
    activity: ['Diurno'],
    distribution: ['Mundial'],
    lifecycle: ['Huevo', 'Larva', 'Pupa', 'Adulto'],
  ),
  Insect(
    name: 'Mantis Religiosa',
    scientificName: 'Mantis religiosa',
    emoji: '🦗',
    description: 'La mantis religiosa es un depredador fascinante conocido por su postura característica y sus habilidades de camuflaje.',
    imageUrl: 'assets/images/insects/praying_mantis.jpg',
    characteristics: [
      'Patas delanteras raptoras',
      'Cabeza triangular móvil',
      'Excelente visión',
      'Camuflaje natural',
    ],
    impact: 'Depredador natural que ayuda a controlar poblaciones de insectos, incluyendo algunas plagas.',
    categories: ['Benéficos', 'Depredadores'],
    habitat: ['Terrestre'],
    size: '5-7.5 cm',
    diet: ['Insectos', 'Arañas'],
    activity: ['Diurno', 'Nocturno'],
    distribution: ['Mundial'],
    lifecycle: ['Huevo', 'Ninfa', 'Adulto'],
  ),
  Insect(
    name: 'Luciérnaga',
    scientificName: 'Lampyris noctiluca',
    emoji: '🪲',
    description: 'Las luciérnagas son escarabajos nocturnos conocidos por su capacidad de producir luz bioluminiscente para atraer parejas.',
    imageUrl: 'assets/images/insects/firefly.jpg',
    characteristics: [
      'Bioluminiscencia',
      'Vuelo nocturno',
      'Cuerpo alargado',
      'Élitros flexibles',
    ],
    impact: 'Bioindicador de la salud ambiental y contribuye al control de caracoles y babosas.',
    categories: ['Benéficos', 'Depredadores'],
    habitat: ['Terrestre', 'Aéreo'],
    size: '10-25 mm',
    diet: ['Caracoles', 'Babosas'],
    activity: ['Nocturno'],
    distribution: ['Mundial'],
    lifecycle: ['Huevo', 'Larva', 'Pupa', 'Adulto'],
  ),
  Insect(
    name: 'Hormiga Carpintera',
    scientificName: 'Camponotus spp.',
    emoji: '🐜',
    description: 'Las hormigas carpinteras son insectos sociales que construyen sus nidos en madera. Son importantes en el ecosistema forestal.',
    imageUrl: 'assets/images/insects/carpenter_ant.jpg',
    characteristics: [
      'Cuerpo negro o rojizo',
      'Mandíbulas fuertes',
      'Comportamiento social',
      'Polimorfismo',
    ],
    impact: 'Ayudan en la descomposición de madera muerta y el ciclo de nutrientes en bosques.',
    categories: ['Benéficos'],
    habitat: ['Terrestre', 'Subterráneo'],
    size: '6-12 mm',
    diet: ['Insectos', 'Néctar', 'Hongos'],
    activity: ['Diurno', 'Nocturno'],
    distribution: ['Mundial'],
    lifecycle: ['Huevo', 'Larva', 'Pupa', 'Adulto'],
  ),
  Insect(
    name: 'Libélula',
    scientificName: 'Anax imperator',
    emoji: '🦋',
    description: 'Las libélulas son excelentes voladoras y depredadoras. Son indicadores de la salud de ecosistemas acuáticos.',
    imageUrl: 'assets/images/insects/dragonfly.jpg',
    characteristics: [
      'Cuatro alas transparentes',
      'Ojos compuestos grandes',
      'Vuelo preciso',
      'Colores brillantes',
    ],
    impact: 'Control natural de mosquitos y otros insectos voladores. Indicador de calidad del agua.',
    categories: ['Benéficos', 'Depredadores'],
    habitat: ['Aéreo', 'Acuático'],
    size: '7-8 cm',
    diet: ['Mosquitos', 'Insectos voladores'],
    activity: ['Diurno'],
    distribution: ['Mundial'],
    lifecycle: ['Huevo', 'Ninfa', 'Adulto'],
  ),
  Insect(
    name: 'Grillo',
    scientificName: 'Acheta domesticus',
    emoji: '🦗',
    description: 'Los grillos son conocidos por su canto nocturno producido por el roce de sus alas. Son importantes en la cadena alimenticia.',
    imageUrl: 'assets/images/insects/cricket.jpg',
    characteristics: [
      'Antenas largas',
      'Patas saltadoras',
      'Alas que producen sonido',
      'Cuerpo cilíndrico',
    ],
    impact: 'Parte importante de la cadena alimenticia y contribuye a la biodiversidad del suelo.',
    categories: ['Benéficos'],
    habitat: ['Terrestre', 'Subterráneo'],
    size: '15-20 mm',
    diet: ['Plantas', 'Materia orgánica'],
    activity: ['Nocturno'],
    distribution: ['Mundial'],
    lifecycle: ['Huevo', 'Ninfa', 'Adulto'],
  ),
];