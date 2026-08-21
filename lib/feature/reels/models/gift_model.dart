double _parseDouble(dynamic value) {
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0.0;
}

int _parseInt(dynamic value) {
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

DateTime? _parseDate(dynamic value) {
  if (value is! String) return null;
  return DateTime.tryParse(value);
}

/// A gift a viewer can send to a reel — the catalog entry from
/// `GET /reels/gift-types`, and also the shape nested inside a sent
/// [GiftModel] (which additionally carries `icon`/`gift_creator`).
class GiftTypeModel {
  final int id;
  final String name;
  final int priceCoin;
  final double priceTmt;
  final String? effectDescription;
  final int sortOrder;
  final bool isActive;
  final GiftMedia? animation;
  final GiftMedia? icon;
  final GiftCreatorModel? giftCreator;

  const GiftTypeModel({
    required this.id,
    required this.name,
    required this.priceCoin,
    required this.priceTmt,
    this.effectDescription,
    this.sortOrder = 0,
    this.isActive = true,
    this.animation,
    this.icon,
    this.giftCreator,
  });

  factory GiftTypeModel.fromJson(Map<String, dynamic> json) {
    return GiftTypeModel(
      id: _parseInt(json['id']),
      name: json['name'] as String? ?? '',
      priceCoin: _parseInt(json['price_coin']),
      priceTmt: _parseDouble(json['price_tmt']),
      effectDescription: json['effect_description'] as String?,
      sortOrder: _parseInt(json['sort_order']),
      isActive: json['is_active'] as bool? ?? true,
      animation: json['animation'] != null
          ? GiftMedia.fromJson(json['animation'] as Map<String, dynamic>)
          : null,
      icon: json['icon'] != null
          ? GiftMedia.fromJson(json['icon'] as Map<String, dynamic>)
          : null,
      giftCreator: json['gift_creator'] != null
          ? GiftCreatorModel.fromJson(
              json['gift_creator'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class GiftMedia {
  final String id;
  final String url;
  final String? mimeType;

  const GiftMedia({required this.id, required this.url, this.mimeType});

  factory GiftMedia.fromJson(Map<String, dynamic> json) {
    return GiftMedia(
      id: json['id'] as String? ?? '',
      url: json['url'] as String? ?? '',
      mimeType: json['mime_type'] as String?,
    );
  }
}

class GiftCreatorModel {
  final int id;
  final String name;
  final String? contactNote;
  final bool isActive;
  final GiftMedia? avatar;
  final GiftCreatorBalance? balance;

  const GiftCreatorModel({
    required this.id,
    required this.name,
    this.contactNote,
    this.isActive = true,
    this.avatar,
    this.balance,
  });

  factory GiftCreatorModel.fromJson(Map<String, dynamic> json) {
    return GiftCreatorModel(
      id: _parseInt(json['id']),
      name: json['name'] as String? ?? '',
      contactNote: json['contact_note'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      avatar: json['avatar'] != null
          ? GiftMedia.fromJson(json['avatar'] as Map<String, dynamic>)
          : null,
      balance: json['balance'] != null
          ? GiftCreatorBalance.fromJson(json['balance'] as Map<String, dynamic>)
          : null,
    );
  }
}

class GiftCreatorBalance {
  final int giftCreatorId;
  final double availableBalance;
  final String currency;

  const GiftCreatorBalance({
    required this.giftCreatorId,
    required this.availableBalance,
    required this.currency,
  });

  factory GiftCreatorBalance.fromJson(Map<String, dynamic> json) {
    return GiftCreatorBalance(
      giftCreatorId: _parseInt(json['gift_creator_id']),
      availableBalance: _parseDouble(json['available_balance']),
      currency: json['currency'] as String? ?? 'TMT',
    );
  }
}

class GiftSenderModel {
  final String id;
  final String name;
  final String surname;

  const GiftSenderModel({
    required this.id,
    required this.name,
    required this.surname,
  });

  factory GiftSenderModel.fromJson(Map<String, dynamic> json) {
    return GiftSenderModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      surname: json['surname'] as String? ?? '',
    );
  }

  String get fullName => [name, surname].where((s) => s.isNotEmpty).join(' ');
}

/// A gift as actually sent to a reel — returned by both the reel gift-history
/// list and the send-gift response.
class GiftModel {
  final int id;
  final int reelId;
  final int priceCoin;
  final double priceTmt;
  final String message;
  final DateTime? createdAt;
  final GiftSenderModel user;
  final GiftTypeModel giftType;

  const GiftModel({
    required this.id,
    required this.reelId,
    required this.priceCoin,
    required this.priceTmt,
    required this.message,
    this.createdAt,
    required this.user,
    required this.giftType,
  });

  factory GiftModel.fromJson(Map<String, dynamic> json) {
    return GiftModel(
      id: _parseInt(json['id']),
      reelId: _parseInt(json['reel_id']),
      priceCoin: _parseInt(json['price_coin']),
      priceTmt: _parseDouble(json['price_tmt']),
      message: json['message'] as String? ?? '',
      createdAt: _parseDate(json['createdAt']),
      user: GiftSenderModel.fromJson(
        json['user'] as Map<String, dynamic>? ?? {},
      ),
      giftType: GiftTypeModel.fromJson(
        json['gift_type'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}

class GiftsResponse {
  final List<GiftModel> gifts;
  final int count;

  const GiftsResponse({required this.gifts, required this.count});

  bool hasMore(int page, int limit) => page * limit < count;

  factory GiftsResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as List? ?? [];
    return GiftsResponse(
      gifts: data
          .map((e) => GiftModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      count: json['count'] as int? ?? data.length,
    );
  }
}
