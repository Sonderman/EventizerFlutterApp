import 'package:eventizer/assets/Colors.dart';
import 'package:flutter/material.dart';

class ExploreEventPage extends StatefulWidget {
  @override
  _ExploreEventPageState createState() => _ExploreEventPageState();
}

class _ExploreEventPageState extends State<ExploreEventPage> {
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
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            textField(),
            categoryList(),
            eventList(),
          ],
        ),
      ),
    );
  }

  Widget eventList() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: heightSize(5),
          ),
          popularEventsText(),
          SizedBox(
            height: heightSize(2),
          ),
          //ANCHOR event list start are here---------------------------------------------
          Container(
            height: heightSize(55),
            child: ListView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: new BorderRadius.all(
                        Radius.circular(20),
                      ),
                      child: Container(
                        width: widthSize(100),
                        height: heightSize(25),
                        child: Stack(
                          children: <Widget>[
                            Image.asset(
                              "assets/images/event_birthday.jpg",
                              //fit: BoxFit.cover,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: "21 Tem. Perş.\n",
                                        style: TextStyle(
                                          fontFamily: "Zona",
                                          fontSize: heightSize(2),
                                          color: MyColors().purpleContainer,
                                        ),
                                      ),
                                      TextSpan(
                                        text: "Taksim Energy Cafe - İst.",
                                        style: TextStyle(
                                          fontFamily: "ZonaLight",
                                          fontSize: heightSize(2),
                                          color: MyColors().purpleContainer,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: heightSize(4),
                    ),
                    //ANCHOR other event start are here----------------------------------------------------
                    ClipRRect(
                      borderRadius: new BorderRadius.all(
                        Radius.circular(20),
                      ),
                      child: Container(
                        width: widthSize(100),
                        height: heightSize(25),
                        child: Stack(
                          children: <Widget>[
                            Image.asset(
                              "assets/images/event_camp.jpg",
                              //fit: BoxFit.cover,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: "14 Ağu. Cmt.\n",
                                        style: TextStyle(
                                          fontFamily: "Zona",
                                          fontSize: heightSize(2),
                                          color: MyColors().purpleContainer,
                                        ),
                                      ),
                                      TextSpan(
                                        text: "Yıldız Parkı - İst.",
                                        style: TextStyle(
                                          fontFamily: "ZonaLight",
                                          fontSize: heightSize(2),
                                          color: MyColors().purpleContainer,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: heightSize(4),
                    ),
                    //ANCHOR other event start are here----------------------------------------------------
                    ClipRRect(
                      borderRadius: new BorderRadius.all(
                        Radius.circular(20),
                      ),
                      child: Container(
                        width: widthSize(100),
                        height: heightSize(25),
                        child: Stack(
                          children: <Widget>[
                            Image.asset(
                              "assets/images/event_world_travel.jpg",
                              //fit: BoxFit.cover,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: "21 Eyl. Cmt.\n",
                                        style: TextStyle(
                                          fontFamily: "Zona",
                                          fontSize: heightSize(2),
                                          color: MyColors().purpleContainer,
                                        ),
                                      ),
                                      TextSpan(
                                        text: "Balkanlar Turu",
                                        style: TextStyle(
                                          fontFamily: "ZonaLight",
                                          fontSize: heightSize(2),
                                          color: MyColors().purpleContainer,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: heightSize(4),
                    ),
                    //ANCHOR other event start are here----------------------------------------------------
                    ClipRRect(
                      borderRadius: new BorderRadius.all(
                        Radius.circular(20),
                      ),
                      child: Container(
                        width: widthSize(100),
                        height: heightSize(25),
                        child: Stack(
                          children: <Widget>[
                            Image.asset(
                              "assets/images/event_travel.jpg",
                              //fit: BoxFit.cover,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: "2 Eki. Pz.\n",
                                        style: TextStyle(
                                          fontFamily: "Zona",
                                          fontSize: heightSize(2),
                                          color: MyColors().purpleContainer,
                                        ),
                                      ),
                                      TextSpan(
                                        text: "İç Anadolu Turu",
                                        style: TextStyle(
                                          fontFamily: "ZonaLight",
                                          fontSize: heightSize(2),
                                          color: MyColors().purpleContainer,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: heightSize(4),
                    ),
                    //ANCHOR other event start are here----------------------------------------------------
                    ClipRRect(
                      borderRadius: new BorderRadius.all(
                        Radius.circular(20),
                      ),
                      child: Container(
                        width: widthSize(100),
                        height: heightSize(25),
                        child: Stack(
                          children: <Widget>[
                            Image.asset(
                              "assets/images/event_conferance.jpg",
                              //fit: BoxFit.cover,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: "18 Kas. Pz.\n",
                                        style: TextStyle(
                                          fontFamily: "Zona",
                                          fontSize: heightSize(2),
                                          color: MyColors().purpleContainer,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            "Flutter'a Giriş ~ 100. Yıl Kültür Merkezi - Çankırı",
                                        style: TextStyle(
                                          fontFamily: "ZonaLight",
                                          fontSize: heightSize(2),
                                          color: MyColors().purpleContainer,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget popularEventsText() {
    return RichText(
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
  }

  Widget categoryList() {
    return Padding(
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
                            child: Image.asset(
                                "assets/icons/birthdayCategory.png"),
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
                            child:
                                Image.asset("assets/icons/travelCategory.png"),
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
                            child: Image.asset(
                                "assets/icons/worldtravelCategory.png"),
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
                  width: widthSize(50),
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
                          "Doğa Fotoğrafçılığı",
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
                            child: Image.asset(
                                "assets/icons/conferenceCategory.png"),
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
  }

  Widget textField() {
    return Padding(
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
  }
}
