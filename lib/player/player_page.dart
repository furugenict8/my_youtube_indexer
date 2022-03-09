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
                        itemBuilder: (context, indexNumber) {
                          final indexList = model.indexList;
                          // ListTileごとのtitle indexTitle
                          // TODO(): これをadd_index_dialogに渡して、更新の時にTextFieldに表示したい。
                          final indexTitle = indexList[indexNumber].indexTitle;
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
                                    indexList[indexNumber].currentPosition,
                              )}',
                            ),
                            onTap: () {
                              // TODO(me): 再生時間から動画が再生される,
                            },
                            trailing: FittedBox(
                              fit: BoxFit.fill,
                              child: Row(
                                children: [
                                  //　編集ボタン
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () async {
                                      final currentPositionDisplayedInAddIndexDialog =
                                          model.currentPosition;

                                      // Navigator.pop(model.indexTitle)をindexTitleで受け取る
                                      final indexTitle =
                                          await showDialog<String>(
                                        context: context,

                                        // ダイアログ表示時の背景をタップしたときにダイアログを閉じてよいかどうか
                                        barrierDismissible: false,

                                        // TODO(me): AlertDialogの見た目をよくしたい。
                                        builder: (BuildContext context) {
                                          return AddIndexDialog(
                                            UsersActionState.update,
                                            currentPositionDisplayedInAddIndexDialog:
                                                currentPositionDisplayedInAddIndexDialog,
                                            index: indexList[indexNumber],
                                          );
                                        },
                                      );

                                      // showSnackBarの返り値indexTitleがあれば、SnackBarを表示。
                                      if (indexTitle != null) {
                                        final snackBar = SnackBar(
                                          backgroundColor: Colors.green,
                                          content:
                                              Text('"$indexTitle"を更新しました！'),
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      }
                                      await model.fetchIndex();
                                    },
                                  ),
                                  // TODO(me): 削除もIcomButton使って実装する。

                                  // 削除ボタン
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () async {
                                      // Navigator.pop(model.deletedIndexTitle)をdeletedIndexTitleで受け取る
                                      final deletedIndexTitle =
                                          await showDialog<String>(
                                        context: context,

                                        // ダイアログ表示時の背景をタップしたときにダイアログを閉じてよいかどうか
                                        barrierDismissible: false,

                                        // TODO(me): AlertDialogの見た目をよくしたい。
                                        builder: (BuildContext context) {
                                          return AddIndexDialog(
                                            UsersActionState.delete,
                                            index: indexList[indexNumber],
                                          );
                                        },
                                      );

                                      // showSnackBarの返り値indexTitleがあれば、SnackBarを表示。
                                      if (deletedIndexTitle != null) {
                                        final snackBar = SnackBar(
                                          backgroundColor: Colors.red,
                                          content: Text(
                                              '"$deletedIndexTitle"を削除しました！'),
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      }
                                      await model.fetchIndex();
                                    },
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
                      // 今回はadd_index_dialogのNavigator.pop(true)を戻り値にしているため
                      // Genericsをboolにしている。
                      final indexTitle = await showDialog<String>(
                        context: context,

                        // ダイアログ表示時の背景をタップしたときにダイアログを閉じてよいかどうか
                        barrierDismissible: false,

                        // TODO(me): AlertDialogの見た目をよくしたい。
                        builder: (BuildContext context) {
                          return AddIndexDialog(
                            UsersActionState.add,
                            currentPositionDisplayedInAddIndexDialog:
                                currentPositionDisplayedInAddIndexDialog,
                          );
                        },
                      );
                      // addedがtrue(つまり、indexが追加された時)ならSnackBarを表示する。
                      if (indexTitle != null) {
                        final snackBar = SnackBar(
                          backgroundColor: Colors.green,
                          content: Text('"$indexTitle"を追加しました！'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
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
