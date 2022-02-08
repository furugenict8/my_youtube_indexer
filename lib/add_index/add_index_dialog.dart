import 'package:flutter/material.dart';
import 'package:my_youtube_indexer/player/player_model.dart';
import 'package:provider/provider.dart';

class AddIndexDialog extends StatelessWidget {
  const AddIndexDialog(this.model, {Key? key}) : super(key: key);
  final PlayerModel model;

  @override
  Widget build(BuildContext context) {
    // PlayerModelを使い回す。
    return ChangeNotifierProvider<PlayerModel>.value(
      value: PlayerModel(),
      child: AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              // controllerでTextEditingControllerが接続され、文字の取得がcontrollerでできるようになる。
              controller: model.addIndexDialogTextController,
              decoration: const InputDecoration(
                hintText: 'index name',
              ),
              autofocus: true,
              keyboardType: TextInputType.text,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text('currentPosition\n'
                  '${model.currentPosition}'),
            ),
          ],
        ),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('キャンセル'),
            onPressed: () =>
                Navigator.of(context).pop('ダイアログは消えて、player_pageに戻る'),
          ),
          ElevatedButton(
            child: const Text('OK'),
            onPressed: () async {
              try {
                // TODO(me): 追加はできているが、cascadeでかくこと推奨(ちょっとわからない。)
                model.indexTitle = model.addIndexDialogTextController.text;
                // TODO(me): currentTimeをFirestoreのindexコレクションに追加する。
                // とりあえず、10000を渡す。
                model.testCurrentPostion = 10000;
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
          ),
        ],
      ),
    );
  }
}
