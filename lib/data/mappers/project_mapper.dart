import 'package:flutter_test_app/data/dtos/project_dto.dart';
import 'package:flutter_test_app/domain/models/card.dart';
import 'package:flutter_test_app/domain/models/home.dart';

extension ProjectsDtoToModel on ProjectsDto {
  HomeData toDomain() =>
      HomeData(data: data?.map((e) => e.toDomain()).toList(), nextPage: meta?.pagination?.next);
}

extension ProjectDtoToDomain on ProjectDto {
  CardData toDomain() => CardData(
    id: id,
    title: title,
    description: description,
    progress: progress,
    collected: collected,
    goal: goal,
    icon: icon,
    categoryId: categoryId,
    organizationId: organizationId,
  );
}
