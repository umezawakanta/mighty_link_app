import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart'; // table_calendarパッケージをインポート

class BookingForm extends StatefulWidget {
  @override
  _BookingFormState createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  DateTime _selectedDate = DateTime.now(); // 日付選択のための状態変数
  CalendarFormat _calendarFormat = CalendarFormat.month; // カレンダーの形式

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
    return SingleChildScrollView(
      // スクロール可能にするためにSingleChildScrollViewを追加
      child: Form(
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
            TableCalendar(
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: _selectedDate,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                // 同じ日付が選択されたかどうかを判断
                return isSameDay(_selectedDate, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDate = selectedDay; // 選択した日付を更新
                  // focusedDayを更新して、選択した日付が常に中心に表示されるようにする
                });
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format; // カレンダーの形式を更新
                  });
                }
              },
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
      ),
    );
  }
}
