import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_app/domain/repositories/project_repository.dart';
import 'package:flutter_test_app/presentation/home_page/bloc/events.dart';
import 'package:flutter_test_app/presentation/home_page/bloc/state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ProjectRepository repo;

  HomeBloc(this.repo) : super(const HomeState()) {
    on<HomeLoadDataEvent>(_onLoadData);
  }

  Future<void> _onLoadData(HomeLoadDataEvent event, Emitter<HomeState> emit) async {
    if (event.nextPage == null) {
      emit(state.copyWith(isLoading: true, error: null));
    } else {
      emit(state.copyWith(isPaginationLoading: true, error: null));
    }

    String? error;

    final data = await repo.loadData(
      q: event.search,
      page: event.nextPage ?? 1,
      onError: (e) => error = e,
    );

    if (event.nextPage != null) {
      data?.data?.insertAll(0, state.data?.data ?? []);
    }

    emit(
      state.copyWith(
        isLoading: false,
        isPaginationLoading: false,
        data: data ?? state.data,
        error: error,
      ),
    );
  }
}
