import 'package:eventizer/Navigation/ProfilePage.dart';
import 'package:eventizer/Services/Repository.dart';
import 'package:eventizer/Tools/NavigationManager.dart';
import 'package:eventizer/Tools/PageComponents.dart';
import 'package:eventizer/assets/Colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventPage extends StatefulWidget {
  final Map<String, dynamic> eventData;
  final Map<String, dynamic> userData;
  final bool amIparticipant;

  const EventPage({Key key, this.eventData, this.userData, this.amIparticipant}) : super(key: key);

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
  bool katilbutton;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    katilbutton = widget.amIparticipant;
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  void toggleJoinButton() {
    katilbutton ? katilbutton = false : katilbutton = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: <Widget>[
              TabBar(
                  labelColor: MyColors().darkblueText,
                  unselectedLabelColor: MyColors().whiteTextColor,
                  labelStyle: TextStyle(
                    fontFamily: "ZonaLight",
                    fontSize: heightSize(3),
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontFamily: "ZonaLight",
                    fontSize: heightSize(3),
                  ),
                  indicatorWeight: 3,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorPadding: EdgeInsets.symmetric(horizontal: 15),
                  indicatorColor: MyColors().darkblueText,
                  controller: _tabController,
                  isScrollable: true,
                  tabs: [
                    Tab(
                      text: "Etkinlik",
                    ),
                    Tab(
                      text: "Yorumlar",
                    ),
                    Tab(
                      text: "Katılımcılar",
                    ),
                  ]),
              SizedBox(
                height: heightSize(2),
              ),
              Expanded(
                child: TabBarView(controller: _tabController, children: [
                  SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: heightSize(2),
                        ),
                        userPhotoAndName(),
                        divider(),
                        SizedBox(
                          height: heightSize(2),
                        ),
                        eventPhotoAndTitle(),
                        SizedBox(
                          height: heightSize(2),
                        ),
                        dateAndDetails(),
                        SizedBox(
                          height: heightSize(2),
                        ),
                        genderBoxes(),
                        SizedBox(
                          height: heightSize(2),
                        ),
                        categoryColumn(),
                        SizedBox(
                          height: heightSize(2),
                        ),
                        mapAndJoin(),
                        SizedBox(
                          height: heightSize(5),
                        ),
                      ],
                    ),
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
    return FlatButton(
      padding: EdgeInsets.all(0),
      splashColor: MyColors().lightGreen,
      highlightColor: MyColors().lightGreen,
      onPressed: () {
        //ANCHOR kullanıcı profiline buradan gidiyor
        NavigationManager(context).pushPage(ProfilePage(
          userID: widget.eventData["OrganizerID"],
          isFromEvent: true,
        ));
      },
      child: Row(
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
                    color: MyColors().darkblueText,
                  ),
                ),
                TextSpan(
                  text: "\n@nickname",
                  style: TextStyle(
                    height: heightSize(0.2),
                    fontFamily: "ZonaLight",
                    fontSize: heightSize(2),
                    color: MyColors().darkblueText,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: heightSize(3)),
        ],
      ),
    );
  }

  Widget divider() {
    return Divider(
      color: MyColors().darkblueText,
      thickness: 1,
    );
  }

  Widget eventPhotoAndTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "${widget.eventData['Title']}".toUpperCase(),
          style: TextStyle(
            fontFamily: "Zona",
            fontSize: heightSize(3.5),
            color: MyColors().darkblueText,
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
            child: FadeInImage.assetNetwork(fit: BoxFit.cover, placeholder: 'assets/images/etkinlik.jpg', image: widget.eventData['EventImageUrl']),
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
                color: MyColors().lightGreen,
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
                color: MyColors().lightGreen,
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

  Widget genderBoxes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          width: widthSize(43),
          height: heightSize(6),
          decoration: new BoxDecoration(
            color: MyColors().lightGreen,
            borderRadius: new BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "Kadın/Erkek",
                style: TextStyle(
                  fontFamily: "Zona",
                  fontSize: heightSize(2),
                  color: MyColors().whiteTextColor,
                ),
              ),
            ),
          ),
        ),
        Container(
          width: widthSize(43),
          height: heightSize(6),
          decoration: new BoxDecoration(
            color: MyColors().lightGreen,
            borderRadius: new BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "12/20 Katılımcı",
                style: TextStyle(
                  fontFamily: "Zona",
                  fontSize: heightSize(2),
                  color: MyColors().whiteTextColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget categoryColumn() {
    return Container(
      width: widthSize(100),
      height: heightSize(6),
      decoration: new BoxDecoration(
        color: MyColors().lightGreen,
        borderRadius: new BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Text(
          "Kategori | Alt Kategori",
          style: TextStyle(
            fontFamily: "Zona",
            fontSize: heightSize(2),
            color: MyColors().whiteTextColor,
          ),
        ),
      ),
    );
  }

  Widget mapAndJoin() {
    Widget joinUnjoinButton;

    if (katilbutton) {
      joinUnjoinButton = Container(
        width: widthSize(43),
        height: heightSize(8),
        decoration: new BoxDecoration(
          color: MyColors().darkblueText,
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

                  child: Image.asset("assets/icons/unjoin.png"),
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
      );
    } else {
      joinUnjoinButton = Container(
        width: widthSize(43),
        height: heightSize(8),
        decoration: new BoxDecoration(
          color: MyColors().darkblueText,
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
                  height: heightSize(4.5),
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
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
            Container(
              width: widthSize(43),
              height: heightSize(8),
              decoration: new BoxDecoration(
                color: MyColors().darkblueText,
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
          [
            InkWell(
                onTap: () async {
                  var eventService = Provider.of<EventService>(context, listen: false);
                  var userService = Provider.of<UserService>(context, listen: false);
                  if (katilbutton) {
                    if (await eventService.leaveEvent(userService.usermodel.getUserId(), widget.eventData['eventID'])) {
                      setState(() {
                        toggleJoinButton();
                        print("Ayrıldı");
                      });
                    } else {
                      print("Hata");
                    }
                  } else {
                    if (await eventService.joinEvent(userService.usermodel.getUserId(), widget.eventData['eventID'])) {
                      setState(() {
                        toggleJoinButton();
                        print("Katıldı");
                      });
                    } else {
                      print("Hata");
                    }
                  }
                },
                child: joinUnjoinButton)
          ],
    );
  }
}
