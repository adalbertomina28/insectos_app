// Modelo para las opciones de observación
class ObservationOption {
  final int id;
  final String name;

  ObservationOption({required this.id, required this.name});
}

// Opciones para la condición del insecto
class ConditionOptions {
  static final List<ObservationOption> options = [
    ObservationOption(id: 1, name: 'Vivo'),
    ObservationOption(id: 2, name: 'Muerto'),
    ObservationOption(id: 3, name: 'Restos'),
  ];

  static ObservationOption getById(int id) {
    return options.firstWhere(
      (option) => option.id == id,
      orElse: () => options.first,
    );
  }
}

// Opciones para el estado del insecto
class StateOptions {
  static final List<ObservationOption> options = [
    ObservationOption(id: 1, name: 'Saludable'),
    ObservationOption(id: 2, name: 'Enfermo'),
    ObservationOption(id: 3, name: 'Herido'),
    ObservationOption(id: 4, name: 'Desconocido'),
  ];

  static ObservationOption getById(int id) {
    return options.firstWhere(
      (option) => option.id == id,
      orElse: () => options.first,
    );
  }
}

// Opciones para la etapa del insecto
class StageOptions {
  static final List<ObservationOption> options = [
    ObservationOption(id: 1, name: 'Huevo'),
    ObservationOption(id: 2, name: 'Larva'),
    ObservationOption(id: 3, name: 'Pupa'),
    ObservationOption(id: 4, name: 'Adulto'),
    ObservationOption(id: 5, name: 'Desconocido'),
  ];

  static ObservationOption getById(int id) {
    return options.firstWhere(
      (option) => option.id == id,
      orElse: () => options.first,
    );
  }
}

// Opciones para el sexo del insecto
class SexOptions {
  static final List<ObservationOption> options = [
    ObservationOption(id: 1, name: 'Macho'),
    ObservationOption(id: 2, name: 'Hembra'),
    ObservationOption(id: 3, name: 'Desconocido'),
  ];

  static ObservationOption getById(int id) {
    return options.firstWhere(
      (option) => option.id == id,
      orElse: () => options.first,
    );
  }
}
