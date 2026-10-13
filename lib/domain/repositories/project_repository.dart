import 'package:flutter_test_app/domain/models/home.dart';

typedef OnErrorCallback = void Function(String? error);

abstract interface class ProjectRepository {
  Future<HomeData?> loadData({
    OnErrorCallback? onError,
    String? q,
    int page = 1,
    int pageSize = 3,
  });
}
