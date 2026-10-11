import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_app/data/repositories/mock_repository.dart';
import 'package:flutter_test_app/data/repositories/potter_repository.dart';
import 'package:flutter_test_app/domain/models/card.dart';
import 'package:flutter_test_app/presentation/details_page/details_page.dart';

part 'card.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _color = Colors.deepOrange;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: _color, title: Text(widget.title)),
      body: Body(),
    );
  }
}


class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  // Конкретный тип — PotterRepository, а не ApiInterface.
  // Поэтому q виден.
  final repo = PotterRepository();

  final searchController = TextEditingController();

  // Текущий Future со списком — пересоздаётся при вводе
  late Future<List<CardData>?> data;

  @override
  void initState() {
    super.initState();
    // Первая загрузка — без поиска
    data = repo.loadData();
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
              controller: searchController,
              onChanged: (search) {
                setState(() {
                  data = repo.loadData(q: search);
                });
              },
            ),
          ),
          Expanded(
            child: Center(
              child: FutureBuilder<List<CardData>?>(
                future: data,
                builder: (context, snapshot) {
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

void _navToDetails(BuildContext context, CardData data) {
  Navigator.push(
    context,
    CupertinoPageRoute(builder: (context) => DetailsPage(data)),
  );
}

void _showSnackBar(BuildContext context, String title, bool isLiked) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'TechnoShop $title ${isLiked ? 'liked!' : 'disliked :('}',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        backgroundColor: Colors.deepOrange,
        duration: Duration(seconds: 1),
      ),
    );
  });
}
