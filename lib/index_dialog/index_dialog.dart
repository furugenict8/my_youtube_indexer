import 'package:flutter/material.dart';
import 'package:my_youtube_indexer/domain/youtube.dart';
import 'package:provider/provider.dart';

import '../domain/index.dart';
import '../player/player_model.dart';
import 'index_model.dart';

class IndexDialog extends StatelessWidget {
  const IndexDialog(this.usersActionState, this.youtube,
      {this.currentPositionDisplayedInAddIndexDialog, this.index, Key? key})
      : super(key: key);

  //　add, update, deleteを判別するためのenum　UsersActionState
  final UsersActionState usersActionState;
  // Youtubeを受け取る
  final Youtube youtube;
  // player_pageからのcurrentPositionを受け取るために変数を用意。
  final Duration? currentPositionDisplayedInAddIndexDialog;
  //　indexのtitleを受け取るために変数を用意。
  final Index? index;

  @override
  Widget build(BuildContext context) {
    // PlayerModelを使い回す。
    return ChangeNotifierProvider<IndexModel>(
      create: (_) => IndexModel(),
      child: AlertDialog(
        content: Consumer<IndexModel>(
          builder: (context, model, child) {
            // Dialog画面をupdate、delete、addで条件分岐してそれぞれ表示
            switch (usersActionState) {
              case UsersActionState.add:
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: model.indexDialogTextEditingController,
                      decoration: const InputDecoration(
                        hintText: 'index name',
                      ),
                      autofocus: true,
                      keyboardType: TextInputType.text,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text('currentPosition\n'
                          '$currentPositionDisplayedInAddIndexDialog'),
                    )
                  ],
                );

              case UsersActionState.update:
                model.indexDialogTextEditingController.text = index!.indexTitle;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: model.indexDialogTextEditingController,
                      autofocus: true,
                      keyboardType: TextInputType.text,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text('currentPosition\n'
                          '$currentPositionDisplayedInAddIndexDialog'),
                    )
                  ],
                );
              case UsersActionState.delete:
                model.indexDialogTextEditingController.text = index!.indexTitle;
                return Text(
                    '『${model.indexDialogTextEditingController.text}』を削除してもよろしいですか？');
            }
          },
        ),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('キャンセル'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          //　isUpdated、isDeleted、それ以外(add)でボタンの動作を変える。
          Consumer<IndexModel>(
            builder: (context, model, child) {
              switch (usersActionState) {
                case UsersActionState.add:
                  return ElevatedButton(
                    child: Text('追加'),
                    onPressed: () async {
                      await addIndex(context, model);
                    },
                  );
                case UsersActionState.update:
                  return ElevatedButton(
                    child: Text('更新'),
                    onPressed: () async {
                      await updateIndex(context, model);
                    },
                  );
                case UsersActionState.delete:
                  return ElevatedButton(
                    child: Text('削除'),
                    onPressed: () async {
                      await deleteIndex(context, model);
                    },
                  );
              }
            },
          ),
        ],
      ),
    );
  }

  // indexを追加する時の処理。
  Future<void> addIndex(BuildContext context, IndexModel model) async {
    try {
      // 入力フォームに入力された文字をmodelのindexTitleに入れる。
      model.indexTitle = model.indexDialogTextEditingController.text;

      // Firestoreにint currentPositionを入れるためにDurationを整形する。
      // currentPositionDisplayedInAddIndexDialogをintに変換して
      // modelのcurrentPositionに持たせる。
      model.currentPosition =
          currentPositionDisplayedInAddIndexDialog!.inMicroseconds;
      await model.addIndex(youtube);
      Navigator.of(context).pop(model.indexTitle);
    } on FormatException catch (e) {
      await showDialog<AlertDialog>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(e.message.toString()),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  // indexを更新する時の処理。
  Future<void> updateIndex(BuildContext context, IndexModel model) async {
    try {
      // 入力フォームに入力された文字をmodelのindexTitleに入れる。
      model.indexTitle = model.indexDialogTextEditingController.text;

      // Firestoreにint currentPositionを入れるためにDurationを整形する。
      // currentPositionDisplayedInAddIndexDialogをintに変換し
      // modelのcurrentPositionに持たせる。
      model.currentPosition =
          currentPositionDisplayedInAddIndexDialog!.inMicroseconds;

      //　ここでYoutubeを渡せばいいのか？
      await model.updateIndex(index!, youtube);
      Navigator.of(context).pop(model.indexTitle);
    } on FormatException catch (e) {
      await showDialog<AlertDialog>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(e.message.toString()),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  // indexを追加する時の処理。
  Future<void> deleteIndex(BuildContext context, IndexModel model) async {
    //　選択されたListTileのindexを表示
    await model.deleteIndex(index!, youtube);
    Navigator.of(context).pop(model.deletedIndexTitle);
  }
}
