import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../domain/index.dart';
import 'add_index_model.dart';

class AddIndexDialog extends StatelessWidget {
  const AddIndexDialog(this.currentPositionDisplayedInAddIndexDialog,
      {this.index, Key? key})
      : super(key: key);
  //　indexのtitleを受け取るために変数を用意。
  final Index? index;
  // player_pageからのcurrentPositionを受け取るために変数を用意。
  final Duration currentPositionDisplayedInAddIndexDialog;

  @override
  Widget build(BuildContext context) {
    //　追加画面と更新画面切り分けのため、indexTitleを持ってきたかを判定するためのisUpdatedを用意。
    final isUpdated = index != null;
    // PlayerModelを使い回す。
    return ChangeNotifierProvider<AddIndexModel>(
      create: (_) => AddIndexModel(),
      child: AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Consumer<AddIndexModel>(builder: (context, model, child) {
              // 更新ならListTileのindexTitleをTextEditingControllerに入れておく。
              // これで、ListTileの更新ボタンを押したときは
              // TextFieldにListTileの持っているtitleが表示される。
              if (isUpdated) {
                model.addIndexDialogTextEditingController.text =
                    index!.indexTitle;
              }
              return TextField(
                // controllerでTextEditingControllerが接続され、
                // 文字の取得がcontrollerで可能になる。
                controller: model.addIndexDialogTextEditingController,
                decoration: const InputDecoration(
                  hintText: 'index name',
                ),
                autofocus: true,
                keyboardType: TextInputType.text,
              );
            }),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text('currentPosition\n'
                  '$currentPositionDisplayedInAddIndexDialog'),
            ),
          ],
        ),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('キャンセル'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Consumer<AddIndexModel>(builder: (context, model, child) {
            return ElevatedButton(
              //　isUpdatedでボタンの表示を変える。
              child: Text(isUpdated ? 'update' : 'ok'),
              onPressed: () async {
                if (isUpdated) {
                  await updateIndex(context, model);
                } else {
                  await addIndex(context, model);
                }
              },
            );
          }),
        ],
      ),
    );
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
          currentPositionDisplayedInAddIndexDialog.inMicroseconds;
      await model.updateIndex(index!);
      Navigator.of(context).pop();
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
  Future<void> addIndex(BuildContext context, AddIndexModel model) async {
    try {
      // 入力フォームに入力された文字をmodelのindexTitleに入れる。
      model.indexTitle = model.addIndexDialogTextEditingController.text;

      // Firestoreにint currentPositionを入れるためにDurationを整形する。
      // currentPositionDisplayedInAddIndexDialogをintに変換して
      // modelのcurrentPositionに持たせる。
      model.currentPosition =
          currentPositionDisplayedInAddIndexDialog.inMicroseconds;
      await model.addIndex();
      Navigator.of(context).pop('Firestoreにデータを送って、player_pageに戻る');
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
}
