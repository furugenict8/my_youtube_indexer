import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'add_index_model.dart';

class AddIndexDialog extends StatelessWidget {
  AddIndexDialog(this.currentPositionDisplayedInAddIndexDialog, {Key? key})
      : super(key: key);

  // player_pageからのcurrentPositionを受け取るために変数を用意。
  Duration currentPositionDisplayedInAddIndexDialog = Duration.zero;

  @override
  Widget build(BuildContext context) {
    // PlayerModelを使い回す。
    return ChangeNotifierProvider<AddIndexModel>(
      create: (_) => AddIndexModel(),
      child: AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Consumer<AddIndexModel>(builder: (context, model, child) {
              return TextField(
                // controllerでTextEditingControllerが接続され、文字の取得がcontrollerでできるようになる。
                controller: model.addIndexDialogTextController,
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
            onPressed: () =>
                Navigator.of(context).pop('ダイアログは消えて、player_pageに戻る'),
          ),
          Consumer<AddIndexModel>(builder: (context, model, child) {
            return ElevatedButton(
              child: const Text('OK'),
              onPressed: () async {
                try {
                  model.indexTitle = model.addIndexDialogTextController.text;
                  // TODO(me): currentTimeをFirestoreのindexコレクションに追加する。
                  // とりあえず、10000を渡す。
                  model.testCurrentPosition = 10000;
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
              },
            );
          }),
        ],
      ),
    );
  }
}
