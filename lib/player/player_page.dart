import 'package:flutter/material.dart';
import 'package:my_youtube_indexer/index_dialog/index_dialog.dart';
import 'package:my_youtube_indexer/player/player_model.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../domain/youtube.dart';

class PlayerPage extends StatelessWidget {
  const PlayerPage({
    Key? key,
    required this.youtube,
  }) : super(key: key);

  //　Youtube(Firestoreのエンティティ)を受け取る。
  final Youtube youtube;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PlayerModel>(
      // ListView.builder実行の前にここで、fetchIndex()をやっておく
      create: (_) => PlayerModel(youtube.videoId)..fetchIndexes(youtube),
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
                    IndexListView(
                      youtube: youtube,
                      model: model,
                    ),
                  ],
                ),
                floatingActionButton: AddIndexButton(
                  youtube: youtube,
                  model: model,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// IndexのListView
class IndexListView extends StatelessWidget {
  const IndexListView({
    Key? key,
    required this.model,
    required this.youtube,
  }) : super(key: key);

  final Youtube youtube;
  final PlayerModel model;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: model.indexList.length,
        itemBuilder: (context, indexNumber) {
          return IndexListTile(
            indexNumber: indexNumber,
            youtube: youtube,
            model: model,
          );
        },
      ),
    );
  }
}

// Indexを表示するためのListTile
class IndexListTile extends StatelessWidget {
  const IndexListTile({
    Key? key,
    required this.indexNumber,
    required this.youtube,
    required this.model,
  }) : super(key: key);

  final int indexNumber;
  final Youtube youtube;
  final PlayerModel model;

  @override
  Widget build(BuildContext context) {
    final indexList = model.indexList;
    // ListTileごとのtitle indexTitle
    final indexTitle = indexList[indexNumber].indexTitle;
    // ListTileに表示されるcurrentPosition
    final currentPosition = Duration(
      days: 0,
      hours: 0,
      minutes: 0,
      seconds: 0,
      milliseconds: 0,
      microseconds: indexList[indexNumber].currentPosition,
    );
    return ListTile(
      // TODO(me): 停止した時のサムネを表示
      leading: const Text('停止した時の\n動画のサムネ'),
      title: Text('title: $indexTitle'),
      subtitle: Text(
        'currentPosition: '
        '$currentPosition',
      ),
      onTap: () {
        model.controller.seekTo(
          currentPosition,
        );
      },
      trailing: FittedBox(
        fit: BoxFit.fill,
        child: Row(
          children: [
            //　編集ボタン
            EditButton(
              indexNumber: indexNumber,
              youtube: youtube,
              currentPosition: currentPosition,
              model: model,
            ),
            // 削除ボタン
            DeleteButton(
              indexNumber: indexNumber,
              youtube: youtube,
              currentPosition: currentPosition,
              model: model,
            ),
          ],
        ),
      ),
    );
  }
}

//　編集ボタン
class EditButton extends StatelessWidget {
  const EditButton({
    Key? key,
    required this.indexNumber,
    required this.youtube,
    required this.currentPosition,
    required this.model,
  }) : super(key: key);

  final int indexNumber;
  final Youtube youtube;
  final Duration currentPosition;
  final PlayerModel model;

  @override
  Widget build(BuildContext context) {
    final indexList = model.indexList;
    return IconButton(
      icon: const Icon(Icons.edit),
      onPressed: () async {
        final currentPositionDisplayedInAddIndexDialog = currentPosition;

        // Navigator.pop(model.indexTitle)をindexTitleで受け取る
        final indexTitle = await showDialog<String>(
          context: context,

          // ダイアログ表示時の背景をタップしたときにダイアログを閉じてよいかどうか
          barrierDismissible: false,

          // TODO(me): AlertDialogの見た目をよくしたい。
          builder: (BuildContext context) {
            return IndexDialog(
              UsersActionState.update,
              youtube,
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
            content: Text('"$indexTitle"を更新しました！'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
        await model.fetchIndexes(youtube);
      },
    );
  }
}

// 削除ボタン
class DeleteButton extends StatelessWidget {
  const DeleteButton({
    Key? key,
    required this.indexNumber,
    required this.youtube,
    required this.currentPosition,
    required this.model,
  }) : super(key: key);

  final int indexNumber;
  final Youtube youtube;
  final Duration currentPosition;
  final PlayerModel model;

  @override
  Widget build(BuildContext context) {
    final indexList = model.indexList;
    return IconButton(
      icon: const Icon(Icons.delete),
      onPressed: () async {
        // Navigator.pop(model.deletedIndexTitle)をdeletedIndexTitleで受け取る
        final deletedIndexTitle = await showDialog<String>(
          context: context,

          // ダイアログ表示時の背景をタップしたときにダイアログを閉じてよいかどうか
          barrierDismissible: false,

          // TODO(me): AlertDialogの見た目をよくしたい。
          builder: (BuildContext context) {
            return IndexDialog(
              UsersActionState.delete,
              youtube,
              index: indexList[indexNumber],
            );
          },
        );

        // showSnackBarの返り値indexTitleがあれば、SnackBarを表示。
        if (deletedIndexTitle != null) {
          final snackBar = SnackBar(
            backgroundColor: Colors.red,
            content: Text('"$deletedIndexTitle"を削除しました！'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
        await model.fetchIndexes(youtube);
      },
    );
  }
}

//　Index追加ボタン
class AddIndexButton extends StatelessWidget {
  const AddIndexButton({
    Key? key,
    required this.youtube,
    required this.model,
  }) : super(key: key);

  final Youtube youtube;
  final PlayerModel model;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        // TODO(me): addIndexDialogから戻ってきたときに止めた時の状態のplayerを表示する。
        // TODO(me): 画面遷移して戻ってきた時に同じ状態（リストとか停止している時間とか）にする。
        model.getCurrentPosition();
        final currentPositionDisplayedInAddIndexDialog = model.currentPosition;

        // showDialog<T> はダイアログの表示結果戻り値の型を指定
        // 今回はadd_index_dialogのNavigator.pop(true)を戻り値にしているため
        // Genericsをboolにしている。
        final indexTitle = await showDialog<String>(
          context: context,

          // ダイアログ表示時の背景をタップしたときにダイアログを閉じてよいかどうか
          barrierDismissible: false,

          // TODO(me): AlertDialogの見た目をよくしたい。
          builder: (BuildContext context) {
            return IndexDialog(
              UsersActionState.add,
              youtube,
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
        await model.fetchIndexes(youtube);
      },
      tooltip: '押したら動画の現在時刻を取得して表示する',
      child: const Icon(Icons.add),
    );
  }
}
