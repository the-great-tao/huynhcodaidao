import 'package:flutter/material.dart';

import 'package:huynhcodaidao/screens/base_screen.dart';

import 'package:native_pdf_view/native_pdf_view.dart';

class PdfViewScreen extends StatelessWidget {
  final String actionTitle;
  final String actionUrl;

  const PdfViewScreen({
    Key key,
    this.actionTitle,
    this.actionUrl,
  })  : assert(actionTitle != null),
        assert(actionUrl != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final pdfController = PdfController(
      document: PdfDocument.openAsset('assets/test.pdf'),
    );

    return BaseScreen(
      title: actionTitle,
      body: PdfView(
        controller: pdfController,
      ),
    );
  }
}
