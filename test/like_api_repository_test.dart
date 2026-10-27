import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_app/data/repositories/like_api_repository.dart';

void main() {
  test('загружает идентификаторы лайкнутых проектов через DTO', () async {
    final dio = Dio();
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          expect(options.method, 'GET');
          expect(options.path, '/likes');
          handler.resolve(
            Response<List<dynamic>>(
              requestOptions: options,
              statusCode: 200,
              data: const [
                {'projectId': 1, 'liked': true},
                {'projectId': 3, 'liked': true},
              ],
            ),
          );
        },
      ),
    );

    final result = await LikeApiRepository(dio: dio).loadLikes();

    expect(result, [1, 3]);
  });

  test('добавляет и удаляет лайк через REST API', () async {
    final dio = Dio();
    final methods = <String>[];
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          methods.add(options.method);
          handler.resolve(
            Response<Map<String, dynamic>>(
              requestOptions: options,
              statusCode: 200,
              data: {'projectId': 2, 'liked': options.method == 'PUT'},
            ),
          );
        },
      ),
    );
    final repository = LikeApiRepository(dio: dio);

    expect(await repository.changeLike(projectId: 2, isLiked: true), isTrue);
    expect(await repository.changeLike(projectId: 2, isLiked: false), isFalse);
    expect(methods, ['PUT', 'DELETE']);
  });
}
