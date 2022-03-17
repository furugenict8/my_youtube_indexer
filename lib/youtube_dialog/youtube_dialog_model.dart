import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_youtube_indexer/domain/youtube.dart';

class YoutubeDialogModel extends ChangeNotifier {
  TextEditingController youtubeDialogTextEditingController =
      TextEditingController();

  // videoId
  String videoId = '';

  // 削除されたvideoId用。削除された時にplayer画面で表示されるSnackBarのためにとっておく。
  String deletedVideoId = '';

  Future<void> addYoutube() async {
    // バリデーション
    if (videoId.isEmpty) {
      throw const FormatException('videoIdを入力してください。');
    }
    final document = FirebaseFirestore.instance.collection('youtube');
    await document.add(<String, dynamic>{
      'videoId': videoId,
    });
  }

  //　videoIdを更新する
  Future<void> updateYoutube(Youtube youtube) async {
    // バリデーション
    if (videoId.isEmpty) {
      throw const FormatException('videoIdを入力してください。');
    }
    final document = FirebaseFirestore.instance
        .collection('youtube')
        .doc(youtube.documentID);
    // 取得したdocumentIDがもつfield 'videoId'に入力されたvideoIdを入れてFirestoreを更新する。
    await document.update(
      {'videoId': videoId},
    );
  }

  // indexを削除する。
  Future<void> deleteYoutube(Youtube youtube) async {
    final document = FirebaseFirestore.instance
        .collection('youtube')
        .doc(youtube.documentID);
    deletedVideoId = youtube.videoId;
    await document.delete();
  }
}
