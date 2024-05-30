import 'package:flutter/material.dart';
import 'package:mighty_link_app/screens/flashcard_screen.dart';

class LevelScreen extends StatelessWidget {
  final String genre;
  final String subgenre;
  final String userId; // ユーザーIDを追加

  LevelScreen(
      {required this.genre,
      required this.subgenre,
      required this.userId}); // コンストラクタを修正

  final List<int> levels = [1, 2, 3];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Level'),
      ),
      body: ListView.builder(
        itemCount: levels.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Level ${levels[index]}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FlashcardScreen(
                    genre: genre,
                    subgenre: subgenre,
                    level: levels[index],
                    userId: userId, // ユーザーIDを渡す
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
