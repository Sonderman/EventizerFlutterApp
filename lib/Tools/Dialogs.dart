import 'package:flutter/material.dart';

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
