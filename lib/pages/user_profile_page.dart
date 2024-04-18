import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  Map<String, dynamic>? userData;
  List<Map<String, dynamic>>? userRoles;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _fetchUserRoles();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
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

  Future<void> _updateUserData() async {
    final response = await Supabase.instance.client.from('users').update({
      'username': _usernameController.text,
      'email': _emailController.text,
      // 他のフィールドもここに追加
    }).eq('id', Supabase.instance.client.auth.currentUser!.id);
    if (response != null) {
      print('Update success: $response');
    }
  }

  @override
  Widget build(BuildContext context) {
    // ユーザーデータが読み込まれた後にテキストフィールドを初期化
    _usernameController.text = userData?['username'] ?? '';
    _emailController.text = userData?['email'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: userData == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16),
              child: ListView(
                children: [
                  Text('ID: ${userData!['id']}',
                      style: TextStyle(fontSize: 20)),
                  SizedBox(height: 10),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(labelText: 'Username'),
                  ),
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
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
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
                      : Text('No roles found'),
                  // 他のユーザー情報もここに表示できます。
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _updateUserData,
                    child: Text('Update Profile'),
                  ),
                ],
              ),
            ),
    );
  }
}
