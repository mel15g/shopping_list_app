import 'package:flutter/material.dart';
import '../models/list_entry.dart';

// ListScreen zeigt eine Liste von ListEntry-Objekten an.
// Er ist StatelessWidget, weil der Zustand im HomeScreen verwaltet wird und hier nur via Callbacks reinkommt.
class ListScreen extends StatelessWidget {
  const ListScreen({
    super.key,
    required this.entries,
    required this.onToggleDone,
    required this.onToggleFavorite,
    required this.onRemove,
    required this.onOpenDetails,
    required this.showMoveToOpen,
    required this.onMoveToOpen,
    required this.emptyText,
    this.showCheckbox = true,
    this.disableDoneStyle = false,
    this.hideDelete = false,
  });

  // Datenquelle: Einträge, die dargestellt werden sollen (z.B. offen/erledigt/favoriten)
  final List<ListEntry> entries;

  // Callbacks (werden im HomeScreen implementiert -> State ändert sich dort) 
  final void Function(String id) onToggleDone;
  final void Function(String id) onToggleFavorite;
  final void Function(String id) onRemove;
  final void Function(ListEntry entry) onOpenDetails;

  // Extra-Funktion für Favoriten: "in Einkaufsliste übernehmen"
  final bool showMoveToOpen;
  final void Function(String id)? onMoveToOpen;

  // Text, wenn die jeweilige Liste leer ist
  final String emptyText;

  // UI-Flags (je nach Tab unterschiedlich)
  final bool showCheckbox;      // Favoriten: false -> keine Checkbox anzeigen
  final bool disableDoneStyle;  // Favoriten: true -> kein Durchstreichen
  final bool hideDelete;        // Favoriten: true -> kein Löschen-Button

  @override
  Widget build(BuildContext context) {
    // Leerer Zustand: wenn keine Einträge da sind -> nette Message anzeigen
    if (entries.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            emptyText,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    // Liste der Einträge
    // ListView.separated gibt automatisch Abstand/Trenner zwischen Cards.
    return ListView.separated(
      // Unten extra Platz, damit BottomNavigationBar/FAB nichts überdeckt
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      itemCount: entries.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        final e = entries[i];

        // Textstyle:
        // Wenn disableDoneStyle = false und e.isDone = true -> durchstreichen
        // In Favoriten disableDoneStyle = true -> niemals durchstreichen
        final titleStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
              decoration: (!disableDoneStyle && e.isDone)
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
            );

        //  Jede Zeile ist eine Card, die tappbar ist (öffnet DetailScreen)
        return Card(
          elevation: 0.5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => onOpenDetails(e),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  // Checkbox nur in "Offen" und "Erledigt"
                  if (showCheckbox) ...[
                    Checkbox(
                      value: e.isDone,
                      onChanged: (_) => onToggleDone(e.id),
                    ),
                    const SizedBox(width: 6),
                  ],

                  // Text nimmt den verfügbaren Platz ein
                  Expanded(
                    child: Text(
                      '${e.title} (${e.quantity}x)',
                      style: titleStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // Favorit-Button:
                  // Stern gefüllt wenn isFavorite, sonst Outline
                  IconButton(
                    tooltip: e.isFavorite
                        ? 'Entfavorisieren'
                        : 'Als Favorit speichern',
                    onPressed: () => onToggleFavorite(e.id),
                    icon: Icon(e.isFavorite ? Icons.star : Icons.star_border),
                  ),

                  // Favoriten-Tab: "In Einkaufsliste übernehmen"
                  if (showMoveToOpen && onMoveToOpen != null)
                    IconButton(
                      tooltip: 'In Einkaufsliste',
                      onPressed: () => onMoveToOpen!(e.id),
                      icon: const Icon(Icons.shopping_cart_outlined),
                    ),

                  // Löschen-Button nur wenn hideDelete = false
                  if (!hideDelete)
                    IconButton(
                      tooltip: 'Löschen',
                      onPressed: () => onRemove(e.id),
                      icon: const Icon(Icons.delete_outline),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
