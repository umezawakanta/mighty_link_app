import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mighty_link_app/models/flashcard.dart';
import 'package:mighty_link_app/widgets/flashcard_widget.dart';

class FlashcardScreen extends StatefulWidget {
  final String genre;
  final String subgenre;
  final int level;
  final String userId; // ユーザーIDを追加

  FlashcardScreen(
      {required this.genre,
      required this.subgenre,
      required this.level,
      required this.userId});

  @override
  FlashcardScreenState createState() => FlashcardScreenState();
}

class FlashcardScreenState extends State<FlashcardScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Flashcard> flashcards = [];
  bool isLoading = true;
  bool showFavoritesOnly = false;
  int totalAnswers = 0;
  int correctAnswers = 0;
  int incorrectAnswers = 0;

  @override
  void initState() {
    super.initState();
    fetchFlashcards();
    fetchQuizStats();
  }

  Future<void> fetchFlashcards() async {
    final response = await supabase
        .from('flashcards')
        .select('id, question, answer, options, is_favorite, level')
        .eq('genre', widget.genre)
        .eq('subgenre', widget.subgenre)
        .eq('level', widget.level);

    final data = response as List<dynamic>;
    print('Fetched data: $data'); // Debug message

    List<Flashcard> loadedFlashcards = [];
    for (var flashcard in data) {
      if (flashcard['options'] == null) {
        flashcard['options'] = [
          flashcard['answer'],
          'Incorrect option 1',
          'Incorrect option 2',
          'Incorrect option 3',
        ];
      }
      loadedFlashcards.add(Flashcard.fromMap(flashcard));
    }
    print('Loaded flashcards: $loadedFlashcards');

    setState(() {
      flashcards = loadedFlashcards;
      isLoading = false;
    });
  }

  Future<void> fetchQuizStats() async {
    final response = await supabase
        .from('quiz_results')
        .select('is_correct')
        .eq('user_id', widget.userId);

    final data = response as List<dynamic>;
    totalAnswers = data.length;
    correctAnswers =
        data.where((result) => result['is_correct'] == true).length;
    incorrectAnswers = totalAnswers - correctAnswers;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final displayedFlashcards = showFavoritesOnly
        ? flashcards.where((flashcard) => flashcard.isFavorite).toList()
        : flashcards;

    print('Displayed flashcards: $displayedFlashcards'); // Debug message

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
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      'Total Answers: $totalAnswers, Correct: $correctAnswers, Incorrect: $incorrectAnswers'),
                ),
                Expanded(
                  child: displayedFlashcards
                          .isEmpty // Add a check for empty list
                      ? Center(child: Text('No flashcards available.'))
                      : Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ListView.builder(
                            itemCount: displayedFlashcards.length,
                            itemBuilder: (context, index) {
                              print(
                                  'Rendering flashcard: ${displayedFlashcards[index]}'); // Debug message
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: FlashcardQuizWidget(
                                  flashcard: displayedFlashcards[index],
                                  userId: widget.userId, // ユーザーIDを渡す
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
    );
  }
}
