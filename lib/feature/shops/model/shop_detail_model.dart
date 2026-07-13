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
  final int? order;
  final int? status;
  final bool? isActive;
  final bool? isVerified;
  final int? verificationStatus;
  final String? verificationNote;
  final String? verifiedAt;
  final String? verifiedBy;
  final String? rating;
  final int? planId;
  final String? videoUrl;
  final String? passportFile;
  final String? patentFile;
  final String? bankIban;
  final String? cardNumber;
  final int? sellerTier;
  final String? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final ShopDetailType? type;
  final ShopOwner? owner;
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
    this.order,
    this.status,
    this.isActive,
    this.isVerified,
    this.verificationStatus,
    this.verificationNote,
    this.verifiedAt,
    this.verifiedBy,
    this.rating,
    this.planId,
    this.videoUrl,
    this.passportFile,
    this.patentFile,
    this.bankIban,
    this.cardNumber,
    this.sellerTier,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.type,
    this.owner,
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
      order: json['order'] as int?,
      status: json['status'] as int?,
      isActive: json['is_active'] as bool?,
      isVerified: json['is_verified'] as bool?,
      verificationStatus: json['verification_status'] as int?,
      verificationNote: json['verification_note'] as String?,
      verifiedAt: json['verified_at'] as String?,
      verifiedBy: json['verified_by'] as String?,
      rating: json['rating'] as String?,
      planId: json['plan_id'] as int?,
      videoUrl: json['video_url'] as String?,
      passportFile: json['passport_file'] as String?,
      patentFile: json['patent_file'] as String?,
      bankIban: json['bank_iban'] as String?,
      cardNumber: json['card_number'] as String?,
      sellerTier: json['seller_tier'] as int?,
      createdBy: json['createdBy'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
      deletedAt: json['deletedAt'] != null
          ? DateTime.tryParse(json['deletedAt'] as String)
          : null,
      type: json['type'] != null
          ? ShopDetailType.fromJson(json['type'] as Map<String, dynamic>)
          : null,
      owner: json['owner'] != null
          ? ShopOwner.fromJson(json['owner'] as Map<String, dynamic>)
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
      'order': order,
      'status': status,
      'is_active': isActive,
      'is_verified': isVerified,
      'verification_status': verificationStatus,
      'verification_note': verificationNote,
      'verified_at': verifiedAt,
      'verified_by': verifiedBy,
      'rating': rating,
      'plan_id': planId,
      'video_url': videoUrl,
      'passport_file': passportFile,
      'patent_file': patentFile,
      'bank_iban': bankIban,
      'card_number': cardNumber,
      'seller_tier': sellerTier,
      'createdBy': createdBy,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
      'type': type?.toJson(),
      'owner': owner?.toJson(),
      'categories': categories.map((e) => e.toJson()).toList(),
    };
  }
}

class ShopOwner {
  final String? id;
  final String? name;
  final String? surname;
  final String? phoneNumber;
  final String? email;
  final int? status;

  const ShopOwner({
    this.id,
    this.name,
    this.surname,
    this.phoneNumber,
    this.email,
    this.status,
  });

  factory ShopOwner.fromJson(Map<String, dynamic> json) {
    return ShopOwner(
      id: json['id'] as String?,
      name: json['name'] as String?,
      surname: json['surname'] as String?,
      phoneNumber: json['phone_number'] as String?,
      email: json['email'] as String?,
      status: json['status'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'surname': surname,
      'phone_number': phoneNumber,
      'email': email,
      'status': status,
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
