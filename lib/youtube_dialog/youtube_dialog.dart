import 'package:flutter/material.dart';
import 'package:my_youtube_indexer/domain/youtube.dart';
import 'package:my_youtube_indexer/youtube_dialog/youtube_dialog_model.dart';
import 'package:provider/provider.dart';

import '../youtube_list/youtube_list_model.dart';

class YoutubeDialog extends StatelessWidget {
  const YoutubeDialog({
    Key? key,
    required this.usersYoutubeActionState,
    this.youtube,
  }) : super(key: key);

  //　add, update, deleteを判別するためのenum　UsersYoutubeActionState
  final UsersYoutubeActionState usersYoutubeActionState;
  // Youtubeを受け取る
  final Youtube? youtube;

  @override
  Widget build(BuildContext context) {
    // PlayerModelを使い回す。
    return ChangeNotifierProvider<YoutubeDialogModel>(
      create: (_) => YoutubeDialogModel(),
      child: AlertDialog(
        content: Consumer<YoutubeDialogModel>(
          builder: (context, model, child) {
            // Dialog画面をupdate、delete、addで条件分岐してそれぞれ表示
            switch (usersYoutubeActionState) {
              case UsersYoutubeActionState.add:
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: model.youtubeDialogTextEditingController,
                      decoration: const InputDecoration(
                        hintText: 'videoId',
                      ),
                      autofocus: true,
                      keyboardType: TextInputType.text,
                    ),
                  ],
                );

              case UsersYoutubeActionState.update:
                model.youtubeDialogTextEditingController.text =
                    youtube!.videoId;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: model.youtubeDialogTextEditingController,
                      autofocus: true,
                      keyboardType: TextInputType.text,
                    ),
                  ],
                );
              case UsersYoutubeActionState.delete:
                model.youtubeDialogTextEditingController.text =
                    youtube!.videoId;
                return Text(
                    '『${model.youtubeDialogTextEditingController.text}』を削除してもよろしいですか？');
            }
          },
        ),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('キャンセル'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          //　isUpdated、isDeleted、それ以外(add)でボタンの動作を変える。
          Consumer<YoutubeDialogModel>(
            builder: (context, model, child) {
              switch (usersYoutubeActionState) {
                case UsersYoutubeActionState.add:
                  return ElevatedButton(
                    child: Text('追加'),
                    onPressed: () async {
                      await addYoutube(context, model);
                    },
                  );
                case UsersYoutubeActionState.update:
                  return ElevatedButton(
                    child: Text('更新'),
                    onPressed: () async {
                      await updateIndex(context, model);
                    },
                  );
                case UsersYoutubeActionState.delete:
                  return ElevatedButton(
                    child: Text('削除'),
                    onPressed: () async {
                      await deleteYoutube(context, model);
                    },
                  );
              }
            },
          ),
        ],
      ),
    );
  }

  // indexを追加する時の処理。
  Future<void> addYoutube(
      BuildContext context, YoutubeDialogModel model) async {
    try {
      // 入力フォームに入力された文字をmodelのindexTitleに入れる。
      model.videoId = model.youtubeDialogTextEditingController.text;

      await model.addYoutube();
      Navigator.of(context).pop(model.videoId);
    } on FormatException catch (e) {
      await showDialog<AlertDialog>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(e.message.toString()),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  // indexを更新する時の処理。
  Future<void> updateIndex(
      BuildContext context, YoutubeDialogModel model) async {
    try {
      // 入力フォームに入力された文字をmodelのindexTitleに入れる。
      model.videoId = model.youtubeDialogTextEditingController.text;

      await model.updateYoutube(youtube!);
      Navigator.of(context).pop(model.videoId);
    } on FormatException catch (e) {
      await showDialog<AlertDialog>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(e.message.toString()),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  // indexを追加する時の処理。
  Future<void> deleteYoutube(
      BuildContext context, YoutubeDialogModel model) async {
    //　選択されたListTileのindexを表示
    await model.deleteYoutube(youtube!);
    Navigator.of(context).pop(model.deletedVideoId);
  }
}
