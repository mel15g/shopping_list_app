import 'package:flutter/material.dart';
import '../models/list_entry.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final List<ListEntry> _entries = [
    const ListEntry(id: 'e1', title: 'Bananen', quantity: 6),
    const ListEntry(id: 'e2', title: 'Milch', quantity: 1),
    const ListEntry(id: 'e3', title: 'Duschgel', quantity: 2),
  ];

  void _toggleDone(String id) {
    setState(() {
      final index = _entries.indexWhere((e) => e.id == id);
      final entry = _entries[index];
      _entries[index] = entry.copyWith(isDone: !entry.isDone);
    });
  }

  void _removeEntry(String id) {
    setState(() {
      _entries.removeWhere((e) => e.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _entries.isEmpty
          ? const Center(
              child: Text('Noch keine Artikel. Tippe später auf +'),
            )
          : ListView.builder(
              itemCount: _entries.length,
              itemBuilder: (context, i) {
                final e = _entries[i];

                return ListTile(
                  leading: Checkbox(
                    value: e.isDone,
                    onChanged: (_) => _toggleDone(e.id),
                  ),
                  title: Text(
                    '${e.title} (${e.quantity}x)',
                    style: TextStyle(
                      decoration:
                          e.isDone ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  trailing: IconButton(
                    onPressed: () => _removeEntry(e.id),
                    icon: const Icon(Icons.delete),
                  ),
                );
              },
            ),
    );
  }
}
