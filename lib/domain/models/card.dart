class CardData {
  final int id;
  final String title;
  final String description;
  final int progress;
  final int collected;
  final int goal;
  final String icon;
  final int categoryId;
  final int organizationId;

  const CardData({
    required this.id,
    required this.title,
    required this.description,
    required this.progress,
    required this.collected,
    required this.goal,
    required this.icon,
    required this.categoryId,
    required this.organizationId,
  });
}
