class ShopTypesResponse {
  final List<ShopTypeModel> shopTypes;

  const ShopTypesResponse({required this.shopTypes});

  factory ShopTypesResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as List? ?? [];

    return ShopTypesResponse(
      shopTypes: data
          .map((e) => ShopTypeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ShopTypeModel {
  final int? id;
  final String? name;
  final String? nameRu;
  final String? nameEng;
  final double? commissionRate;
  final bool? isActive;

  const ShopTypeModel({
    this.id,
    this.name,
    this.nameRu,
    this.nameEng,
    this.commissionRate,
    this.isActive,
  });

  factory ShopTypeModel.fromJson(Map<String, dynamic> json) {
    return ShopTypeModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      nameRu: json['name_ru'] as String?,
      nameEng: json['name_eng'] as String?,
      commissionRate: double.tryParse(
        json['commission_rate']?.toString() ?? '',
      ),
      isActive: json['is_active'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_ru': nameRu,
      'name_eng': nameEng,
      'commission_rate': commissionRate,
      'is_active': isActive,
    };
  }
}
