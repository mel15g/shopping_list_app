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
        child: Text('Keine Einträge in dieser Ansicht.'),
      );
    }

    return ListView.builder(
      itemCount: entries.length,
      itemBuilder: (context, i) {
        final e = entries[i];

        return ListTile(
          leading: Checkbox(
            value: e.isDone,
            onChanged: (_) => onToggleDone(e.id),
          ),
          title: Text('${e.title} (${e.quantity}x)'),
          trailing: IconButton(
            onPressed: () => onRemove(e.id),
            icon: const Icon(Icons.delete),
          ),
        );
      },
    );
  }
}
