import 'dart:io';
import 'dart:typed_data';
import 'package:eventizer/assets/Colors.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:image_editor/image_editor.dart';

class ImageEditorPage extends StatefulWidget {
  final File image;
  final bool forCreateEvent;
  ImageEditorPage({@required this.image, @required this.forCreateEvent});
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
        title: Text("Image Editor"),
        backgroundColor: MyColors().loginGreyColor,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.done),
            onPressed: () {
              _cropImage().whenComplete(() {
                if (_image != null) {
                  Navigator.pop(context);
                  Navigator.pop(context, _image);
                }
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
                // lineColor: Colors.blue,
                // lineHeight: 2,
                maxScale: 2.0,
                cornerColor: Colors.red,
                //cornerSize: Size(25, 5),
                cropRectPadding: EdgeInsets.all(20.0),
                hitTestSize: 20.0,
                initCropRectType: InitCropRectType.imageRect,
                cropAspectRatio: CropAspectRatios.ratio16_9);
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: MyColors().loginGreyColor,
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: FlatButton.icon(
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
            ),
            Visibility(
              visible: !widget.forCreateEvent,
              child: Expanded(
                child: FlatButton.icon(
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
              ),
            ),
            Visibility(
              visible: !widget.forCreateEvent,
              child: Expanded(
                child: FlatButton.icon(
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
              ),
            ),
            Expanded(
              child: FlatButton.icon(
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
            ),
/*
            FlatButton.icon(
              icon: Icon(Icons.aspect_ratio),
              label: Text(
                "Aspect",
                style: TextStyle(fontSize: 10.0),
              ),
              textColor: Colors.white,
              onPressed: () {
                print(editorKey.currentState.getCropRect());
              },
            ),*/
          ],
        ),
      ),
    );
  }

  Future<void> _cropImage() async {
    try {
      showBusyingDialog();
      _image =
          await cropImageDataWithNativeLibrary(state: editorKey.currentState);
    } catch (e) {
      print(e);
    }
  }

  Future<Uint8List> cropImageDataWithNativeLibrary(
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

  void showBusyingDialog() async {
    var primaryColor = Theme.of(context).primaryColor;
    return showDialog(
        useRootNavigator: true,
        context: context,
        barrierDismissible: false,
        child: Material(
          color: Colors.transparent.withOpacity(0.2),
          child: Container(
            height: double.infinity,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(
                  strokeWidth: 5.0,
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
