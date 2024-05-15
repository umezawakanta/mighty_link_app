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
      onTapFlipping: true,  // ここを追加
      frontWidget: Card(
        elevation: 4,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              flashcard.question,
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
      backWidget: Card(
        elevation: 4,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              flashcard.answer,
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
