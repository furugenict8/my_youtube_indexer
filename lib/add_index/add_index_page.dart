import 'package:flutter/material.dart';

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
      title: const Text('indexを入れてください'),
      content: TextField(
        controller: indexTextController,
        decoration: const InputDecoration(
          hintText: '2回目のAメロ',
        ),
        autofocus: true,
        keyboardType: TextInputType.text,
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
