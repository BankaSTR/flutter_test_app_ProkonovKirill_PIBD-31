import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test_app/data/dtos/like_dto.dart';
import 'package:flutter_test_app/domain/repositories/like_repository.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class LikeApiRepository implements LikeRepository {
  LikeApiRepository({Dio? dio}) : _dio = dio ?? _createDio();

  final Dio _dio;

  static const _configuredBaseUrl = String.fromEnvironment('API_BASE_URL');

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(PrettyDioLogger(requestHeader: true, requestBody: true));
    }

    return dio;
  }

  static String get _baseUrl {
    if (_configuredBaseUrl.isNotEmpty) {
      return _configuredBaseUrl;
    }

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8080/api/1.0';
    }

    return 'http://localhost:8080/api/1.0';
  }

  @override
  Future<List<int>?> loadLikes({LikeErrorCallback? onError}) async {
    try {
      final response = await _dio.get<List<dynamic>>('/likes');
      final jsonList = response.data;

      if (jsonList == null) {
        throw const FormatException('Сервер вернул пустой ответ');
      }

      return jsonList
          .map((json) => LikeDto.fromJson(Map<String, dynamic>.from(json as Map)))
          .where((like) => like.liked)
          .map((like) => like.projectId)
          .toList();
    } on DioException catch (error) {
      onError?.call(_errorMessage(error));
      return null;
    } on FormatException catch (error) {
      onError?.call(error.message);
      return null;
    } on TypeError {
      onError?.call('Формат ответа сервера не соответствует DTO лайка');
      return null;
    }
  }

  @override
  Future<bool?> changeLike({
    required int projectId,
    required bool isLiked,
    LikeErrorCallback? onError,
  }) async {
    try {
      final Response<Map<String, dynamic>> response;

      if (isLiked) {
        response = await _dio.put<Map<String, dynamic>>('/likes/$projectId');
      } else {
        response = await _dio.delete<Map<String, dynamic>>('/likes/$projectId');
      }

      final json = response.data;
      if (json == null) {
        throw const FormatException('Сервер вернул пустой ответ');
      }

      return LikeDto.fromJson(json).liked;
    } on DioException catch (error) {
      onError?.call(_errorMessage(error));
      return null;
    } on FormatException catch (error) {
      onError?.call(error.message);
      return null;
    } on TypeError {
      onError?.call('Формат ответа сервера не соответствует DTO лайка');
      return null;
    }
  }

  static String _errorMessage(DioException error) {
    if (error.response != null) {
      return 'Сервер вернул ошибку ${error.response?.statusCode}';
    }

    return 'Не удалось сохранить лайк на сервере';
  }
}
