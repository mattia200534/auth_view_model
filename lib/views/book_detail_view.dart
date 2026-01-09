import 'package:flutter/material.dart';
import 'package:model/models/book_model.dart';
import 'package:path/path.dart';

class BookDetailView extends StatelessWidget {
  final Book book;
  const BookDetailView({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Images = book.images ?? [];
    return Scaffold(
      appBar: AppBar(title: Text(book.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Images.isNotEmpty)
              SizedBox(
                height: 200,
                child: CarouselView(
                  itemExtent: 300,
                  itemSnapping: true,
                  elevation: 2,
                  scrollDirection: Axis.horizontal,
                  children: Images.map((img) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        img.imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    );
                  }).toList(),
                ),
              )
            else
              Container(
                height: 200,
                color: Colors.grey,
                child: const Center(child: Icon(Icons.photo, size: 40)),
              ),

            Text("titolo: ${book.title}"),
            Text("Autore: ${book.author}"),
            Text("Genere: ${book.genre}"),
            Text("Pagine: ${book.pages.toString()}"),
            Text("Stato: ${book.status.name}"),
            Text("Valutazione: ${book.rating}/5"),
            if (book.comment.isNotEmpty)
              Text(
                "Commento:\n ${book.comment}",
                strutStyle: const StrutStyle(fontStyle: FontStyle.italic),
              ),
          ],
        ),
      ),
    );
  }
}
