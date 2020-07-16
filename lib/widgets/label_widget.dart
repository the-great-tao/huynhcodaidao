import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

import 'package:flutter/material.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:huynhcodaidao/models/user_token.dart';
import 'package:huynhcodaidao/models/label.dart';

class LabelWidget extends StatefulWidget {
  final String labelUrl;

  const LabelWidget({
    Key key,
    @required this.labelUrl,
  })  : assert(labelUrl != null),
        super(key: key);

  @override
  _LabelWidgetState createState() => _LabelWidgetState();
}

class _LabelWidgetState extends State<LabelWidget> {
  final Box _appData = Hive.box('appData');

  Future<Response> _responseFuture;

  @override
  void initState() {
    _responseFuture = Dio().get(
      widget.labelUrl,
      options: Options(
        headers: {
          'Authorization':
              'Bearer ' + (_appData.get('userToken') as UserToken).accessToken,
        },
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _responseFuture,
      builder: (BuildContext context, AsyncSnapshot<Response> snapshot) {
        if (!snapshot.hasData ||
            snapshot.connectionState != ConnectionState.done) {
          return Container();
        }

        Response response = snapshot.data;
        Label label = Label.fromJson(response.data);

        return Container(
          padding: EdgeInsets.fromLTRB(20.sp, 10.sp, 20.sp, 10.sp),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(9999.sp),
          ),
          child: Center(
            child: Text(
              label.data.toString(),
              style: GoogleFonts.robotoSlab(
                color: Colors.white,
                fontSize: 32.sp,
              ),
            ),
          ),
        );
      },
    );
  }
}
