import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mighty_link_app/models/flashcard.dart';
import 'package:mighty_link_app/widgets/flashcard_widget.dart';

class FlashcardScreen extends StatefulWidget {
  final String genre;
  final String subgenre;

  FlashcardScreen({required this.genre, required this.subgenre});

  @override
  FlashcardScreenState createState() => FlashcardScreenState();
}

class FlashcardScreenState extends State<FlashcardScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Flashcard> flashcards = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFlashcards();
  }

  Future<void> fetchFlashcards() async {
    final response = await supabase
        .from('flashcards')
        .select()
        .eq('genre', widget.genre)
        .eq('subgenre', widget.subgenre);
    
    final data = response as List<dynamic>;

    setState(() {
      flashcards = data.map((flashcard) {
        return Flashcard(
          question: flashcard['question'],
          answer: flashcard['answer'],
        );
      }).toList();
      isLoading = false;
    });
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FlashCard Quiz: ${widget.genre} - ${widget.subgenre}'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
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
