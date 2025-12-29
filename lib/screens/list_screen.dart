import 'package:flutter/material.dart';
import '../models/list_entry.dart';

class ListScreen extends StatelessWidget {
  final List<ListEntry> entries;
  final void Function(String id) onToggleDone;
  final void Function(String id) onRemove;

  const ListScreen({
    super.key,
    required this.entries,
    required this.onToggleDone,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Keine Einträge in dieser Ansicht.\nTippe unten auf + um etwas hinzuzufügen.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 80),
      itemCount: entries.length,
      itemBuilder: (context, i) {
        final e = entries[i];

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          elevation: 1,
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            leading: Checkbox(
              value: e.isDone,
              onChanged: (_) => onToggleDone(e.id),
            ),
            title: Text(
              e.title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                decoration: e.isDone ? TextDecoration.lineThrough : null,
              ),
            ),
            subtitle: Text('Menge: ${e.quantity}'),
            trailing: IconButton(
              tooltip: 'Löschen',
              onPressed: () => onRemove(e.id),
              icon: const Icon(Icons.delete_outline),
            ),
          ),
        );
      },
    );
  }
}
