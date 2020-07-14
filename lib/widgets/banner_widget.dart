import 'package:meta/meta.dart';
import 'package:hive/hive.dart';

import 'package:flutter/material.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

import 'package:huynhcodaidao/models/user_token.dart';
import 'package:huynhcodaidao/models/banner.dart' as BannerModel;

import 'package:huynhcodaidao/services/router_service.dart';

class BannerWidget extends StatefulWidget {
  final BannerModel.Banner banner;
  final EdgeInsetsGeometry margin;

  const BannerWidget({
    Key key,
    @required this.banner,
    this.margin,
  }) : super(key: key);

  @override
  _BannerWidgetState createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  final Box _appData = Hive.box('appData');

  @override
  Widget build(BuildContext context) {
    final BannerModel.Banner banner = widget.banner;
    final EdgeInsetsGeometry margin = widget.margin;
    final Container marginWidget = Container(
      margin: margin,
    );

    if (banner == null) {
      return marginWidget;
    }

    final double width = 1080.w;
    final double height = banner.width == null || banner.height == null
        ? null
        : 1080.w * banner.height / banner.width;

    return CachedNetworkImage(
      httpHeaders: {
        'Authorization':
            'Bearer ' + (_appData.get('userToken') as UserToken).accessToken,
      },
      imageUrl: banner.url,
      imageBuilder: (BuildContext context, ImageProvider imageProvider) {
        return GestureDetector(
          onTap: () {
            if (banner.actionUrl == null || banner.actionTypeName == null) {
              return;
            }

            RouterService.navigateTo(
              context: context,
              actionUrl: banner.actionUrl,
              actionTypeName: banner.actionTypeName,
              actionTitle: banner.actionTitle,
            );
          },
          child: Container(
            width: width,
            height: height,
            margin: margin,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
        );
      },
      placeholder: (BuildContext context, String url) {
        return Shimmer.fromColors(
          baseColor: Colors.amberAccent,
          highlightColor: Colors.white,
          child: Container(
            color: Colors.white12,
            width: 1080.w,
            height: 540.w,
            margin: margin,
          ),
        );
      },
      errorWidget: (BuildContext context, String url, dynamic error) {
        return marginWidget;
      },
    );
  }
}
