class AddressCoordinates {
  final double lat;
  final double lng;

  const AddressCoordinates({required this.lat, required this.lng});

  factory AddressCoordinates.fromJson(Map<String, dynamic> json) {
    return AddressCoordinates(
      lat: (json['lat'] as num?)?.toDouble() ?? 0,
      lng: (json['lng'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {'lat': lat, 'lng': lng};
}

class AddressModel {
  final int id;
  final String userId;
  final String label;
  final String address;
  final int cityId;
  final int regionId;
  final AddressCoordinates coordinates;
  final bool isDefault;
  final DateTime? createdAt;

  const AddressModel({
    required this.id,
    required this.userId,
    required this.label,
    required this.address,
    required this.cityId,
    required this.regionId,
    required this.coordinates,
    required this.isDefault,
    this.createdAt,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] as int? ?? 0,
      userId: json['user_id']?.toString() ?? '',
      label: json['label'] as String? ?? '',
      address: json['address'] as String? ?? '',
      cityId: json['city_id'] as int? ?? 0,
      regionId: json['region_id'] as int? ?? 0,
      coordinates: json['coordinates'] != null
          ? AddressCoordinates.fromJson(
              json['coordinates'] as Map<String, dynamic>,
            )
          : const AddressCoordinates(lat: 0, lng: 0),
      isDefault: json['is_default'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
    );
  }

  /// Request body shape for POST/PUT — server assigns id/user_id/createdAt.
  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'address': address,
      'city_id': cityId,
      'region_id': regionId,
      'coordinates': coordinates.toJson(),
      'is_default': isDefault,
    };
  }

  AddressModel copyWith({
    int? id,
    String? userId,
    String? label,
    String? address,
    int? cityId,
    int? regionId,
    AddressCoordinates? coordinates,
    bool? isDefault,
    DateTime? createdAt,
  }) {
    return AddressModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      label: label ?? this.label,
      address: address ?? this.address,
      cityId: cityId ?? this.cityId,
      regionId: regionId ?? this.regionId,
      coordinates: coordinates ?? this.coordinates,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
