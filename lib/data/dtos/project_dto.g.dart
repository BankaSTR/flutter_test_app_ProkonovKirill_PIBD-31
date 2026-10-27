// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProjectsDto _$ProjectsDtoFromJson(Map<String, dynamic> json) => ProjectsDto(
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => ProjectDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  meta: json['meta'] == null ? null : MetaDto.fromJson(json['meta'] as Map<String, dynamic>),
);

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

MetaDto _$MetaDtoFromJson(Map<String, dynamic> json) => MetaDto(
  pagination: json['pagination'] == null
      ? null
      : PaginationDto.fromJson(json['pagination'] as Map<String, dynamic>),
);

PaginationDto _$PaginationDtoFromJson(Map<String, dynamic> json) => PaginationDto(
  current: (json['current'] as num?)?.toInt(),
  next: (json['next'] as num?)?.toInt(),
  last: (json['last'] as num?)?.toInt(),
);
