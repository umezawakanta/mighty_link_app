import 'package:flutter/material.dart';

class GreetingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Greeting Page'),
      ),
      body: Center(
        child: Text('Welcome to the Greeting Page!', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
