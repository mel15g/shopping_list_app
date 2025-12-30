import 'package:flutter/material.dart';
import '../models/list_entry.dart';

// DetailScreen zeigt die Details eines einzelnen Produkts und erlaubt direktes Bearbeiten (Name, Menge, Status, Favorit).
// -> StatefulWidget, weil sich Eingaben und Switches ändern.
class DetailScreen extends StatefulWidget {
  final ListEntry entry;

  const DetailScreen({
    super.key,
    required this.entry,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  // Controller für Textfelder, notwendig, um Text auszulesen und vorab zu befüllen
  late final TextEditingController _titleCtrl;
  late final TextEditingController _qtyCtrl;

  // Lokale Kopien der Status-Werte, werden im Screen verändert, aber erst beim Speichern zurückgegeben
  late bool _isDone;
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();

    // Initialisierung mit den aktuellen Werten des Eintrags
    _titleCtrl = TextEditingController(text: widget.entry.title);
    _qtyCtrl =
        TextEditingController(text: widget.entry.quantity.toString());
    _isDone = widget.entry.isDone;
    _isFavorite = widget.entry.isFavorite;
  }

  @override
  void dispose() {
    // Controller immer sauber entsorgen -> Best Practice
    _titleCtrl.dispose();
    _qtyCtrl.dispose();
    super.dispose();
  }

  // Speichern: validiert Eingaben, erstellt eine neue Kopie des ListEntry, gibt sie mit Navigator.pop() an den HomeScreen zurück
  void _save() {
    final title = _titleCtrl.text.trim();
    final qty = int.tryParse(_qtyCtrl.text.trim()) ?? 1;

    // einfache Validierung
    if (title.isEmpty) return;

    Navigator.of(context).pop(
      widget.entry.copyWith(
        title: title,
        quantity: qty,
        isDone: _isDone,
        isFavorite: _isFavorite,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Einheitlicher pinker Hintergrund (Design-Konsistenz)
      backgroundColor: const Color(0xFFFFF4F7),

      // AppBar mit Icon + Titel mittig
      appBar: AppBar(
        backgroundColor: Colors.pink.shade50,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.info_outline, color: Colors.pink),
            SizedBox(width: 8),
            Text(
              'Produktdetails',
              style: TextStyle(
                color: Colors.pink,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),

        // Speichern-Icon oben rechts
        actions: [
          IconButton(
            onPressed: _save,
            icon: const Icon(Icons.save, color: Colors.pink),
          ),
        ],
      ),

      // Inhalt des Screens
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Produktname bearbeiten
                TextField(
                  controller: _titleCtrl,
                  decoration:
                      const InputDecoration(labelText: 'Name'),
                ),

                const SizedBox(height: 12),

                // Menge bearbeiten
                TextField(
                  controller: _qtyCtrl,
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration(labelText: 'Menge'),
                ),

                const SizedBox(height: 8),

                // Status erledigt / offen
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _isDone,
                  activeColor: Colors.pink,
                  title:
                      const Text('Als erledigt markieren'),
                  onChanged: (v) =>
                      setState(() => _isDone = v),
                ),

                // Favoriten-Status
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _isFavorite,
                  activeColor: Colors.pink,
                  title:
                      const Text('Als Favorit speichern'),
                  onChanged: (v) =>
                      setState(() => _isFavorite = v),
                ),

                const SizedBox(height: 12),

                // Großer Speichern-Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _save,
                    icon: const Icon(Icons.check),
                    label:
                        const Text('Änderungen speichern'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
