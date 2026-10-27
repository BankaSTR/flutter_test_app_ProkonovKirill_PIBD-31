import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test_app/data/dtos/project_dto.dart';
import 'package:flutter_test_app/data/mappers/project_mapper.dart';
import 'package:flutter_test_app/domain/models/home.dart';
import 'package:flutter_test_app/domain/repositories/project_repository.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ProjectApiRepository implements ProjectRepository {
  ProjectApiRepository({Dio? dio}) : _dio = dio ?? _createDio();

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
  Future<HomeData?> loadData({
    OnErrorCallback? onError,
    String? q,
    int page = 1,
    int pageSize = 3,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/projects/page',
        queryParameters: {'search': q?.trim() ?? '', 'page': page, 'pageSize': pageSize},
      );
      final json = response.data;

      if (json == null) {
        throw const FormatException('Сервер вернул пустой ответ');
      }

      final dto = ProjectsDto.fromJson(json);
      return dto.toDomain();
    } on DioException catch (error) {
      onError?.call(_errorMessage(error));
      return null;
    } on FormatException catch (error) {
      onError?.call(error.message);
      return null;
    } on TypeError {
      onError?.call('Формат ответа сервера не соответствует DTO проекта');
      return null;
    }
  }

  static String _errorMessage(DioException error) {
    if (error.response != null) {
      return 'Сервер вернул ошибку ${error.response?.statusCode}';
    }

    return 'Не удалось подключиться к серверу благотворительной платформы';
  }
}
