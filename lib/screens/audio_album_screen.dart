import 'package:flutter/material.dart';

import 'package:huynhcodaidao/screens/base_screen.dart';

import 'package:huynhcodaidao/widgets/audio_album_widget.dart';

class AudioAlbumScreen extends StatelessWidget {
  final String actionTitle;
  final String actionUrl;

  const AudioAlbumScreen({
    Key key,
    this.actionTitle,
    this.actionUrl,
  })  : assert(actionTitle != null),
        assert(actionUrl != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: actionTitle,
      body: AudioAlbumWidget(
        actionUrl: actionUrl,
      ),
    );
  }
}
