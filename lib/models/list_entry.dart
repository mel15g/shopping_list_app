import 'package:flutter/foundation.dart';

@immutable // Objekt wird nicht direkt verändert
class ListEntry {
  final String id;        // eindeutige ID
  final String title;     // Produktname
  final int quantity;     // Menge
  final bool isDone;      // erledigt / offen
  final bool isFavorite;  // Favorit oder nicht

  const ListEntry({
    required this.id,
    required this.title,
    required this.quantity,
    this.isDone = false,
    this.isFavorite = false,
  });

  // Erstellt eine neue Kopie mit geänderten Werten
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
