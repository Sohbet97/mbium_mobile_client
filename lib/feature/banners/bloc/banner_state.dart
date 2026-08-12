part of 'banner_bloc.dart';

sealed class BannerState extends Equatable {
  const BannerState();

  @override
  List<Object?> get props => [];
}

final class BannerInitial extends BannerState {}

final class BannerLoading extends BannerState {}

final class BannerLoaded extends BannerState {
  final List<BannerModel> banners;

  const BannerLoaded({required this.banners});

  List<BannerModel> bannersByType(String slug) {
    return banners.where((b) => b.bannerType?.slug == slug).toList();
  }

  List<BannerModel> get activeBanners {
    return banners.where((b) => b.isCurrentlyActive).toList();
  }

  @override
  List<Object?> get props => [banners];
}

final class BannerError extends BannerState {
  final String message;

  const BannerError({required this.message});

  @override
  List<Object?> get props => [message];
}
