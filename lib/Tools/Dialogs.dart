import 'package:eventizer/services/repository.dart';
import 'package:eventizer/components/liquidglass_widgets.dart';
import 'package:eventizer/data/themes.dart';
import 'package:eventizer/tools/page_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

Future<bool> askForQuit(BuildContext context) async {
  return await showDialog(
    context: context,
    builder: (con) => AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
      content: MyLiquidGlass.standartDialog(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text("Uygulamadan Çıkmak istiyormusunuz?"),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: const Text("Hayır"),
                  ),
                  TextButton(
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                    child: const Text("Evet"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Future<bool> askingDialog(
  BuildContext context,
  String title,
  Color backgroundColor,
) async {
  return await showDialog(
    context: context,
    builder: (dcontext) {
      return AlertDialog(
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        content: MyLiquidGlass.standartDialog(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(title, style: TextStyle(color: backgroundColor)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(dcontext, false);
                      },
                      child: const Text(
                        "Hayır",
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(dcontext, true);
                      },
                      child: const Text(
                        "Evet",
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Future<bool> feedbackDialog(BuildContext context) async {
  return await showDialog(
    context: context,
    builder: (dcontext) {
      TextEditingController controller = TextEditingController();
      var responsive = PageComponents(dcontext);
      UserService userService = Provider.of<UserService>(
        context,
        listen: false,
      );
      return AlertDialog(
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        content: MyLiquidGlass.standartDialog(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Center(child: Text("Sorun Bildir")),
                SizedBox(height: responsive.heightSize(1)),
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
                        borderSide: BorderSide(color: MyColors.loginGreyColor),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: MyColors.loginGreyColor),
                      ),
                    ),
                    style: TextStyle(
                      fontSize: responsive.heightSize(2.5),
                      fontFamily: "ZonaLight",
                      color: MyColors.loginGreyColor,
                    ),
                  ),
                ),
                SizedBox(height: responsive.heightSize(2)),
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
                            fontSize: 18.0,
                          );
                        }
                      });
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                      Colors.green,
                    ),
                  ),
                  child: const Text("Gönder", style: TextStyle(fontSize: 16.0)),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
