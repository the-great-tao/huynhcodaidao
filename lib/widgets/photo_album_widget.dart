import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import 'package:flutter/material.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:frefresh/frefresh.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:huynhcodaidao/models/user_token.dart';
import 'package:huynhcodaidao/models/photo_album_item.dart';
import 'package:huynhcodaidao/models/photo_album_page.dart';
import 'package:huynhcodaidao/models/photo_album.dart';

import 'package:huynhcodaidao/repositories/photo_album_repository.dart';

import 'package:huynhcodaidao/ui_components/linear_gradients.dart';

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
  final PageController _photoPageController = PageController();
  final PhotoViewController _photoViewController = PhotoViewController();

  Future<PhotoAlbum> _photoAlbumFuture;
  PhotoAlbum _photoAlbum;
  PhotoAlbumPage _photoAlbumPage;
  List<PhotoAlbumItem> _photoAlbumItems;

  int _page = 1;
  int _photoIndex = 0;

  bool _shouldLoad = false;
  dynamic _loadState;

  @override
  void initState() {
    _photoAlbumFuture = _photoAlbumRepository.get(
      path: widget.actionUrl,
    );

    super.initState();
  }

  @override
  void dispose() {
    _photoPageController.dispose();
    _photoViewController.dispose();

    super.dispose();
  }

  void onPhotoPageChanged(int index) {
    setState(() {
      _photoIndex = index;
      _photoViewController.reset();
    });

    if (_loadState is LoadState && _loadState == LoadState.LOADING) {
      return;
    }
    if (!_shouldLoad || _photoAlbumItems.length - _photoIndex >= 3) {
      return;
    }

    print('Loading more photos...');

    setState(() {
      _loadState = LoadState.LOADING;
      _photoAlbumFuture = _photoAlbumRepository.get(
        path: widget.actionUrl,
        page: _page + 1,
      );
    });
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
          if (_loadState == null) {
            _photoAlbum = snapshot.data;
            _photoAlbumPage = _photoAlbum.photoAlbumPage;
            _photoAlbumItems = _photoAlbumPage.data;

            _page = 1;
            _shouldLoad = _photoAlbumPage.nextPageUrl != null;
          }

          if (_loadState is LoadState && _loadState == LoadState.LOADING) {
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
          }

          _loadState = LoadState.IDLE;
        }

        return Column(
          children: <Widget>[
            Expanded(
              child: ClipRect(
                child: PhotoViewGallery.builder(
                    pageController: _photoPageController,
                    onPageChanged: onPhotoPageChanged,
                    itemCount:
                        _photoAlbumItems == null || _photoAlbumItems.length == 0
                            ? 0
                            : _photoAlbumPage.to - _photoAlbumPage.from + 1,
                    builder: (BuildContext context, int index) {
                      PhotoAlbumItem _photoAlbumItem = _photoAlbumItems[index];

                      return PhotoViewGalleryPageOptions(
                        controller: _photoViewController,
                        heroAttributes: PhotoViewHeroAttributes(
                          tag: _photoAlbumItem.id,
                        ),
                        minScale: PhotoViewComputedScale.contained,
                        maxScale: PhotoViewComputedScale.contained * 5,
                        imageProvider: CachedNetworkImageProvider(
                          _photoAlbumItem.photoUrl,
                          headers: {
                            'Authorization': 'Bearer ' +
                                (_appData.get('userToken') as UserToken)
                                    .accessToken,
                          },
                        ),
                      );
                    },
                    loadingBuilder:
                        (BuildContext context, ImageChunkEvent event) {
                      return Container(
                        color: Colors.black,
                        child: Center(
                          child: SizedBox(
                            width: 120.sp,
                            height: 120.sp,
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.amber),
                              value: event == null
                                  ? 0
                                  : event.cumulativeBytesLoaded /
                                      event.expectedTotalBytes,
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ),
            Container(
              width: 1080.w,
              height: 200.sp,
              color: Colors.black,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Container(
                      height: double.infinity,
                      margin: EdgeInsets.fromLTRB(80.sp, 40.sp, 40.sp, 40.sp),
                      decoration: BoxDecoration(
                        gradient: LinearGradients.main,
                        borderRadius: BorderRadius.all(
                          Radius.circular(9999.sp),
                        ),
                      ),
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 20.sp,
                          ),
                          GestureDetector(
                            onTap: () {
                              _photoViewController.scale /= 1.1;
                            },
                            child: Icon(
                              Icons.zoom_out,
                              color: Colors.white,
                              size: 100.sp,
                            ),
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              _photoViewController.scale *= 1.1;
                            },
                            child: Icon(
                              Icons.zoom_in,
                              color: Colors.white,
                              size: 100.sp,
                            ),
                          ),
                          SizedBox(
                            width: 20.sp,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                      height: double.infinity,
                      margin: EdgeInsets.fromLTRB(40.sp, 40.sp, 80.sp, 40.sp),
                      decoration: BoxDecoration(
                        gradient: LinearGradients.main,
                        borderRadius: BorderRadius.all(
                          Radius.circular(9999.sp),
                        ),
                      ),
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 20.sp,
                          ),
                          GestureDetector(
                            onTap: () {
                              if (_photoIndex <= 0) {
                                return;
                              }

                              _photoPageController.previousPage(
                                duration: Duration(milliseconds: 500),
                                curve: Curves.decelerate,
                              );
                            },
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 100.sp,
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                '${_photoIndex + 1} / ${_photoAlbumPage.total}',
                                style: GoogleFonts.robotoSlab(
                                  color: Colors.white,
                                  fontSize: 60.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (_photoIndex >= _photoAlbumItems.length - 1) {
                                return;
                              }

                              _photoPageController.nextPage(
                                duration: Duration(milliseconds: 500),
                                curve: Curves.decelerate,
                              );
                            },
                            child: Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 100.sp,
                            ),
                          ),
                          SizedBox(
                            width: 20.sp,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
