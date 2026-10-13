import 'package:flutter_test_app/domain/models/card.dart';

abstract interface class ProjectRepository {
  Future<List<CardData>> loadProjects({String search = ''});
}
