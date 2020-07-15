import 'package:flutter/material.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cached_network_image/cached_network_image.dart';

class NetworkImageWidget extends StatelessWidget {
  final String source;
  final Map<String, String> headers;
  final double width;
  final double height;
  final BoxFit fit;

  const NetworkImageWidget({
    Key key,
    this.source,
    this.headers,
    this.width,
    this.height,
    this.fit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: source,
      httpHeaders: headers,
      width: width,
      height: height,
      fit: fit,
      fadeOutDuration: Duration(milliseconds: 500),
      placeholder: (BuildContext context, String url) {
        return Container(
          width: width,
          height: height,
          child: Center(
            child: SpinKitFadingCircle(
              size: 120.sp,
              color: Colors.amber,
            ),
          ),
        );
      },
      errorWidget: (BuildContext context, String url, dynamic error) {
        return Container(
          width: width,
          height: height,
        );
      },
    );
  }
}
