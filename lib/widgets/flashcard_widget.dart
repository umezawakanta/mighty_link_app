import 'package:flutter/material.dart';
import 'package:mighty_link_app/models/flashcard.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FlashcardQuizWidget extends StatefulWidget {
  final Flashcard flashcard;
  final String userId; // ユーザーIDを追加

  FlashcardQuizWidget({required this.flashcard, required this.userId});

  @override
  FlashcardQuizWidgetState createState() => FlashcardQuizWidgetState();
}

class FlashcardQuizWidgetState extends State<FlashcardQuizWidget> {
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

  Future<void> _saveQuizResult(bool isCorrect) async {
    await Supabase.instance.client.from('quiz_results').insert({
      'user_id': widget.userId,
      'flashcard_id': widget.flashcard.id, // フラッシュカードIDを使用
      'is_correct': isCorrect,
    });

    print('Quiz result saved successfully');
  }

  @override
  Widget build(BuildContext context) {
    print(
        'Rendering FlashcardQuizWidget: ${widget.flashcard}'); // Debug message
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
                    onChanged: (value) async {
                      setState(() {
                        selectedOption = value;
                      });
                      final isCorrect = value == widget.flashcard.answer;
                      await _saveQuizResult(isCorrect);
                      _showResultDialog(isCorrect);
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
