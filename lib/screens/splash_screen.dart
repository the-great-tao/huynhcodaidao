import 'package:flutter/material.dart';
import 'package:responsive_widgets/responsive_widgets.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ResponsiveWidgets.init(
      context,
      width: 1080,
      height: 1920,
      allowFontScaling: true,
    );

    return Scaffold(
      backgroundColor: Colors.amber,
      body: Center(
        child: SizedBox(
          width: 600.w,
          height: 600.w,
          child: Container(
            child: Image(
              image: AssetImage('assets/login_screen_logo.png'),
            ),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black87,
                  blurRadius: 20.w,
                  spreadRadius: 10.w,
                  offset: Offset(0, 20.w),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
