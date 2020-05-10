import 'package:eventizer/assets/Colors.dart';
import 'package:flutter/material.dart';

class EventPage extends StatefulWidget {
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  double heightSize(double value) {
    value /= 100;
    return MediaQuery.of(context).size.height * value;
  }

  double widthSize(double value) {
    value /= 100;
    return MediaQuery.of(context).size.width * value;
  }

  Widget userPhotoAndName() {
    return Row(
      children: <Widget>[
        Container(
          height: heightSize(7),
          width: widthSize(14),
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage("assets/images/avatar_man.png"),
            ),
          ),
        ),
        SizedBox(
          width: widthSize(3),
        ),
        RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: "Murat Altıntaş\n",
                style: TextStyle(
                  fontFamily: "Zona",
                  fontSize: heightSize(2.5),
                  color: MyColors().whiteTextColor,
                ),
              ),
              TextSpan(
                text: "@altintas",
                style: TextStyle(
                  height: heightSize(0.2),
                  fontFamily: "ZonaLight",
                  fontSize: heightSize(2),
                  color: MyColors().whiteTextColor,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: widthSize(10),
        ),
        Container(
          width: widthSize(30),
          height: heightSize(8),
          decoration: new BoxDecoration(
            color: MyColors().darkOrangeContainer,
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
                      child: Image.asset(
                        "assets/icons/showProfile.png",
                      )),
                  Text(
                    "Gözat",
                    style: TextStyle(
                      fontFamily: "Zona",
                      fontSize: heightSize(2),
                      color: MyColors().whiteTextColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget eventPhotoAndTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Balkanlar Turu",
          style: TextStyle(
            fontFamily: "Zona",
            fontSize: heightSize(3.5),
            color: MyColors().whiteTextColor,
          ),
        ),
        SizedBox(
          height: heightSize(1),
        ),
        ClipRRect(
          borderRadius: new BorderRadius.all(
            Radius.circular(20),
          ),
          child: Container(
            color: MyColors().blackOpacityContainer,
            width: widthSize(100),
            height: heightSize(25),
            child: Center(child: Text("Default photo are here")),
          ),
        ),
        SizedBox(
          height: heightSize(2),
        ),
      ],
    );
  }

  Widget dateAndDetails() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: widthSize(43),
              height: heightSize(6),
              decoration: new BoxDecoration(
                color: MyColors().darkOrangeContainer,
                borderRadius: new BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: "07.10.2020",
                          style: TextStyle(
                            fontFamily: "Zona",
                            fontSize: heightSize(2),
                            color: MyColors().whiteTextColor,
                          ),
                        ),
                        TextSpan(
                          text: " | 20:30",
                          style: TextStyle(
                            fontFamily: "ZonaLight",
                            fontSize: heightSize(2),
                            color: MyColors().whiteTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: widthSize(43),
              height: heightSize(6),
              decoration: new BoxDecoration(
                color: MyColors().darkOrangeContainer,
                borderRadius: new BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: "14.10.2020",
                          style: TextStyle(
                            fontFamily: "Zona",
                            fontSize: heightSize(2),
                            color: MyColors().whiteTextColor,
                          ),
                        ),
                        TextSpan(
                          text: " | 00:30",
                          style: TextStyle(
                            fontFamily: "ZonaLight",
                            fontSize: heightSize(2),
                            color: MyColors().whiteTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        //ANCHOR Detailst start are here
        SizedBox(
          height: heightSize(2),
        ),
        ClipRRect(
          borderRadius: new BorderRadius.all(
            Radius.circular(20),
          ),
          child: Container(
            color: MyColors().blackOpacityContainer,
            width: widthSize(100),
            height: heightSize(20),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                "This is event's details container...",
                style: TextStyle(
                  fontFamily: "ZonaLight",
                  color: MyColors().whiteTextColor,
                  fontSize: heightSize(2),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget mapAndJoin() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          width: widthSize(43),
          height: heightSize(8),
          decoration: new BoxDecoration(
            color: MyColors().darkOrangeContainer,
            borderRadius: new BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    height: heightSize(4),
                    child: Image.asset("assets/icons/location.png"),
                  ),
                  Text(
                    "Konum",
                    style: TextStyle(
                      fontFamily: "Zona",
                      fontSize: heightSize(2),
                      color: MyColors().whiteTextColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          width: widthSize(43),
          height: heightSize(8),
          decoration: new BoxDecoration(
            color: MyColors().darkOrangeContainer,
            borderRadius: new BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 35),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    height: heightSize(4),
                    child: Image.asset("assets/icons/joinEvent.png"),
                  ),
                  Text(
                    "KATIL",
                    style: TextStyle(
                      fontFamily: "Zona",
                      fontSize: heightSize(2),
                      color: MyColors().whiteTextColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrangeAccent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: <Widget>[
              userPhotoAndName(),
              SizedBox(
                height: heightSize(2),
              ),
              eventPhotoAndTitle(),
              dateAndDetails(),
              SizedBox(
                height: heightSize(2),
              ),
              mapAndJoin(),
            ],
          ),
        ),
      ),
    );
  }
}
