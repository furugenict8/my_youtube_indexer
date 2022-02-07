import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_youtube_indexer/domain/index.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// ChangeNotifierはChangeNotifierBuilderのcreateのところでコンストラクタがつかわれる。
//　なのでコンストラクタ内でinitすればよさそう。
// salon appと違うけど。
class PlayerModel extends ChangeNotifier {
  PlayerModel() {
    init();
  }

  late Duration currentPosition;
  late YoutubePlayerController controller;
  late TextEditingController addIndexDialogTextController;
  late PlayerState _playerState;
  bool _isPlayerReady = false;

  // documentの要素Indexのリストをモデルで持たせる。
  List<Index> indexList = [];

  // Indexのタイトルを用意
  String indexTitle = '';

  // currentPositonのテストtestCurrentPostionを用意
  int testCurrentPostion = 0;

  // playerの初期化
  void init() {
    controller = YoutubePlayerController(
      initialVideoId: 'nPt8bK2gbaU',
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),

      // addListenerはオブジェクト(YoutubePlayerController)が変更された時に呼ばれるlistener(void Callback)を登録する。
      // 今回はListener()を登録。
    )..addListener(listener);

    // index入力フォームのため
    addIndexDialogTextController = TextEditingController();
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
    addIndexDialogTextController.dispose();
    super.dispose();
  }

  void getCurrentPosition() {
    controller.pause();
    currentPosition = controller.value.position;
    notifyListeners();
  }

  Future<void> fetchIndex() async {
    // firestoreのコレクションをとる。
    final document = await FirebaseFirestore.instance.collection('index').get();
    // コレクションのドキュメント( QueryDocumentSnapshot<Map<String, dynamic>>)を
    // Indexへ変換。それをListにして、indexListに代入する。
    indexList = document.docs.map((doc) => Index(doc)).toList();
    notifyListeners();
  }

  Future<void> addIndex() async {
    //ここでバリデーションする　13:27
    if (indexTitle.isEmpty) {
      // Linterで指摘うけないように、FormatException使ってみた。
      throw const FormatException('タイトル入力してください。');
    }
    final CollectionReference index = FirebaseFirestore.instance.collection(
      'index',
    );
    await index.add({
      //addの中はcloud_firestore 0.13.6参照　JSONみたいなやつ　Dictionaly型
      'title': indexTitle, //13:08
      'currentTime': testCurrentPostion,
    });
  }
}
