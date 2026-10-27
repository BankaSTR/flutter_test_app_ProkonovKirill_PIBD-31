import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';

part 'like_state.g.dart';

@CopyWith()
class LikeState extends Equatable {
  final List<int>? likedIds;
  final String? error;

  const LikeState({required this.likedIds, this.error});

  @override
  List<Object?> get props => [likedIds, error];
}
