import 'package:flutter/material.dart';
import 'package:my_youtube_indexer/add_index/add_index_dialog.dart';
import 'package:my_youtube_indexer/player/player_model.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PlayerPage extends StatelessWidget {
  const PlayerPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PlayerModel>(
      // ListView.builder実行の前にここで、fetchIndex()をやっておく
      create: (_) => PlayerModel()..fetchIndex(),
      child: Consumer<PlayerModel>(
        builder: (context, model, child) {
          //Full screen対応のためのYoutubePlayerBuilder
          return YoutubePlayerBuilder(
            player: YoutubePlayer(
              controller: model.controller,
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.blueAccent,

              // TODO(me): onReadyを調べる。
              onReady: () {
                // TODO(me): 何かの処理。
              },
            ),
            builder: (context, player) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text('my_youtube_indexer'),
                ),
                body: Column(
                  children: [
                    // youtube_player_flutterのこと。
                    player,
                    // ListViewの部分
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: model.indexList.length,
                        itemBuilder: (context, index) {
                          final showIndexList = model.indexList;
                          // ListTileごとのtitle indexTitle
                          // TODO(): これをadd_index_dialogに渡して、更新の時にTextFieldに表示したい。
                          final indexTitle = showIndexList[index].index;
                          return ListTile(
                            leading: const Text('停止した時の\n動画のサムネ'),
                            title: Text('title: $indexTitle'),
                            subtitle: Text(
                              'currentPosition: '
                              '${Duration(
                                days: 0,
                                hours: 0,
                                minutes: 0,
                                seconds: 0,
                                milliseconds: 0,
                                microseconds:
                                    showIndexList[index].currentPosition,
                              )}',
                            ),
                            onTap: () {
                              // TODO(me): 再生時間から動画が再生される,
                            },
                            trailing: FittedBox(
                              fit: BoxFit.fill,
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      //　TODO(me): ボタンを押したらこのListTileが編集される操作
                                      //　TODO(me): ボタンタップでAddIndexDialogが表示
                                      //　TODO(me): index入力欄には選択されているListTileのtitleが入っている。
                                      //　TODO(me): ボタンのtextは更新の文字に変わる
                                      //　TODO(me): indexは編集されないと更新ボタンはグレーアウトでタップできない。
                                      //　TODO(me): indexが編集されると更新ボタンをタップしてFirestoreにデータが反映される。
                                      //　TODO(me): player_pageに戻るとListTileは更新されている。
                                      //　TODO(me): 更新のタイミングでSnackBar「indexは更新されました」と表示する。
                                      final currentPositionDisplayedInAddIndexDialog =
                                          model.currentPosition;
                                      final result = showDialog<String>(
                                        context: context,

                                        // ダイアログ表示時の背景をタップしたときにダイアログを閉じてよいかどうか
                                        barrierDismissible: false,

                                        // TODO(me): AlertDialogの見た目をよくしたい。
                                        builder: (BuildContext context) {
                                          return AddIndexDialog(
                                            currentPositionDisplayedInAddIndexDialog,
                                            indexTitle: indexTitle,
                                          );
                                        },
                                      );
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Icon(
                                        Icons.edit,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      //　TODO(me): ボタンを押したらこのListTileが削除される操作
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                floatingActionButton:
                    Consumer<PlayerModel>(builder: (context, model, child) {
                  return FloatingActionButton(
                    onPressed: () async {
                      // TODO(me): addIndexDialogから戻ってきたときに止めた時の状態のplayerを表示する。
                      // TODO(me): 画面遷移して戻ってきた時に同じ状態（リストとか停止している時間とか）にする。
                      model.getCurrentPosition();
                      final currentPositionDisplayedInAddIndexDialog =
                          model.currentPosition;

                      // showDialog<T> はダイアログの表示結果戻り値の型を指定
                      final result = await showDialog<String>(
                        context: context,

                        // ダイアログ表示時の背景をタップしたときにダイアログを閉じてよいかどうか
                        barrierDismissible: false,

                        // TODO(me): AlertDialogの見た目をよくしたい。
                        builder: (BuildContext context) {
                          return AddIndexDialog(
                              currentPositionDisplayedInAddIndexDialog);
                        },
                      );
                      print('dialog result: $result');
                      await model.fetchIndex();
                    },
                    tooltip: '押したら動画の現在時刻を取得して表示する',
                    child: const Icon(Icons.add),
                  );
                }),
              );
            },
          );
        },
      ),
    );
  }
}
