import 'package:cloud_firestore/cloud_firestore.dart';

class Index {
  Index(DocumentSnapshot doc) {
    currentTime = doc['currentTime'] as int;
    title = doc['title'] as String;
  }
  int currentTime = 0;
  String title = '';
}
