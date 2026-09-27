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
      _CardData(
        'Ноутбук',
        descriptionText: '4ядря 4 гига',
        icon: Icons.waving_hand_sharp,
        imageUrl: 'https://w7.pngwing.com/pngs/790/725/png-transparent-laptop-lenovo-ideapad-yoga-13-lenovo-yoga-720-13-lenovo-yoga-720-15-laptop-electronics-netbook-computer-thumbnail.png',
      ),
      _CardData(
        'Смартфон',
        descriptionText: 'Самсунг?',
        icon: Icons.local_activity,
        imageUrl: 'https://pngdownload.io/wp-content/uploads/2025/02/Samsung-Galaxy-S25-Ultra-Titanium-Black-Premium-Smartphone-2048x1877.webp',
      ),
      _CardData(
        'Процессор',
        descriptionText: '5 5600x',
        icon: Icons.face,
        imageUrl: 'https://cdn.citilink.ru/GHh35ODAI5AMlUID0GD2DxFYzUgOqtYqaJS1Lif_TXI/resizing_type:fit/gravity:sm/width:1200/height:750/plain/product-images/bd7752f0-19a1-471d-ac80-de15d55ab131.jpg',
      ),
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

class _Card extends StatefulWidget {
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
  State<_Card> createState() => _CardState();
}

class _CardState extends State<_Card> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15),
      constraints: BoxConstraints(minHeight: 150),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            spreadRadius: 1,
            offset: Offset(0, 10),
            blurRadius: 15,
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                topLeft: Radius.circular(10),
              ),
              child: Flexible(
                child: SizedBox(
                  height: double.infinity,
                  width: 120,
                  child: Image.network(
                    widget.imageUrl ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Placeholder(),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.text,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      widget.descriptionText,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: AlignmentGeometry.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(left: 1, right: 10, bottom: 16),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isLiked = !isLiked;
                    });
                  },
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    child: isLiked
                        ? const Icon(
                            Icons.favorite,
                            color: Colors.red,
                            key: ValueKey(0),
                          )
                        : const Icon(Icons.favorite_border, key: ValueKey(1)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
