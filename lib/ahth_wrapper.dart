import 'package:flutter/material.dart';
import 'package:mighty_link_app/pages/login_page.dart';
import 'package:mighty_link_app/pages/my_home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isLoggedIn = Supabase.instance.client.auth.currentUser != null;

    if (isLoggedIn) {
      return MyHomePage(); // ユーザーがログインしている場合の画面
    } else {
      return LoginPage(); // ログインしていない場合の画面
    }
  }
}
