import 'package:get_it/get_it.dart';

import 'package:flutter/material.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:frefresh/frefresh.dart';

import 'package:huynhcodaidao/modules/message/message.dart';
import 'package:huynhcodaidao/modules/message/message_list.dart';
import 'package:huynhcodaidao/modules/message/message_category.dart';
import 'package:huynhcodaidao/models/banner.dart' as BannerModel;

import 'package:huynhcodaidao/widgets/network_image_widget.dart';
import 'package:huynhcodaidao/widgets/banner_widget.dart';
import 'package:huynhcodaidao/widgets/loading_widget.dart';
import 'package:huynhcodaidao/widgets/label_widget.dart';

import 'package:huynhcodaidao/modules/message/message_category_repository.dart';

import 'package:huynhcodaidao/services/router_service.dart';

final GetIt getIt = GetIt.instance;

class MessageCategoryWidget extends StatefulWidget {
  final String actionUrl;

  const MessageCategoryWidget({
    Key key,
    this.actionUrl = '/app/messages/thong-bao',
  }) : super(key: key);

  @override
  State createState() => _MessageCategoryWidgetState();
}

class _MessageCategoryWidgetState extends State<MessageCategoryWidget> {
  final MessageCategoryRepository _messageCategoryRepository =
      getIt.get<MessageCategoryRepository>();
  final FRefreshController _fRefreshController = FRefreshController();

  dynamic _state;
  Future<MessageCategory> _messageCategoryFuture;
  MessageCategory _messageCategory;
  MessageList _messageList;
  List<Message> _messages;
  BannerModel.Banner _banner;
  int _page = 1;
  bool _shouldLoad = false;

  @override
  void initState() {
    _fRefreshController.setOnStateChangedCallback((state) => _state = state);

    _messageCategoryFuture = _messageCategoryRepository.get(
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
      future: _messageCategoryFuture,
      builder: (BuildContext context, AsyncSnapshot<MessageCategory> snapshot) {
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
            _messageCategory = snapshot.data;
            _messageList = _messageCategory.messages;
            _messages = _messageList.data;
            _banner = _messageCategory.banner;

            _page = 1;
            _shouldLoad = _messageList.nextPageUrl != null;
            if (_state is RefreshState) {
              _fRefreshController.finishRefresh();
            }
          }

          if (_state is LoadState) {
            MessageCategory _nextMessageCategory = snapshot.data;
            MessageList _nextMessageList = _nextMessageCategory.messages;
            List<Message> _nextMessages = _nextMessageList.data;

            if (_nextMessages.length != 0) {
              _messageList.to = _nextMessageList.to;
              _messages.addAll(_nextMessages);
            }

            _page++;
            _shouldLoad = _nextMessageList.nextPageUrl != null;
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
              _messageCategoryFuture = _messageCategoryRepository.get(
                path: widget.actionUrl,
              );
            });
          },
          onLoad: () {
            setState(() {
              _messageCategoryFuture = _messageCategoryRepository.get(
                path: widget.actionUrl,
                page: _page + 1,
              );
            });
          },
          shouldLoad: _shouldLoad,
          child: Column(
            children: <Widget>[
              BannerWidget(
                banner: _banner,
                margin: EdgeInsets.only(
                  bottom: 16.sp,
                ),
              ),
              ListView.builder(
                primary: false,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _messages == null || _messages.length == 0
                    ? 0
                    : _messageList.to - _messageList.from + 1,
                itemBuilder: (BuildContext context, int index) {
                  Message _message = _messages[index];

                  if (_message.customStyle.primaryIconUrl == null) {
                    if (_messageCategory != null &&
                        _messageCategory.defaultStyle != null) {
                      _message.customStyle.primaryIconUrl =
                          _messageCategory.defaultStyle.primaryIconUrl;
                    }
                  }

                  return GestureDetector(
                    onTap: () {
                      RouterService.navigateTo(
                        context: context,
                        actionUrl: _message.actionUrl,
                        actionTypeName: _message.actionTypeName,
                        actionTitle: _message.actionTitle,
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.fromLTRB(40.sp, 40.sp, 20.sp, 40.sp),
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
                          _message.customStyle.primaryIconUrl == null
                              ? Image.asset(
                                  'assets/default_message_icon.png',
                                  width: 120.sp,
                                  height: 120.sp,
                                )
                              : NetworkImageWidget(
                                  source: _message.customStyle.primaryIconUrl,
                                  width: 120.sp,
                                  height: 120.sp,
                                  fit: BoxFit.cover,
                                ),
                          SizedBox(
                            width: 40.sp,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _message.title,
                                  style: GoogleFonts.robotoSlab(
                                    fontSize: 48.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                _message.content == null
                                    ? Container()
                                    : Text(
                                        _message.content,
                                        style: GoogleFonts.robotoSlab(
                                          fontSize: 38.sp,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                              ],
                            ),
                          ),
                          // SizedBox(
                          //   width: 20.sp,
                          // ),
                          // _menuItem.labelUrl == null
                          //     ? Container()
                          //     : LabelWidget(labelUrl: _menuItem.labelUrl),
                          // SizedBox(
                          //   width: 20.sp,
                          // ),
                          // _menuItem.secondaryIconUrl == null
                          //     ? Container(
                          //         width: 100.sp,
                          //         height: 100.sp,
                          //         child: Center(
                          //           child: Icon(
                          //             Icons.navigate_next,
                          //             color: Colors.amberAccent,
                          //             size: 100.sp,
                          //           ),
                          //         ),
                          //       )
                          //     : NetworkImageWidget(
                          //         source: _menuItem.secondaryIconUrl,
                          //         width: 100.sp,
                          //         height: 100.sp,
                          //         fit: BoxFit.cover,
                          //       ),
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
