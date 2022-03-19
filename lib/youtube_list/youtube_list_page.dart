import 'package:flutter/material.dart';
import 'package:my_youtube_indexer/youtube_list/youtube_list_model.dart';
import 'package:provider/provider.dart';

import '../player/player_page.dart';
import '../youtube_dialog/youtube_dialog.dart';

class YoutubeListPage extends StatelessWidget {
  const YoutubeListPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<YoutubeListModel>(
      // ListView.builder実行の前にここで、fetchIndex()をやっておく
      create: (_) => YoutubeListModel()..fetchVideoId(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('動画一覧'),
        ),
        body: Consumer<YoutubeListModel>(builder: (context, model, child) {
          return ListView.builder(
            shrinkWrap: true,
            //　TODO(me): youtubeのListを取得してその長さを入れる。
            itemCount: model.youtubeList.length,
            itemBuilder: (context, indexNumber) {
              final youtube = model.youtubeList[indexNumber];
              final videoId = youtube.videoId;
              return ListTile(
                leading: const Text('youtubeのサムネ'),
                title: Text('title: $videoId'),
                onTap: () {
                  // TODO(me): player_pageへ画面遷移、VideoIDをplayer_pageに渡す。
                  Navigator.push<Widget>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlayerPage(
                        youtube: youtube,
                      ),
                    ),
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
        floatingActionButton:
            Consumer<YoutubeListModel>(builder: (context, model, child) {
          return FloatingActionButton(
            onPressed: () async {
              // TODO(me): 動画のURLもしくはVideoIDを追加する処理
              // TODO(me): 追加したらSnackBarを表示。
              final videoId = await showDialog<String>(
                context: context,

                // ダイアログ表示時の背景をタップしたときにダイアログを閉じてよいかどうか
                barrierDismissible: false,

                // TODO(me): AlertDialogの見た目をよくしたい。
                builder: (BuildContext context) {
                  return const YoutubeDialog(
                    usersYoutubeActionState: UsersYoutubeActionState.add,
                  );
                },
              );
              // addedがtrue(つまり、indexが追加された時)ならSnackBarを表示する。
              if (videoId != null) {
                final snackBar = SnackBar(
                  backgroundColor: Colors.green,
                  content: Text('"$videoId"を追加しました！'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
              await model.fetchVideoId();
            },
            tooltip: '押したらyoutubeのURL入力ダイアログを表示',
            child: const Icon(Icons.add),
          );
        }),
      ),
    );
  }
}
