import 'package:flutter/material.dart';
import '../models/list_entry.dart';
import 'list_screen.dart';
import 'add_item_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  final List<ListEntry> _entries = [
    const ListEntry(id: 'e1', title: 'Bananen', quantity: 6),
    const ListEntry(id: 'e2', title: 'Milch', quantity: 1),
    const ListEntry(id: 'e3', title: 'Duschgel', quantity: 2),
  ];

  void _toggleDone(String id) {
    setState(() {
      final idx = _entries.indexWhere((e) => e.id == id);
      _entries[idx] = _entries[idx].copyWith(isDone: !_entries[idx].isDone);
    });
  }

  void _removeEntry(String id) {
    setState(() {
      _entries.removeWhere((e) => e.id == id);
    });
  }

  Future<void> _openAddItem() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const AddItemScreen()),
    );

    if (result == null) return;

    setState(() {
      _entries.add(
        ListEntry(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          title: result['title'] as String,
          quantity: result['quantity'] as int,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final openItems = _entries.where((e) => !e.isDone).toList();
    final doneItems = _entries.where((e) => e.isDone).toList();

    final title = _index == 0 ? 'Offen' : 'Erledigt';
    final shownItems = _index == 0 ? openItems : doneItems;

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListScreen(
        entries: shownItems,
        onToggleDone: _toggleDone,
        onRemove: _removeEntry,
      ),
      floatingActionButton: _index == 0
          ? FloatingActionButton(
              onPressed: _openAddItem,
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Offen',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline),
            label: 'Erledigt',
          ),
        ],
      ),
    );
  }
}
