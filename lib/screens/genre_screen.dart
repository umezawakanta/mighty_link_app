import 'package:flutter/material.dart';
import 'package:mighty_link_app/screens/subgenre_screen.dart';

class GenreScreen extends StatelessWidget {
  final Map<String, List<String>> genresWithSubgenres = {
    'Flutter': ['Basics', 'Widgets', 'State Management'],
    'Dart': ['Syntax', 'Asynchronous', 'Collections'],
    'Firebase': ['Authentication', 'Firestore', 'Storage'],
    'Supabase': ['Database', 'Auth', 'Storage'],
    'AWS': ['EC2', 'S3', 'Lambda'],
    'LPI': ['Linux Basics', 'System Administration', 'Networking'],
  };

  final String userId; // ユーザーIDを追加

  GenreScreen({required this.userId}); // コンストラクタを修正

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Genre'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.purple],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          itemCount: genresWithSubgenres.keys.length,
          itemBuilder: (context, index) {
            String genre = genresWithSubgenres.keys.elementAt(index);
            return Card(
              color: Colors.black87, // Optional: change card background color
              elevation: 4,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SubgenreScreen(
                        genre: genre,
                        subgenres: genresWithSubgenres[genre]!,
                        userId: userId, // ユーザーIDを渡す
                      ),
                    ),
                  );
                },
                child: ListTile(
                  leading: Icon(Icons.category,
                      color: Colors.white), // Ensure icon color is also visible
                  title: Text(
                    genre,
                    style: TextStyle(
                      color: Colors
                          .white, // Change text color to white for better contrast
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
