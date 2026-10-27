import 'package:json_annotation/json_annotation.dart';

part 'like_dto.g.dart';

@JsonSerializable(createToJson: false)
class LikeDto {
  final int projectId;
  final bool liked;

  const LikeDto({required this.projectId, required this.liked});

  factory LikeDto.fromJson(Map<String, dynamic> json) => _$LikeDtoFromJson(json);
}
