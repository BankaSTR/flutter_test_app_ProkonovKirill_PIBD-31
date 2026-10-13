import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_app/components/utils/debounce.dart';
import 'package:flutter_test_app/domain/models/card.dart';
import 'package:flutter_test_app/domain/repositories/project_repository.dart';
import 'package:flutter_test_app/presentation/details_page/details_page.dart';
import 'package:flutter_test_app/presentation/home_page/bloc/bloc.dart';
import 'package:flutter_test_app/presentation/home_page/bloc/events.dart';
import 'package:flutter_test_app/presentation/home_page/bloc/state.dart';
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
      body: Body(repository: widget.repository),
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeBloc>().add(const HomeLoadDataEvent());
    });

    scrollController.addListener(_onNextPageListener);

    super.initState();
  }

  void _onNextPageListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent) {
      final bloc = context.read<HomeBloc>();
      final nextPage = bloc.state.data?.nextPage;

      if (!bloc.state.isPaginationLoading && nextPage != null) {
        bloc.add(
          HomeLoadDataEvent(search: searchController.text, nextPage: nextPage),
        );
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
          Padding(
            padding: const EdgeInsets.all(12),
            child: CupertinoSearchTextField(
              controller: searchController,
              placeholder: 'Поиск благотворительных проектов',
              onChanged: (search) {
                Debounce.run(
                  () => context.read<HomeBloc>().add(
                    HomeLoadDataEvent(search: search),
                  ),
                );
              },
            ),
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
                            const Icon(
                              Icons.wifi_off,
                              size: 48,
                              color: Colors.deepOrange,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Ошибка загрузки',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              state.error ?? '',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () => context.read<HomeBloc>().add(
                                HomeLoadDataEvent(
                                  search: searchController.text,
                                ),
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
                ? const Expanded(
                    child: Center(child: Text('Ничего не найдено')),
                  )
                : Expanded(
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
                                  onLike: (title, isLiked) =>
                                      _showSnackBar(context, title, isLiked),
                                  onTap: () => _navToDetails(context, data),
                                )
                              : const SizedBox.shrink();
                        },
                      ),
                    ),
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
    context.read<HomeBloc>().add(
      HomeLoadDataEvent(search: searchController.text),
    );
    return Future.value(null);
  }

  void _navToDetails(BuildContext context, CardData project) {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => DetailsPage(project)),
    );
  }

  void _showSnackBar(BuildContext context, String title, bool isLiked) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Проект «$title» '
            '${isLiked ? 'добавлен в избранное' : 'удалён из избранного'}',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          backgroundColor: Colors.deepOrange,
          duration: Duration(seconds: 1),
        ),
      );
    });
  }
}
