import 'package:model/models/book_image.dart';

enum BookStatus {
  nonLetto,
  inLettura,
  daLeggere,
  lasciato,
  nonInteressa;

  //metodo per convertire un enum in stringa
  String toDbValue() {
    switch (this) {
      case BookStatus.nonLetto:
        return "nonLetto";
      case BookStatus.inLettura:
        return "inLettura";
      case BookStatus.daLeggere:
        return "daLeggere";
      case BookStatus.lasciato:
        return "lasciato";
      case BookStatus.nonInteressa:
        return "nonInteressa";
    }
  }

  static BookStatus fromDbValue(String value) {
    switch (value) {
      case "nonLetto":
        return BookStatus.nonLetto;
      case "inLettura":
        return BookStatus.inLettura;
      case "daLeggere":
        return BookStatus.daLeggere;
      case "lasciato":
        return BookStatus.lasciato;
      case "nonInteressa":
        return BookStatus.nonInteressa;
      default:
        return BookStatus.nonLetto;
    }
  }
}

class Book {
  final String id;
  final String userId;
  final String title;
  final String genre;
  final int pages;
  final int rating;
  final String comment;
  final String author;
  final BookStatus status;
  final DateTime createdAt;

  final List<BookImage>? images;

  Book({
    required this.id,
    required this.userId,
    required this.title,
    required this.genre,
    required this.pages,
    required this.rating,
    required this.comment,
    required this.author,
    required this.status,
    required this.createdAt,
    this.images,
  });

  factory Book.fromMap(Map<String, dynamic> map, {List<BookImage>? images}) {
    return Book(
      id: map['id'],
      userId: map['userId'],
      title: map['title'],
      genre: map['genre'],
      pages: map['pages'],
      rating: map['rating'],
      comment: map['comment'],
      author: map['author'],
      status: BookStatus.fromDbValue(map['status']),
      createdAt: DateTime.parse(map['createdAt']),
      images: images ?? [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'genre': genre,
      'pages': pages,
      'rating': rating,
      'comment': comment,
      'author': author,
      'status': status.toDbValue(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
