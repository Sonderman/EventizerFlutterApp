import 'package:eventizer/Services/Repository.dart';
import 'package:eventizer/Tools/PageComponents.dart';
import 'package:eventizer/assets/Colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

Future<bool> askingDialog(
    BuildContext context, String title, Color backgroundColor) {
  return showDialog(
      context: context,
      builder: (dcontext) {
        return AlertDialog(
          title: Text(title),
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pop(dcontext, false);
              },
              child: Text(
                "Hayır",
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                ),
              ),
            ),
            FlatButton(
              onPressed: () {
                Navigator.pop(dcontext, true);
              },
              child: Text(
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
) {
  return showDialog(
      context: context,
      builder: (dcontext) {
        TextEditingController controller = TextEditingController();
        var responsive = PageComponents(dcontext);
        UserService userService =
            Provider.of<UserService>(context, listen: false);
        return AlertDialog(
          title: Center(child: Text("Sorun Bildir")),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
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
              FlatButton(
                onPressed: () {
                  if (controller.text != "")
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
                },
                color: Colors.green,
                child: Text(
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
