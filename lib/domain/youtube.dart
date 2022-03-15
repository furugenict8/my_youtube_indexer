import 'package:cloud_firestore/cloud_firestore.dart';

class Youtube {
  Youtube(DocumentSnapshot doc) {
    videoId = doc['videoId'] as String;
  }
  // インデックスのtitle
  String videoId = '';
}
