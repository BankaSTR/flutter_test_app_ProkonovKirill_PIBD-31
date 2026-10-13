import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_app/domain/models/card.dart';
import 'package:flutter_test_app/domain/repositories/project_repository.dart';
import 'package:flutter_test_app/presentation/details_page/details_page.dart';
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
  late Future<List<CardData>> data;

  @override
  void initState() {
    super.initState();
    data = widget.repository.loadProjects();
  }

  @override
  void dispose() {
    searchController.dispose();
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
              key: const ValueKey('project-search'),
              controller: searchController,
              placeholder: 'Поиск благотворительных проектов',
              onChanged: (search) {
                setState(() {
                  data = widget.repository.loadProjects(search: search);
                });
              },
            ),
          ),
          Expanded(
            child: Center(
              child: FutureBuilder<List<CardData>>(
                future: data,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Padding(
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
                            snapshot.error.toString(),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                data = widget.repository.loadProjects(
                                  search: searchController.text,
                                );
                              });
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text('Повторить'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }

                  final list = snapshot.data ?? [];

                  if (list.isEmpty) {
                    return const Text('Ничего не найдено');
                  }

                  return SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: list.map((cardData) {
                        return _Card.fromData(
                          cardData,
                          onLike: (String title, bool isLiked) =>
                              _showSnackBar(context, title, isLiked),
                          onTap: () => _navToDetails(context, cardData),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
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
