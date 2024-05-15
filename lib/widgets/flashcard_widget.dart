import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:mighty_link_app/models/flashcard.dart';

class FlashcardWidget extends StatelessWidget {
  final Flashcard flashcard;

  FlashcardWidget({required this.flashcard});

  @override
  Widget build(BuildContext context) {
    final FlipCardController controller = FlipCardController();

    return FlipCard(
      controller: controller,
      rotateSide: RotateSide.left,
      axis: FlipAxis.horizontal,
      onTapFlipping: true,
      frontWidget: Card(
        color: Colors.blueAccent, // 表の色を青に設定
        elevation: 4,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              flashcard.question,
              style: TextStyle(fontSize: 24, color: Colors.white), // テキストの色を白に設定
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
      backWidget: Card(
        color: Colors.greenAccent, // 裏の色を緑に設定
        elevation: 4,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              flashcard.answer,
              style: TextStyle(fontSize: 24, color: Colors.white), // テキストの色を白に設定
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
