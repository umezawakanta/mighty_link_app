import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:email_validator/email_validator.dart'; // email_validator パッケージを追加してください

class SignUpPage extends StatefulWidget {
  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // フォームキーを追加

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Formウィジェットを追加
          child: Column(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => EmailValidator.validate(value!)
                    ? null
                    : "Please enter a valid email",
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
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // 会員登録処理を呼び出す前にバリデーションを実行
                    _registerUser(_usernameController.text,
                        _emailController.text, _passwordController.text);
                  }
                },
                child: Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 会員登録処理の実装
  Future<void> _registerUser(
      String username, String email, String password) async {
    try {
      final response = await Supabase.instance.client.auth
          .signUp(email: email, password: password);
      print(response.toString());
      // Check if registration was successful
      if (response.user != null) {
        if (mounted) {
          // mountedチェックを追加
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Registered successfully!')));
        }
      } else {
        // Handle the case where the user is null
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Failed to register')));
        }
      }
    } catch (e) {
      // Catch any kind of exception here
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
