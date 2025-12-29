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
            'Keine Einträge in dieser Ansicht.\nTippe auf + um etwas hinzuzufügen.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 12, bottom: 90),
      itemCount: entries.length,
      itemBuilder: (context, i) {
        final e = entries[i];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Material(
            borderRadius: BorderRadius.circular(16),
            elevation: 1,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => onToggleDone(e.id), // Tippen toggelt auch
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Checkbox(
                      value: e.isDone,
                      onChanged: (_) => onToggleDone(e.id),
                    ),
                    const SizedBox(width: 6),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            e.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              decoration:
                                  e.isDone ? TextDecoration.lineThrough : null,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children: [
                              Chip(
                                label: Text('Menge: ${e.quantity}'),
                                visualDensity: VisualDensity.compact,
                              ),
                              Chip(
                                label: Text(e.isDone ? 'Erledigt' : 'Offen'),
                                visualDensity: VisualDensity.compact,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    IconButton(
                      tooltip: 'Löschen',
                      onPressed: () => onRemove(e.id),
                      icon: const Icon(Icons.delete_outline),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
