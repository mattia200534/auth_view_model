import 'package:flutter/foundation.dart';
import 'package:model/core/book_service.dart';
import 'package:model/models/book_model.dart';

class BookViewModel extends ChangeNotifier {
  final BookService _bookService = BookService();
  List<Book> _books = [];
  bool _isLoading = false;

  List<Book> get books => _books;

  Future<void> loadAllBooks() async {
    _isLoading = true;
    notifyListeners();

    try {
      _books = await _bookService.fetchBooks();
    } catch (e) {
      print("errore nel caricamento dei libri: $e");
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadBooks(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _books = await _bookService.fetchBooksForCurrentUser(userId);
    } catch (e) {
      print("errore nel caricamento dei libri: $e");
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addBook(Book book) async {
    try {
      await _bookService.createBook(book);
      _books.insert(0, book);
      notifyListeners();
    } catch (e) {
      print("errore nell'aggiunta del libro: $e");
    }
  }

  Future<void> updateBook(Book updatedBook) async {
    try {
      await _bookService.updateBook(updatedBook);
      final index = _books.indexWhere((b) => b.id == updatedBook.id);
      if (index != -1) {
        _books[index] = updatedBook;
        notifyListeners();
      }
    } catch (e) {
      print("errore nell'aggiornamento del libro: $e");
    }
  }

  Future<void> deleteBook(String bookId) async {
    try {
      await _bookService.deleteBook(bookId);
      _books.removeWhere((b) => b.id == bookId);
      notifyListeners();
    } catch (e) {
      print("errore nella cancellazione del libro: $e");
    }
  }
}
