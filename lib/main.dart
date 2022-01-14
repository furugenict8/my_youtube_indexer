import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp(key: null,));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  const MyApp({required Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: YoutubePlayerFlutterExample(
        items: List<String>.generate(10000, (i) => '動画のインデックス ${i+1}'),
      ),
    );
  }
}


class YoutubePlayerFlutterExample extends StatelessWidget {
        YoutubePlayerFlutterExample({
          Key? key,
          required this.items,
        }) : super(key: key);
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _positionController,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.blueAccent,
        onReady: () {
          // TODO　何か
        },
      ),
      builder: (context, player) => Scaffold(
        appBar: AppBar(
          title: const Text('my_youtube_indexer'),
        ),
        body: Column(
              children: [
              // youtube_player_flutterのこと。
              player,
              Text(
                '停止しているposition\n'
                    '${_positionController.value.position}',
                // TODO(me): 画面が止まったら現在時刻を表示
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
                      onTap: (){
                        // TODO(me): 再生時間から動画が再生される,
                      },
                    );
                  },
                ),
              ),
            ]
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            //TODO(自分): 押したら動画の現在時刻を取得して表示する
            _positionController.playPause();
            print(_positionController.value.position);
          },
          tooltip: '押したら動画の現在時刻を取得して表示する',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

// 検証のため、YoutubePlayerControllerのインスタンス _controllerを用意
var _controller = YoutubePlayerController(
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

var _positionController = PositionManagement();

// positionのような状態管理のため、YoutubePlayerControllerをextendsしたClassをつくる
// YoutubePlayerControllerをValueNotifierに見立てる。
class PositionManagement extends YoutubePlayerController {
  PositionManagement() : super(
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

  Duration currentPosition = Duration.zero;

  void playPause() {
    // TODO(me): ここにYoutubePlayerValueを再描画させる処理を入れる。
    // currentPosition = _controller.value.position;
    super.pause();
    notifyListeners();
  }
}

