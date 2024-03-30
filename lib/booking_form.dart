import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingForm extends StatefulWidget {
  @override
  _BookingFormState createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  DateTime _selectedDate = DateTime.now(); // 日付選択のための状態変数

  void _submitForm() {
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      form.save(); // ここで onSaved コールバックが呼ばれ、_name と _email に値が保存されます。

      // フォームが有効な場合、ここで予約処理を実装できます。
      // 予約日を含めて送信します。
      print('名前: $_name');
      print('メールアドレス: $_email');
      print('選択された日付: ${DateFormat('yyyy年MM月dd日').format(_selectedDate)}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                '予約が送信されました: 名前: $_name, メール: $_email, 日付: ${DateFormat('yyyy年MM月dd日').format(_selectedDate)}')),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
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
              onPressed: () => _selectDate(context),
              child: Text(
                  '日付を選択: ${DateFormat('yyyy年MM月dd日').format(_selectedDate)}'),
            ),
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
