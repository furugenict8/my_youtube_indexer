import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_youtube_indexer/youtube_list/youtube_list_page.dart';

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
      home: YoutubeListPage(),
    );
  }
}
