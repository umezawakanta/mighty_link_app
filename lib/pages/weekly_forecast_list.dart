import 'package:flutter/material.dart';

class WeeklyForecastList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final DateTime currentDate = DateTime.now();
    final TextTheme textTheme = Theme.of(context).textTheme;

    // TODO:Convert this to a SliverList
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Card(
            child: Row(
              children: <Widget>[
                SizedBox(
                  height: 200.0,
                  width: 200.0,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      DecoratedBox(
                        position: DecorationPosition.foreground,
                        decoration: BoxDecoration(
                          gradient: RadialGradient(colors: <Color>[
                            Colors.grey[800]!,
                            Colors.transparent,
                          ]),
                        ),
                        child: Image.network(
                          'https://picsum.photos/200/200?random=$index',
                          fit: BoxFit.cover,
                          width: 200.0,
                          height: 200.0,
                        ),
                      ),
                      Center(
                        child: Text(
                          currentDate
                              .add(Duration(days: index))
                              .toLocal()
                              .toString(),
                          style: textTheme.headlineMedium,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          currentDate
                              .add(Duration(days: index))
                              .toLocal()
                              .toString(),
                          style: textTheme.titleLarge,
                        ),
                        Text('Rainy'),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.wb_sunny),
                ),
              ],
            ),
          );
        },
        childCount: 7,
      ),
    );
  }
}
