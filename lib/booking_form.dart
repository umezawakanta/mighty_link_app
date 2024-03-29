import 'package:flutter/material.dart';

class BookingForm extends StatefulWidget {
  @override
  _BookingFormState createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // フォームが有効な場合、ここで予約処理を実装できます。
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('予約が送信されました')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(labelText: '名前'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '名前を入力してください';
              }
              return null;
            },
            onSaved: (value) => _name = value!,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'メールアドレス'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'メールアドレスを入力してください';
              }
              return null;
            },
            onSaved: (value) => _email = value!,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: _submitForm,
              child: Text('予約する'),
            ),
          ),
        ],
      ),
    );
  }
}