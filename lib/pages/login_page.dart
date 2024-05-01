import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:email_validator/email_validator.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => EmailValidator.validate(value!)
                    ? null
                    : "Please enter a valid email",
                onFieldSubmitted: (value) {
                  // Email入力後にEnterキーが押されたら、パスワードフィールドにフォーカスを移動
                  FocusScope.of(context).nextFocus();
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
                onFieldSubmitted: (value) {
                  // Password入力後にEnterキーが押されたらログイン処理を実行
                  if (_formKey.currentState!.validate()) {
                    _loginUser(_emailController.text, _passwordController.text);
                  }
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _loginUser(_emailController.text, _passwordController.text);
                  }
                },
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Login process implementation
  Future<void> _loginUser(String email, String password) async {
    try {
      final response = await Supabase.instance.client.auth
          .signInWithPassword(email: email, password: password);
      if (response.session != null) {
        // ログイン成功
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Logged in successfully!')));
        // 成功時の画面に戻る
        Navigator.pop(context, true); // `true` はログインが成功したことを意味します
      } else {
        // ログイン失敗
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Login failed')));
      }
    } catch (e) {
      print('Exception during login: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Login exception: $e')));
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
