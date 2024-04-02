import 'package:flutter/material.dart';
import 'package:mighty_link_app/booking.dart';
import 'package:mighty_link_app/pages/booking_calendar.dart';
import 'package:mighty_link_app/pages/flutter_calendar_carousel.dart';
import 'package:mighty_link_app/pages/generator_page.dart';
import 'package:mighty_link_app/pages/favorites_page.dart';
// その他の必要なページのimport文をここに追加

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
                  onTap: () {
                    // 会社概要ページへの遷移処理
                  },
                ),
                ExpansionTile(
                  title: Text('製品情報'),
                  children: <Widget>[
                    ListTile(
                      title: Text('GeneratorPage'),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => GeneratorPage())), // GeneratorPageへ遷移
                    ),
                    ListTile(
                      title: Text('FavoritesPage'),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FavoritesPage())), // FavoritesPageへ遷移
                    ),
                  ],
                ),
                ListTile(
                  title: Text('予約フォーム'),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Booking())), // Bookingへ遷移
                ),
                ExpansionTile(
                  title: Text('カレンダーサンプル'),
                  children: <Widget>[
                    ListTile(
                      title: Text('TableCalendar'),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => BookingCalendar())), // GeneratorPageへ遷移
                    ),
                    ListTile(
                      title: Text('FlutterCalendarCarousel'),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FlutterCalendarCarousel())), // FavoritesPageへ遷移
                    ),
                  ],
                ),
                ListTile(
                  title: Text('お問い合わせ'),
                  onTap: () {
                    // お問い合わせページへの遷移処理
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
