import 'package:flutter/material.dart';
import 'package:mighty_link_app/screens/flashcard_screen.dart';

class GenreScreen extends StatelessWidget {
  final List<String> genres = ['Flutter', 'Dart', 'Firebase', 'Supabase', 'AWS', 'LPI'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Genre'),
      ),
      body: ListView.builder(
        itemCount: genres.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(genres[index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FlashcardScreen(genre: genres[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
