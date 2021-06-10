import 'package:flutter/material.dart';

import 'package:huynhcodaidao/screens/base_screen.dart';

import 'package:huynhcodaidao/modules/message/message_category_widget.dart';

class MessageCategoryScreen extends StatelessWidget {
  final String actionTitle;
  final String actionUrl;

  const MessageCategoryScreen({
    Key key,
    this.actionTitle,
    this.actionUrl,
  })  : assert(actionTitle != null),
        assert(actionUrl != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: actionTitle,
      body: MessageCategoryWidget(
        actionUrl: actionUrl,
      ),
    );
  }
}
