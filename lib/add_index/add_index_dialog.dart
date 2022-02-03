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
              // TODO(me): 入力されたtitleを何か変数に保存する。
              // controllerでTextEditingControllerが接続され、文字の取得がcontrollerでできるようになった。
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
            onPressed: () {
              // TODO(me): index欄で入力したtitleをFirestoreのindexコレクションに追加する。
              // TODO(me): 追加はできているが、cascadeでかくこと推奨(ちょっとわからない。)
              final indexText = model.addIndexDialogTextController.text;
              model.indexTitle = indexText;
              // TODO(me): currentTimeをFirestoreのindexコレクションに追加する。
              // とりあえず、10000を渡す。
              model.testCurrentPostion = 10000;
              model.addIndex();
              Navigator.of(context).pop('Firestoreにデータを送って、player_pageに戻る');
            },
          ),
        ],
      ),
    );
  }
}
