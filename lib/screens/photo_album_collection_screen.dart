import 'package:flutter/material.dart';

import 'package:huynhcodaidao/screens/base_screen.dart';

import 'package:huynhcodaidao/widgets/photo_album_collection_widget.dart';

class PhotoAlbumCollectionScreen extends StatelessWidget {
  final String actionTitle;
  final String actionUrl;

  const PhotoAlbumCollectionScreen({
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
      body: PhotoAlbumCollectionWidget(
        actionUrl: actionUrl,
      ),
    );
  }
}
