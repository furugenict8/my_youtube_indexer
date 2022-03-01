import 'package:cloud_firestore/cloud_firestore.dart';

class Index {
  Index(DocumentSnapshot doc) {
    currentPosition = doc['currentPosition'] as int;
    indexTitle = doc['title'] as String;
    // indexのdocumentIDを取得
    documentID = doc.id;
  }
  // 停止した時の時間
  int currentPosition = 0;

  // インデックスのtitle
  String indexTitle = '';

  // indexのdocumentIDを持たせる。
  String documentID = '';
}
