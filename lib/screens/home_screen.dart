import 'package:flutter/material.dart';
import 'package:responsive_widgets/responsive_widgets.dart';

import 'package:huynhcodaidao/ui_components/linear_gradients.dart';
import 'package:huynhcodaidao/widgets/app_bar_01_widget.dart';

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
            height: 160.h,
          ),
          body: Container(
            child: Center(
              child: Text('Home Screen'),
            ),
          ),
          bottomNavigationBar: SizedBox(
            height: 240.h,
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              type: BottomNavigationBarType.fixed,
              selectedIconTheme: IconThemeData(
                size: 80.sp,
              ),
              selectedItemColor: Colors.red,
              selectedFontSize: 40.sp,
              unselectedIconTheme: IconThemeData(
                size: 80.sp,
              ),
              unselectedItemColor: Colors.black45,
              unselectedFontSize: 40.sp,
              items: [
                BottomNavigationBarItem(
                  icon: new Icon(Icons.home),
                  title: new Text('Trang chủ'),
                ),
                BottomNavigationBarItem(
                  icon: new Icon(Icons.rss_feed),
                  title: new Text('Thông báo'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.notifications_active),
                  title: Text('Chuông tu'),
                ),
                BottomNavigationBarItem(
                  icon: new Icon(Icons.music_note),
                  title: new Text('Nhạc niệm'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  title: Text('Cài đặt'),
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
