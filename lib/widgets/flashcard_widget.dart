import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:mighty_link_app/models/flashcard.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FlashcardWidget extends StatefulWidget {
  final Flashcard flashcard;

  FlashcardWidget({required this.flashcard});

  @override
  _FlashcardWidgetState createState() => _FlashcardWidgetState();
}

class _FlashcardWidgetState extends State<FlashcardWidget> {
  final SupabaseClient supabase = Supabase.instance.client;
  late FlipCardController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FlipCardController();
  }

  Future<void> toggleFavorite() async {
    setState(() {
      widget.flashcard.isFavorite = !widget.flashcard.isFavorite;
    });

    // Log the value of widget.flashcard.isFavorite
    print("widget.flashcard.isFavorite: ${widget.flashcard.isFavorite}");

    try {
      final response = await supabase
          .from('flashcards')
          .update({'is_favorite': widget.flashcard.isFavorite})
          .eq('question', widget.flashcard.question)
          .select();

      // Check the response to see if the update was successful
      if (response.isEmpty) {
        print('Error: Update failed or no data returned');
      } else {
        print('Update successful: $response');
      }
    } catch (e) {
      // Handle error
      print('An error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlipCard(
      controller: _controller,
      rotateSide: RotateSide.left,
      axis: FlipAxis.horizontal,
      onTapFlipping: true,
      frontWidget: Card(
        elevation: 4,
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  widget.flashcard.question,
                  style: TextStyle(fontSize: 24),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: Icon(
                  widget.flashcard.isFavorite ? Icons.star : Icons.star_border,
                  color: widget.flashcard.isFavorite ? Colors.yellow : null,
                ),
                onPressed: toggleFavorite,
              ),
            ),
          ],
        ),
      ),
      backWidget: Card(
        elevation: 4,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              widget.flashcard.answer,
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
