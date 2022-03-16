import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_youtube_indexer/domain/youtube.dart';

import '../domain/index.dart';

class IndexModel extends ChangeNotifier {
  TextEditingController indexDialogTextEditingController =
      TextEditingController();

  // Indexのタイトルを用意
  String indexTitle = '';

  // 動画を止めた時のcurrentPositionを用意。
  // Firestoreに入れるためDurationではなくint
  int currentPosition = 0;

  // 削除されたindexTitle用。削除された時にplayer画面で表示されるSnackBarのためにとっておく。
  String deletedIndexTitle = '';

  // YoutubePlayerFlutter参考
  @override
  void dispose() {
    indexDialogTextEditingController.dispose();
    super.dispose();
  }

  Future<void> addIndex() async {
    // バリデーション
    if (indexTitle.isEmpty) {
      throw const FormatException('タイトル入力してください。');
    }
    final CollectionReference index = FirebaseFirestore.instance.collection(
      'indexes',
    );
    await index.add({
      'title': indexTitle,
      'currentPosition': currentPosition,
    });
  }

  //　indexを更新する
  Future<void> updateIndex(Index index, Youtube youtube) async {
    // バリデーション
    if (indexTitle.isEmpty) {
      throw const FormatException('タイトル入力してください。');
    }
    final document = FirebaseFirestore.instance
        .collection('youtube')
        .doc(youtube.documentID)
        .collection('indexes')
        .doc(index.documentID);
    // 取得したdocumentIDがもつfield 'title'に入力されたindexTitleを入れてFirestoreを更新する。
    await document.update(
      {'title': indexTitle},
    );
  }

  // indexを削除する。
  Future<void> deleteIndex(Index index) async {
    final document = FirebaseFirestore.instance.collection('indexes').doc(index
        .documentID); // indexのイニシャライザでFirestoreのdocumentIDを取得し、documentに入れる。(14:28 Fires)
    deletedIndexTitle = index.indexTitle;
    await document.delete();
  }
}
