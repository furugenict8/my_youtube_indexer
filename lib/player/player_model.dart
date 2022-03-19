import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_youtube_indexer/domain/index.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../domain/youtube.dart';

// ChangeNotifierはChangeNotifierBuilderのcreateのところでコンストラクタがつかわれる。
//　なのでコンストラクタ内でinitすればよさそう。
// salon appと違うけど。
class PlayerModel extends ChangeNotifier {
  PlayerModel({
    required this.videoId,
  }) {
    init();
  }

  late Duration currentPosition;
  late YoutubePlayerController controller;
  late PlayerState _playerState;
  final bool _isPlayerReady = false;

  // documentの要素Indexのリストをモデルで持たせる。
  List<Index> indexList = [];

  // youtubeのvideoID
  String videoId = '';

  // playerの初期化
  void init() {
    controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
        hideThumbnail: true,
      ),

      // addListenerはオブジェクト(YoutubePlayerController)が変更された時に呼ばれるlistener(void Callback)を登録する。
      // 今回はListener()を登録。
    )..addListener(listener);

    // index入力フォームのため
    _playerState = PlayerState.unknown;
    currentPosition = Duration.zero;

    notifyListeners();
  }

  // youtube_player_flutter_sampleにあるmount propertyにあたるものは
  // とりあえず無視してみます。
  void listener() {
    if (_isPlayerReady && !controller.value.isFullScreen) {
      _playerState = controller.value.playerState;
    }
  }

  // YoutubePlayerFlutter参考
  @override
  void dispose() {
    // TODO(me): implement dispose
    controller.dispose();
    super.dispose();
  }

  //　playerの停止時の時間を取得
  void getCurrentPosition() {
    controller.pause();
    currentPosition = controller.value.position;
    notifyListeners();
  }

  // titleと停止した時の時間currentPositionをfirestoreから取得
  Future<void> fetchIndexes(Youtube youtube) async {
    // Firestoreのコレクションyoutubeのそれぞれのyoutubeが持っているドキュメントの中のコレクションindexesを取得する
    final document = await FirebaseFirestore.instance
        .collection('youtube')
        .doc(youtube.documentID)
        .collection('indexes')
        .get();
    // コレクションindexのドキュメント( QueryDocumentSnapshot<Map<String, dynamic>>)を
    // Indexへ変換。それをListにして、indexListに代入する。
    indexList = document.docs.map((doc) => Index(doc)).toList();
    notifyListeners();
  }
}

// userがadd、update、deleteのどのボタンをタップしたかを判別するためのenum
enum UsersActionState { add, update, delete }
