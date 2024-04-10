import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  Map<String, dynamic>? userData;
  List<Map<String, dynamic>>? userRoles;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _fetchUserRoles();
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
    if (user != null) 
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: userData == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ID: ${userData!['id']}',
                      style: TextStyle(fontSize: 20)),
                  SizedBox(height: 10),
                  Text('UserName: ${userData!['username']}',
                      style: TextStyle(fontSize: 20)),
                  SizedBox(height: 10),
                  Text('Status: ${userData!['status']}',
                      style: TextStyle(fontSize: 20)),
                  SizedBox(height: 10),
                  Text('LastName: ${userData!['lastname']}',
                      style: TextStyle(fontSize: 20)),
                  SizedBox(height: 10),
                  Text('FirstName: ${userData!['firstname']}',
                      style: TextStyle(fontSize: 20)),
                  SizedBox(height: 10),
                  Text('Email: ${userData!['email']}',
                      style: TextStyle(fontSize: 20)),
                  SizedBox(height: 10),
                  Text('Age: ${userData!['age']}',
                      style: TextStyle(fontSize: 20)),
                  SizedBox(height: 10),
                  Text('payedvacation: ${userData!['payedvacation']}',
                      style: TextStyle(fontSize: 20)),
                  SizedBox(height: 10),
                  Text('default_channel_id: ${userData!['default_channel_id']}',
                      style: TextStyle(fontSize: 20)),
                  SizedBox(height: 10),
                  Text('avatar_url: ${userData!['avatar_url']}',
                      style: TextStyle(fontSize: 20)),
                  SizedBox(height: 10),
                  Text('peer_id: ${userData!['peer_id']}',
                      style: TextStyle(fontSize: 20)),
                  SizedBox(height: 10),
                  Text('userRoles: ', style: TextStyle(fontSize: 20)),
                  userRoles != null
                      ? Column(
                          children: userRoles!.map<Widget>((role) {
                            return ListTile(
                              title: Text(role['role'] ?? 'No Name'),
                            );
                          }).toList(),
                        )
                      : Text('No roles found')
                  // 他のユーザー情報もここに表示できます。
                ],
              ),
            ),
    );
  }
}
