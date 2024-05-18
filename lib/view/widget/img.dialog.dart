import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImgDialog extends StatelessWidget {
  const ImgDialog({super.key, required this.url});
  final String url;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Dialog(
          child: SafeArea(
        child: PhotoView(
          minScale: 0.6,
          imageProvider: NetworkImage(url),
        ),
      )

          // child: Image.network(
          //   url,
          //   fit: BoxFit.fitWidth,
          //   height: MediaQuery.of(context).size.height,
          //   width: 500,
          // ),
          ),
    );
  }
}
