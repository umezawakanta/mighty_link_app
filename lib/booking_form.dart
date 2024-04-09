import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
  // カレンダーイベントの状態
  Map<DateTime, List<dynamic>> _eventsMap = {};

  @override
  void initState() {
    super.initState();
    _fetchReservations(); // 予約データをフェッチ
  }

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

  // Supabaseクライアントを初期化
  final supabaseClient = Supabase.instance.client;

  // Supabaseから予約データを非同期で取得する関数
  Future<void> _fetchReservations() async {
    final response = await supabaseClient
        .from('reservations')
        .select()
        .order('date', ascending: true);

    print('response: $response');
    if (response.isNotEmpty) {
      final data = response as List<dynamic>;
      Map<DateTime, List<dynamic>> eventsMap = {};
      for (var reservation in data) {
        final date = DateTime.parse(reservation['date']);
        if (!eventsMap.containsKey(date)) {
          eventsMap[date] = [];
        }
        eventsMap[date]!.add(reservation); // 名前をリストに追加
      }
      setState(() {
        _eventsMap = eventsMap;
      });
    } else {
      print('Error fetching reservations: $response');
      throw response;
    }
  }

  Widget _buildEventsMarker(DateTime date, List<dynamic> events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.blue[400],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  void _showEventDetailsDialog(DateTime date, List<dynamic> events) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('イベント詳細 (${DateFormat('yyyy年MM月dd日').format(date)})'),
          content: SingleChildScrollView(
            child: ListBody(
              children: events.map((event) {
                // イベント詳細を取得して表示
                String name = event['name'] ?? '不明なイベント';
                String time = event['time'] ?? '時間不明';
                String count = event['count'].toString();
                return ListTile(
                  title: Text('$name 様'),
                  subtitle: Text('時間: $time ~ / 人数: $count 名様'),
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('閉じる'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            // 予約追加・編集のオプションを追加する処理を実装
          ],
        );
      },
    );
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
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  if (events.isNotEmpty) {
                    return Positioned(
                      right: 1,
                      bottom: 1,
                      child: _buildEventsMarker(date, events),
                    );
                  }
                  return null;
                },
              ),
              eventLoader: (date) {
                // Supabaseから取得したUTCの日付をローカルタイムゾーンに変換
                final localDate = date.toLocal();
                // 日付のみの部分を取得（時間を切り捨てる）
                final dateWithoutTime =
                    DateTime(localDate.year, localDate.month, localDate.day);
                return _eventsMap[dateWithoutTime] ?? [];
              },
              selectedDayPredicate: (day) {
                // 同じ日付が選択されたかどうかを判断
                return isSameDay(_selectedDate, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                // Supabaseから取得したUTCの日付をローカルタイムゾーンに変換
                final localDate = selectedDay.toLocal();
                // 日付のみの部分を取得（時間を切り捨てる）
                final dateWithoutTime =
                    DateTime(localDate.year, localDate.month, localDate.day);
                print('dateWithoutTime : $dateWithoutTime');
                if (_eventsMap[dateWithoutTime] != null) {
                  _showEventDetailsDialog(
                      dateWithoutTime, _eventsMap[dateWithoutTime]!);
                }
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
