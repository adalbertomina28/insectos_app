import 'package:intl/intl.dart';

class ObservationPhoto {
  final String id;
  final String observationId;
  final String photoUrl;
  final String? description;
  final int order;
  final DateTime createdAt;

  ObservationPhoto({
    required this.id,
    required this.observationId,
    required this.photoUrl,
    this.description,
    required this.order,
    required this.createdAt,
  });

  factory ObservationPhoto.fromJson(Map<String, dynamic> json) {
    return ObservationPhoto(
      id: json['id'] ?? '',
      observationId: json['observation_id'] ?? '',
      photoUrl: json['photo_url'] ?? '',
      description: json['description'],
      order: json['order'] ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'observation_id': observationId,
      'photo_url': photoUrl,
      'description': description,
      'order': order,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class Observation {
  final String id;
  final String userId;
  final int? inaturalistId;
  final String scientificName;
  final String? commonName;
  final DateTime observationDate;
  final double latitude;
  final double longitude;
  final int conditionId;
  final int stateId;
  final int stageId;
  final int sexId;
  final String? description;
  final DateTime createdAt;
  final List<ObservationPhoto> photos;

  Observation({
    required this.id,
    required this.userId,
    this.inaturalistId,
    required this.scientificName,
    this.commonName,
    required this.observationDate,
    required this.latitude,
    required this.longitude,
    required this.conditionId,
    required this.stateId,
    required this.stageId,
    required this.sexId,
    this.description,
    required this.createdAt,
    required this.photos,
  });

  factory Observation.fromJson(Map<String, dynamic> json) {
    List<ObservationPhoto> photosList = [];
    if (json['photos'] != null) {
      photosList = List<ObservationPhoto>.from(
        json['photos'].map((photo) => ObservationPhoto.fromJson(photo)),
      );
    }

    return Observation(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      inaturalistId: json['inaturalist_id'],
      scientificName: json['scientific_name'] ?? '',
      commonName: json['common_name'],
      observationDate: json['observation_date'] != null
          ? DateTime.parse(json['observation_date'])
          : DateTime.now(),
      latitude: json['latitude'] != null ? double.parse(json['latitude'].toString()) : 0.0,
      longitude: json['longitude'] != null ? double.parse(json['longitude'].toString()) : 0.0,
      conditionId: json['condition_id'] ?? 1,
      stateId: json['state_id'] ?? 1,
      stageId: json['stage_id'] ?? 1,
      sexId: json['sex_id'] ?? 1,
      description: json['description'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      photos: photosList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'inaturalist_id': inaturalistId,
      'scientific_name': scientificName,
      'common_name': commonName,
      'observation_date': DateFormat('yyyy-MM-dd').format(observationDate),
      'latitude': latitude,
      'longitude': longitude,
      'condition_id': conditionId,
      'state_id': stateId,
      'stage_id': stageId,
      'sex_id': sexId,
      'description': description,
      'created_at': createdAt.toIso8601String(),
      'photos': photos.map((photo) => photo.toJson()).toList(),
    };
  }

  // Método para obtener la primera foto o una URL por defecto
  String get mainPhotoUrl {
    if (photos.isNotEmpty) {
      return photos.first.photoUrl;
    }
    return 'images/vectors/no_image_attached.png'; // Imagen por defecto
  }

  // Método para obtener una representación formateada de la fecha
  String get formattedDate {
    return DateFormat('dd/MM/yyyy').format(observationDate);
  }
}
