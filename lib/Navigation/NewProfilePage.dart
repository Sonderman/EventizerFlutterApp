import 'package:eventizer/assets/Colors.dart';
import 'package:flutter/material.dart';

class NewProfilePage extends StatefulWidget {
  @override
  _NewProfilePageState createState() => _NewProfilePageState();
}

class _NewProfilePageState extends State<NewProfilePage> {
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
    var avatarAndname = Container(
      alignment: Alignment.center,
      height: heightSize(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            height: heightSize(20),
            child: Image.asset("assets/images/avatar_man.png"),
          ),
          Text(
            "Murat Altıntaş",
            style: TextStyle(
              fontFamily: "Zona",
              fontSize: heightSize(3),
            ),
          ),
          Text(
            "@altintas",
            style: TextStyle(
              fontFamily: "ZonaLight",
              fontSize: heightSize(2),
            ),
          ),
        ],
      ),
    );

    var threeBoxes = Column(
      children: <Widget>[
        SizedBox(
          height: heightSize(5),
        ),
        //ANCHOR About myself box are here
        Container(
          height: heightSize(8),
          width: widthSize(85),
          child: Padding(
            padding: const EdgeInsets.only(left: 30, top: 22),
            child: Text(
              "Hakkımda...",
              style: TextStyle(
                fontFamily: "Zona",
                fontSize: heightSize(2),
                color: MyColors().whiteTextColor,
              ),
            ),
          ),
          decoration: new BoxDecoration(
            color: MyColors().yellowContainer,
            borderRadius: new BorderRadius.all(
              Radius.circular(20),
            ),
          ),
        ),
        SizedBox(
          height: heightSize(3),
        ),
        //ANCHOR Chat and Follow boxes are here
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              height: heightSize(8),
              width: widthSize(35),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Image.asset("assets/icons/chat.png"),
                    height: heightSize(4),
                  ),
                  SizedBox(
                    width: widthSize(2),
                  ),
                  Text(
                    "Chat",
                    style: TextStyle(
                      fontFamily: "Zona",
                      fontSize: heightSize(2),
                      color: MyColors().whiteTextColor,
                    ),
                  ),
                ],
              ),
              decoration: new BoxDecoration(
                color: MyColors().blueContainer,
                borderRadius: new BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
            ),
            Container(
              height: heightSize(8),
              width: widthSize(35),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Image.asset("assets/icons/follow.png"),
                    height: heightSize(4),
                  ),
                  SizedBox(
                    width: widthSize(2),
                  ),
                  Text(
                    "Takip Et",
                    style: TextStyle(
                      fontFamily: "Zona",
                      fontSize: heightSize(2),
                      color: MyColors().whiteTextColor,
                    ),
                  ),
                ],
              ),
              decoration: new BoxDecoration(
                color: MyColors().orangeContainer,
                borderRadius: new BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ],
    );

    var numberDatas = Column(
      children: <Widget>[
        SizedBox(
          height: heightSize(5),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  "TAKİPÇİ",
                  style: TextStyle(
                    color: MyColors().blueTextColor,
                    fontFamily: "Zona",
                    fontSize: 20,
                  ),
                ),
                Text("56",
                    style: TextStyle(
                      color: MyColors().blueTextColor,
                      fontFamily: "ZonaLight",
                      fontSize: 25,
                    )),
              ],
            ),
            Column(
              children: <Widget>[
                Text("ETKİNLİK",
                    style: TextStyle(
                      color: MyColors().blueTextColor,
                      fontFamily: "Zona",
                      fontSize: 20,
                    )),
                Text("56",
                    style: TextStyle(
                      color: MyColors().blueTextColor,
                      fontFamily: "ZonaLight",
                      fontSize: 25,
                    )),
              ],
            ),
            Column(
              children: <Widget>[
                Text("GÜVEN",
                    style: TextStyle(
                      color: MyColors().blueTextColor,
                      fontFamily: "Zona",
                      fontSize: 20,
                    )),
                Text("105",
                    style: TextStyle(
                      color: MyColors().blueTextColor,
                      fontFamily: "ZonaLight",
                      fontSize: 25,
                    )),
              ],
            )
          ],
        ),
      ],
    );

    var eventList = Column(
            children: <Widget>[
              SizedBox(
                height: heightSize(5),
              ),
              ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
                child: Container(
                  height: heightSize(30),
                  child: Image.asset("assets/images/event_camp.jpg"),
                ),
              ),
            ],
          );

    return Scaffold(
      body: ListView(
        children: <Widget>[
          avatarAndname,
          threeBoxes,
          numberDatas,
          eventList,
        ],
      ),
    );
  }
}