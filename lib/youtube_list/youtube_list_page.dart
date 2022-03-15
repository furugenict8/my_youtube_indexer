import 'package:flutter/material.dart';

import '../player/player_page.dart';

class YoutubeListPage extends StatelessWidget {
  const YoutubeListPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('動画一覧'),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        //　TODO(me): youtubeのListを取得してその長さを入れる。
        itemCount: 3,
        itemBuilder: (context, indexNumber) {
          return ListTile(
            leading: const Text('youtubeのサムネ'),
            title: Text('title:  動画のタイトル'),
            onTap: () {
              // TODO(me): player_pageへ画面遷移、VideoIDをplayer_pageに渡す。
              Navigator.push<Widget>(
                context,
                MaterialPageRoute(builder: (context) => PlayerPage(videoID)),
              );
            },
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                // TODO(me): 削除確認ダイアログを表示。
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO(me): 動画のURLもしくはVideoIDを追加する処理
          // TODO(me): 追加したらSnackBarを表示。
        },
        tooltip: '押したらyoutubeのURL入力ダイアログを表示',
        child: const Icon(Icons.add),
      ),
    );
  }
}

String videoID = 'nPt8bK2gbaU';
