import 'package:eventizer/assets/Colors.dart';
import 'package:flutter/material.dart';

class CreateEventPage extends StatefulWidget {
  @override
  _CreateEventPageState createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  double heightSize(double value) {
    value /= 100;
    return MediaQuery.of(context).size.height * value;
  }

  double widthSize(double value) {
    value /= 100;
    return MediaQuery.of(context).size.width * value;
  }

  Widget eventPhotoAndButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: heightSize(10),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: widthSize(43),
                height: heightSize(8),
                decoration: new BoxDecoration(
                  color: MyColors().blackOpacityContainer,
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
                          child: Image.asset("assets/icons/camera.png"),
                        ),
                        Text(
                          "Kamera",
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
                  color: MyColors().blackOpacityContainer,
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
                          child: Image.asset("assets/icons/gallery.png"),
                        ),
                        Text(
                          "Galeri",
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
          ),
        ],
      ),
    );
  }

  Widget dateButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: widthSize(43),
            height: heightSize(8),
            decoration: new BoxDecoration(
              color: MyColors().blackOpacityContainer,
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
                      child: Image.asset("assets/icons/startDate.png"),
                    ),
                    Text(
                      "Başlangıç",
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
              color: MyColors().blackOpacityContainer,
              borderRadius: new BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      height: heightSize(4),
                      child: Image.asset("assets/icons/end_date.png"),
                    ),
                    Text(
                      "Bitiş",
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
      ),
    );
  }

  Widget eventTitleAndDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: new BorderRadius.all(
              Radius.circular(20),
            ),
            child: Container(
              color: MyColors().blackOpacityContainer,
              width: widthSize(100),
              height: heightSize(8),
              child: Center(
                child: TextFormField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Etkinlik başlığı...",
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
            ),
          ),
          SizedBox(
            height: heightSize(1.5),
          ),
          ClipRRect(
            borderRadius: new BorderRadius.all(
              Radius.circular(20),
            ),
            child: Container(
              color: MyColors().blackOpacityContainer,
              width: widthSize(100),
              height: heightSize(8),
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 8),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Etkinlik içeriği...",
                    hintStyle: TextStyle(
                      color: MyColors().whiteTextColor,
                    ),
                  ),
                  style: TextStyle(
                    fontFamily: "ZonaLight",
                    color: MyColors().whiteTextColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      body: Column(
        children: <Widget>[
          eventPhotoAndButtons(),
          SizedBox(
            height: heightSize(3),
          ),
          dateButtons(),
          SizedBox(
            height: heightSize(3),
          ),
          eventTitleAndDetails(),
          SizedBox(
            height: heightSize(3),
          ),
          createEventButton(),
        ],
      ),
    );
  }

  Widget createEventButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: widthSize(100),
        height: heightSize(8),
        decoration: new BoxDecoration(
          color: MyColors().blackOpacityContainer,
          borderRadius: new BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 90),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  height: heightSize(4),
                  child: Image.asset("assets/icons/addEvent.png"),
                ),
                Text(
                  "ETKİNLİK OLUŞTUR",
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
    );
  }
}
