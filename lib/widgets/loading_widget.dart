import 'package:flutter/material.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1080.w,
      child: Stack(
        children: <Widget>[
          Container(
            height: 80.sp,
            child: LinearProgressIndicator(
              backgroundColor: Colors.amberAccent,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
            ),
          ),
          Container(
            height: 80.sp,
            child: Center(
              child: Text(
                'Đang tải dữ liệu...',
                style: GoogleFonts.robotoSlab(
                  color: Colors.white,
                  fontSize: 40.sp,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
