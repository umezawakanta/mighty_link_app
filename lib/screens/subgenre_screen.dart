import 'package:flutter/material.dart';
import 'package:mighty_link_app/screens/flashcard_screen.dart';

class SubgenreScreen extends StatelessWidget {
  final String genre;
  final List<String> subgenres;

  SubgenreScreen({required this.genre, required this.subgenres});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Subgenre'),
      ),
      body: ListView.builder(
        itemCount: subgenres.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(subgenres[index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FlashcardScreen(
                    genre: genre,
                    subgenre: subgenres[index],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
