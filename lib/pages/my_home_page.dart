import 'package:flutter/material.dart';
import 'package:mighty_link_app/booking.dart';
import 'package:mighty_link_app/pages/booking_calendar.dart';
import 'package:mighty_link_app/pages/favorites_page.dart';
import 'package:mighty_link_app/pages/flutter_calendar_carousel.dart';
import 'package:mighty_link_app/pages/generator_page.dart';
import 'package:mighty_link_app/pages/greeting_page.dart';
import 'package:mighty_link_app/pages/login_page.dart';
import 'package:mighty_link_app/pages/search_page.dart';
import 'package:mighty_link_app/pages/sign_up_page.dart';
import 'package:mighty_link_app/pages/site_map.dart';
import 'package:mighty_link_app/pages/weekly_forecast_list.dart';
import 'package:mighty_link_app/scrolling_text.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;
  String appBarTitle = 'MightyLINK 古民家カフェ'; // AppBarのデフォルトタイトル

  @override
  void initState() {
    super.initState();
    // 認証状態のリッスンを設定
    Supabase.instance.client.auth.onAuthStateChange.listen((AuthState state) {
      if (state.event == AuthChangeEvent.signedIn && state.session != null) {
        print(state.session!.user.email);
        // ログインしている場合、AppBarにユーザー名を表示
        setState(() {
          appBarTitle =
              'MightyLINK 古民家カフェ ログインユーザー： ${state.session!.user.email}'; // メールアドレスまたはユーザー名を表示
        });
      } else {
        print("ログインしていません");
        // ログアウトまたは未ログインの場合、デフォルトのタイトルを表示
        setState(() {
          appBarTitle = 'MightyLINK 古民家カフェ';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    // Supabaseから現在の認証セッションを取得
    final session = Supabase.instance.client.auth.currentSession;
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

    Future<void> _navigateAndLogin(BuildContext context) async {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
      if (result == true) {
        // ログインが成功した場合の処理をここに記述します。
        print("Logged in successfully.");
      }
    }

    List<Widget> appBarActions = [];
    // ユーザーがログインしていない場合のみ、「ログイン」と「会員登録」ボタンを表示
    if (session == null) {
      appBarActions.addAll([
        TextButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => LoginPage()));
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Colors.teal[700], // ボタンの背景色
          ),
          child: Text('ログイン'),
        ),
        SizedBox(width: 8), // ボタン間のスペース
        TextButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => SignUpPage()));
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Colors.teal[700], // ボタンの背景色
          ),
          child: Text('会員登録（無料）'),
        ),
      ]);
    } else {
      // ユーザーがログインしている場合にのみログアウトボタンを表示
      appBarActions.add(
        TextButton(
          onPressed: () async {
            await Supabase.instance.client.auth.signOut();
            // 任意の処理、例えばトップページに戻るなどをここに追加
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Colors.teal[700], // ボタンの背景色
          ),
          child: Text('ログアウト'),
        ),
      );
    }
    // 全ユーザーに表示するアクションを追加
    appBarActions.add(
      IconButton(
        icon: Icon(Icons.search),
        onPressed: () {
          showSearch(context: context, delegate: SearchPage());
        },
      ),
    );
    print(appBarActions.length);
    return Scaffold(
      appBar: AppBar(
          title: ScrollingText(
              text: appBarTitle, style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.teal[100],
          actions: appBarActions),
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
