import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import 'package:flutter/material.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:frefresh/frefresh.dart';
import 'package:photo_view/photo_view.dart';

import 'package:huynhcodaidao/models/user_token.dart';
import 'package:huynhcodaidao/models/photo_album_item.dart';
import 'package:huynhcodaidao/models/photo_album_page.dart';
import 'package:huynhcodaidao/models/photo_album.dart';

import 'package:huynhcodaidao/repositories/photo_album_repository.dart';

final GetIt getIt = GetIt.instance;

class PhotoAlbumWidget extends StatefulWidget {
  final String actionUrl;

  const PhotoAlbumWidget({
    Key key,
    this.actionUrl,
  }) : super(key: key);

  @override
  State createState() => _PhotoAlbumWidgetState();
}

class _PhotoAlbumWidgetState extends State<PhotoAlbumWidget> {
  final Box _appData = Hive.box('appData');
  final PhotoAlbumRepository _photoAlbumRepository =
      getIt.get<PhotoAlbumRepository>();
  final RefreshController _refreshController = RefreshController();

  dynamic _state;
  Future<PhotoAlbum> _photoAlbumFuture;
  PhotoAlbum _photoAlbum;
  PhotoAlbumPage _photoAlbumPage;
  List<PhotoAlbumItem> _photoAlbumItems;
  int _page = 1;
  bool _shouldLoad = false;

  @override
  void initState() {
    _photoAlbumFuture = _photoAlbumRepository.get(
      path: widget.actionUrl,
    );

    super.initState();
  }

  @override
  void dispose() {
    _refreshController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _photoAlbumFuture,
      builder: (BuildContext context, AsyncSnapshot<PhotoAlbum> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: SpinKitFadingCircle(
              size: 120.sp,
              color: Colors.amber,
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          if (_state == null || _state is RefreshState) {
            _photoAlbum = snapshot.data;
            _photoAlbumPage = _photoAlbum.photoAlbumPage;
            _photoAlbumItems = _photoAlbumPage.data;

            _page = 1;
            _shouldLoad = _photoAlbumPage.nextPageUrl != null;
            if (_state is RefreshState) {
              _refreshController.refreshCompleted();
            }
          }

          if (_state is LoadState) {
            PhotoAlbum _nextPhotoAlbum = snapshot.data;
            PhotoAlbumPage _nextPhotoAlbumPage = _nextPhotoAlbum.photoAlbumPage;
            List<PhotoAlbumItem> _nextPhotoAlbumItems =
                _nextPhotoAlbumPage.data;

            if (_nextPhotoAlbumItems.length != 0) {
              _photoAlbumPage.to = _nextPhotoAlbumPage.to;
              _photoAlbumItems.addAll(_nextPhotoAlbumItems);
            }

            _page++;
            _shouldLoad = _nextPhotoAlbumPage.nextPageUrl != null;
            _refreshController.loadComplete();
          }
        }

        return SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          controller: _refreshController,
          scrollDirection: Axis.horizontal,
          physics: PageScrollPhysics(),
          footer: ClassicFooter(
            iconPos: IconPosition.top,
            outerBuilder: (child) {
              return Container(
                child: Center(
                  child: child,
                ),
              );
            },
          ),
          header: ClassicHeader(
            iconPos: IconPosition.top,
            outerBuilder: (child) {
              return Container(
                child: Center(
                  child: child,
                ),
              );
            },
          ),
          onRefresh: () {
            _state = RefreshState.REFRESHING;
            _photoAlbumFuture = _photoAlbumRepository.get(
              path: widget.actionUrl,
            );
            setState(() {});
          },
          onLoading: () {
            _state = LoadState.LOADING;
            _photoAlbumFuture = _photoAlbumRepository.get(
              path: widget.actionUrl,
              page: _page + 1,
            );
            setState(() {});
          },
          child: ListView.builder(
            itemCount: _photoAlbumItems == null || _photoAlbumItems.length == 0
                ? 0
                : _photoAlbumPage.to - _photoAlbumPage.from + 1,
            itemBuilder: (BuildContext context, int index) {
              PhotoAlbumItem _photoAlbumItem = _photoAlbumItems[index];

              return Container(
                width: 1080.sp,
                color: Colors.black,
                child: PhotoView(
                  backgroundDecoration: BoxDecoration(color: Colors.black),
                  imageProvider: CachedNetworkImageProvider(
                    _photoAlbumItem.photoUrl,
                    headers: {
                      'Authorization': 'Bearer ' +
                          (_appData.get('userToken') as UserToken).accessToken,
                    },
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
