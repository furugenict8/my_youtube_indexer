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
        body: const YoutubePlayerFlutterExample(),
        // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}

class YoutubePlayerFlutterExample extends StatelessWidget {
  const YoutubePlayerFlutterExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.blueAccent,

        // Adds custom top bar widgets.
        topActions: <Widget>[
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _controller.metadata.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
              size: 25,
            ),
            onPressed: () {
              // TODO 何か;
            },
          ),
        ],
        onReady: () {
          // TODO　何か
        },
      ),
      builder: (context, player) => const Text(
          'ListViewがあったところ'
      ),
    );
  }
}


var _controller = YoutubePlayerController(
  initialVideoId: 'nPt8bK2gbaU',
  flags: const YoutubePlayerFlags(
    mute: false,
    autoPlay: true,
    disableDragSeek: false,
    loop: false,
    isLive: false,
    forceHD: false,
    enableCaption: true,
  ),
);