class RegionModel {
  final int id;
  final String name;
  final int countryId;

  const RegionModel({
    required this.id,
    required this.name,
    required this.countryId,
  });

  factory RegionModel.fromJson(Map<String, dynamic> json) {
    return RegionModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      countryId: json['country_id'] as int? ?? 0,
    );
  }
}

class CityModel {
  final int id;
  final String name;

  const CityModel({required this.id, required this.name});

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
    );
  }
}
