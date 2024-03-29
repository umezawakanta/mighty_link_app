import 'package:flutter/material.dart';
import 'package:mighty_link_app/big_card.dart';
import 'package:mighty_link_app/history_list_view.dart';
import 'package:mighty_link_app/main.dart';
import 'package:provider/provider.dart';

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    Widget _dialogBuilder(BuildContext context) {
      ThemeData localTheme = Theme.of(context);

      return SimpleDialog(
        contentPadding: EdgeInsets.zero,
        children: [
          Image.network('https://picsum.photos/200/200?random=1',
              fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'This is a dialog. Put your stuff here.',
                  style: localTheme.textTheme.displayLarge,
                ),
                Text('testing 1234',
                    style: localTheme.textTheme.titleMedium?.copyWith(
                      fontStyle: FontStyle.italic,
                    )),
                SizedBox(height: 16),
                Text(
                  'description goes here.',
                  style: localTheme.textTheme.bodyMedium,
                ),
                SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: Wrap(children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('I\'M ALLERGIC'),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('SEND HELP'),
                    ),
                  ]),
                )
              ],
            ),
          ),
        ],
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: HistoryListView(),
          ),
          SizedBox(height: 10),
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => showDialog(
                    context: context,
                    builder: (context) => _dialogBuilder(context)),
                child: Text('Dialog'),
              ),
            ],
          ),
          Spacer(flex: 2),
        ],
      ),
    );
  }
}