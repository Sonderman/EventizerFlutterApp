import 'package:eventizer/Navigation/EventPage.dart';
import 'package:eventizer/Services/Repository.dart';
import 'package:eventizer/Tools/NavigationManager.dart';
import 'package:eventizer/Tools/PageComponents.dart';
import 'package:eventizer/assets/Colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyEventsPage extends StatefulWidget {
  final String userID;
  final bool isOld;

  const MyEventsPage({Key key, this.userID, this.isOld}) : super(key: key);

  @override
  _MyEventsPageState createState() => _MyEventsPageState();
}

class _MyEventsPageState extends State<MyEventsPage> {
  bool isMine;

  @override
  void initState() {
    super.initState();
    widget.userID == null ? isMine = false : isMine = true;
  }

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
            //categoryList(),
            eventList(),
          ],
        ),
      ),
    );
  }

  Widget eventItem(Map<String, dynamic> eventDatas) {
    UserService userWorker = Provider.of<UserService>(context);
    var eventService = Provider.of<EventService>(context);
    String eventID = eventDatas['eventID'];
    String title = eventDatas['Title'];
    String ownerID = eventDatas['OrganizerID'];
    String category = eventDatas['Category'];
    String imageUrl = eventDatas['EventImageUrl'];
    String startDate = eventDatas['StartDate'];
    Map<String, dynamic> ownerData;
    return InkWell(
      onTap: () async {
        eventService
            .amIparticipant(userWorker.userModel.getUserId(), eventID)
            .then((amIparticipant) {
          print("Kullanıcı bu etkinliğe katılmış:" + amIparticipant.toString());
          NavigationManager(context).pushPage(EventPage(
            eventData: eventDatas,
            userData: ownerData,
            amIparticipant: amIparticipant,
          ));
        });
      },
      child: ClipRRect(
        borderRadius: new BorderRadius.all(
          Radius.circular(20),
        ),
        child: Container(
          width: widthSize(100),
          height: heightSize(33),
          color: Colors.white,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: heightSize(2),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Container(
                      height: heightSize(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: FutureBuilder(
                          future: userWorker.findUserByID(ownerID),
                          builder: (BuildContext _,
                              AsyncSnapshot<dynamic> userData) {
                            if (userData.connectionState ==
                                ConnectionState.done) {
                              ownerData = userData.data;
                              //ANCHOR user profil resmi burada
                              return Container(
                                height: heightSize(5),
                                width: widthSize(10),
                                decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                          userData.data['ProfilePhotoUrl'])),
                                ),
                              );
                            } else
                              return Image.asset(
                                  "assets/images/avatar_man.png");
                          }),
                    ),
                    SizedBox(
                      width: widthSize(2),
                    ),
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: "Zona",
                        fontSize: heightSize(2),
                        color: MyColors().greyTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Divider(
                  thickness: 2,
                  color: MyColors().loginGreyColor,
                ),
              ),
              Container(
                height: heightSize(22),
                child: FadeInImage.assetNetwork(
                    placeholder: "assets/images/event_birthday.jpg",
                    image: imageUrl),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget eventList() {
    var _eventManager = Provider.of<EventService>(context);

    String userID = widget.userID == null
        ? Provider.of<UserService>(context, listen: false).userModel.getUserId()
        : widget.userID;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: heightSize(5),
          ),
          titleText(),
          SizedBox(
            height: heightSize(2),
          ),
          //ANCHOR event list start are here---------------------------------------------
          Container(
              height: heightSize(70),
              child: FutureBuilder(
                  future: _eventManager.fetchEventListsForUser(
                      userID, widget.isOld),
                  builder: (BuildContext context, AsyncSnapshot fetchedlist) {
                    if (fetchedlist.connectionState == ConnectionState.done) {
                      List<Map<String, dynamic>> listofMaps = fetchedlist.data;
                      if (listofMaps.length == 0) {
                        return Center(child: Card(child: Text("Etkinlik Yok")));
                      } else {
                        return ListView.separated(
                            separatorBuilder:
                                //ANCHOR ayıraç burada
                                (BuildContext context, int index) => SizedBox(
                                      height: heightSize(3),
                                    ),
                            itemCount: listofMaps.length,
                            itemBuilder: (context, index) {
                              return eventItem(listofMaps[index]);
                            });
                      }
                    } else
                      return PageComponents()
                          .loadingCustomOverlay(500, Colors.white);
                  })),
        ],
      ),
    );
  }

  Widget titleText() {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: widget.isOld ? "Geçmiş" : "Gelecek",
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
}
