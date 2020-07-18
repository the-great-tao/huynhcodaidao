import 'package:get_it/get_it.dart';

import 'package:flutter/material.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:frefresh/frefresh.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import 'package:huynhcodaidao/models/audio_album_item.dart';
import 'package:huynhcodaidao/models/audio_album_page.dart';
import 'package:huynhcodaidao/models/audio_album.dart';

import 'package:huynhcodaidao/widgets/network_image_widget.dart';
import 'package:huynhcodaidao/widgets/loading_widget.dart';

import 'package:huynhcodaidao/repositories/audio_album_repository.dart';

import 'package:huynhcodaidao/services/router_service.dart';

final GetIt getIt = GetIt.instance;

class AudioAlbumWidget extends StatefulWidget {
  final String actionUrl;

  const AudioAlbumWidget({
    Key key,
    this.actionUrl,
  }) : super(key: key);

  @override
  State createState() => _AudioAlbumWidgetState();
}

class _AudioAlbumWidgetState extends State<AudioAlbumWidget> {
  final AudioAlbumRepository _audioAlbumRepository =
      getIt.get<AudioAlbumRepository>();
  final FRefreshController _fRefreshController = FRefreshController();

  dynamic _state;
  Future<AudioAlbum> _audioAlbumFuture;
  AudioAlbum _audioAlbum;
  AudioAlbumPage _audioAlbumPage;
  List<AudioAlbumItem> _audioAlbumItems;
  int _page = 1;
  bool _shouldLoad = false;

  @override
  void initState() {
    _fRefreshController.setOnStateChangedCallback((state) => _state = state);

    _audioAlbumFuture = _audioAlbumRepository.get(
      path: widget.actionUrl,
    );

    super.initState();
  }

  @override
  void dispose() {
    _fRefreshController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _audioAlbumFuture,
      builder: (BuildContext context, AsyncSnapshot<AudioAlbum> snapshot) {
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
            _audioAlbum = snapshot.data;
            _audioAlbumPage = _audioAlbum.audioAlbumPage;
            _audioAlbumItems = _audioAlbumPage.data;

            _page = 1;
            _shouldLoad = _audioAlbumPage.nextPageUrl != null;
            if (_state is RefreshState) {
              _fRefreshController.finishRefresh();
            }
          }

          if (_state is LoadState) {
            AudioAlbum _nextAudioAlbum = snapshot.data;
            AudioAlbumPage _nextAudioAlbumPage = _nextAudioAlbum.audioAlbumPage;
            List<AudioAlbumItem> _nextAudioAlbumItems =
                _nextAudioAlbumPage.data;

            if (_nextAudioAlbumItems.length != 0) {
              _audioAlbumPage.to = _nextAudioAlbumPage.to;
              _audioAlbumItems.addAll(_nextAudioAlbumItems);
            }

            _page++;
            _shouldLoad = _nextAudioAlbumPage.nextPageUrl != null;
            _fRefreshController.finishLoad();
          }
        }

