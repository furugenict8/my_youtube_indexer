import 'package:flutter/material.dart';

class AddIndexDialog extends StatelessWidget {
  const AddIndexDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: model.addIndexDialogTextController,
            decoration: const InputDecoration(
              hintText: 'index name',
            ),
            autofocus: true,
            keyboardType: TextInputType.text,
          ),
          // TODO(me): playerで停止している時間currentPositionを表示する。
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text('currentPosition\n'
                '${model.currentPosition}'),
          ),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop('Cancelだよ'),
        ),
        ElevatedButton(
          child: const Text('OK'),
          onPressed: () => Navigator.of(context).pop('indexだよ。'),
        ),
      ],
    );
    ;
  }
}
