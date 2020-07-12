import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_widgets/responsive_widgets.dart';

import 'package:huynhcodaidao/ui_components/linear_gradients.dart';

import 'package:huynhcodaidao/widgets/app_bar_01_widget.dart';
import 'package:huynhcodaidao/widgets/menu_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

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
          appBar: AppBar01Widget(
            height: 160.sp,
          ),
          body: Container(
            child: MenuWidget(),
          ),
          bottomNavigationBar: Container(
            height: 180.sp,
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white.withAlpha(240),
              selectedIconTheme: IconThemeData(
                size: 78.sp,
              ),
              selectedItemColor: Colors.red,
              selectedFontSize: 38.sp,
              unselectedIconTheme: IconThemeData(
                size: 78.sp,
              ),
              unselectedItemColor: Colors.black45,
              unselectedFontSize: 38.sp,
              items: [
                BottomNavigationBarItem(
                  icon: new Icon(Icons.home),
                  title: new Text(
                    'Trang chủ',
                    style: GoogleFonts.robotoSlab(),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: new Icon(Icons.rss_feed),
                  title: new Text(
                    'Thông báo',
                    style: GoogleFonts.robotoSlab(),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.notifications_active),
                  title: Text(
                    'Chuông tu',
                    style: GoogleFonts.robotoSlab(),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: new Icon(Icons.music_note),
                  title: new Text(
                    'Nhạc niệm',
                    style: GoogleFonts.robotoSlab(),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  title: Text(
                    'Cài đặt',
                    style: GoogleFonts.robotoSlab(),
                  ),
                ),
              ],
              onTap: (index) => setState(() => _currentIndex = index),
            ),
          ),
        ),
      ),
    );
  }
}