        return FRefresh(
          controller: _fRefreshController,
          headerHeight: 80.sp,
          headerTrigger: 240.sp,
          headerBuilder: (StateSetter setter, BoxConstraints constraints) {
            return _state is RefreshState && _state != RefreshState.IDLE
                ? LoadingWidget(height: 80.sp)
                : Container();
          },
          footerHeight: _shouldLoad ? 100.sp : 0,
          footerTrigger: 80.sp,
          footerBuilder: (StateSetter setter) {
            return _shouldLoad &&
                    _state is LoadState &&
                    _state != LoadState.IDLE
                ? LoadingWidget(height: 80.sp)
                : Container();
          },
          onRefresh: () {
            setState(() {
              _audioAlbumFuture = _audioAlbumRepository.get(
                path: widget.actionUrl,
              );
            });
          },
          onLoad: () {
            setState(() {
              _audioAlbumFuture = _audioAlbumRepository.get(
                path: widget.actionUrl,
                page: _page + 1,
              );
            });
          },
          shouldLoad: _shouldLoad,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 16.sp,
              ),
              ListView.builder(
                primary: false,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount:
                    _audioAlbumItems == null || _audioAlbumItems.length == 0
                        ? 0
                        : _audioAlbumPage.to - _audioAlbumPage.from + 1,
                itemBuilder: (BuildContext context, int index) {
                  AudioAlbumItem _audioAlbumItem = _audioAlbumItems[index];

                  if (_audioAlbumItem.iconUrl == null) {
                    if (_audioAlbum != null &&
                        _audioAlbum.defaultIconUrl != null) {
                      _audioAlbumItem.iconUrl = _audioAlbum.defaultIconUrl;
                    }
                  }

                  return GestureDetector(
                    onTap: () {
                      RouterService.navigateTo(
                        context: context,
                        actionUrl: _audioAlbumItem.actionUrl,
                        actionTypeName: _audioAlbumItem.actionTypeName,
                        actionTitle: _audioAlbumItem.actionTitle,
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.fromLTRB(30.sp, 40.sp, 20.sp, 40.sp),
                      margin: EdgeInsets.fromLTRB(16.sp, 0, 16.sp, 16.sp),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.sp),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4.sp,
                            spreadRadius: 2.sp,
                          ),
                        ],
                      ),
                      child: Row(
                        children: <Widget>[
                          _audioAlbumItem.iconUrl == null
                              ? Image.asset(
                                  'assets/default_menu_item_icon.png',
                                  width: 120.sp,
                                  height: 120.sp,
                                )
                              : NetworkImageWidget(
                                  source: _audioAlbumItem.iconUrl,
                                  width: 120.sp,
                                  height: 120.sp,
                                  fit: BoxFit.cover,
                                ),
                          SizedBox(
                            width: 30.sp,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _audioAlbumItem.title,
                                  style: GoogleFonts.robotoSlab(
                                    fontSize: 48.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                _audioAlbumItem.artist == null ||
                                        _audioAlbumItem.artist == ''
                                    ? Container()
                                    : Text(
                                        _audioAlbumItem.artist,
                                        style: GoogleFonts.robotoSlab(
                                          fontSize: 38.sp,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                _audioAlbumItem.description == null ||
                                        _audioAlbumItem.description == ''
                                    ? Container()
                                    : Text(
                                        _audioAlbumItem.description,
                                        style: GoogleFonts.robotoSlab(
                                          fontSize: 38.sp,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 10.sp,
                          ),
                          _audioAlbumItem.audioUrl == null
                              ? Container(
                                  width: 100.sp,
                                  height: 100.sp,
                                  child: Center(
                                    child: Icon(
                                      FontAwesome.volume_up,
                                      color: Colors.black.withOpacity(0.1),
                                      size: 100.sp,
                                    ),
                                  ),
                                )
                              : Container(
                                  width: 100.sp,
                                  height: 100.sp,
                                  child: Center(
                                    child: Icon(
                                      FontAwesome.volume_up,
                                      color: Colors.black.withOpacity(0.7),
                                      size: 100.sp,
                                    ),
                                  ),
                                ),
                          SizedBox(
                            width: 10.sp,
                          ),
                          _audioAlbumItem.actionUrl == null
                              ? Container(
                                  width: 100.sp,
                                  height: 100.sp,
                                  child: Center(
                                    child: Icon(
                                      Ionicons.ios_paper,
                                      color: Colors.black.withOpacity(0.1),
                                      size: 100.sp,
                                    ),
                                  ),
                                )
                              : Container(
                                  width: 100.sp,
                                  height: 100.sp,
                                  child: Center(
                                    child: Icon(
                                      Ionicons.ios_paper,
                                      color: Colors.black.withOpacity(0.7),
                                      size: 100.sp,
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
