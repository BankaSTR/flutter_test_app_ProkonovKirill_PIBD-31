import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_app/data/repositories/project_api_repository.dart';

void main() {
  test('отправляет search и преобразует DTO в доменную модель', () async {
    final dio = Dio();
    Map<String, dynamic>? queryParameters;
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          queryParameters = options.queryParameters;
          handler.resolve(
            Response<List<dynamic>>(
              requestOptions: options,
              statusCode: 200,
              data: const [
                {
                  'id': 7,
                  'title': 'Лечение детей',
                  'description': 'Сбор средств на лечение детей',
                  'progress': 45,
                  'collected': 450000,
                  'goal': 1000000,
                  'icon': 'bi-house-heart-fill',
                  'categoryId': 2,
                  'organizationId': 1,
                },
              ],
            ),
          );
        },
      ),
    );
    final repository = ProjectApiRepository(dio: dio);

    final projects = await repository.loadProjects(search: '  лечение  ');

    expect(queryParameters, {'search': 'лечение'});
    expect(projects, hasLength(1));
    expect(projects.single.title, 'Лечение детей');
    expect(projects.single.collected, 450000);
  });
}
