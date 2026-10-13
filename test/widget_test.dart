import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_app/domain/models/card.dart';
import 'package:flutter_test_app/domain/repositories/project_repository.dart';
import 'package:flutter_test_app/main.dart';

void main() {
  testWidgets('получает проекты через интерфейс репозитория и отображает их', (
    tester,
  ) async {
    final repository = FakeProjectRepository();

    await tester.pumpWidget(MyApp(repository: repository));
    await tester.pumpAndSettle();

    expect(find.text('Детям — образование'), findsOneWidget);
    expect(find.text('Помощь детям в получении образования'), findsOneWidget);
    expect(repository.searches, ['']);
  });

  testWidgets('передаёт введённую строку как параметр поиска', (tester) async {
    final repository = FakeProjectRepository();

    await tester.pumpWidget(MyApp(repository: repository));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const ValueKey('project-search')),
      'лечение',
    );
    await tester.pump(const Duration(milliseconds: 351));
    await tester.pumpAndSettle();

    expect(repository.searches, ['', 'лечение']);
    expect(find.text('Ничего не найдено'), findsOneWidget);
  });

  testWidgets('открывает страницу с подробными данными проекта', (
    tester,
  ) async {
    final repository = FakeProjectRepository();

    await tester.pumpWidget(MyApp(repository: repository));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Детям — образование'));
    await tester.pumpAndSettle();

    expect(find.text('Выполнено: 75%'), findsOneWidget);
    expect(find.text('Собрано 750 000 ₽ из 1 000 000 ₽'), findsOneWidget);
  });
}

class FakeProjectRepository implements ProjectRepository {
  final List<String> searches = [];

  @override
  Future<List<CardData>> loadProjects({String search = ''}) async {
    searches.add(search);
    if (search.isNotEmpty) {
      return [];
    }

    return const [
      CardData(
        id: 1,
        title: 'Детям — образование',
        description: 'Помощь детям в получении образования',
        progress: 75,
        collected: 750000,
        goal: 1000000,
        icon: 'bi-mortarboard-fill',
        categoryId: 1,
        organizationId: 2,
      ),
    ];
  }
}
