import 'package:flutter/material.dart';
import 'package:my_youtube_indexer/player/player_model.dart';
import 'package:provider/provider.dart';

class AddIndexDialog extends StatelessWidget {
  const AddIndexDialog(this.model, {Key? key}) : super(key: key);
  final PlayerModel model;

  @override
  Widget build(BuildContext context) {
    // いきなりAlertDialogはありなんだろうか。
    return ChangeNotifierProvider<PlayerModel>.value(
      value: PlayerModel(),
      child: AlertDialog(
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
            onPressed: () => Navigator.of(context).pop('index追加だよ。'),
          ),
        ],
      ),
    );
  }
}
