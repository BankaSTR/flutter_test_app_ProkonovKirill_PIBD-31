import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ПРИВЕТ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.blue)),
      home: const MyHomePage(title: 'Проконов Кирилл ПИбд-31'),
    );
  }
}

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
      body: MyWidget(),
    );
  }
}

class _CardData {
  final String text;
  final String descriptionText;
  final IconData icon;
  final String? imageUrl;

  _CardData(
    this.text, {
    required this.descriptionText,
    this.icon = Icons.drive_file_rename_outline,
    this.imageUrl,
  });
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final data = [
      _CardData('Ноутбук', descriptionText: '4ядря 4 гига', icon: Icons.waving_hand_sharp, imageUrl: 'https://w7.pngwing.com/pngs/790/725/png-transparent-laptop-lenovo-ideapad-yoga-13-lenovo-yoga-720-13-lenovo-yoga-720-15-laptop-electronics-netbook-computer-thumbnail.png'),
      _CardData('Смартфон', descriptionText: 'Самсунг?', icon: Icons.local_activity, imageUrl: 'https://pngdownload.io/wp-content/uploads/2025/02/Samsung-Galaxy-S25-Ultra-Titanium-Black-Premium-Smartphone-2048x1877.webp'),
      _CardData('Процессор', descriptionText: '5 5600x', icon: Icons.face, imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTAWsxT_TZznhqJYxfRlOGGeEiyf4tnOJLLtS7lPbBFQg&s'),
    ];
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: data.map((e) => _Card.fromData(e)).toList(),
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final String text;
  final String descriptionText;
  final IconData icon;
  final String? imageUrl;

  const _Card(
    this.text, {
    required this.descriptionText,
    this.icon = Icons.drive_file_rename_outline,
    this.imageUrl,
  });

  factory _Card.fromData(_CardData data) => _Card(
    data.text,
    descriptionText: data.descriptionText,
    icon: data.icon,
    imageUrl: data.imageUrl,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.deepOrange,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey, width: 5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: SizedBox(height: 150, width: 100,
              child: Image.network(
                imageUrl ?? '',
                errorBuilder: (_, __, ___) => const Placeholder(),
              ),
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(left: 1, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(text, style: Theme.of(context).textTheme.headlineMedium),
                  Text(
                    descriptionText,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
          ),
          Padding(padding: const EdgeInsets.all(5.0), child: Icon(icon)),
        ],
      ),
    );
  }
}
