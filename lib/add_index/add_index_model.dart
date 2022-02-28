import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../domain/index.dart';

class AddIndexModel extends ChangeNotifier {
  TextEditingController addIndexDialogTextEditingController =
      TextEditingController();

  // Indexのタイトルを用意
  String indexTitle = '';

  // 動画を止めた時のcurrentPositionを用意。
  // Firestoreに入れるためDurationではなくint
  int currentPosition = 0;

  // YoutubePlayerFlutter参考
  @override
  void dispose() {
    addIndexDialogTextEditingController.dispose();
    super.dispose();
  }

  Future<void> addIndex() async {
    //ここでバリデーションする
    if (indexTitle.isEmpty) {
      // Linterで指摘うけないように、FormatException使ってみた。
      throw const FormatException('タイトル入力してください。');
    }
    final CollectionReference index = FirebaseFirestore.instance.collection(
      'indexes',
    );
    await index.add({
      //addの中はcloud_firestore 0.13.6参照　JSONみたいなやつ　Dictionary型
      'index': indexTitle, //13:08
      'currentPosition': currentPosition,
    });
  }

  //　indexを更新する
  Future<void> updateIndex(Index index) async {
    //ここでバリデーションする
    if (indexTitle.isEmpty) {
      // Linterで指摘うけないように、FormatException使ってみた。
      throw const FormatException('タイトル入力してください。');
    }
    final document = FirebaseFirestore.instance.collection('indexes').doc(index
        .documentID); //indexのイニシャライザでFirestoreのdocumentIDを取得し、documentに入れる。(14:28 Fires)
    // 取得したdocumentIDがもつfield 'title'に入力されたindexTitleを入れてFirestoreを更新する。
    await document.update(
      {'title': indexTitle},
    );
  }
}
