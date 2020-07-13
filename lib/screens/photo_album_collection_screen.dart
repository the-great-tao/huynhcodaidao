import 'package:flutter/material.dart';
import 'package:responsive_widgets/responsive_widgets.dart';

import 'package:huynhcodaidao/ui_components/linear_gradients.dart';

import 'package:huynhcodaidao/widgets/app_bar_02_widget.dart';
import 'package:huynhcodaidao/widgets/photo_album_collection_widget.dart';

class PhotoAlbumCollectionScreen extends StatelessWidget {
  final String actionUrl;
  final String actionTitle;

  const PhotoAlbumCollectionScreen({
    Key key,
    this.actionUrl,
    this.actionTitle,
  })  : assert(actionUrl != null),
        assert(actionTitle != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    ResponsiveWidgets.init(
      context,
      width: 1080,
      height: 1920,
      allowFontScaling: true,
    );

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradients.main,
      ),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar02Widget(
            height: 160.sp,
            title: actionTitle,
          ),
          body: Container(
            child: PhotoAlbumCollectionWidget(
              actionUrl: actionUrl,
              fullUrl: true,
            ),
          ),
        ),
      ),
    );
  }
}
