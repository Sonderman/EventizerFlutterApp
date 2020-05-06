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
    var textField = Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        height: heightSize(8),
        width: widthSize(90),
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
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
      ),
    );

    var categoryList = Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: heightSize(5),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: <Widget>[
                Container(
                  width: widthSize(20),
                  height: heightSize(8),
                  decoration: new BoxDecoration(
                    color: MyColors().lightBlueContainer,
                    borderRadius: new BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Hepsi",
                      style: TextStyle(
                        fontFamily: "Zona",
                        color: MyColors().whiteTextColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: widthSize(2),
                ),
                Container(
                  width: widthSize(40),
                  height: heightSize(8),
                  decoration: new BoxDecoration(
                    color: MyColors().purpleContainer,
                    borderRadius: new BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            height: heightSize(4),
                            child: Image.asset("assets/icons/birthdayCategory.png"),
                          ),
                          Text(
                            "Doğum Günü",
                            style: TextStyle(
                              fontFamily: "Zona",
                              color: MyColors().whiteTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: widthSize(2),
                ),
                Container(
                  width: widthSize(40),
                  height: heightSize(8),
                  decoration: new BoxDecoration(
                    color: MyColors().purpleContainer,
                    borderRadius: new BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            height: heightSize(4),
                            child: Image.asset("assets/icons/travelCategory.png"),
                          ),
                          Text(
                            "Gezi Turu",
                            style: TextStyle(
                              fontFamily: "Zona",
                              color: MyColors().whiteTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: widthSize(2),
                ),
                Container(
                  width: widthSize(40),
                  height: heightSize(8),
                  decoration: new BoxDecoration(
                    color: MyColors().purpleContainer,
                    borderRadius: new BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            height: heightSize(4),
                            child: Image.asset("assets/icons/worldtravelCategory.png"),
                          ),
                          Text(
                            "Dünya Turu",
                            style: TextStyle(
                              fontFamily: "Zona",
                              color: MyColors().whiteTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: widthSize(2),
                ),
                Container(
                  width: widthSize(40),
                  height: heightSize(8),
                  decoration: new BoxDecoration(
                    color: MyColors().purpleContainer,
                    borderRadius: new BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          height: heightSize(4),
                          child: Image.asset("assets/icons/cameraCategory.png"),
                        ),
                        Text(
                          "Fotoğrafçılık",
                          style: TextStyle(
                            fontFamily: "Zona",
                            color: MyColors().whiteTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: widthSize(2),
                ),
                Container(
                  width: widthSize(40),
                  height: heightSize(8),
                  decoration: new BoxDecoration(
                    color: MyColors().purpleContainer,
                    borderRadius: new BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Container(
                            height: heightSize(4),
                            child: Image.asset("assets/icons/conferenceCategory.png"),
                          ),
                          Text(
                            "Konferans",
                            style: TextStyle(
                              fontFamily: "Zona",
                              color: MyColors().whiteTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: widthSize(2),
                ),
                Container(
                  width: widthSize(30),
                  height: heightSize(8),
                  decoration: new BoxDecoration(
                    color: MyColors().purpleContainer,
                    borderRadius: new BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Container(
                            height: heightSize(4),
                            child: Image.asset("assets/icons/campCategory.png"),
                          ),
                          Text(
                            "Kamp",
                            style: TextStyle(
                              fontFamily: "Zona",
                              color: MyColors().whiteTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: widthSize(2),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    var populerEventsText = RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: "Popüler",
            style: TextStyle(fontFamily: "Zona", fontSize: heightSize(3)),
          ),
          TextSpan(
            text: " Etkinlikler",
            style: TextStyle(fontFamily: "ZonaLight", fontSize: heightSize(3)),
          ),
        ],
      ),
    );
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: heightSize(5),
          ),
          textField,
          categoryList,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: heightSize(5),
                ),
                populerEventsText,
                SizedBox(
                  height: heightSize(2),
                ),
                Container(
                  width: widthSize(100),
                  height: heightSize(25),
                  child: Image.asset(
                    "assets/images/event_birthday.jpg",
                    //fit: BoxFit.cover,
                  ),
                  decoration: new BoxDecoration(
                    color: MyColors().purpleContainer,
                    borderRadius: new BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
