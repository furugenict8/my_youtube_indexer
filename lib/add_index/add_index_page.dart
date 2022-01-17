import 'package:flutter/material.dart';

// TODO(me): StatelessWidgetとChangeNotifierを使ってUIとモデルを分離する。
// TODO(me): player_pageにポップアップ表示にする。
class AddIndexDialog extends StatefulWidget {
  const AddIndexDialog({Key? key}) : super(key: key);

  @override
  State createState() => AddIndexDialogState();
}

class AddIndexDialogState extends State<AddIndexDialog> {
  final indexTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    final actions = <Widget>[
      ElevatedButton(
        child: Text(localizations.cancelButtonLabel),
        onPressed: () => Navigator.pop(context),
      ),
      ElevatedButton(
        child: Text(localizations.okButtonLabel),
        onPressed: () {
          // TODO(me): 入力したindexをplayer_pageのListTileのindex欄に渡す
          //　とりあえずもとに戻す
          Navigator.pop(context);
        },
      ),
    ];
    final dialog = AlertDialog(
      // TODO(me): 見た目を調整する。
      title: const Text('indexを入れてください'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: indexTextController,
            decoration: const InputDecoration(
              hintText: '2回目のAメロ',
            ),
            autofocus: true,
            keyboardType: TextInputType.text,
          ),
          // TODO(me): playerで停止している時間currentPositonを表示する。
          const Text('currentPositionを表示\n20：02'),
        ],
      ),
      actions: actions,
    );

    return dialog;
  }

  @override
  void dispose() {
    indexTextController.dispose();
    super.dispose();
  }
}
