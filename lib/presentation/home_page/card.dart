part of 'home_page.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    final data = [
      CardData(
        'Ноутбук',
        descriptionText: '4ядря 4 гига',
        icon: Icons.waving_hand_sharp,
        imageUrl: 'https://w7.pngwing.com/pngs/790/725/png-transparent-laptop-lenovo-ideapad-yoga-13-lenovo-yoga-720-13-lenovo-yoga-720-15-laptop-electronics-netbook-computer-thumbnail.png',
      ),
      CardData(
        'Смартфон',
        descriptionText: 'Самсунг?',
        icon: Icons.local_activity,
        imageUrl: 'https://pngdownload.io/wp-content/uploads/2025/02/Samsung-Galaxy-S25-Ultra-Titanium-Black-Premium-Smartphone-2048x1877.webp',
      ),
      CardData(
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
          children: data.map((data) {
            return _Card.fromData(
              data,
              onLike: (String title, bool isLiked) =>
                  _showSnackBar(context, title, isLiked),
              onTap: () => _navToDetails(context, data),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _navToDetails(BuildContext context, CardData data) {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => DetailsPage(data)),
    );
  }
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

typedef OnLikeCallback = void Function(String title, bool isLiked)?;

class _Card extends StatefulWidget {
  final String text;
  final String descriptionText;
  final IconData icon;
  final String? imageUrl;
  final OnLikeCallback onLike;
  final VoidCallback? onTap;

  const _Card(
    this.text, {
    required this.descriptionText,
    this.icon = Icons.drive_file_rename_outline,
    this.imageUrl,
    this.onLike,
    this.onTap,
  });

  factory _Card.fromData(
    CardData data, {
    OnLikeCallback? onLike,
    VoidCallback? onTap,
  }) => _Card(
    data.text,
    descriptionText: data.descriptionText,
    icon: data.icon,
    imageUrl: data.imageUrl,
    onLike: onLike,
    onTap: onTap,
  );

  @override
  State<_Card> createState() => _CardState();
}

class _CardState extends State<_Card> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: EdgeInsets.all(15),
        constraints: BoxConstraints(minHeight: 160),
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
                child: SizedBox(
                  height: double.infinity,
                  width: 130,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.network(
                          widget.imageUrl ?? '',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Placeholder(),
                        ),
                      ),
                      Align(
                        alignment: AlignmentGeometry.bottomLeft,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.deepOrange,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                            ),
                          ),
                          padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
                          child: Text(
                            'скидка 15%',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
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
                  padding: const EdgeInsets.only(
                    left: 1,
                    right: 10,
                    bottom: 16,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isLiked = !isLiked;
                        widget.onLike?.call(widget.text, isLiked);
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
      ),
    );
  }
}
