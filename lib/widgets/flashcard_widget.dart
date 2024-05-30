import 'package:flutter/material.dart';
import 'package:mighty_link_app/models/flashcard.dart';

class FlashcardQuizWidget extends StatelessWidget {
  final Flashcard flashcard;

  FlashcardQuizWidget({required this.flashcard});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              flashcard.question,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            ...flashcard.options.map((option) {
              return ElevatedButton(
                onPressed: () {
                  bool isCorrect = option == flashcard.answer;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isCorrect ? 'Correct!' : 'Wrong answer.'),
                      backgroundColor: isCorrect ? Colors.green : Colors.red,
                    ),
                  );
                },
                child: Text(option),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
