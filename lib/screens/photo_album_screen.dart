import 'package:flutter/material.dart';

import 'package:huynhcodaidao/screens/base_screen.dart';

import 'package:huynhcodaidao/widgets/photo_album_widget.dart';

class PhotoAlbumScreen extends StatelessWidget {
  final String actionTitle;
  final String actionUrl;

  const PhotoAlbumScreen({
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
      body: PhotoAlbumWidget(
        actionUrl: actionUrl,
      ),
    );
  }
}
