class BookImage {
  final String id;
  final String bookId;
  final String imageUrl;

  BookImage({required this.id, required this.bookId, required this.imageUrl});

  factory BookImage.fromMap(Map<String, dynamic> map) {
    return BookImage(
      id: map['id'],
      bookId: map['bookId'],
      imageUrl: map['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'bookId': bookId, 'imageUrl': imageUrl};
  }
}
