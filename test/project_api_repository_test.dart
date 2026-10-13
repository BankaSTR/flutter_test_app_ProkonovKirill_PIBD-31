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
            Response<Map<String, dynamic>>(
              requestOptions: options,
              statusCode: 200,
              data: const {
                'data': [
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
                'meta': {
                  'pagination': {'current': 1, 'next': 2, 'last': 2},
                },
              },
            ),
          );
        },
      ),
    );
    final repository = ProjectApiRepository(dio: dio);

    final result = await repository.loadData(q: '  лечение  ');

    expect(queryParameters, {'search': 'лечение', 'page': 1, 'pageSize': 3});
    expect(result?.data, hasLength(1));
    expect(result?.data?.single.title, 'Лечение детей');
    expect(result?.data?.single.collected, 450000);
    expect(result?.nextPage, 2);
  });
}
