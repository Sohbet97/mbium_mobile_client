import 'package:equatable/equatable.dart';

class ReelsFilterModel extends Equatable {
  final int page;
  final int limit;
  final String? text;
  final bool? isLive;

  const ReelsFilterModel({
    this.page = 1,
    this.limit = 20,
    this.text,
    this.isLive,
  });

  ReelsFilterModel copyWith({
    int? page,
    int? limit,
    String? text,
    bool? isLive,
    bool clearText = false,
    bool clearIsLive = false,
  }) {
    return ReelsFilterModel(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      text: clearText ? null : (text ?? this.text),
      isLive: clearIsLive ? null : (isLive ?? this.isLive),
    );
  }

  ReelsFilterModel resetPage() => copyWith(page: 1);

  Map<String, dynamic> toQueryParameters() {
    return {
      'page': page,
      'limit': limit,
      if (text != null && text!.isNotEmpty) 'text': text,
      if (isLive != null) 'is_live': isLive! ? 1 : 0,
    };
  }

  @override
  List<Object?> get props => [page, limit, text, isLive];
}
