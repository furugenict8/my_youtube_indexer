import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

void main() {
  runApp(const MyApp(key: null,));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  const MyApp({required Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('youtube player demo'),
        ),
        body: YoutubePlayerFlutterExample(
          items: List<String>.generate(10000, (i) => 'Item $i'),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              //TODO(自分): 押したら動画の現在時刻を取得して表示する,
            },
            tooltip: '押したら動画の現在時刻を取得して表示する',
            child: const Icon(Icons.add),
        ),
        // This trailing comma makes auto-formatting nicer for build methods.
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
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.blueAccent,
        onReady: () {
          // TODO　何か
        },
      ),
      builder: (context, player) => Expanded(
        child: Column(
          children: [
            // youtube_player_flutterのこと。
            player,
            const Text(
                'ここにpositionを表示したい。とりあえず。'
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(items[index]),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}


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