import 'package:dio/dio.dart';
import 'package:mbium_mobile_client/core/storage/app_preferences.dart';
import 'package:mbium_mobile_client/feature/reels/models/reels_filter_model.dart';
import 'package:mbium_mobile_client/feature/reels/models/reels_model.dart';
import 'package:mbium_mobile_client/feature/reels/models/reels_response.dart';

class ReelsRepository {
  final Dio dio;
  final AppPreferences appPreferences;

  ReelsRepository({required this.dio, required this.appPreferences});

  static const _mockVideos = [
    'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4',
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Subaru_Outback_On_Street_And_In_The_Wild.mp4',
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4',
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/VolkswagenGTIReview.mp4',
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4',
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WhatCarCanYouGetForAGrand.mp4',
  ];

  Future<ReelsResponse> getReels(
    ReelsFilterModel filter, {
    CancelToken? cancelToken,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    const totalCount = 30;
    final startIndex = (filter.page - 1) * filter.limit;

    if (startIndex >= totalCount) {
      return const ReelsResponse(reels: [], count: totalCount);
    }

    final endIndex = (startIndex + filter.limit).clamp(0, totalCount);
    final pageCount = endIndex - startIndex;

    final reels = List.generate(pageCount, (i) {
      final globalIndex = startIndex + i;
      final videoUrl = _mockVideos[globalIndex % _mockVideos.length];
      return ReelsModel(
        id: globalIndex + 1,
        titleTm: 'Reel ${globalIndex + 1} TM',
        titleRu: 'Reel ${globalIndex + 1} RU',
        titleEn: 'Reel ${globalIndex + 1} EN',
        videoUrl: videoUrl,
        commentCount: (globalIndex * 3) % 50,
        shareCount: (globalIndex * 7) % 30,
        favoriteCount: (globalIndex * 11) % 100,
        isLive: globalIndex % 5 == 0,
        starCount: (globalIndex * 13) % 500,
      );
    });

    return ReelsResponse(reels: reels, count: totalCount);
  }
}
