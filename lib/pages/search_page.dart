import 'package:flutter/material.dart';

class SearchPage extends SearchDelegate<String> {
  final List<String> data = ['Hello', 'World', 'Flutter', 'Search', 'Example'];

  @override
  List<Widget> buildActions(BuildContext context) {
    // 検索バーの右側に表示されるアクション（例：クリアボタン）
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = ''; // 検索クエリをクリア
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // 検索バーの左側に表示されるウィジェット（例：戻るボタン）
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, ''); // 検索ページを閉じる
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // 検索結果を表示するウィジェット
    final results = data.where((element) => element.toLowerCase().contains(query.toLowerCase())).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(results[index]),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // 検索候補を表示するウィジェット
    final suggestions = data.where((element) => element.toLowerCase().startsWith(query.toLowerCase())).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestions[index]),
          onTap: () {
            query = suggestions[index]; // タップした候補で検索クエリを更新
            showResults(context); // 検索結果を表示
          },
        );
      },
    );
  }
}
