import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import 'package:flutter/material.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:frefresh/frefresh.dart';

import 'package:huynhcodaidao/models/user_token.dart';
import 'package:huynhcodaidao/models/menu_item.dart';
import 'package:huynhcodaidao/models/menu_item_list.dart';
import 'package:huynhcodaidao/models/menu.dart';
import 'package:huynhcodaidao/models/banner.dart' as BannerModel;

import 'package:huynhcodaidao/repositories/menu_repository.dart';

import 'package:huynhcodaidao/services/router_service.dart';

final GetIt getIt = GetIt.instance;

class MenuWidget extends StatefulWidget {
  final String actionUrl;
  final bool fullUrl;

  const MenuWidget({
    Key key,
    this.actionUrl = '/app/menu/danh-muc-chinh',
    this.fullUrl = false,
  }) : super(key: key);

  @override
  State createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget> {
  final Box _appData = Hive.box('appData');
  final MenuRepository _menuRepository = getIt.get<MenuRepository>();
  final FRefreshController _fRefreshController = FRefreshController();

  dynamic _state;
  Future<Menu> _menuFuture;
  Menu _menu;
  MenuItemList _menuItemList;
  List<MenuItem> _menuItems;
  BannerModel.Banner _banner;
  int _page = 1;
  bool _shouldLoad = false;

  @override
  void initState() {
    _fRefreshController.setOnStateChangedCallback((state) => _state = state);

    _menuFuture = _menuRepository.get(
      path: widget.actionUrl,
      fullUrl: widget.fullUrl,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _menuFuture,
      builder: (BuildContext context, AsyncSnapshot<Menu> snapshot) {
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
            _menu = snapshot.data;
            _menuItemList = _menu.menuItemList;
            _menuItems = _menuItemList.data;
            _banner = _menu.banner;

            _page = 1;
            _shouldLoad = _menuItemList.nextPageUrl != null;
          }

          if (_state is LoadState) {
            Menu _nextMenu = snapshot.data;
            MenuItemList _nextMenuItemList = _nextMenu.menuItemList;
            List<MenuItem> _nextMenuItems = _nextMenuItemList.data;

            if (_nextMenuItems.length != 0) {
              _menuItemList.to = _nextMenuItemList.to;
              _menuItems.addAll(_nextMenuItems);
            }

            _page++;
            _shouldLoad = _nextMenuItemList.nextPageUrl != null;
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
            _menuFuture = _menuRepository.get(
              path: widget.actionUrl,
              fullUrl: widget.fullUrl,
            );
            _fRefreshController.finishRefresh();
            setState(() {});
          },
          onLoad: () {
            _menuFuture = _menuRepository.get(
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
              ListView.builder(
                primary: false,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _menuItems == null || _menuItems.length == 0
                    ? 0
                    : _menuItemList.to - _menuItemList.from + 1,
                itemBuilder: (BuildContext context, int index) {
                  MenuItem _menuItem = _menuItems[index];

                  return GestureDetector(
                    onTap: () {
                      print(_menuItem.actionUrl);
                      RouterService.navigateTo(
                        context: context,
                        actionUrl: _menuItem.actionUrl,
                        actionTypeName: _menuItem.actionTypeName,
                        actionTitle: _menuItem.actionTitle,
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(40.sp),
                      margin: EdgeInsets.fromLTRB(10.sp, 5.sp, 10.sp, 5.sp),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.sp),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 2.sp,
                            spreadRadius: 2.sp,
                            offset: Offset(0.sp, 2.sp),
                          ),
                        ],
                      ),
                      child: Row(
                        children: <Widget>[
                          _menuItem.primaryIconUrl == null
                              ? Container(
                                  width: 120.sp,
                                  height: 120.sp,
                                )
                              : Image.network(
                                  _menuItem.primaryIconUrl,
                                  headers: {
                                    'Authorization': 'Bearer ' +
                                        (_appData.get('userToken') as UserToken)
                                            .accessToken,
                                  },
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
                                  _menuItem.title,
                                  style: GoogleFonts.robotoSlab(
                                    fontSize: 48.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                _menuItem.description == null
                                    ? Container()
                                    : Text(
                                        _menuItem.description,
                                        style: GoogleFonts.robotoSlab(
                                          fontSize: 38.sp,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 20.sp,
                          ),
                          Container(
                            padding:
                                EdgeInsets.fromLTRB(20.sp, 10.sp, 20.sp, 10.sp),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(9999.sp),
                            ),
                            child: Center(
                              child: Text(
                                'Mới',
                                style: GoogleFonts.robotoSlab(
                                  color: Colors.white,
                                  fontSize: 32.sp,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20.sp,
                          ),
                          _menuItem.secondaryIconUrl == null
                              ? SizedBox(
                                  width: 100.sp,
                                  height: 100.sp,
                                )
                              : Image.network(
                                  _menuItem.primaryIconUrl,
                                  headers: {
                                    'Authorization': 'Bearer ' +
                                        (_appData.get('userToken') as UserToken)
                                            .accessToken,
                                  },
                                  width: 100.sp,
                                  height: 100.sp,
                                  fit: BoxFit.cover,
                                ),
                          SizedBox(
                            width: 20.sp,
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
