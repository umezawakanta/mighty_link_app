import 'dart:async';
import 'package:flutter/material.dart';

class GreetingPage extends StatefulWidget {
  @override
  _GreetingPageState createState() => _GreetingPageState();
}

class _GreetingPageState extends State<GreetingPage> {
  final PageController _pageController = PageController();
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // 5枚の画像を自動でスクロールさせる
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      int nextPage = _pageController.page!.round() + 1;
      if (nextPage == 5) {
        nextPage = 0; // 最後の画像に達したら最初の画像に戻る
      }
      _pageController.animateToPage(
        nextPage,
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

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
            Expanded(
              child: PageView(
                controller: _pageController,
                children: <Widget>[
                  Image.asset('assets/cafe01.webp'),
                  Image.asset('assets/cafe02.webp'),
                  Image.asset('assets/cafe03.webp'),
                  Image.asset('assets/cafe04.webp'),
                  Image.asset('assets/cafe05.webp'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
