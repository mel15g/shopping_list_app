import 'package:flutter/material.dart';

// AddItemScreen dient zum Anlegen eines neuen Produkts.
// -> StatefulWidget, da Benutzereingaben (Textfelder & Switch) den Zustand des Screens verändern.
class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  // Controller für den Produktnamen
  final _titleCtrl = TextEditingController();

  // Controller für die Menge -> Standardwert = 1
  final _qtyCtrl = TextEditingController(text: '1');

  // Status, ob das Produkt direkt als Favorit gespeichert wird
  bool _isFavorite = false;

  @override
  void dispose() {
    // Controller immer freigeben -> Best Practice
    _titleCtrl.dispose();
    _qtyCtrl.dispose();
    super.dispose();
  }

  // Speichert das neue Produkt: liest Eingaben aus, validiert Basiswerte und gibt Daten als Map an den HomeScreen zurück
  void _save() {
    final title = _titleCtrl.text.trim();
    final qty = int.tryParse(_qtyCtrl.text.trim()) ?? 1;

    // Ein Produkt ohne Namen wird nicht gespeichert
    if (title.isEmpty) return;

    // Rückgabe der Daten an den vorherigen Screen
    Navigator.of(context).pop({
      'title': title,
      'quantity': qty,
      'isFavorite': _isFavorite,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Einheitlicher Hintergrund (pinkes Design)
      backgroundColor: const Color(0xFFFFF4F7),

      // AppBar mit Icon + Titel, mittig ausgerichtet
      appBar: AppBar(
        backgroundColor: Colors.pink.shade50,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.add_shopping_cart, color: Colors.pink),
            SizedBox(width: 8),
            Text(
              'Neues Produkt',
              style: TextStyle(
                color: Colors.pink,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
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
                // Eingabe: Produktname
                TextField(
                  controller: _titleCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Produktname',
                  ),
                ),

                const SizedBox(height: 12),

                // Eingabe: Menge
                TextField(
                  controller: _qtyCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Menge',
                  ),
                ),

                const SizedBox(height: 8),

                // Option: direkt als Favorit speichern
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _isFavorite,
                  activeColor: Colors.pink,
                  title: const Text(
                    'Direkt als Favorit speichern',
                  ),
                  onChanged: (v) =>
                      setState(() => _isFavorite = v),
                ),

                const SizedBox(height: 12),

                // Speichern-Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _save,
                    icon: const Icon(Icons.save),
                    label: const Text('Speichern'),
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
