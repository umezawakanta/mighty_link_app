import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserProfilePage extends StatefulWidget {
  @override
  UserProfilePageState createState() => UserProfilePageState();
}

// DropdownMenuEntry labels and values for the first dropdown menu.
enum SexLabel {
  man('男性'),
  woman('女性');

  const SexLabel(this.label);
  final String label;
}

class UserProfilePageState extends State<UserProfilePage> {
  Map<String, dynamic>? userData;
  List<Map<String, dynamic>>? userRoles;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  SexLabel? selectedSex;

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
          // ユーザーデータが読み込まれた後にテキストフィールドを初期化
          _usernameController.text = userData?['username'] ?? '';
          _emailController.text = userData?['email'] ?? '';
          // 性別を初期化
          selectedSex = _getSexLabel(userData?['sex']);
        });
        print('Update success: $response');
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile Updated Successfully!')));
      }
    }
  }

  SexLabel? _getSexLabel(String? sexLabel) {
    switch (sexLabel) {
      case '男性':
        return SexLabel.man;
      case '女性':
        return SexLabel.woman;
      default:
        return null;
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
      'sex': selectedSex?.label, // 新しいフィールドを更新
      // 他のフィールドもここに追加
    }).eq('id', Supabase.instance.client.auth.currentUser!.id);
    if (response != null) {
      print('Update success: $response');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile Updated Successfully!')));
    } else {
      print('Update success: response　is null');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile Updated Successfully!')));
    }
  }

  String _calculateAge(String? birthdayString) {
    if (birthdayString != null) {
      DateTime birthday = DateTime.parse(birthdayString);
      DateTime currentDate = DateTime.now();
      int age = currentDate.year - birthday.year;
      if (currentDate.month < birthday.month ||
          (currentDate.month == birthday.month &&
              currentDate.day < birthday.day)) {
        age--;
      }
      return age.toString();
    } else {
      return 'N/A';
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController colorController = TextEditingController();
    // 画像を表示するWidget
    Widget _buildAvatar() {
      return userData!['avatar_url'] != null
          ? Image.network(
              userData!['avatar_url'],
              width: 400,
              height: 400,
              fit: BoxFit.cover,
            )
          : SizedBox(); // avatar_urlがnullの場合は何も表示しない
    }

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
                  _buildAvatar(), // ここに_buildAvatar()を追加
                  SizedBox(height: 10),
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
                  Text(
                      '誕生日: ${DateFormat('MM/dd/yyyy').format(DateTime.parse(userData!['birthday']))}',
                      style: TextStyle(fontSize: 20)),
                  SizedBox(height: 10),
                  Text('年齢: ${_calculateAge(userData!['birthday'])}',
                      style: TextStyle(fontSize: 20)),
                  SizedBox(height: 10),
                  DropdownMenu<SexLabel>(
                    initialSelection: selectedSex ?? SexLabel.man, // 初期選択項目を設定
                    controller: colorController,
                    // requestFocusOnTap is enabled/disabled by platforms when it is null.
                    // On mobile platforms, this is false by default. Setting this to true will
                    // trigger focus request on the text field and virtual keyboard will appear
                    // afterward. On desktop platforms however, this defaults to true.
                    requestFocusOnTap: true,
                    label: const Text('Sex'),
                    onSelected: (SexLabel? sex) {
                      setState(() {
                        selectedSex = sex;
                      });
                    },
                    dropdownMenuEntries: SexLabel.values
                        .map<DropdownMenuEntry<SexLabel>>((SexLabel sex) {
                      return DropdownMenuEntry<SexLabel>(
                        value: sex,
                        label: sex.label,
                        enabled: true,
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 10),
                  Text('有給休暇: ${userData!['payedvacation']}',
                      style: TextStyle(fontSize: 20)),
                  SizedBox(height: 10),
                  Text('default_channel_id: ${userData!['default_channel_id']}',
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
