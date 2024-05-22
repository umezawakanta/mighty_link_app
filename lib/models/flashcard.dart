class Flashcard {
  final String question;
  final String answer;
  bool isFavorite;
  final int level; // 新しく追加

  Flashcard({required this.question, required this.answer, this.isFavorite = false, required this.level});

  // データベースから取得する際に必要なfactoryメソッド
  factory Flashcard.fromMap(Map<String, dynamic> data) {
    return Flashcard(
      question: data['question'],
      answer: data['answer'],
      isFavorite: data['is_favorite'] ?? false,
      level: data['level'], // 新しく追加
    );
  }

  // データベースに保存する際に必要なメソッド
  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'answer': answer,
      'is_favorite': isFavorite,
      'level': level, // 新しく追加
    };
  }
}
