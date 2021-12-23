import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('youtube player demo'),
        ),
        body:YoutubePlayerBuilder(
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
                  size: 25.0,
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
          builder: (context, player) => Scaffold(
            appBar: AppBar(
              leading: Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Image.asset(
                  'assets/ypf.png',
                  fit: BoxFit.fitWidth,
                ),
              ),
              title: const Text(
                'YoutubePlayerFlutterDemo',
                style: TextStyle(color: Colors.white),
              ),
            ),
            body: const Text(
              'ListViewがあったところ'
            ),
          ),
        ),
        // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}

var _controller = _controller = YoutubePlayerController(
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