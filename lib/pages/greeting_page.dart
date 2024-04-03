import 'package:flutter/material.dart';

class GreetingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Greeting Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Welcome to the Greeting Page!', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20), // 余白を追加
            Expanded(child: Image.asset('assets/cafe01.webp')),
            SizedBox(height: 20), // 余白を追加
            Expanded(child: Image.asset('assets/cafe02.webp')),
          ],
        ),
      ),
    );
  }
}
