import 'package:json_annotation/json_annotation.dart';

part 'project_dto.g.dart';

@JsonSerializable(createToJson: false)
class ProjectsDto {
  final List<ProjectDto>? data;
  final MetaDto? meta;

  const ProjectsDto({this.data, this.meta});

  factory ProjectsDto.fromJson(Map<String, dynamic> json) => _$ProjectsDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class ProjectDto {
  final int id;
  final String title;
  final String description;
  final int progress;
  final int collected;
  final int goal;
  final String icon;
  final int categoryId;
  final int organizationId;

  const ProjectDto({
    required this.id,
    required this.title,
    required this.description,
    required this.progress,
    required this.collected,
    required this.goal,
    required this.icon,
    required this.categoryId,
    required this.organizationId,
  });

  factory ProjectDto.fromJson(Map<String, dynamic> json) => _$ProjectDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class MetaDto {
  final PaginationDto? pagination;

  const MetaDto({this.pagination});

  factory MetaDto.fromJson(Map<String, dynamic> json) => _$MetaDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class PaginationDto {
  final int? current;
  final int? next;
  final int? last;

  const PaginationDto({this.current, this.next, this.last});

  factory PaginationDto.fromJson(Map<String, dynamic> json) => _$PaginationDtoFromJson(json);
}
