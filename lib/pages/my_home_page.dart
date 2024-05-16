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
import 'package:mighty_link_app/pages/typography_screen.dart';
import 'package:mighty_link_app/pages/user_profile_page.dart';
import 'package:mighty_link_app/pages/weekly_forecast_list.dart';
import 'package:mighty_link_app/screens/flashcard_screen.dart';
import 'package:mighty_link_app/screens/genre_screen.dart';
import 'package:mighty_link_app/scrolling_text.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;
  String appBarTitle = 'MightyLINK 古民家カフェ'; // AppBarのデフォルトタイトル
  Map<String, dynamic>? userData;
  List<Map<String, dynamic>>? userRoles;
  late Future<void> _userFetchFuture; // ユーザーデータとロールを取得するFuture

  @override
  void initState() {
    super.initState();
    // 認証状態のリッスンを設定
    Supabase.instance.client.auth.onAuthStateChange.listen((AuthState state) {
      if (state.event == AuthChangeEvent.signedIn && state.session != null) {
        setState(() {
          appBarTitle = 'MightyLINK 古民家カフェ お帰りなさい！';
        });
      } else {
        setState(() {
          selectedIndex = 0;
        });
        print("ログインしていません");
        // ログアウトまたは未ログインの場合、デフォルトのタイトルを表示
        setState(() {
          appBarTitle = 'MightyLINK 古民家カフェへようこそ';
        });
      }
    });
    // 初期のFutureをセットアップ（ログイン状態によっては何もしないかもしれない）
    _userFetchFuture = _fetchUserDataAndRoles();
  }

  Future<void> _fetchUserDataAndRoles() async {
    await _fetchUserData(); // ユーザーデータを取得
    await _fetchUserRoles(); // ユーザーロールを取得
  }

  Future<void> _fetchUserData() async {
    print('fetching user data');
    final user = Supabase.instance.client.auth.currentUser;
    print('user: $user');
    if (user != null) {
      final response = await Supabase.instance.client
          .from('users') // 'users' はユーザー情報を保存しているテーブル名
          .select() // ここで必要な列を指定できます。全ての列を取得する場合は '*' を使用します。
          .eq('id', user.id) // ログインユーザーのIDでフィルタリング
          .single(); // 単一のレコードを返します
      print('response: $response');
      if (response.isNotEmpty) {
        setState(() {
          userData = response;
        });
      }
    }
  }

  Future<void> _fetchUserRoles() async {
    print('fetching user Roles data');
    final user = Supabase.instance.client.auth.currentUser;
    print('user: $user');
    if (user != null) {
      final response =
          await Supabase.instance.client.from('user_roles').select();

      print('response: $response');
      if (response.isNotEmpty) {
        setState(() {
          userRoles = response;
        });
      }
    }
  }

  bool hasAdminRole() {
    if (userRoles == null) return false;
    return userRoles!.any((role) => role["role"] == "admin");
  }

  bool hasDeveloperRole() {
    if (userRoles == null) return false;
    return userRoles!.any((role) => role["role"] == "developer");
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    // Supabaseから現在の認証セッションを取得
    final session = Supabase.instance.client.auth.currentSession;
    Widget page;
    List<Map<String, dynamic>> getNavItems() {
      List<Map<String, dynamic>> allItems = [
        {"icon": Icons.menu, "label": "Greeting", "page": GreetingPage()},
        {"icon": Icons.home, "label": "Home", "page": SiteMap()},
        {
          "icon": Icons.abc,
          "label": "Generator",
          "page": GeneratorPage(),
          "requiresLogin": true,
          "requiresDeveloperRole": true
        },
        {
          "icon": Icons.favorite,
          "label": "Favorites",
          "page": FavoritesPage(),
          "requiresLogin": true,
          "requiresDeveloperRole": true
        },
        {
          "icon": Icons.filter_drama,
          "label": "天気予報",
          "page": CustomScrollView(
            slivers: <Widget>[
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
            ],
          ),
          "requiresLogin": true,
          "requiresDeveloperRole": true
        },
        {
          "icon": Icons.event,
          "label": "予約フォーム",
          "page": Booking(),
        },
        {
          "icon": Icons.calendar_today,
          "label": "TableCalender",
          "page": BookingCalendar(),
          "requiresLogin": true,
          "requiresDeveloperRole": true
        },
        {
          "icon": Icons.calendar_today,
          "label": "Flutter Calendar Carousel",
          "page": FlutterCalendarCarousel(),
          "requiresLogin": true,
          "requiresDeveloperRole": true
        },
        {
          "icon": Icons.text_snippet_outlined,
          "label": "Typography",
          "page": TypographyScreen(),
          "requiresLogin": true,
          "requiresDeveloperRole": true
        },
        {
          "icon": Icons.quiz_outlined,
          "label": "Flashcardクイズ",
          "page": GenreScreen(),
          "requiresLogin": true,
          "requiresDeveloperRole": true
        },
        {
          "icon": Icons.people,
          "label": "ユーザー情報",
          "page": UserProfilePage(),
          "requiresLogin": true
        },
      ];

      // ログインしている場合はすべての項目を、そうでない場合はrequiresLoginがfalseまたは未設定の項目のみを返す
      // 加えて、developerロールが必要な項目はhasDeveloperRole()の結果に基づいてフィルタリング
      return session != null
          ? allItems.where((item) {
              final requiresDeveloperRole =
                  item["requiresDeveloperRole"] ?? false;
              return !requiresDeveloperRole ||
                  (requiresDeveloperRole && hasDeveloperRole());
            }).toList()
          : allItems.where((item) => item["requiresLogin"] != true).toList();
    }

    List<Widget> appBarActions = [];
    // ユーザーがログインしていない場合のみ、「ログイン」と「会員登録」ボタンを表示
    if (session == null) {
      appBarActions.addAll([
        TextButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => Dialog(
                child: SizedBox(
                  width: 300,
                  height: 400,
                  child: LoginPage(),
                ),
              ),
            );
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.teal[700], // ボタンの背景色
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
            foregroundColor: Colors.white,
            backgroundColor: Colors.teal[700], // ボタンの背景色
          ),
          child: Tooltip(
            message: '会員登録をして特典を得る', // ここにツールチップのテキストを設定
            child: Text('会員登録（無料）'),
          ),
        ),
      ]);
    } else {
      // ユーザーがログインしている場合、ログアウトボタンとユーザー名を表示
      appBarActions.addAll([
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Center(
            child: Text(
              userData != null
                  ? 'ログインユーザー: ${userData!['lastname']} ${userData!['firstname']}'
                  : 'ログインユーザー:',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        TextButton(
          onPressed: () async {
            await Supabase.instance.client.auth.signOut();
            // ログアウト後の処理
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.teal[700], // ボタンの背景色
          ),
          child: Text('ログアウト'),
        ),
      ]);
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

    List<BottomNavigationBarItem> buildBottomNavigationBarItems() {
      var items = getNavItems();
      return items.map((item) {
        return BottomNavigationBarItem(
          icon: Icon(item['icon']),
          label: item['label'],
        );
      }).toList();
    }

    List<NavigationRailDestination> buildNavigationRailDestinations() {
      var items = getNavItems();
      return items.map((item) {
        return NavigationRailDestination(
          icon: Icon(item['icon']),
          label: Text(item['label']),
        );
      }).toList();
    }

    return FutureBuilder(
        future: _userFetchFuture, // initStateで定義したFutureを使用
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // データの取得中はローディングインジケータを表示
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            // エラーが発生した場合はエラーメッセージを表示
            return Text('Error: ${snapshot.error}');
          } else {
            // データの取得が完了したら、アプリのメイン画面を表示
            var navItems = getNavItems();
            page = navItems[selectedIndex]["page"];

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
                            items: buildBottomNavigationBarItems(),
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
                            destinations: buildNavigationRailDestinations(),
                            selectedIconTheme:
                                IconThemeData(color: Colors.black),
                            unselectedIconTheme:
                                IconThemeData(color: Colors.grey),
                            selectedLabelTextStyle:
                                TextStyle(color: Colors.black),
                            unselectedLabelTextStyle:
                                TextStyle(color: Colors.grey),
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
        });
  }
}
