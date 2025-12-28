class ListEntry {
  final String id;
  final String title;
  final int quantity;
  final bool isDone;

  const ListEntry({
    required this.id,
    required this.title,
    required this.quantity,
    this.isDone = false,
  });

  ListEntry copyWith({
    String? title,
    int? quantity,
    bool? isDone,
  }) {
    return ListEntry(
      id: id,
      title: title ?? this.title,
      quantity: quantity ?? this.quantity,
      isDone: isDone ?? this.isDone,
    );
  }
}
