// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:english_words/english_words.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mighty_link_app/big_card.dart';
import 'package:mighty_link_app/booking.dart';
import 'package:mighty_link_app/booking_calender.dart';
import 'package:mighty_link_app/favorites_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'MightyLINK App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
          primarySwatch: Colors.purple,
          buttonTheme: const ButtonThemeData(
            textTheme: ButtonTextTheme.primary,
          ),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  var history = <WordPair>[];

  GlobalKey? historyListKey;

  void getNext() {
    history.insert(0, current);
    var animatedList = historyListKey?.currentState as AnimatedListState?;
    animatedList?.insertItem(0);
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void toggleFavorite([WordPair? pair]) {
    pair = pair ?? current;
    if (favorites.contains(pair)) {
      favorites.remove(pair);
    } else {
      favorites.add(pair);
    }
    notifyListeners();
  }

  void removeFavorite(WordPair pair) {
    favorites.remove(pair);
    notifyListeners();
  }
}

class Kitten {
  const Kitten(this.name, this.description, this.age, this.imageUrl);

  final String name;
  final String description;
  final int age;
  final String imageUrl;
}

final String server =
    defaultTargetPlatform == TargetPlatform.android ? "10.0.2.2" : "localhost";

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
      case 1:
        page = FavoritesPage();
      case 2:
        page = CustomScrollView(slivers: <Widget>[
          SliverAppBar(
              pinned: true,
              stretch: true,
              onStretchTrigger: () async {
                print('stretch');
              },
              backgroundColor: Colors.teal[800],
              // floating: true,
              // snap: true,
              expandedHeight: 200.0,
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: <StretchMode>[
                  StretchMode.zoomBackground,
                  StretchMode.blurBackground,
                  StretchMode.fadeTitle,
                ],
                title: Text('Weekly Forecast'),
                background: DecoratedBox(
                  position: DecorationPosition.foreground,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.center,
                      colors: <Color>[
                        Colors.teal[800]!,
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Image.network(
                    'https://picsum.photos/200/200?random=1',
                    fit: BoxFit.cover,
                  ),
                ),
              )),
          WeeklyForecastList(),
        ]);
      case 3:
        page = Booking();
      case 4:
        page = BookingCalender();
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    // The container for the current page, with its background color
    // and subtle switching animation.
    var mainArea = ColoredBox(
      color: colorScheme.surfaceVariant,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        child: page,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('MightyLINK App'),
        backgroundColor: Colors.teal[800],
      ),
      // TODO: Add a CustomScrollView
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 450) {
            // Use a more mobile-friendly layout with BottomNavigationBar
            // on narrow screens.
            return Column(
              children: [
                Expanded(child: mainArea),
                SafeArea(
                  child: BottomNavigationBar(
                    items: [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home, color: Colors.black),
                        label: 'Home',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.favorite, color: Colors.black),
                        label: 'Favorites',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.filter_drama, color: Colors.black),
                        label: '天気予報',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.event, color: Colors.black),
                        label: '予約',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.calendar_today, color: Colors.black),
                        label: '予約カレンダー',
                      ),
                    ],
                    currentIndex: selectedIndex,
                    onTap: (value) {
                      setState(() {
                        selectedIndex = value;
                      });
                    },
                  ),
                )
              ],
            );
          } else {
            return Row(
              children: [
                SafeArea(
                  child: NavigationRail(
                    extended: constraints.maxWidth >= 600,
                    destinations: [
                      NavigationRailDestination(
                        icon: Icon(Icons.home),
                        label: Text('Home'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.favorite),
                        label: Text('Favorites'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.filter_drama),
                        label: Text('天気予報'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.event),
                        label: Text('予約'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.calendar_today),
                        label: Text('予約カレンダー'),
                      ),
                    ],
                    selectedIndex: selectedIndex,
                    onDestinationSelected: (value) {
                      setState(() {
                        selectedIndex = value;
                      });
                    },
                  ),
                ),
                Expanded(child: mainArea),
              ],
            );
          }
        },
      ),
    );
  }
}

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
                    style: localTheme.textTheme.subtitle1?.copyWith(
                      fontStyle: FontStyle.italic,
                    )),
                SizedBox(height: 16),
                Text(
                  'description goes here.',
                  style: localTheme.textTheme.bodyText2,
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

class HistoryListView extends StatefulWidget {
  const HistoryListView({Key? key}) : super(key: key);

  @override
  State<HistoryListView> createState() => _HistoryListViewState();
}

class _HistoryListViewState extends State<HistoryListView> {
  /// Needed so that [MyAppState] can tell [AnimatedList] below to animate
  /// new items.
  final _key = GlobalKey();

  /// Used to "fade out" the history items at the top, to suggest continuation.
  static const Gradient _maskingGradient = LinearGradient(
    // This gradient goes from fully transparent to fully opaque black...
    colors: [Colors.transparent, Colors.black],
    // ... from the top (transparent) to half (0.5) of the way to the bottom.
    stops: [0.0, 0.5],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    appState.historyListKey = _key;

    return ShaderMask(
      shaderCallback: (bounds) => _maskingGradient.createShader(bounds),
      // This blend mode takes the opacity of the shader (i.e. our gradient)
      // and applies it to the destination (i.e. our animated list).
      blendMode: BlendMode.dstIn,
      child: AnimatedList(
        key: _key,
        reverse: true,
        padding: EdgeInsets.only(top: 100),
        initialItemCount: appState.history.length,
        itemBuilder: (context, index, animation) {
          final pair = appState.history[index];
          return SizeTransition(
            sizeFactor: animation,
            child: Center(
              child: TextButton.icon(
                onPressed: () {
                  appState.toggleFavorite(pair);
                },
                icon: appState.favorites.contains(pair)
                    ? Icon(Icons.favorite, size: 12)
                    : SizedBox(),
                label: Text(
                  pair.asLowerCase,
                  semanticsLabel: pair.asPascalCase,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

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
                          style: textTheme.headline4,
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
                          style: textTheme.headline6,
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
