import 'package:flutter/material.dart';
import '../models/list_entry.dart';
import 'add_item_screen.dart';
import 'list_screen.dart';
import 'detail_screen.dart';

// HomeScreen ist die "Zentrale" der App: verwaltet den Zustand (Liste, Favoriten, erledigt), steuert die Tabs (BottomNavigationBar), navigiert zu AddItemScreen und DetailScreen
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// _HomeScreenState ist notwendig, weil sich hier Daten ändern:
// -> Daher StatefulWidget + setState()
class _HomeScreenState extends State<HomeScreen> {
  // aktueller Tab: 0=Offen, 1=Erledigt, 2=Favoriten
  int _index = 0;

  // "Datenbank" im Speicher: Liste aller Einträge, aus der wir später gefiltert anzeigen.
  final List<ListEntry> _entries = [
    const ListEntry(id: 'e1', title: 'Bananen', quantity: 4),
    const ListEntry(id: 'e2', title: 'Milch', quantity: 1),
    const ListEntry(id: 'e3', title: 'Duschgel', quantity: 2),
  ];

  // Erledigt-Status umschalten (Checkbox), setState() ist wichtig: Flutter baut das UI danach neu auf.
  void _toggleDone(String id) {
    setState(() {
      final i = _entries.indexWhere((e) => e.id == id);
      _entries[i] = _entries[i].copyWith(isDone: !_entries[i].isDone);
    });
  }

  // Favorit-Status umschalten (Stern)
  void _toggleFavorite(String id) {
    setState(() {
      final i = _entries.indexWhere((e) => e.id == id);
      _entries[i] = _entries[i].copyWith(isFavorite: !_entries[i].isFavorite);
    });
  }

  // Eintrag löschen
  void _removeEntry(String id) {
    setState(() => _entries.removeWhere((e) => e.id == id));
  }

  // Favorit -> zurück in die Einkaufsliste (Offen), Idee: Favoriten sind eine Merkliste, die man schnell wieder übernehmen kann.
  void _moveToOpen(String id) {
    setState(() {
      final i = _entries.indexWhere((e) => e.id == id);
      _entries[i] = _entries[i].copyWith(isDone: false);
      _index = 0; // springt auf Tab "Offen" zurück
    });
  }

  // Navigation zum AddItemScreen:
  // - push() öffnet den Screen
  // - pop() gibt Map zurück (title, quantity, isFavorite)
  Future<void> _openAddItem() async {
    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(builder: (_) => const AddItemScreen()),
    );
    if (result == null) return;

    setState(() {
      _entries.add(
        ListEntry(
          id: DateTime.now().microsecondsSinceEpoch.toString(), // einfache eindeutige ID
          title: result['title'] as String,
          quantity: result['quantity'] as int,
          // evtl. beim Hinzufügen gleich Favorit setzen
          isFavorite: (result['isFavorite'] as bool?) ?? false,
        ),
      );
    });
  }

  // Navigation zum DetailScreen: wir schicken den Eintrag hin, bekommen evtl. einen aktualisierten ListEntry zurück
  Future<void> _openDetails(ListEntry entry) async {
    final updated = await Navigator.of(context).push<ListEntry>(
      MaterialPageRoute(builder: (_) => DetailScreen(entry: entry)),
    );
    if (updated == null) return;

    setState(() {
      final i = _entries.indexWhere((e) => e.id == updated.id);
      _entries[i] = updated; // ersetze Eintrag durch die neue Version
    });
  }

  @override
  Widget build(BuildContext context) {
    // Filter-Logik: Wir haben eine "Master-Liste" (_entries) und erstellen je Tab eine gefilterte Ansicht.
    final open = _entries.where((e) => !e.isDone).toList();
    final done = _entries.where((e) => e.isDone).toList();
    final favs = _entries.where((e) => e.isFavorite).toList();

    // Icon & Titel hängen vom aktiven Tab ab
    final IconData icon = _index == 0
        ? Icons.shopping_basket_outlined
        : _index == 1
            ? Icons.check_circle_outline
            : Icons.star_outline;

    final String title = _index == 0
        ? 'Einkaufsliste'
        : _index == 1
            ? 'Erledigt'
            : 'Favoriten';

    // Was angezeigt wird, hängt vom Tab ab
    final shown = _index == 0 ? open : _index == 1 ? done : favs;

    return Scaffold(
      // Hintergrundfarbe im Pink-Stil (UI-Design)
      backgroundColor: const Color(0xFFFFF4F7),

      // AppBar: centerTitle: true und Titel + Icon in Pink
      appBar: AppBar(
        backgroundColor: Colors.pink.shade50,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min, // wichtig, damit es wirklich mittig bleibt
          children: [
            Icon(icon, color: Colors.pink),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.pink,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),

      // Body ist immer derselbe ListScreen, aber es gibt je Tab andere Daten + UI-Flags mit.
      body: ListScreen(
        entries: shown,
        onToggleDone: _toggleDone,
        onToggleFavorite: _toggleFavorite,
        onRemove: _removeEntry,
        onOpenDetails: _openDetails,

        // Favoriten-Tab: keine Checkbox, kein Durchstreichen, kein Löschen
        showCheckbox: _index != 2,
        disableDoneStyle: _index == 2,
        hideDelete: _index == 2,

        // Favoriten-Tab: Einkaufswagen-Button aktiv
        showMoveToOpen: _index == 2,
        onMoveToOpen: _index == 2 ? _moveToOpen : null,

        // Leer-Text je Tab
        emptyText: _index == 0
            ? 'Deine Einkaufsliste ist leer.'
            : _index == 1
                ? 'Noch keine erledigten Produkte.'
                : 'Noch keine Favoriten gespeichert.',
      ),

      // FAB nur im Tab "Offen":, neue Artikel werden normalerweise in die Einkaufsliste gelegt.
      floatingActionButton: _index == 0
          ? FloatingActionButton(
              backgroundColor: Colors.pink,
              onPressed: _openAddItem,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,

      // Navigation zwischen den Screens (Offen/Erledigt/Favoriten)
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i), // Tab wechseln + UI neu bauen
        selectedItemColor: Colors.pink,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_basket_outlined),
            label: 'Offen',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline),
            label: 'Erledigt',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_outline),
            label: 'Favoriten',
          ),
        ],
      ),
    );
  }
}
