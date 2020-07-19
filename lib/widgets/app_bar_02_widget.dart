import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_widgets/responsive_widgets.dart';

import 'package:huynhcodaidao/ui_components/linear_gradients.dart';
import 'package:huynhcodaidao/widgets/app_bar_widget.dart';

class AppBar02Widget extends StatefulWidget implements PreferredSizeWidget {
  final double height;
  final String title;

  const AppBar02Widget({
    Key key,
    @required this.height,
    @required this.title,
  })  : assert(height != null),
        assert(title != null);

  @override
  Size get preferredSize => Size.fromHeight(height + 180.sp);

  @override
  State createState() => _AppBar02WidgetState();
}

class _AppBar02WidgetState extends State<AppBar02Widget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: 1080.w,
          height: widget.height + 180.sp,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [
//                Color.fromRGBO(208, 246, 255, 1),
//                Color.fromRGBO(255, 237, 237, 1),
//                Color.fromRGBO(255, 255, 231, 1),

                Color.fromRGBO(92, 121, 255, 1),
                Color.fromRGBO(76, 221, 242, 1),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8.h,
                spreadRadius: 2.h,
                offset: Offset(0, 4.h),
              ),
            ],
          ),
        ),
        AppBarWidget(
          height: widget.height,
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
                    widget.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
                color: Colors.black26,
                blurRadius: 8.h,
                spreadRadius: 2.h,
                offset: Offset(0, 4.h),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
