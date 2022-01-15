import 'package:flutter/material.dart';
import 'package:my_youtube_indexer/player_notifier.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlayerFlutterExample extends StatelessWidget {
  const YoutubePlayerFlutterExample({
    Key? key,
    required this.items,
  }) : super(key: key);
  final List<String> items;

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
                  '停止した時のposition\n'
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
                onPressed: () {
                  //TODO(自分): 押したら動画の現在時刻を取得して表示する
                  youtubePlayerControllerNotifier
                    ..pause()
                    ..currentPosition =
                        youtubePlayerControllerNotifier.value.position;
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
