import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import 'package:flutter/material.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:frefresh/frefresh.dart';

import 'package:huynhcodaidao/models/user_token.dart';
import 'package:huynhcodaidao/models/audio_album_list_item.dart';
import 'package:huynhcodaidao/models/audio_album_list.dart';
import 'package:huynhcodaidao/models/audio_album_collection.dart';
import 'package:huynhcodaidao/models/banner.dart' as BannerModel;

import 'package:huynhcodaidao/repositories/audio_album_collection_repository.dart';

import 'package:huynhcodaidao/services/router_service.dart';

final GetIt getIt = GetIt.instance;

class AudioAlbumCollectionWidget extends StatefulWidget {
  final String actionUrl;
  final bool fullUrl;

  const AudioAlbumCollectionWidget({
    Key key,
    this.actionUrl,
    this.fullUrl = true,
  }) : super(key: key);

  @override
  State createState() => _AudioAlbumCollectionWidgetState();
}

class _AudioAlbumCollectionWidgetState
    extends State<AudioAlbumCollectionWidget> {
  final Box _appData = Hive.box('appData');
  final AudioAlbumCollectionRepository _audioAlbumCollectionRepository =
      getIt.get<AudioAlbumCollectionRepository>();
  final FRefreshController _fRefreshController = FRefreshController();

  dynamic _state;
  Future<AudioAlbumCollection> _audioAlbumCollectionFuture;
  AudioAlbumCollection _audioAlbumCollection;
  AudioAlbumList _audioAlbumList;
  List<AudioAlbumListItem> _audioAlbumListItems;
  BannerModel.Banner _banner;
  int _page = 1;
  bool _shouldLoad = false;

  @override
  void initState() {
    _fRefreshController.setOnStateChangedCallback((state) => _state = state);

    _audioAlbumCollectionFuture = _audioAlbumCollectionRepository.get(
      path: widget.actionUrl,
      fullUrl: widget.fullUrl,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _audioAlbumCollectionFuture,
      builder:
          (BuildContext context, AsyncSnapshot<AudioAlbumCollection> snapshot) {
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
            _audioAlbumCollection = snapshot.data;
            _audioAlbumList = _audioAlbumCollection.audioAlbumList;
            _audioAlbumListItems = _audioAlbumList.data;
            _banner = _audioAlbumCollection.banner;

            _page = 1;
            _shouldLoad = _audioAlbumList.nextPageUrl != null;
          }

          if (_state is LoadState) {
            AudioAlbumCollection _nextAudioAlbumCollection = snapshot.data;
            AudioAlbumList _nextAudioAlbumList =
                _nextAudioAlbumCollection.audioAlbumList;
            List<AudioAlbumListItem> _nextAudioAlbumListItems =
                _nextAudioAlbumList.data;

            if (_nextAudioAlbumListItems.length != 0) {
              _audioAlbumList.to = _nextAudioAlbumList.to;
              _audioAlbumListItems.addAll(_nextAudioAlbumListItems);
            }

            _page++;
            _shouldLoad = _nextAudioAlbumList.nextPageUrl != null;
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
            _audioAlbumCollectionFuture = _audioAlbumCollectionRepository.get(
              path: widget.actionUrl,
              fullUrl: widget.fullUrl,
            );
            _fRefreshController.finishRefresh();
            setState(() {});
          },
          onLoad: () {
            _audioAlbumCollectionFuture = _audioAlbumCollectionRepository.get(
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
              GestureDetector(
                onTap: () {
                  print(_banner != null ? _banner.actionUrl : null);
                  RouterService.navigateTo(
                    context: context,
                    actionUrl: _banner.actionUrl,
                    actionTypeName: _banner.actionTypeName,
                    actionTitle: _banner.actionTitle,
                  );
                },
                child: Container(
                  width: 1080.sp,
                  padding: EdgeInsets.only(bottom: 50.sp),
                  child: _banner == null
                      ? Container()
                      : Image.network(
                          _banner.url,
                          headers: {
                            'Authorization': 'Bearer ' +
                                (_appData.get('userToken') as UserToken)
                                    .accessToken,
                          },
                          fit: BoxFit.fitWidth,
                        ),
                ),
              ),
              GridView.builder(
                primary: false,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                ),
                itemCount: _audioAlbumListItems == null ||
                        _audioAlbumListItems.length == 0
                    ? 0
                    : _audioAlbumList.to - _audioAlbumList.from + 1,
                itemBuilder: (BuildContext context, int index) {
                  AudioAlbumListItem _audioAlbumListItem =
                      _audioAlbumListItems[index];

                  if (_audioAlbumListItem.coverUrl == null) {
                    if (_audioAlbumCollection != null &&
                        _audioAlbumCollection.defaultIconUrl != null) {
                      _audioAlbumListItem.coverUrl =
                          _audioAlbumCollection.defaultIconUrl;
                    }
                  }

                  return GestureDetector(
                    onTap: () {
                      print(_audioAlbumListItem.actionUrl);
                      RouterService.navigateTo(
                        context: context,
                        actionUrl: _audioAlbumListItem.actionUrl,
                        actionTypeName: _audioAlbumListItem.actionTypeName,
                        actionTitle: _audioAlbumListItem.actionTitle,
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.fromLTRB(40.sp, 50.sp, 40.sp, 50.sp),
                      margin: index % 2 == 0
                          ? EdgeInsets.fromLTRB(50.sp, 5.sp, 25.sp, 45.sp)
                          : EdgeInsets.fromLTRB(25.sp, 5.sp, 50.sp, 45.sp),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25.sp),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4.sp,
                            spreadRadius: 4.sp,
                          ),
                        ],
                      ),
                      child: Column(
                        children: <Widget>[
                          _audioAlbumListItem.coverUrl == null
                              ? Image.asset(
                                  'assets/default_menu_item_icon.png',
                                  width: 400.sp,
                                  height: 400.sp,
                                )
                              : Image.network(
                                  _audioAlbumListItem.coverUrl,
                                  headers: {
                                    'Authorization': 'Bearer ' +
                                        (_appData.get('userToken') as UserToken)
                                            .accessToken,
                                  },
                                  width: 400.sp,
                                  height: 400.sp,
                                  fit: BoxFit.contain,
                                ),
                          SizedBox(
                            height: 40.sp,
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                _audioAlbumListItem.title,
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
