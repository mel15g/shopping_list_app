import 'package:flutter/material.dart';
import '../models/list_entry.dart';

class DetailScreen extends StatefulWidget {
  final ListEntry entry;

  const DetailScreen({super.key, required this.entry});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _quantityController;

  late bool _isDone;
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.entry.title);
    _quantityController =
        TextEditingController(text: widget.entry.quantity.toString());
    _isDone = widget.entry.isDone;
    _isFavorite = widget.entry.isFavorite;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _save() {
    final title = _titleController.text.trim();
    final qty = int.tryParse(_quantityController.text.trim());

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitte einen Produktnamen eingeben.')),
      );
      return;
    }
    if (qty == null || qty <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitte eine gültige Menge (>= 1) eingeben.')),
      );
      return;
    }

    final updated = widget.entry.copyWith(
      title: title,
      quantity: qty,
      isDone: _isDone,
      isFavorite: _isFavorite,
    );

    Navigator.of(context).pop(updated);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details bearbeiten'),
        actions: [
          IconButton(
            tooltip: 'Speichern',
            onPressed: _save,
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Produktname',
              border: OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _quantityController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Menge',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            value: _isDone,
            onChanged: (v) => setState(() => _isDone = v),
            title: const Text('Erledigt'),
          ),
          SwitchListTile(
            value: _isFavorite,
            onChanged: (v) => setState(() => _isFavorite = v),
            title: const Text('Favorit'),
            secondary: Icon(_isFavorite ? Icons.star : Icons.star_border),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.save),
            label: const Text('Speichern'),
          ),
        ],
      ),
    );
  }
}
