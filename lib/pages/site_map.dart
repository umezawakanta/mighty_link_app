import 'package:flutter/material.dart';

class SiteMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('サイトマップ'),
        ),
        body: ListView(
          children: [
            ExpansionTile(
              title: Text('トップページ'),
              children: <Widget>[
                ListTile(
                  title: Text('会社概要'),
                ),
                ExpansionTile(
                  title: Text('製品情報'),
                  children: <Widget>[
                    ListTile(
                      title: Text('製品A'),
                    ),
                    ListTile(
                      title: Text('製品B'),
                    ),
                  ],
                ),
                ListTile(
                  title: Text('お問い合わせ'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
