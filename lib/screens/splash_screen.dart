import 'package:flutter/material.dart';
import 'package:responsive_widgets/responsive_widgets.dart';

import 'package:huynhcodaidao/ui_components/linear_gradients.dart';

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
      body: ContainerResponsive(
        width: 1080,
        height: 1920,
        decoration: BoxDecoration(
          gradient: LinearGradients.main,
        ),
        child: Center(
          child: ContainerResponsive(
            width: 600,
            child: Image(
              image: AssetImage('assets/logo.png'),
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
