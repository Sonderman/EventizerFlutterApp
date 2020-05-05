import 'package:eventizer/assets/Colors.dart';
import 'package:flutter/material.dart';

class NewEventPage extends StatefulWidget {
  @override
  _NewEventPageState createState() => _NewEventPageState();
}

class _NewEventPageState extends State<NewEventPage> {
  double heightSize(double value) {
    value /= 100;
    return MediaQuery.of(context).size.height * value;
  }

  double widthSize(double value) {
    value /= 100;
    return MediaQuery.of(context).size.width * value;
  }

  @override
  Widget build(BuildContext context) {
    var textField = Container(
                height: heightSize(8),
                width: widthSize(85),
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.search,
                        color: MyColors().whiteTextColor,
                        size: heightSize(4),
                      ),
                      hintText: "Arama",
                      hintStyle: TextStyle(
                        color: MyColors().whiteTextColor,
                      ),
                    ),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "Zona",
                      color: MyColors().whiteTextColor,
                    ),
                  ),
                ),
                decoration: new BoxDecoration(
                  color: MyColors().purpleContainer,
                  borderRadius: new BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
              );
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              textField,
              Container(
                width: double.infinity,
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    Container(
                      width: 100,
                      height: 5,
                      color: Colors.red,
                    ),
                    SizedBox(
                      width: widthSize(3),
                    ),
                    Container(
                      width: 100,
                      height: 5,
                      color: Colors.red,
                    ),
                    SizedBox(
                      width: widthSize(3),
                    ),
                    Container(
                      width: 100,
                      height: 5,
                      color: Colors.red,
                    ),
                    SizedBox(
                      width: widthSize(3),
                    ),
                    Container(
                      width: 100,
                      height: 5,
                      color: Colors.red,
                    ),
                    SizedBox(
                      width: widthSize(3),
                    ),
                    Container(
                      width: 100,
                      height: 5,
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
