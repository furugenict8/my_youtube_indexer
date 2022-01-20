import 'package:flutter/cupertino.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// ChangeNotifierはChangeNotifierBuilderのcreateのところでコンストラクタがつかわれる。
//　なのでコンストラクタ内でinitすればよさそう。
// salon appと違うけど。
class PlayerModel extends ChangeNotifier {
  PlayerModel() {
    init();
  }

  late Duration _currentPosition;
  late YoutubePlayerController _controller;
  late TextEditingController _addIndexDialogTextController;
  late PlayerState _playerState;
  bool _isPlayerReady = false;

  // playerの初期化
  void init() {
    _controller = YoutubePlayerController(
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

    _currentPosition = Duration.zero;
    _addIndexDialogTextController = TextEditingController();
    _playerState = PlayerState.unknown;
  }

  // youtube_player_flutter_sampleにあるmount propertyにあたるものは
  // とりあえず無視してみます。
  void listener() {
    if (_isPlayerReady && !_controller.value.isFullScreen) {
      _playerState = _controller.value.playerState;
    }
  }

  // YoutubePlayerFlutter参考
  @override
  void dispose() {
    // TODO(me): implement dispose
    _controller.dispose();
    _addIndexDialogTextController.dispose();
    super.dispose();
  }
}

// 以下はValueNotifierを状態管理で使っているバージョン

// ValueListenableBuilderに登録するため
// youtubePlayerControllerNotifierのインスタンスを作る。
YoutubePlayerControllerNotifier youtubePlayerControllerNotifier =
    YoutubePlayerControllerNotifier();

// positionのような変数の状態管理のため、YoutubePlayerControllerをextendsしたClassをつくる
// YoutubePlayerControllerをValueNotifierに見立てる。
class YoutubePlayerControllerNotifier extends YoutubePlayerController {
  YoutubePlayerControllerNotifier()
      : super(
          initialVideoId: 'nPt8bK2gbaU',
          flags: const YoutubePlayerFlags(
            mute: false,
            autoPlay: false,
            disableDragSeek: false,
            loop: false,
            isLive: false,
            forceHD: false,
            enableCaption: true,
          ),
        );

  // 止まった時の時間を保持する変数currentPosition
  Duration currentPosition = Duration.zero;
}

// 検証のため、YoutubePlayerControllerのインスタンス _controllerを用意
// var _controller = YoutubePlayerController(
//   initialVideoId: 'nPt8bK2gbaU',
//   flags: const YoutubePlayerFlags(
//     mute: false,
//     autoPlay: false,
//     disableDragSeek: false,
//     loop: false,
//     isLive: false,
//     forceHD: false,
//     enableCaption: true,
//   ),
// );
