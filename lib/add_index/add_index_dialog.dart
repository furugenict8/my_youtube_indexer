import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../domain/index.dart';
import '../player/player_model.dart';
import 'add_index_model.dart';

class AddIndexDialog extends StatelessWidget {
  const AddIndexDialog(this.usersActionState,
      {this.currentPositionDisplayedInAddIndexDialog, this.index, Key? key})
      : super(key: key);

  //　add, update, deleteを判別するためのenum　UsersActionState
  final UsersActionState usersActionState;
  //　indexのtitleを受け取るために変数を用意。
  final Index? index;
  // player_pageからのcurrentPositionを受け取るために変数を用意。
  final Duration? currentPositionDisplayedInAddIndexDialog;

  @override
  Widget build(BuildContext context) {
    // PlayerModelを使い回す。
    return ChangeNotifierProvider<AddIndexModel>(
      create: (_) => AddIndexModel(),
      child: AlertDialog(
        content: Consumer<AddIndexModel>(
          builder: (context, model, child) {
            // Dialog画面をupdate、delete、addで条件分岐してそれぞれ表示
            switch (usersActionState) {
              case UsersActionState.add:
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: model.addIndexDialogTextEditingController,
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
                model.addIndexDialogTextEditingController.text =
                    index!.indexTitle;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: model.addIndexDialogTextEditingController,
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
                model.addIndexDialogTextEditingController.text =
                    index!.indexTitle;
                return Text(
                    '『${model.addIndexDialogTextEditingController.text}』を削除してもよろしいですか？');
            }
          },
        ),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('キャンセル'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          //　isUpdated、isDeleted、それ以外(add)でボタンの動作を変える。
          Consumer<AddIndexModel>(
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
  Future<void> addIndex(BuildContext context, AddIndexModel model) async {
    try {
      // 入力フォームに入力された文字をmodelのindexTitleに入れる。
      model.indexTitle = model.addIndexDialogTextEditingController.text;

      // Firestoreにint currentPositionを入れるためにDurationを整形する。
      // currentPositionDisplayedInAddIndexDialogをintに変換して
      // modelのcurrentPositionに持たせる。
      model.currentPosition =
          currentPositionDisplayedInAddIndexDialog!.inMicroseconds;
      await model.addIndex();
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
  Future<void> updateIndex(BuildContext context, AddIndexModel model) async {
    try {
      // 入力フォームに入力された文字をmodelのindexTitleに入れる。
      model.indexTitle = model.addIndexDialogTextEditingController.text;

      // Firestoreにint currentPositionを入れるためにDurationを整形する。
      // currentPositionDisplayedInAddIndexDialogをintに変換し
      // modelのcurrentPositionに持たせる。
      model.currentPosition =
          currentPositionDisplayedInAddIndexDialog!.inMicroseconds;
      await model.updateIndex(index!);
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
  Future<void> deleteIndex(BuildContext context, AddIndexModel model) async {
    //　選択されたListTileのindexを表示
    await model.deleteIndex(index!);
    Navigator.of(context).pop(model.deletedIndexTitle);
  }
}
