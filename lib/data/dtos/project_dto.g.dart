// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProjectDto _$ProjectDtoFromJson(Map<String, dynamic> json) => ProjectDto(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  description: json['description'] as String,
  progress: (json['progress'] as num).toInt(),
  collected: (json['collected'] as num).toInt(),
  goal: (json['goal'] as num).toInt(),
  icon: json['icon'] as String,
  categoryId: (json['categoryId'] as num).toInt(),
  organizationId: (json['organizationId'] as num).toInt(),
);
