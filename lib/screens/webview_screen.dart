import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:huynhcodaidao/models/user_token.dart';

import 'package:huynhcodaidao/ui_components/linear_gradients.dart';

import 'package:huynhcodaidao/widgets/app_bar_02_widget.dart';

class WebviewScreen extends StatefulWidget {
  final String actionUrl;
  final String actionTitle;

  WebviewScreen({
    Key key,
    this.actionUrl,
    this.actionTitle,
  })  : assert(actionUrl != null),
        assert(actionTitle != null),
        super(key: key);

  @override
  _WebviewScreenState createState() => _WebviewScreenState();
}

class _WebviewScreenState extends State<WebviewScreen> {
  final Box _appData = Hive.box('appData');
  WebViewController _webviewController;

  @override
  Widget build(BuildContext context) {
    ResponsiveWidgets.init(
      context,
      width: 1080,
      height: 1920,
      allowFontScaling: true,
    );

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradients.main,
      ),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar02Widget(
            height: 160.sp,
            title: widget.actionTitle,
          ),
          body: Container(
            child: WebView(
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _webviewController = webViewController;
                _webviewController.loadUrl(
                  widget.actionUrl,
                  headers: {
                    'Authorization': 'Bearer ' +
                        (_appData.get('userToken') as UserToken).accessToken,
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
