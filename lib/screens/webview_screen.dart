import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:huynhcodaidao/models/user_token.dart';

import 'package:huynhcodaidao/screens/base_screen.dart';

class WebviewScreen extends StatefulWidget {
  final String actionTitle;
  final String actionUrl;

  const WebviewScreen({
    Key key,
    this.actionTitle,
    this.actionUrl,
  })  : assert(actionTitle != null),
        assert(actionUrl != null),
        super(key: key);

  @override
  _WebviewScreenState createState() => _WebviewScreenState();
}

class _WebviewScreenState extends State<WebviewScreen> {
  final Box _appData = Hive.box('appData');

  WebViewController _webviewController;

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: widget.actionTitle,
      body: WebView(
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
    );
  }
}
