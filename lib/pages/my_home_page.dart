import 'package:flutter/material.dart';
import 'package:mighty_link_app/booking.dart';
import 'package:mighty_link_app/pages/booking_calendar.dart';
import 'package:mighty_link_app/pages/favorites_page.dart';
import 'package:mighty_link_app/pages/flutter_calendar_carousel.dart';
import 'package:mighty_link_app/pages/generator_page.dart';
import 'package:mighty_link_app/pages/greeting_page.dart';
import 'package:mighty_link_app/pages/site_map.dart';
import 'package:mighty_link_app/pages/weekly_forecast_list.dart';

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
        page = GreetingPage();
      case 1:
        page = SiteMap();
      case 2:
        page = GeneratorPage();
      case 3:
        page = FavoritesPage();
      case 4:
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
      case 5:
        page = Booking();
      case 6:
        page = BookingCalendar();
      case 7:
        page = FlutterCalendarCarousel();
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
                        icon: Icon(Icons.menu,
                            color: Colors.black), // アイコンを選択してください
                        label: 'Greeting',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home, color: Colors.black),
                        label: 'Home',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.abc, color: Colors.black),
                        label: 'Generator',
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
                        label: '予約フォーム',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.calendar_today, color: Colors.black),
                        label: 'TableCalender Example',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.calendar_today, color: Colors.black),
                        label: 'Flutter Calendar Carousel Example',
                      ),
                    ],
                    currentIndex: selectedIndex,
                    selectedItemColor: Colors.black, // 選択されたアイテムの色
                    unselectedItemColor: Colors.grey, // 選択されていないアイテムの色
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
                    selectedIndex: selectedIndex,
                    onDestinationSelected: (value) {
                      setState(() {
                        selectedIndex = value;
                      });
                    },
                    destinations: [
                      NavigationRailDestination(
                        icon: Icon(Icons.menu),
                        label: Text('Greeting'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.home),
                        label: Text('Home'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.abc),
                        label: Text('Generator'),
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
                        label: Text('予約フォーム'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.calendar_today),
                        label: Text('TableCalender'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.calendar_today),
                        label: Text('Flutter Calendar Carousel'),
                      ),
                    ],
                    selectedIconTheme: IconThemeData(color: Colors.black),
                    unselectedIconTheme: IconThemeData(color: Colors.grey),
                    selectedLabelTextStyle: TextStyle(color: Colors.black),
                    unselectedLabelTextStyle: TextStyle(color: Colors.grey),
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
