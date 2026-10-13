part of 'home_page.dart';

typedef OnLikeCallback = void Function(String title, bool isLiked)?;

class _Card extends StatefulWidget {
  final String text;
  final String descriptionText;
  final IconData icon;
  final OnLikeCallback onLike;
  final VoidCallback? onTap;

  const _Card(
    this.text, {
    required this.descriptionText,
    this.icon = Icons.drive_file_rename_outline,
    this.onLike,
    this.onTap,
  });

  factory _Card.fromData(
    CardData project, {
    OnLikeCallback? onLike,
    VoidCallback? onTap,
  }) => _Card(
    project.title,
    descriptionText: project.description,
    icon: projectIcon(project.icon),
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
                        child: Container(
                          color: Colors.deepOrange.shade100,
                          child: Icon(
                            widget.icon,
                            size: 54,
                            color: Colors.deepOrange,
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
