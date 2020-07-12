import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_widgets/responsive_widgets.dart';

import 'package:huynhcodaidao/ui_components/linear_gradients.dart';
import 'package:huynhcodaidao/widgets/app_bar_widget.dart';

class AppBar02Widget extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final String title;

  const AppBar02Widget({
    Key key,
    @required this.height,
    @required this.title,
  })  : assert(height != null),
        assert(title != null);

  @override
  Widget build(BuildContext context) {
    return AppBarWidget(
      height: height,
      child: Center(
        child: Row(
          children: <Widget>[
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: EdgeInsetsResponsive.fromLTRB(40, 20, 40, 20),
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 80.sp,
                ),
              ),
            ),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.robotoSlab(
                  color: Colors.white,
                  fontSize: 50.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.pushNamedAndRemoveUntil(
                context,
                '/home/',
                (route) => false,
              ),
              child: Container(
                padding: EdgeInsetsResponsive.fromLTRB(40, 20, 40, 20),
                child: Icon(
                  Icons.home,
                  color: Colors.white,
                  size: 80.sp,
                ),
              ),
            ),
          ],
        ),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradients.main,
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 10.h,
            spreadRadius: 5.h,
            offset: Offset(0, 5.h),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
