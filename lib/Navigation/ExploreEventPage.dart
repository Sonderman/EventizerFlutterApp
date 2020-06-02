import 'package:eventizer/Navigation/EventPage.dart';
import 'package:eventizer/Services/Repository.dart';
import 'package:eventizer/Tools/NavigationManager.dart';
import 'package:eventizer/Tools/PageComponents.dart';
import 'package:eventizer/assets/Colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

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
            // textField(),
            categoryList(),
            Expanded(child: eventList()),
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
    //String category = eventDatas['Category'];
    String imageUrl = eventDatas['EventImageUrl'];
    String startDate = eventDatas['StartDate'];
    String finishDate = eventDatas['FinishDate'];
    String currentParticipantNumber =
        eventDatas['CurrentParticipantNumber'].toString();
    String maxParticipantNumber = eventDatas['MaxParticipantNumber'].toString();
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
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        child: Container(
          width: widthSize(100),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: heightSize(2),
                ),
                Row(
                  children: <Widget>[
                    Row(
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
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(userData
                                              .data['ProfilePhotoUrl'])),
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
                    Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon:
                          Icon(Icons.share, color: MyColors().purpleContainer),
                    ),
                  ],
                ),
                Divider(
                  thickness: 2,
                  color: MyColors().loginGreyColor,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: FadeInImage.assetNetwork(
                    width: widthSize(80),
                    height: heightSize(40),
                    fit: BoxFit.cover,
                    placeholder: "assets/images/event_birthday.jpg",
                    image: imageUrl,
                  ),
                ),
                Divider(
                  thickness: 2,
                  color: MyColors().loginGreyColor,
                ),
                Row(
                  children: <Widget>[
                    //ANCHOR Start Date and Participants icons are here
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: heightSize(1),
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              child: FaIcon(
                                FontAwesomeIcons.calendarCheck,
                                color: MyColors().greyTextColor,
                              ),
                            ),
                            SizedBox(
                              width: widthSize(2),
                            ),
                            Text(
                              startDate,
                              style: TextStyle(
                                fontFamily: "Zona",
                                fontSize: heightSize(2),
                                color: MyColors().greyTextColor,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: heightSize(1),
                        ),
                        //TODO Katılımcı sayısı Stream ile getirilcek
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.people,
                              color: MyColors().greyTextColor,
                            ),
                            SizedBox(
                              width: widthSize(2),
                            ),
                            Text(
                              currentParticipantNumber +
                                  "/" +
                                  maxParticipantNumber +
                                  " Katılımcı",
                              style: TextStyle(
                                fontFamily: "Zona",
                                fontSize: heightSize(2),
                                color: MyColors().greyTextColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Spacer(),
                    //ANCHOR Finish Date and Locaition icons are here
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: heightSize(1),
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              child: FaIcon(
                                FontAwesomeIcons.calendarTimes,
                                color: MyColors().greyTextColor,
                              ),
                            ),
                            SizedBox(
                              width: widthSize(2),
                            ),
                            Text(
                              finishDate,
                              style: TextStyle(
                                fontFamily: "Zona",
                                fontSize: heightSize(2),
                                color: MyColors().greyTextColor,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: heightSize(1),
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.location_on,
                              color: MyColors().greyTextColor,
                            ),
                            SizedBox(
                              width: widthSize(1),
                            ),
                            Text(
                              "Diyarbakır",
                              style: TextStyle(
                                fontFamily: "Zona",
                                fontSize: heightSize(2),
                                color: MyColors().greyTextColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: heightSize(2.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget eventList() {
    var _eventManager = Provider.of<EventService>(context);
    String category;
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
          Expanded(
            child: Container(
                child: FutureBuilder(
                    future: (category == null || category == "Hepsi")
                        ? _eventManager.fetchActiveEventLists()
                        : _eventManager
                            .fetchActiveEventListsByCategory(category),
                    builder: (BuildContext context, AsyncSnapshot fetchedlist) {
                      if (fetchedlist.connectionState == ConnectionState.done) {
                        List<Map<String, dynamic>> listofMaps =
                            fetchedlist.data;
                        if (listofMaps.length == 0) {
                          return Center(child: Text("Etkinlik Yok"));
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
          ),
          SizedBox(
            height: heightSize(4),
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
            text: "En Yeni",
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
