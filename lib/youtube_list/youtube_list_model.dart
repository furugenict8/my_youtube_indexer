import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../domain/youtube.dart';

class YoutubeListModel extends ChangeNotifier {
  YoutubeListModel();

  List<Youtube> youtubeList = [];

  Future<void> fetchVideoId() async {
    // TODO(me): Firestoreからデータを取ってくる処理
    final document =
        await FirebaseFirestore.instance.collection('youtube').get();
    youtubeList = document.docs.map((doc) => Youtube(doc)).toList();
    notifyListeners();
  }
}
