import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:frefresh/frefresh.dart';

import 'package:huynhcodaidao/models/user_token.dart';
import 'package:huynhcodaidao/models/menu_item.dart';
import 'package:huynhcodaidao/models/menu_item_list.dart';
import 'package:huynhcodaidao/models/menu.dart';
import 'package:huynhcodaidao/repositories/menu_repository.dart';

class MenuWidget extends StatefulWidget {
  @override
  State createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget> {
  final Box _appData = Hive.box('appData');
  final Logger _logger = Logger();
  final MenuRepository _menuRepository = MenuRepository();
  final FRefreshController _fRefreshController = FRefreshController();

  Menu _menu;
  MenuItemList _menuItemList;
  List<MenuItem> _menuItems;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _menuRepository.get(slug: 'danh-muc-chinh'),
      builder: (BuildContext context, AsyncSnapshot<Menu> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: SpinKitFadingCircle(
              size: 120.sp,
              color: Colors.amber,
            ),
          );
        }

        _menu = snapshot.data;
        _menuItemList = _menu.menuItemList;
        _menuItems = _menuItemList.data;

        return ListView.builder(
          itemCount: _menuItemList.total,
          itemBuilder: (BuildContext context, int index) {
            MenuItem _menuItem = _menuItems[index];
//            _logger.i(_menuItem.toJson());

            List<Widget> titles = [
              Text(
                _menuItem.title,
                style: GoogleFonts.robotoSlab(
                  fontSize: 50.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _menuItem.description == null
                  ? Container()
                  : Text(
                      _menuItem.description,
                      style: GoogleFonts.robotoSlab(
                        fontSize: 40.sp,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
            ];

            return Container(
//              height: 180.sp,
              padding: EdgeInsets.only(
                top: 40.sp,
                bottom: 40.sp,
              ),
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
                  SizedBox(
                    width: 40.sp,
                  ),
                  Image.network(
                    _menuItem.primaryIconUrl,
                    headers: {
                      'Authorization': 'Bearer ' +
                          (_appData.get('userToken') as UserToken).accessToken,
                    },
                    width: 120.sp,
                    height: 120.sp,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(
                    width: 40.sp,
                  ),
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: titles,
                        ),
                        Spacer(),
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
                                fontSize: 36.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 20.sp,
                  ),
                  _menuItem.secondaryIconUrl == null
                      ? SizedBox(
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
                    width: 20.sp,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
