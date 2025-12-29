import 'package:flutter/material.dart';
import '../models/list_entry.dart';

class ListScreen extends StatelessWidget {
  final List<ListEntry> entries;
  final void Function(String id) onToggleDone;
  final void Function(String id) onRemove;
  final void Function(String id) onToggleFavorite;

  /// optional: wenn gesetzt, wird statt "Löschen" ein anderes Icon/Action gezeigt
  final bool showMoveToOpen;
  final void Function(String id)? onMoveToOpen;

  const ListScreen({
    super.key,
    required this.entries,
    required this.onToggleDone,
    required this.onRemove,
    required this.onToggleFavorite,
    this.showMoveToOpen = false,
    this.onMoveToOpen,
  });

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return const Center(child: Text('Keine Einträge vorhanden.'));
    }

    return ListView.separated(
      itemCount: entries.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, i) {
        final e = entries[i];

        return ListTile(
          leading: Checkbox(
            value: e.isDone,
            onChanged: (_) => onToggleDone(e.id),
          ),
          title: Text(
            '${e.title} (${e.quantity}x)',
            style: TextStyle(
              decoration: e.isDone ? TextDecoration.lineThrough : null,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                tooltip: e.isFavorite ? 'Aus Favoriten entfernen' : 'Zu Favoriten',
                onPressed: () => onToggleFavorite(e.id),
                icon: Icon(
                  e.isFavorite ? Icons.star : Icons.star_border,
                ),
              ),
              if (showMoveToOpen)
                IconButton(
                  tooltip: 'In Einkaufsliste (Offen)',
                  onPressed: onMoveToOpen == null ? null : () => onMoveToOpen!(e.id),
                  icon: const Icon(Icons.shopping_cart_outlined),
                )
              else
                IconButton(
                  tooltip: 'Löschen',
                  onPressed: () => onRemove(e.id),
                  icon: const Icon(Icons.delete),
                ),
            ],
          ),
        );
      },
    );
  }
}
