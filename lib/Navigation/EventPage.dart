import 'package:eventizer/Navigation/ProfilePage.dart';
import 'package:eventizer/Settings/AppSettings.dart';
import 'package:eventizer/Tools/BottomNavigation.dart';
import 'package:eventizer/Tools/NavigationManager.dart';
import 'package:eventizer/Tools/PageComponents.dart';
import 'package:eventizer/assets/Colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventPage extends StatefulWidget {
  final Map<String, dynamic> eventData;
  final Map<String, dynamic> userData;
  final bool amIparticipant;
  const EventPage({Key key, this.eventData, this.userData, this.amIparticipant})
      : super(key: key);
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> with TickerProviderStateMixin {
  double heightSize(double value) {
    value /= 100;
    return MediaQuery.of(context).size.height * value;
  }

  double widthSize(double value) {
    value /= 100;
    return MediaQuery.of(context).size.width * value;
  }

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
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
              Container(
                child: TabBar(
                    indicatorColor: Colors.teal,
                    labelColor: Colors.teal,
                    unselectedLabelColor: Colors.black54,
                    controller: _tabController,
                    isScrollable: true,
                    tabs: [
                      Tab(
                        text: "Etkinlik Detay",
                      ),
                      Tab(
                        text: "Yorumlar",
                      ),
                      Tab(
                        text: "Katılımcılar",
                      ),
                    ]),
              ),
              Expanded(
                child: TabBarView(controller: _tabController, children: [
                  Column(
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
                  //TODO buraya Yorumlar sayfası yapılcak
                  Center(
                    child: PageComponents().underConstruction(context),
                  ),
                  //TODO buraya Katılımcılar sayfası yapılcak
                  Center(
                    child: PageComponents().underConstruction(context),
                  )
                ]),
              ),
            ],
          ),
        ),
      ),
    );
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
              image: NetworkImage(widget.userData['ProfilePhotoUrl']),
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
                text: widget.userData['Name'] + widget.userData['Surname'],
                style: TextStyle(
                  fontFamily: "Zona",
                  fontSize: heightSize(2.5),
                  color: MyColors().whiteTextColor,
                ),
              ),
              TextSpan(
                text: "\n@nickname",
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
        InkWell(
          onTap: () {
            //ANCHOR kullanıcı profiline buradan gidiyor
            NavigationManager(context).pushPage(ProfilePage(
              userID: widget.eventData["OrganizerID"],
              isFromEvent: true,
            ));
          },
          child: Container(
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
        ),
      ],
    );
  }

  Widget eventPhotoAndTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          widget.eventData['Title'],
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
            child: FadeInImage.assetNetwork(
                fit: BoxFit.cover,
                placeholder: 'assets/images/etkinlik.jpg',
                image: widget.eventData['EventImageUrl']),
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
                          text: widget.eventData['StartDate'],
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
                          text: widget.eventData['FinishDate'],
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
        //ANCHOR Details start are here
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
                widget.eventData['Detail'],
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
    List<Widget> buttons = [];

    if (widget.amIparticipant) {
      buttons.add(Container(
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
                  "AYRIL",
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
      ));
    } else {
      buttons.add(Container(
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
      ));
    }

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
          ] +
          buttons,
    );
  }
}
