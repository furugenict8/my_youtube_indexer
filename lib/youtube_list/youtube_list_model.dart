import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../domain/youtube.dart';

class YoutubeListModel extends ChangeNotifier {
  YoutubeListModel();

  List<Youtube> youtubeList = [];
  String title = '';
  late YoutubePlayerController controller;

  Future<void> fetchVideoId() async {
    // TODO(me): Firestoreからデータを取ってくる処理
    final document =
        await FirebaseFirestore.instance.collection('youtube').get();
    youtubeList = document.docs.map((doc) => Youtube(doc)).toList();
    notifyListeners();
  }

  void fetchYoutubeTitle(String videoId) {
    // videoIdから動画のタイトルを取得して返す処理
    final _youtubePlayerController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
      ),
    );
    var _youtubePlayer = YoutubePlayer(
      controller: _youtubePlayerController,
      onReady: () {
        controller.load(videoId);
      },
    );

    final title = _youtubePlayerController.metadata.title;
  }
}

// userがyoutubeでadd、update、deleteのどのボタンをタップしたかを判別するためのenum
enum UsersYoutubeActionState { add, update, delete }
