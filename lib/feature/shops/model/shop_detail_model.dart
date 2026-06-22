import 'package:mbium_mobile_client/feature/category/models/category_modes.dart';

class ShopDetailResponse {
  final ShopDetailModel model;

  const ShopDetailResponse({required this.model});

  factory ShopDetailResponse.fromJson(Map<String, dynamic> json) {
    return ShopDetailResponse(
      model: ShopDetailModel.fromJson(json['model'] as Map<String, dynamic>),
    );
  }
}

class ShopDetailModel {
  final int? id;
  final String? ownerId;
  final int? typeId;
  final String? name;
  final String? nameRu;
  final String? nameEng;
  final String? description;
  final String? descriptionTm;
  final String? descriptionRu;
  final String? descriptionEn;
  final String? logo;
  final String? address;
  final String? location;
  final ShopCoordinates? coordinates;
  final int? cityId;
  final int? regionId;
  final String? phone;
  final String? email;
  final int? status;
  final bool? isActive;
  final bool? isVerified;
  final int? verificationStatus;
  final String? verificationNote;
  final String? rating;
  final ShopDetailType? type;
  final List<CategoryModel> categories;

  const ShopDetailModel({
    this.id,
    this.ownerId,
    this.typeId,
    this.name,
    this.nameRu,
    this.nameEng,
    this.description,
    this.descriptionTm,
    this.descriptionRu,
    this.descriptionEn,
    this.logo,
    this.address,
    this.location,
    this.coordinates,
    this.cityId,
    this.regionId,
    this.phone,
    this.email,
    this.status,
    this.isActive,
    this.isVerified,
    this.verificationStatus,
    this.verificationNote,
    this.rating,
    this.type,
    this.categories = const [],
  });

  factory ShopDetailModel.fromJson(Map<String, dynamic> json) {
    return ShopDetailModel(
      id: json['id'] as int?,
      ownerId: json['owner_id'] as String?,
      typeId: json['type_id'] as int?,
      name: json['name'] as String?,
      nameRu: json['name_ru'] as String?,
      nameEng: json['name_eng'] as String?,
      description: json['description'] as String?,
      descriptionTm: json['description_tm'] as String?,
      descriptionRu: json['description_ru'] as String?,
      descriptionEn: json['description_en'] as String?,
      logo: json['logo'] as String?,
      address: json['address'] as String?,
      location: json['location'] as String?,
      coordinates: json['coordinates'] != null
          ? ShopCoordinates.fromJson(
              json['coordinates'] as Map<String, dynamic>,
            )
          : null,
      cityId: json['city_id'] as int?,
      regionId: json['region_id'] as int?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      status: json['status'] as int?,
      isActive: json['is_active'] as bool?,
      isVerified: json['is_verified'] as bool?,
      verificationStatus: json['verification_status'] as int?,
      verificationNote: json['verification_note'] as String?,
      rating: json['rating'] as String?,
      type: json['type'] != null
          ? ShopDetailType.fromJson(json['type'] as Map<String, dynamic>)
          : null,
      categories: json['categories'] != null
          ? (json['categories'] as List)
                .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
                .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'owner_id': ownerId,
      'type_id': typeId,
      'name': name,
      'name_ru': nameRu,
      'name_eng': nameEng,
      'description': description,
      'description_tm': descriptionTm,
      'description_ru': descriptionRu,
      'description_en': descriptionEn,
      'logo': logo,
      'address': address,
      'location': location,
      'coordinates': coordinates?.toJson(),
      'city_id': cityId,
      'region_id': regionId,
      'phone': phone,
      'email': email,
      'status': status,
      'is_active': isActive,
      'is_verified': isVerified,
      'verification_status': verificationStatus,
      'verification_note': verificationNote,
      'rating': rating,
      'type': type?.toJson(),
      'categories': categories.map((e) => e.toJson()).toList(),
    };
  }
}

class ShopCoordinates {
  final double? lat;
  final double? lng;

  const ShopCoordinates({this.lat, this.lng});

  factory ShopCoordinates.fromJson(Map<String, dynamic> json) {
    return ShopCoordinates(
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'lat': lat, 'lng': lng};
  }
}

class ShopDetailType {
  final int? id;
  final String? name;
  final String? nameRu;
  final String? nameEng;
  final double? commissionRate;
  final bool? isActive;

  const ShopDetailType({
    this.id,
    this.name,
    this.nameRu,
    this.nameEng,
    this.commissionRate,
    this.isActive,
  });

  factory ShopDetailType.fromJson(Map<String, dynamic> json) {
    return ShopDetailType(
      id: json['id'] as int?,
      name: json['name'] as String?,
      nameRu: json['name_ru'] as String?,
      nameEng: json['name_eng'] as String?,
      commissionRate: double.parse(json['commission_rate']),
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
