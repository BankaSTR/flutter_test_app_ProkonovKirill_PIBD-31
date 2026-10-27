typedef LikeErrorCallback = void Function(String? error);

abstract interface class LikeRepository {
  Future<List<int>?> loadLikes({LikeErrorCallback? onError});

  Future<bool?> changeLike({
    required int projectId,
    required bool isLiked,
    LikeErrorCallback? onError,
  });
}
