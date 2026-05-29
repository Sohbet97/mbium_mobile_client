import 'package:equatable/equatable.dart';

class ShopFilterModel extends Equatable {
  final int page;
  final int limit;
  final String? text;
  final int? typeId;

  const ShopFilterModel({
    this.page = 1,
    this.limit = 20,
    this.text,
    this.typeId,
  });

  ShopFilterModel copyWith({
    int? page,
    int? limit,
    String? text,
    int? typeId,
    bool clearText = false,
    bool clearTypeId = false,
  }) {
    return ShopFilterModel(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      text: clearText ? null : (text ?? this.text),
      typeId: clearTypeId ? null : (typeId ?? this.typeId),
    );
  }

  ShopFilterModel resetPage() => copyWith(page: 1);

  Map<String, dynamic> toQueryParameters() {
    return {
      'page': page,
      'limit': limit,
      if (text != null && text!.isNotEmpty) 'text': text,
      if (typeId != null) 'type_id': typeId,
    };
  }

  @override
  List<Object?> get props => [page, limit, text, typeId];
}
