import 'package:flutter/foundation.dart';

@immutable
class ListEntry {
  final String id;
  final String title;
  final int quantity;
  final bool isDone;
  final bool isFavorite;

  const ListEntry({
    required this.id,
    required this.title,
    required this.quantity,
    this.isDone = false,
    this.isFavorite = false,
  });

  ListEntry copyWith({
    String? id,
    String? title,
    int? quantity,
    bool? isDone,
    bool? isFavorite,
  }) {
    return ListEntry(
      id: id ?? this.id,
      title: title ?? this.title,
      quantity: quantity ?? this.quantity,
      isDone: isDone ?? this.isDone,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
