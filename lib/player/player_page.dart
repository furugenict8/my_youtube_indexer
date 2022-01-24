import 'package:flutter/material.dart';
import 'package:my_youtube_indexer/player/player_model.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PlayerPage extends StatelessWidget {
  const PlayerPage({
    Key? key,
    required this.items,
  }) : super(key: key);
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    //Full screen対応のためのYoutubePlayerBuilder
    return ChangeNotifierProvider<PlayerModel>(
      create: (_) => PlayerModel(),
      child: Consumer<PlayerModel>(
        builder: (context, model, child) {
          return YoutubePlayerBuilder(
            player: YoutubePlayer(
              controller: model.controller,
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.blueAccent,

              // TODO(me): onReadyを調べる。
              onReady: () {
                // TODO(me): 何かの処理。
              },
            ),
            builder: (context, player) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text('my_youtube_indexer'),
                ),
                body: Column(children: [
                  // youtube_player_flutterのこと。
                  player,
                  Text(
                    'FloatingActionButtonがタップされた時のposition\n'
                    '${model.currentPosition}',
                  ),
                  // ListViewの部分
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const Text('停止した時の\n動画のサムネ'),
                          title: Text(items[index]),
                          subtitle: const Text('再生が始まる時間'),
                          onTap: () {
                            // TODO(me): 再生時間から動画が再生される,
                          },
                          trailing: GestureDetector(
                            onTap: () {
                              //　TODO(me): ボタンを押したらこのListTileが削除される操作
                            },
                            child: const Icon(
                              Icons.close,
                              color: Colors.red,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ]),
                floatingActionButton: FloatingActionButton(
                  onPressed: () async {
                    // TODO(me): addIndexDialogから戻ってきたときに止めた時の状態のplayerを表示する。
                    // TODO(me): 画面遷移して戻ってきた時に同じ状態（リストとか停止している時間とか）にする。
                    model.getCurrentPosition();

                    // showDialog<T> はダイアログの表示結果戻り値の型を指定
                    final result = await showDialog<String>(
                      context: context,

                      // barrierDismissibleはダイアログ表示時の背景をタップしたときにダイアログを閉じてよいかどうか
                      barrierDismissible: false,

                      // TODO(me): AlertDialogの見た目をよくしたい。
                      builder: (BuildContext context) {
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
                              onPressed: () =>
                                  Navigator.of(context).pop('Cancelだよ'),
                            ),
                            ElevatedButton(
                              child: const Text('OK'),
                              onPressed: () =>
                                  Navigator.of(context).pop('indexだよ。'),
                            ),
                          ],
                        );
                      },
                    );
                    print('dialog result: $result');
                  },
                  tooltip: '押したら動画の現在時刻を取得して表示する',
                  child: const Icon(Icons.add),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
