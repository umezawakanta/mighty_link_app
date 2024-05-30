import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mighty_link_app/models/flashcard.dart';
import 'package:mighty_link_app/widgets/flashcard_widget.dart';

class FlashcardScreen extends StatefulWidget {
  final String genre;
  final String subgenre;
  final int level;

  FlashcardScreen({required this.genre, required this.subgenre, required this.level});

  @override
  FlashcardScreenState createState() => FlashcardScreenState();
}

class FlashcardScreenState extends State<FlashcardScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Flashcard> flashcards = [];
  bool isLoading = true;
  bool showFavoritesOnly = false;

  @override
  void initState() {
    super.initState();
    fetchFlashcards();
  }

  Future<void> fetchFlashcards() async {
    final response = await supabase
        .from('flashcards')
        .select('question, answer, options, is_favorite, level')
        .eq('genre', widget.genre)
        .eq('subgenre', widget.subgenre)
        .eq('level', widget.level);

    final data = response as List<dynamic>;

    setState(() {
      flashcards = data.map((flashcard) => Flashcard.fromMap(flashcard)).toList();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final displayedFlashcards = showFavoritesOnly
        ? flashcards.where((flashcard) => flashcard.isFavorite).toList()
        : flashcards;

    return Scaffold(
      appBar: AppBar(
        title: Text(
            'FlashCard Quiz: ${widget.genre} - ${widget.subgenre} - Level ${widget.level}'),
        actions: [
          IconButton(
            icon: Icon(showFavoritesOnly ? Icons.star : Icons.star_border),
            onPressed: () {
              setState(() {
                showFavoritesOnly = !showFavoritesOnly;
              });
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: displayedFlashcards.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: FlashcardQuizWidget(flashcard: displayedFlashcards[index]),
                  );
                },
              ),
            ),
    );
  }
}
