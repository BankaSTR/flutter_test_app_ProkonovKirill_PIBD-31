import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_app/domain/repositories/like_repository.dart';
import 'package:flutter_test_app/presentation/like_bloc/like_event.dart';
import 'package:flutter_test_app/presentation/like_bloc/like_state.dart';

class LikeBloc extends Bloc<LikeEvent, LikeState> {
  final LikeRepository repo;

  LikeBloc(this.repo) : super(const LikeState(likedIds: [])) {
    on<ChangeLikeEvent>(_onChangeLike);
    on<LoadLikesEvent>(_onLoadLikes);
  }

  Future<void> _onLoadLikes(LoadLikesEvent event, Emitter<LikeState> emit) async {
    String? error;
    final data = await repo.loadLikes(onError: (e) => error = e);

    emit(state.copyWith(likedIds: data ?? state.likedIds, error: error));
  }

  Future<void> _onChangeLike(ChangeLikeEvent event, Emitter<LikeState> emit) async {
    final updatedList = List<int>.from(state.likedIds ?? []);
    final isLiked = !updatedList.contains(event.id);
    String? error;

    final result = await repo.changeLike(
      projectId: event.id,
      isLiked: isLiked,
      onError: (e) => error = e,
    );

    if (result == null) {
      emit(state.copyWith(error: error));
      return;
    }

    if (result) {
      updatedList.add(event.id);
    } else {
      updatedList.remove(event.id);
    }

    emit(state.copyWith(likedIds: updatedList, error: null));
  }
}
