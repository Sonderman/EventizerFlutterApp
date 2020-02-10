import 'dart:io';
import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';

import 'package:flutter/material.dart';
import 'package:image_editor/image_editor.dart';

class ImageEditorPage extends StatefulWidget {
  final File image;
  ImageEditorPage(this.image);
  @override
  _ImageEditorState createState() => _ImageEditorState(image);
}

class _ImageEditorState extends State<ImageEditorPage> {
  final GlobalKey<ExtendedImageEditorState> editorKey =
      GlobalKey<ExtendedImageEditorState>();

  Uint8List _image;
  final File rawImage;
  _ImageEditorState(this.rawImage);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("image editor"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.done),
            onPressed: () {
              _cropImage().whenComplete(() {
                if (_image != null) Navigator.pop(context, _image);
              });
            },
          ),
        ],
      ),
      body: Center(
        child: ExtendedImage.file(
          rawImage,
          fit: BoxFit.contain,
          mode: ExtendedImageMode.editor,
          enableLoadState: true,
          extendedImageEditorKey: editorKey,
          initEditorConfigHandler: (state) {
            return EditorConfig(
                maxScale: 8.0,
                cropRectPadding: EdgeInsets.all(20.0),
                hitTestSize: 20.0,
                initCropRectType: InitCropRectType.imageRect,
                cropAspectRatio: CropAspectRatios.ratio4_3);
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.lightBlue,
        shape: CircularNotchedRectangle(),
        child: ButtonTheme(
          minWidth: 0.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              /*FlatButton.icon(
                icon: Icon(Icons.crop),
                label: Text(
                  "Crop",
                  style: TextStyle(fontSize: 10.0),
                ),
                textColor: Colors.white,
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Column(
                          children: <Widget>[
                            Expanded(
                              child: SizedBox(),
                            ),
                            SizedBox(
                              height: 200,
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                padding: EdgeInsets.all(20.0),
                                itemBuilder: (_, index) {
                                  var item = _aspectRatios[index];
                                  return GestureDetector(
                                    child: AspectRatioWidget(
                                      aspectRatio: item.value,
                                      aspectRatioS: item.text,
                                      isSelected: item == _aspectRatio,
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                      setState(() {
                                        _aspectRatio = item;
                                      });
                                    },
                                  );
                                },
                                itemCount: _aspectRatios.length,
                              ),
                            ),
                          ],
                        );
                      });
                },
              ),*/
              FlatButton.icon(
                icon: Icon(Icons.flip),
                label: Text(
                  "Flip",
                  style: TextStyle(fontSize: 10.0),
                ),
                textColor: Colors.white,
                onPressed: () {
                  editorKey.currentState.flip();
                },
              ),
              FlatButton.icon(
                icon: Icon(Icons.rotate_left),
                label: Text(
                  "Rotate Left",
                  style: TextStyle(fontSize: 8.0),
                ),
                textColor: Colors.white,
                onPressed: () {
                  editorKey.currentState.rotate(right: false);
                },
              ),
              FlatButton.icon(
                icon: Icon(Icons.rotate_right),
                label: Text(
                  "Rotate Right",
                  style: TextStyle(fontSize: 8.0),
                ),
                textColor: Colors.white,
                onPressed: () {
                  editorKey.currentState.rotate(right: true);
                },
              ),
              FlatButton.icon(
                icon: Icon(Icons.restore),
                label: Text(
                  "Reset",
                  style: TextStyle(fontSize: 10.0),
                ),
                textColor: Colors.white,
                onPressed: () {
                  editorKey.currentState.reset();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _cropImage() async {
    try {
      //showBusyingDialog();
      _image =
          await cropImageDataWithNativeLibrary(state: editorKey.currentState);
    } catch (e) {
      print(e);
    }
  }

  Future<List<int>> cropImageDataWithNativeLibrary(
      {ExtendedImageEditorState state}) async {
    print("native library start cropping");

    final cropRect = state.getCropRect();
    final action = state.editAction;
    final rotateAngle = action.rotateAngle.toInt();
    final flipHorizontal = action.flipY;
    final flipVertical = action.flipX;
    final img = state.rawImageData;

    ImageEditorOption option = ImageEditorOption();

    if (action.needCrop) option.addOption(ClipOption.fromRect(cropRect));

    if (action.needFlip)
      option.addOption(
          FlipOption(horizontal: flipHorizontal, vertical: flipVertical));

    if (action.hasRotateAngle) option.addOption(RotateOption(rotateAngle));

    final start = DateTime.now();
    final result = await ImageEditor.editImage(
      image: img,
      imageEditorOption: option,
    );

    print("${DateTime.now().difference(start)} ：total time");
    return result;
  }

  Future showBusyingDialog() async {
    var primaryColor = Theme.of(context).primaryColor;
    return showDialog(
        useRootNavigator: true,
        context: context,
        barrierDismissible: false,
        child: Material(
          color: Colors.transparent,
          child: Container(
            height: double.infinity,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(
                  strokeWidth: 2.0,
                  valueColor: AlwaysStoppedAnimation(primaryColor),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  "cropping...",
                  style: TextStyle(color: primaryColor),
                )
              ],
            ),
          ),
        ));
  }
}
