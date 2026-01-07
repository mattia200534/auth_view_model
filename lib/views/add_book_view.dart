import 'package:flutter/material.dart';
import 'package:model/models/book_model.dart';
import 'package:model/viewmodel/book_view_model.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

String _statusLabel(BookStatus status) {
  switch (status) {
    case BookStatus.nonLetto:
      return "Non letto";
    case BookStatus.inLettura:
      return "In lettura";
    case BookStatus.daLeggere:
      return "Da leggere";
    case BookStatus.lasciato:
      return "Lasciato";
    case BookStatus.nonInteressa:
      return "Non interessa";
  }
}

class AddBookView extends StatefulWidget {
  const AddBookView({super.key});

  @override
  State<AddBookView> createState() => _AddBookViewState();
}

class _AddBookViewState extends State<AddBookView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _genreController = TextEditingController();
  final _pagesController = TextEditingController();
  final _commentController = TextEditingController();
  BookStatus? _selectedStatus;
  double _rating = 3.0;

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _genreController.dispose();
    _pagesController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate() && _selectedStatus != null) {
      final userId = Supabase.instance.client.auth.currentUser?.id ?? '';
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Errore: utente non autenticato')),
        );
        return;
      }

      final newBook = Book(
        id: const Uuid().v4(), // L'ID sarà generato dal backend
        userId: userId,
        title: _titleController.text.trim(),
        genre: _genreController.text.trim(),
        author: _authorController.text.trim(),
        pages: int.tryParse(_pagesController.text.trim()) ?? 0,
        rating: _rating.toInt(),
        comment: _commentController.text.trim(),
        status: _selectedStatus!,
        createdAt: DateTime.now(),
      );

      try {
        await Provider.of<BookViewModel>(
          context,
          listen: false,
        ).addBook(newBook);
        if (context.mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Libro aggiunto con successo!')),
          );
        }
      } catch (e) {
        print("errore nel salvataggio del libro: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Errore nel salvataggio del Libro')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Aggiungi un libro")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Titolo'),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'campo obbligatorio'
                    : null,
              ),
              TextFormField(
                controller: _authorController,
                decoration: InputDecoration(labelText: 'Autore'),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'campo obbligatorio'
                    : null,
              ),
              TextFormField(
                controller: _genreController,
                decoration: InputDecoration(labelText: 'Genere'),
              ),
              TextFormField(
                controller: _pagesController,
                decoration: InputDecoration(labelText: 'Numero di pagine'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return null;
                  }
                  final pages = int.tryParse(value);
                  if (pages == null || pages <= 0) {
                    return 'Inserisci un numero valido di pagine';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField(
                value: _selectedStatus,
                decoration: InputDecoration(
                  labelText: 'Stato di lettura',
                  border: OutlineInputBorder(),
                ),
                items: BookStatus.values.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(_statusLabel(status)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Seleziona uno stato' : null,
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Valutazione:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Slider(
                          value: _rating,
                          min: 1,
                          max: 5,
                          divisions: 4,
                          onChanged: (value) {
                            setState(() {
                              _rating = value;
                            });
                          },
                        ),
                      ),
                      Text("${_rating.toStringAsFixed(0)}"),
                    ],
                  ),
                ],
              ),
              TextFormField(
                controller: _commentController,
                decoration: InputDecoration(
                  labelText: 'Commento',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
              ),
              ElevatedButton.icon(
                onPressed: _submitForm,
                icon: Icon(Icons.add),
                label: Text('Aggiungi Libro'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
