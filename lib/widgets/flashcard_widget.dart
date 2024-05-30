import 'package:flutter/material.dart';
import 'package:mighty_link_app/models/flashcard.dart';

class FlashcardQuizWidget extends StatefulWidget {
  final Flashcard flashcard;

  FlashcardQuizWidget({required this.flashcard});

  @override
  _FlashcardQuizWidgetState createState() => _FlashcardQuizWidgetState();
}

class _FlashcardQuizWidgetState extends State<FlashcardQuizWidget> {
  String? selectedOption;

  void _showResultDialog(bool isCorrect) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isCorrect ? 'Correct!' : 'Incorrect'),
          content: Text(isCorrect
              ? 'Well done! The correct answer is ${widget.flashcard.answer}.'
              : 'Try again. The correct answer is ${widget.flashcard.answer}.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print('Rendering FlashcardQuizWidget: ${widget.flashcard}'); // Debug message
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.flashcard.question,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            ...widget.flashcard.options.map((option) => ListTile(
                  title: Text(option),
                  leading: Radio<String>(
                    value: option,
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value;
                      });
                      _showResultDialog(value == widget.flashcard.answer);
                      print('Selected option: $value'); // Debug message
                    },
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
