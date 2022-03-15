import 'package:flutter/material.dart';
import 'package:my_youtube_indexer/youtube_list/youtube_list_model.dart';
import 'package:provider/provider.dart';

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
      body: ChangeNotifierProvider<YoutubeListModel>(
        create: (_) => YoutubeListModel()..fetchVideoId(),
        child: Consumer<YoutubeListModel>(builder: (context, model, child) {
          return ListView.builder(
            shrinkWrap: true,
            //　TODO(me): youtubeのListを取得してその長さを入れる。
            itemCount: model.youtubeList.length,
            itemBuilder: (context, indexNumber) {
              final videoID = model.youtubeList[indexNumber].videoId;
              return ListTile(
                leading: const Text('youtubeのサムネ'),
                title: Text('title: $videoID'),
                onTap: () {
                  // TODO(me): player_pageへ画面遷移、VideoIDをplayer_pageに渡す。
                  Navigator.push<Widget>(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PlayerPage(videoID)),
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
          );
        }),
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
