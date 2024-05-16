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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Genre'),
      ),
      body: ListView.builder(
        itemCount: genresWithSubgenres.keys.length,
        itemBuilder: (context, index) {
          String genre = genresWithSubgenres.keys.elementAt(index);
          return ListTile(
            title: Text(genre),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubgenreScreen(
                    genre: genre,
                    subgenres: genresWithSubgenres[genre]!,
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
