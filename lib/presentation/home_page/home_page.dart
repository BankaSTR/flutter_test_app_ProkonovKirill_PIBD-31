import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_app/components/extensions/context_x.dart';
import 'package:flutter_test_app/components/utils/debounce.dart';
import 'package:flutter_test_app/domain/models/card.dart';
import 'package:flutter_test_app/domain/repositories/project_repository.dart';
import 'package:flutter_test_app/presentation/common/svg_objects.dart';
import 'package:flutter_test_app/presentation/details_page/details_page.dart';
import 'package:flutter_test_app/presentation/home_page/bloc/bloc.dart';
import 'package:flutter_test_app/presentation/home_page/bloc/events.dart';
import 'package:flutter_test_app/presentation/home_page/bloc/state.dart';
import 'package:flutter_test_app/presentation/like_bloc/like_bloc.dart';
import 'package:flutter_test_app/presentation/like_bloc/like_event.dart';
import 'package:flutter_test_app/presentation/like_bloc/like_state.dart';
import 'package:flutter_test_app/presentation/locale_bloc/locale_bloc.dart';
import 'package:flutter_test_app/presentation/locale_bloc/locale_events.dart';
import 'package:flutter_test_app/presentation/locale_bloc/locale_state.dart';
import 'package:flutter_test_app/presentation/project_formatters.dart';

part 'card.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.repository});

  final String title;
  final ProjectRepository repository;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _color = Colors.deepOrange;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: _color, title: Text(widget.title)),
      body: BlocListener<LikeBloc, LikeState>(
        listenWhen: (previous, current) => previous.error != current.error && current.error != null,
        listener: (context, state) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error ?? ''), backgroundColor: Colors.red));
        },
        child: Body(repository: widget.repository),
      ),
    );
  }
}

class Body extends StatefulWidget {
  final ProjectRepository repository;

  const Body({super.key, required this.repository});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final searchController = TextEditingController();
  final scrollController = ScrollController();

  @override
  void initState() {
    SvgObjects.init();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeBloc>().add(const HomeLoadDataEvent());
      context.read<LikeBloc>().add(const LoadLikesEvent());
    });

    scrollController.addListener(_onNextPageListener);

    super.initState();
  }

  void _onNextPageListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent) {
      final bloc = context.read<HomeBloc>();
      final nextPage = bloc.state.data?.nextPage;

      if (!bloc.state.isPaginationLoading && nextPage != null) {
        bloc.add(HomeLoadDataEvent(search: searchController.text, nextPage: nextPage));
      }
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: CupertinoSearchTextField(
                    controller: searchController,
                    placeholder: context.locale.search,
                    onChanged: (search) {
                      Debounce.run(
                        () => context.read<HomeBloc>().add(HomeLoadDataEvent(search: search)),
                      );
                    },
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => context.read<LocaleBloc>().add(const ChangeLocaleEvent()),
                child: SizedBox.square(
                  dimension: 50,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: BlocBuilder<LocaleBloc, LocaleState>(
                      builder: (context, state) {
                        return state.currentLocale.languageCode == 'ru'
                            ? const SvgRu()
                            : const SvgUk();
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) => state.error != null
                ? Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.wifi_off, size: 48, color: Colors.deepOrange),
                            const SizedBox(height: 12),
                            Text('Ошибка загрузки', style: Theme.of(context).textTheme.titleLarge),
                            const SizedBox(height: 8),
                            Text(
                              state.error ?? '',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () => context.read<HomeBloc>().add(
                                HomeLoadDataEvent(search: searchController.text),
                              ),
                              icon: const Icon(Icons.refresh),
                              label: const Text('Повторить'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : state.isLoading
                ? const CircularProgressIndicator()
                : state.data?.data?.isEmpty ?? true
                ? const Expanded(child: Center(child: Text('Ничего не найдено')))
                : BlocBuilder<LikeBloc, LikeState>(
                    builder: (context, likeState) {
                      return Expanded(
                        child: RefreshIndicator(
                          onRefresh: _onRefresh,
                          child: ListView.builder(
                            controller: scrollController,
                            padding: EdgeInsets.zero,
                            itemCount: state.data?.data?.length ?? 0,
                            itemBuilder: (context, index) {
                              final data = state.data?.data?[index];
                              return data != null
                                  ? _Card.fromData(
                                      data,
                                      onLike: _onLike,
                                      isLiked: likeState.likedIds?.contains(data.id) == true,
                                      onTap: () => _navToDetails(context, data),
                                    )
                                  : const SizedBox.shrink();
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
          BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) => state.isPaginationLoading
                ? const CircularProgressIndicator()
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Future<void> _onRefresh() {
    context.read<HomeBloc>().add(HomeLoadDataEvent(search: searchController.text));
    return Future.value(null);
  }

  void _navToDetails(BuildContext context, CardData project) {
    Navigator.push(context, CupertinoPageRoute(builder: (context) => DetailsPage(project)));
  }

  void _onLike(int? id, String title, bool isLiked) {
    if (id != null) {
      context.read<LikeBloc>().add(ChangeLikeEvent(id));
      _showSnackBar(context, title, !isLiked);
    }
  }

  void _showSnackBar(BuildContext context, String title, bool isLiked) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Проект «$title» '
            '${isLiked ? context.locale.liked : context.locale.disliked}',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          backgroundColor: Colors.deepOrange,
          duration: Duration(seconds: 1),
        ),
      );
    });
  }
}
