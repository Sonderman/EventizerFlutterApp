import 'dart:io';

import 'package:flutter/material.dart';


class ImageViewer extends StatelessWidget {
  final String tag;
  final File image;

  const ImageViewer({Key key, this.tag, this.image}) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Color(0XFF001970),
        body: Container(
          child: Center(
            child: Hero(
              tag: tag,
              child: image == null ? Image(
              image: AssetImage('assets/images/etkinlik.jpg'),
              width: MediaQuery.of(context).size.width)
             : Image.file(image, width: MediaQuery.of(context).size.width)
            ),
          ),
        ),
      ),
    );
  }
}