import 'package:flutter/material.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class LoadingWidget extends StatelessWidget {
  final double height;

  const LoadingWidget({
    Key key,
    @required this.height,
  })  : assert(height != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1080.w,
      child: Stack(
        children: <Widget>[
          Container(
            height: height,
            child: LinearProgressIndicator(
              backgroundColor: Colors.amberAccent,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
            ),
          ),
          Container(
            height: height,
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
