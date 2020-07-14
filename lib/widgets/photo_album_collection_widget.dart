import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import 'package:flutter/material.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:frefresh/frefresh.dart';

import 'package:huynhcodaidao/models/user_token.dart';
import 'package:huynhcodaidao/models/photo_album_list_item.dart';
import 'package:huynhcodaidao/models/photo_album_list.dart';
import 'package:huynhcodaidao/models/photo_album_collection.dart';
import 'package:huynhcodaidao/models/banner.dart' as BannerModel;

import 'package:huynhcodaidao/widgets/banner_widget.dart';

import 'package:huynhcodaidao/repositories/photo_album_collection_repository.dart';

import 'package:huynhcodaidao/services/router_service.dart';

final GetIt getIt = GetIt.instance;

class PhotoAlbumCollectionWidget extends StatefulWidget {
  final String actionUrl;
  final bool fullUrl;

  const PhotoAlbumCollectionWidget({
    Key key,
    this.actionUrl,
    this.fullUrl = true,
  }) : super(key: key);

  @override
  State createState() => _PhotoAlbumCollectionWidgetState();
}

class _PhotoAlbumCollectionWidgetState
    extends State<PhotoAlbumCollectionWidget> {
  final Box _appData = Hive.box('appData');
  final PhotoAlbumCollectionRepository _photoAlbumCollectionRepository =
      getIt.get<PhotoAlbumCollectionRepository>();
  final FRefreshController _fRefreshController = FRefreshController();

  dynamic _state;
  Future<PhotoAlbumCollection> _photoAlbumCollectionFuture;
  PhotoAlbumCollection _photoAlbumCollection;
  PhotoAlbumList _photoAlbumList;
  List<PhotoAlbumListItem> _photoAlbumListItems;
  BannerModel.Banner _banner;
  int _page = 1;
  bool _shouldLoad = false;

  @override
  void initState() {
    _fRefreshController.setOnStateChangedCallback((state) => _state = state);

    _photoAlbumCollectionFuture = _photoAlbumCollectionRepository.get(
      path: widget.actionUrl,
      fullUrl: widget.fullUrl,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _photoAlbumCollectionFuture,
      builder:
          (BuildContext context, AsyncSnapshot<PhotoAlbumCollection> snapshot) {
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
            _photoAlbumCollection = snapshot.data;
            _photoAlbumList = _photoAlbumCollection.photoAlbumList;
            _photoAlbumListItems = _photoAlbumList.data;
            _banner = _photoAlbumCollection.banner;

            _page = 1;
            _shouldLoad = _photoAlbumList.nextPageUrl != null;
          }

          if (_state is LoadState) {
            PhotoAlbumCollection _nextPhotoAlbumCollection = snapshot.data;
            PhotoAlbumList _nextPhotoAlbumList =
                _nextPhotoAlbumCollection.photoAlbumList;
            List<PhotoAlbumListItem> _nextPhotoAlbumListItems =
                _nextPhotoAlbumList.data;

            if (_nextPhotoAlbumListItems.length != 0) {
              _photoAlbumList.to = _nextPhotoAlbumList.to;
              _photoAlbumListItems.addAll(_nextPhotoAlbumListItems);
            }

            _page++;
            _shouldLoad = _nextPhotoAlbumList.nextPageUrl != null;
          }
        }

        return FRefresh(
          controller: _fRefreshController,
          header: Container(
            width: 1080.w,
            height: 50.sp,
            child: LinearProgressIndicator(
              backgroundColor: Colors.amberAccent,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
            ),
          ),
          headerHeight: 50.sp,
          footer: _shouldLoad
              ? LinearProgressIndicator(
                  backgroundColor: Colors.amberAccent,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                )
              : null,
          footerHeight: 50.sp,
          onRefresh: () {
            _photoAlbumCollectionFuture = _photoAlbumCollectionRepository.get(
              path: widget.actionUrl,
              fullUrl: widget.fullUrl,
            );
            _fRefreshController.finishRefresh();
            setState(() {});
          },
          onLoad: () {
            _photoAlbumCollectionFuture = _photoAlbumCollectionRepository.get(
              path: widget.actionUrl,
              page: _page + 1,
              fullUrl: widget.fullUrl,
            );
            _fRefreshController.finishLoad();
            setState(() {});
          },
          shouldLoad: _shouldLoad,
          child: Column(
            children: <Widget>[
              BannerWidget(
                banner: _banner,
                margin: EdgeInsets.only(
                  bottom: 50.sp,
                ),
              ),
              GridView.builder(
                primary: false,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.66,
                ),
                itemCount: _photoAlbumListItems == null ||
                        _photoAlbumListItems.length == 0
                    ? 0
                    : _photoAlbumList.to - _photoAlbumList.from + 1,
                itemBuilder: (BuildContext context, int index) {
                  PhotoAlbumListItem _photoAlbumListItem =
                      _photoAlbumListItems[index];

                  if (_photoAlbumListItem.coverUrl == null) {
                    if (_photoAlbumCollection != null &&
                        _photoAlbumCollection.defaultIconUrl != null) {
                      _photoAlbumListItem.coverUrl =
                          _photoAlbumCollection.defaultIconUrl;
                    }
                  }

                  return GestureDetector(
                    onTap: () {
                      RouterService.navigateTo(
                        context: context,
                        actionUrl: _photoAlbumListItem.actionUrl,
                        actionTypeName: _photoAlbumListItem.actionTypeName,
                        actionTitle: _photoAlbumListItem.actionTitle,
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.fromLTRB(40.sp, 40.sp, 40.sp, 25.sp),
                      margin: index % 2 == 0
                          ? EdgeInsets.fromLTRB(50.sp, 5.sp, 25.sp, 45.sp)
                          : EdgeInsets.fromLTRB(25.sp, 5.sp, 50.sp, 45.sp),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.amber,
                          width: 1.sp,
                        ),
                        borderRadius: BorderRadius.circular(25.sp),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5.sp,
                            spreadRadius: 1.sp,
                            offset: Offset(0.sp, 5.sp),
                          ),
                        ],
                      ),
                      child: Column(
                        children: <Widget>[
                          _photoAlbumListItem.coverUrl == null
                              ? Image.asset(
                                  'assets/default_menu_item_icon.png',
                                  width: 400.sp,
                                  height: 550.sp,
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  _photoAlbumListItem.coverUrl,
                                  headers: {
                                    'Authorization': 'Bearer ' +
                                        (_appData.get('userToken') as UserToken)
                                            .accessToken,
                                  },
                                  width: 400.sp,
                                  height: 550.sp,
                                  fit: BoxFit.cover,
                                ),
                          SizedBox(
                            height: 25.sp,
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                _photoAlbumListItem.title,
                                style: GoogleFonts.robotoSlab(
                                  fontSize: 42.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
