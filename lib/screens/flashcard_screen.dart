import 'package:flutter/material.dart';
import 'package:mighty_link_app/models/flashcard.dart';
import 'package:mighty_link_app/widgets/flashcard_widget.dart';

class FlashcardScreen extends StatelessWidget {
  final List<Flashcard> flashcards = [
    Flashcard(question: 'What is Flutter?', answer: 'An open-source UI software development toolkit.'),
    Flashcard(question: 'Who developed Flutter?', answer: 'Google.'),
    // Add more flashcards here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FlashCard Quiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: flashcards.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: FlashcardWidget(flashcard: flashcards[index]),
            );
          },
        ),
      ),
    );
  }
}
