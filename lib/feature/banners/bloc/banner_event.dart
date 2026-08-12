part of 'banner_bloc.dart';

sealed class BannerEvent extends Equatable {
  const BannerEvent();

  @override
  List<Object?> get props => [];
}

final class LoadBannersEvent extends BannerEvent {
  final String? type;
  final int? shopId;

  const LoadBannersEvent({this.type, this.shopId});

  @override
  List<Object?> get props => [type, shopId];
}
