import 'package:flutter/material.dart';

class NetworkImageWidget extends StatelessWidget {
  final String source;
  final double width;
  final double height;
  final BoxFit fit;
  final Map<String, String> headers;

  const NetworkImageWidget({
    Key key,
    this.source,
    this.width,
    this.height,
    this.fit,
    this.headers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      source,
      width: width,
      height: height,
      fit: fit,
      headers: headers,
    );
  }
}
