class Flashcard {
  final String question;
  final String answer;
  final List<String> options;
  final bool isFavorite;
  final int level;

  Flashcard({
    required this.question,
    required this.answer,
    required this.options,
    required this.isFavorite,
    required this.level,
  });

  factory Flashcard.fromMap(Map<String, dynamic> map) {
    return Flashcard(
      question: map['question'] ?? '',
      answer: map['answer'] ?? '',
      options: map['options'] != null ? List<String>.from(map['options']) : [],
      isFavorite: map['is_favorite'] ?? false,
      level: map['level'] ?? 1,
    );
  }
}
