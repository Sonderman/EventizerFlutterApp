import 'package:eventizer/Services/Repository.dart';
import 'package:eventizer/Tools/PageComponents.dart';
import 'package:eventizer/assets/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

Future<bool> askForQuit(BuildContext context) async {
  return await showDialog(
      context: context,
      builder: (con) => AlertDialog(
            title: const Text("Uygulamadan Çıkmak istiyormusunuz?"),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text("Hayır")),
              TextButton(
                  onPressed: () {
                    SystemNavigator.pop();
                    //Navigator.pop(context);
                  },
                  child: const Text("Evet"))
            ],
          ));
}

Future<bool> askingDialog(
    BuildContext context, String title, Color backgroundColor) async {
  return await showDialog(
      context: context,
      builder: (dcontext) {
        return AlertDialog(
          title: Text(title),
          backgroundColor: backgroundColor,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(dcontext, false);
              },
              child: const Text(
                "Hayır",
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dcontext, true);
              },
              child: const Text(
                "Evet",
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      });
}

Future<bool> feedbackDialog(
  BuildContext context,
) async {
  return await showDialog(
      context: context,
      builder: (dcontext) {
        TextEditingController controller = TextEditingController();
        var responsive = PageComponents(dcontext);
        UserService userService =
            Provider.of<UserService>(context, listen: false);
        return AlertDialog(
          title: const Center(child: Text("Sorun Bildir")),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                width: responsive.widthSize(80),
                child: TextFormField(
                  controller: controller,
                  textAlign: TextAlign.left,
                  keyboardType: TextInputType.multiline,
                  enableInteractiveSelection: true,
                  minLines: 1,
                  maxLines: 10,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    alignLabelWithHint: true,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: MyColors().loginGreyColor),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: MyColors().loginGreyColor),
                    ),
                  ),
                  style: TextStyle(
                    fontSize: responsive.heightSize(2.5),
                    fontFamily: "ZonaLight",
                    color: MyColors().loginGreyColor,
                  ),
                ),
              ),
              SizedBox(
                height: responsive.heightSize(2),
              ),
              TextButton(
                onPressed: () {
                  if (controller.text != "") {
                    userService.sendFeedback(controller.text).then((value) {
                      if (value) {
                        Navigator.pop(dcontext, true);
                        Fluttertoast.showToast(
                            msg:
                                "Geri Bildiriminiz Gönderilmiştir Teşekkür Ederiz.",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 2,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 18.0);
                      }
                    });
                  }
                },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.green)),
                child: const Text(
                  "Gönder",
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
            ],
          ),
        );
      });
}
