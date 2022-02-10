import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddIndexModel extends ChangeNotifier {
  TextEditingController addIndexDialogTextController = TextEditingController();

  // Indexのタイトルを用意
  String indexTitle = '';

  // currentPositionのテストtestCurrentPositionを用意
  int testCurrentPosition = 0;

  // YoutubePlayerFlutter参考
  @override
  void dispose() {
    addIndexDialogTextController.dispose();
    super.dispose();
  }

  Future<void> addIndex() async {
    //ここでバリデーションする　13:27
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
      'currentPosition': testCurrentPosition,
    });
  }
}
