import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class Booklet extends StatelessWidget {
  const Booklet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: const PDF().cachedFromUrl(
            'https://e-legion.newpage.xyz/static/files/WB_E-LEGION%202021.pdf'));
  }
}
