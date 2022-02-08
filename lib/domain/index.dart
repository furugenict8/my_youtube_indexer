import 'package:cloud_firestore/cloud_firestore.dart';

class Index {
  Index(DocumentSnapshot doc) {
    currentPosition = doc['currentPosition'] as int;
    index = doc['index'] as String;
  }
  int currentPosition = 0;
  String index = '';
}
