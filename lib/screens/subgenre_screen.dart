import 'package:flutter/material.dart';
import 'package:mighty_link_app/screens/level_screen.dart';

class SubgenreScreen extends StatelessWidget {
  final String genre;
  final List<String> subgenres;

  SubgenreScreen({required this.genre, required this.subgenres});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Subgenre'),
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
          itemCount: subgenres.length,
          itemBuilder: (context, index) {
            String subgenre = subgenres[index];
            return Card(
              color: Colors.black87, // Optional: change card background color
              elevation: 4,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LevelScreen(
                        genre: genre,
                        subgenre: subgenre,
                      ),
                    ),
                  );
                },
                child: ListTile(
                  leading: Icon(Icons.subdirectory_arrow_right, color: Colors.white), // Ensure icon color is also visible
                  title: Text(
                    subgenre,
                    style: TextStyle(
                      color: Colors.white, // Change text color to white for better contrast
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
