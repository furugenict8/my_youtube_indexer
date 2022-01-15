import 'package:flutter/material.dart';
import 'package:my_youtube_indexer/player_page.dart';

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
