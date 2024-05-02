import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:table_calendar/table_calendar.dart'; // table_calendarパッケージをインポート

class BookingForm extends StatefulWidget {
  @override
  BookingFormState createState() => BookingFormState();
}

enum CalendarView { month, twoWeeks, week }

class BookingFormState extends State<BookingForm> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  String _phoneNumber = ''; // 電話番号の状態を追加
  DateTime _selectedDate = DateTime.now(); // 日付選択のための状態変数
  TimeOfDay? _time; // 時間入力用の状態変数
  int _count = 1; // 人数入力用の状態変数
  CalendarFormat _calendarFormat = CalendarFormat.month; // カレンダーの形式
  CalendarView calendarView = CalendarView.month;
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
      print('電話番号: $_phoneNumber');
      print('選択された日付: ${DateFormat('yyyy年MM月dd日').format(_selectedDate)}');
      // フォームが有効な場合、Supabaseにデータを送信
      _addReservation(
          _name, _email, _phoneNumber, _selectedDate, _time, _count);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              '予約が送信されました: 名前: $_name, メール: $_email, 電話番号: $_phoneNumber, 人数: $_count, 日付: ${DateFormat('yyyy年MM月dd日').format(_selectedDate)}, 時間: ${_time?.format(context) ?? '未定'}')));
    }
  }

// 予約をSupabaseに送信する処理
  Future<void> _addReservation(String name, String email, String phonenumber,
      DateTime date, TimeOfDay? time, int count) async {
    final response = await supabaseClient.from('reservations').insert({
      'name': name,
      'date': DateFormat('yyyy-MM-dd').format(date),
      'time': time != null ? '${time.hour}:${time.minute}' : '未定',
      'count': count,
      'email': email,
      'phonenumber': phonenumber,
    });

    print('response: $response');
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

  // 時間を選択するためのメソッド
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _time = pickedTime;
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
                String phonenumber = event['phonenumber'] ?? '電話番号不明';
                return ListTile(
                  title: Text('$name 様 電話番号: $phonenumber'),
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
            TableCalendar(
              // カレンダーの設定
              calendarFormat: calendarView == CalendarView.month
                  ? CalendarFormat.month
                  : calendarView == CalendarView.week
                      ? CalendarFormat.week
                      : CalendarFormat.twoWeeks,
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: _selectedDate,
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
            SegmentedButton<CalendarView>(
              style: SegmentedButton.styleFrom(
                backgroundColor: Colors.grey[200],
                foregroundColor: Colors.red,
                selectedForegroundColor: Colors.white,
                selectedBackgroundColor: Colors.green,
              ),
              segments: const <ButtonSegment<CalendarView>>[
                ButtonSegment<CalendarView>(
                    value: CalendarView.month,
                    label: Text('Month'),
                    icon: Icon(Icons.calendar_view_month)),
                ButtonSegment<CalendarView>(
                    value: CalendarView.twoWeeks,
                    label: Text('2 Weeks'),
                    icon: Icon(Icons.calendar_view_week_sharp)),
                ButtonSegment<CalendarView>(
                    value: CalendarView.week,
                    label: Text('Week'),
                    icon: Icon(Icons.calendar_view_week)),
              ],
              selected: <CalendarView>{calendarView},
              onSelectionChanged: (Set<CalendarView> newSelection) {
                setState(() {
                  calendarView = newSelection.first;
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: '名前',
                prefixIcon: Icon(Icons.person), // 名前入力フィールドのアイコン
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '名前を入力してください';
                }
                return null;
              },
              onSaved: (value) => _name = value!,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'メールアドレス',
                prefixIcon: Icon(Icons.email), // メールアドレス入力フィールドのアイコン
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'メールアドレスを入力してください';
                }
                return null;
              },
              onSaved: (value) => _email = value!,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: '電話番号',
                prefixIcon: Icon(Icons.phone), // 電話番号入力フィールドのアイコン
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value!.isEmpty ||
                    !RegExp(r'^[0-9+\(\)#\.\s\/ext-]+$').hasMatch(value)) {
                  return '有効な電話番号を入力してください';
                }
                return null;
              },
              onSaved: (value) => _phoneNumber = value!,
            ),
            // 人数入力用のTextFormFieldを追加
            TextFormField(
              decoration: InputDecoration(
                labelText: '人数',
                prefixIcon: Icon(Icons.group), // 人数入力フィールドのアイコン
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    int.tryParse(value) == null) {
                  return '正しい人数を入力してください';
                }
                return null;
              },
              onSaved: (value) => _count = int.parse(value!),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton.icon(
                onPressed: () => _selectDate(context),
                icon: Icon(Icons.calendar_today), // 日付選択ボタンのアイコン
                label: Text(
                    '日付を選択: ${DateFormat('yyyy年MM月dd日').format(_selectedDate)}'),
              ),
            ),
            // 時間選択用のボタンを追加
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton.icon(
                onPressed: () => _selectTime(context),
                icon: Icon(Icons.access_time), // 時間選択ボタンのアイコン
                label: Text(
                    _time == null ? '時間を選択' : '時間: ${_time!.format(context)}'),
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
