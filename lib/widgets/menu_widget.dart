import 'package:get_it/get_it.dart';

import 'package:flutter/material.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:frefresh/frefresh.dart';

import 'package:huynhcodaidao/models/menu_item.dart';
import 'package:huynhcodaidao/models/menu_item_list.dart';
import 'package:huynhcodaidao/models/menu.dart';
import 'package:huynhcodaidao/models/banner.dart' as BannerModel;

import 'package:huynhcodaidao/widgets/network_image_widget.dart';
import 'package:huynhcodaidao/widgets/banner_widget.dart';
import 'package:huynhcodaidao/widgets/loading_widget.dart';
import 'package:huynhcodaidao/widgets/label_widget.dart';

import 'package:huynhcodaidao/repositories/menu_repository.dart';

import 'package:huynhcodaidao/services/router_service.dart';

final GetIt getIt = GetIt.instance;

class MenuWidget extends StatefulWidget {
  final String actionUrl;

  const MenuWidget({
    Key key,
    this.actionUrl = '/app/menu/danh-muc-chinh',
  }) : super(key: key);

  @override
  State createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget> {
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
            if (_state is RefreshState) {
              _fRefreshController.finishRefresh();
            }
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
            _fRefreshController.finishLoad();
          }

          _menuFuture = null;
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
          footerHeight: _shouldLoad ? 240.sp : 0,
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
              _menuFuture = _menuRepository.get(
                path: widget.actionUrl,
              );
            });
          },
          onLoad: () {
            setState(() {
              _menuFuture = _menuRepository.get(
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
                itemCount: _menuItems == null || _menuItems.length == 0
                    ? 0
                    : _menuItemList.to - _menuItemList.from + 1,
                itemBuilder: (BuildContext context, int index) {
                  MenuItem _menuItem = _menuItems[index];

                  if (_menuItem.primaryIconUrl == null) {
                    if (_menu != null && _menu.defaultIconUrl != null) {
                      _menuItem.primaryIconUrl = _menu.defaultIconUrl;
                    }
                  }

                  return GestureDetector(
                    onTap: () {
                      RouterService.navigateTo(
                        context: context,
                        actionUrl: _menuItem.actionUrl,
                        actionTypeName: _menuItem.actionTypeName,
                        actionTitle: _menuItem.actionTitle,
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
                          _menuItem.primaryIconUrl == null
                              ? Image.asset(
                                  'assets/default_menu_item_icon.png',
                                  width: 120.sp,
                                  height: 120.sp,
                                )
                              : NetworkImageWidget(
                                  source: _menuItem.primaryIconUrl,
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
                          _menuItem.labelUrl == null
                              ? Container()
                              : LabelWidget(labelUrl: _menuItem.labelUrl),
                          SizedBox(
                            width: 20.sp,
                          ),
                          _menuItem.secondaryIconUrl == null
                              ? Container(
                                  width: 100.sp,
                                  height: 100.sp,
                                  child: Center(
                                    child: Icon(
                                      Icons.navigate_next,
                                      color: Colors.amberAccent,
                                      size: 100.sp,
                                    ),
                                  ),
                                )
                              : NetworkImageWidget(
                                  source: _menuItem.secondaryIconUrl,
                                  width: 100.sp,
                                  height: 100.sp,
                                  fit: BoxFit.cover,
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
