import 'package:flutter_test_app/data/dtos/project_dto.dart';
import 'package:flutter_test_app/domain/models/card.dart';

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
