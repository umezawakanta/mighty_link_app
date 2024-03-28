import 'package:flutter/material.dart';

class BookingCalender extends StatefulWidget {
  @override
  _BookingCalenderState createState() => _BookingCalenderState();
}

class _BookingCalenderState extends State<BookingCalender> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TableCalendar Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20.0),
            ElevatedButton(
              child: Text('Basics'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TableBasicsExample()),
              ),
            ),
            const SizedBox(height: 12.0),
            ElevatedButton(
              child: Text('Range Selection'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TableRangeExample()),
              ),
            ),
            const SizedBox(height: 12.0),
            ElevatedButton(
              child: Text('Events'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TableEventsExample()),
              ),
            ),
            const SizedBox(height: 12.0),
            ElevatedButton(
              child: Text('Multiple Selection'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TableMultiExample()),
              ),
            ),
            const SizedBox(height: 12.0),
            ElevatedButton(
              child: Text('Complex'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TableComplexExample()),
              ),
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}

class TableComplexExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class TableMultiExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  } 
}

class TableEventsExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class TableRangeExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  } 
}

class TableBasicsExample extends StatefulWidget {
  @override
  _TableBasicsExampleState createState() => _TableBasicsExampleState();
}

class _TableBasicsExampleState extends State<TableBasicsExample> {
  get kFirstDay => null;
  
  get kLastDay => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TableCalendar - Basics'),
      ),
      body: TableCalendar(
        firstDay: kFirstDay,
        lastDay: kLastDay,
        focusedDay: DateTime.now(),
      ),
    );
  }
}

class TableCalendar extends StatelessWidget {
  final DateTime firstDay;
  final DateTime lastDay;
  final DateTime focusedDay;

  const TableCalendar({
    Key? key,
    required this.firstDay,
    required this.lastDay,
    required this.focusedDay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}