import 'dart:io';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class ImageViewer extends StatefulWidget {
  final String tag, url;
  final File? image;

  const ImageViewer(
      {super.key, required this.tag, required this.url, this.image});
  @override
  _ImageViewerState createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          automaticallyImplyLeading: true,
        ),
        backgroundColor: Colors.black,
        body: Container(
          child: Center(
            child: Hero(
                tag: widget.tag,
                child: ExtendedImage.network(
                  widget.url,
                  cache: true,
                  fit: BoxFit.contain,
                  mode: ExtendedImageMode.gesture,
                )),
          ),
        ),
      ),
    );
  }
}
