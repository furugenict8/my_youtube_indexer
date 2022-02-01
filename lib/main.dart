import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_youtube_indexer/player/player_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp(
    key: null,
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  const MyApp({required Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PlayerPage(
          // items: List<String>.generate(10000, (i) => '動画のインデックス ${i + 1}'),
          ),
    );
  }
}
