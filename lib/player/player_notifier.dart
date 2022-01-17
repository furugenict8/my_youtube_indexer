import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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
