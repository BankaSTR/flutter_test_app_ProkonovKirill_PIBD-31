part of 'home_page.dart';

typedef OnLikeCallback = void Function(int? id, String title, bool isLiked)?;

class _Card extends StatelessWidget {
  final String text;
  final String descriptionText;
  final IconData icon;
  final OnLikeCallback onLike;
  final VoidCallback? onTap;
  final int? id;
  final bool isLiked;

  const _Card(
    this.text, {
    required this.descriptionText,
    this.icon = Icons.drive_file_rename_outline,
    this.onLike,
    this.onTap,
    this.id,
    this.isLiked = false,
  });

  factory _Card.fromData(
    CardData project, {
    OnLikeCallback onLike,
    VoidCallback? onTap,
    bool isLiked = false,
  }) => _Card(
    project.title,
    descriptionText: project.description,
    icon: projectIcon(project.icon),
    onLike: onLike,
    onTap: onTap,
    isLiked: isLiked,
    id: project.id,
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(15),
        constraints: BoxConstraints(minHeight: 160),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey, width: 1),
          boxShadow: [
            BoxShadow(color: Colors.black, spreadRadius: 1, offset: Offset(0, 10), blurRadius: 15),
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
                          child: Icon(icon, size: 54, color: Colors.deepOrange),
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
                      Text(text, style: Theme.of(context).textTheme.titleLarge),
                      Text(descriptionText, style: Theme.of(context).textTheme.titleSmall),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: AlignmentGeometry.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(left: 1, right: 10, bottom: 16),
                  child: GestureDetector(
                    onTap: () => onLike?.call(id, text, isLiked),
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      child: isLiked
                          ? const Icon(Icons.favorite, color: Colors.red, key: ValueKey(0))
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
