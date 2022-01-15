import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

void main() {
  runApp(const MyApp(
    key: null,
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  const MyApp({required Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: YoutubePlayerFlutterExample(
        items: List<String>.generate(10000, (i) => '動画のインデックス ${i + 1}'),
      ),
    );
  }
}

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
                  // print(positionController.currentPosition);
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

// 検証のため、YoutubePlayerControllerのインスタンス _controllerを用意
// var _controller = YoutubePlayerController(
//   initialVideoId: 'nPt8bK2gbaU',
//   flags: const YoutubePlayerFlags(
//     mute: false,
//     autoPlay: false,
//     disableDragSeek: false,
//     loop: false,
//     isLive: false,
//     forceHD: false,
//     enableCaption: true,
//   ),
// );

// ValueListenableBuilderに登録するため
// youtubePlayerControllerNotifierのインスタンスを作る。
YoutubePlayerControllerNotifier youtubePlayerControllerNotifier =
    YoutubePlayerControllerNotifier();

// positionのような変数の状態管理のため、YoutubePlayerControllerをextendsしたClassをつくる
// YoutubePlayerControllerをValueNotifierに見立てる。
class YoutubePlayerControllerNotifier extends YoutubePlayerController {
  YoutubePlayerControllerNotifier()
      : super(
          initialVideoId: 'nPt8bK2gbaU',
          flags: const YoutubePlayerFlags(
            mute: false,
            autoPlay: false,
            disableDragSeek: false,
            loop: false,
            isLive: false,
            forceHD: false,
            enableCaption: true,
          ),
        );

  // 止まった時の時間を保持する変数currentPosition
  Duration currentPosition = Duration.zero;
}
