// web_image_view.dart
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'dart:ui_web' as ui; // ✅ CORRECT for platformViewRegistry on web
/// A widget to load image using HTML element for Flutter Web
class HtmlImage extends StatelessWidget {
  final String imageUrl;
  final String viewId;

  const HtmlImage({super.key, required this.imageUrl, required this.viewId});

  @override
  Widget build(BuildContext context) {
    // Register once per viewId
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(viewId, (int viewId)  {
      final image = html.ImageElement()
        ..src = imageUrl
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.objectFit = 'cover';
      return image;
    });

    return SizedBox(
      width: 200,
      height: 200,
      child: HtmlElementView(viewType: viewId),
    );
  }
}