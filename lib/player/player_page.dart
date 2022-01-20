import 'package:flutter/material.dart';
import 'package:my_youtube_indexer/player/player_model.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlayerFlutterExample extends StatelessWidget {
  YoutubePlayerFlutterExample({
    Key? key,
    required this.items,
  }) : super(key: key);
  final List<String> items;

  // index入力フォームのため。
  final addIndexDialogTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //Full screen対応のためのYoutubePlayerBuilder
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: youtubePlayerControllerNotifier,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.blueAccent,

        // TODO(me): onReadyを調べる。
        onReady: () {
          // TODO(me): 何かの処理。
        },
      ),
      builder: (context, player) {
        // YoutubePlayerValueをScaffoldに渡すためのValueListenableBuilder
        return ValueListenableBuilder<YoutubePlayerValue>(
          valueListenable: youtubePlayerControllerNotifier,
          builder: (context, youtubePlayerValue, child) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('my_youtube_indexer'),
              ),
              body: Column(children: [
                // youtube_player_flutterのこと。
                player,
                Text(
                  'FloatingActionButtonがタップされた時のposition\n'
                  '${youtubePlayerControllerNotifier.currentPosition}',
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
                  youtubePlayerControllerNotifier
                    ..pause()
                    ..currentPosition =
                        youtubePlayerControllerNotifier.value.position;

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
                              controller: addIndexDialogTextController,
                              decoration: const InputDecoration(
                                hintText: 'index name',
                              ),
                              autofocus: true,
                              keyboardType: TextInputType.text,
                            ),
                            // TODO(me): playerで停止している時間currentPositionを表示する。
                            Text('currentPosition\n'
                                '${youtubePlayerControllerNotifier.currentPosition}'),
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
    );
  }
}
