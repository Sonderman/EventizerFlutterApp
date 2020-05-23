import 'package:eventizer/Models/UserModel.dart';
import 'package:eventizer/Navigation/EventPage.dart';
import 'package:eventizer/Services/AuthCheck.dart';
import 'package:eventizer/Services/AuthService.dart';
import 'package:eventizer/Services/Repository.dart';
import 'package:eventizer/Settings/AppSettings.dart';
import 'package:eventizer/Tools/BottomNavigation.dart';
import 'package:eventizer/Tools/Message.dart';
import 'package:eventizer/Tools/NavigationManager.dart';
import 'package:eventizer/Tools/PageComponents.dart';
import 'package:eventizer/assets/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  final userID;
  final isFromEvent;

  const ProfilePage({Key key, this.userID, this.isFromEvent}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  double heightSize(double value) {
    value /= 100;
    return MediaQuery.of(context).size.height * value;
  }

  double widthSize(double value) {
    value /= 100;
    return MediaQuery.of(context).size.width * value;
  }

  UserService userWorker;
  User usermodel;
  bool amIFollowing = false;
  String nameText;
  String surnameText;
  String aboutText;
  String followersText;
  String eventsText;
  String trustText;
  String profilePhotoUrl;

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    usermodel = User(userID: widget.userID);
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    userWorker = Provider.of<UserService>(context);
    if (widget.userID != userWorker.usermodel.userID) if (await userWorker
        .amIFollowing(usermodel.userID)) {
      setState(() {
        amIFollowing = true;
      });
    } else {
      setState(() {
        amIFollowing = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  void textUpdaterByUserModel(User model) {
    nameText = model.getUserName() ?? "Loading";
    surnameText = model.getUserSurname() ?? "Loading";
    aboutText = model.getUserAbout() ?? "Loading";
    followersText = model.getUserFollowNumber().toString();
    eventsText = model.getUserEventsNumber().toString();
    trustText = model.getUserTrustPointNumber().toString();
    profilePhotoUrl = model.getUserProfilePhotoUrl();
  }

  Widget avatarAndname() => Container(
        alignment: Alignment.center,
        height: heightSize(35),
        width: widthSize(85),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: heightSize(1),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              width: widthSize(82),
              child: FadeInImage.assetNetwork(
                  height: widthSize(48),
                  width: widthSize(80),
                  fit: BoxFit.fill,
                  placeholder: "assets/images/avatar_man.png",
                  image: profilePhotoUrl),
            ),
            SizedBox(
              height: heightSize(1),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  height: heightSize(6),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Image.asset(
                      "assets/icons/options.png",
                    ),
                  ),
                  decoration: new BoxDecoration(
                    color: MyColors().yellowContainer,
                    borderRadius: new BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      nameText.toUpperCase() + ' ' + surnameText.toUpperCase(),
                      style: TextStyle(
                        fontFamily: "Zona",
                        fontSize: heightSize(3),
                      ),
                    ),
                    Text(
                      "@nickname",
                      style: TextStyle(
                        fontFamily: "ZonaLight",
                        fontSize: heightSize(2),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: heightSize(6),
                  child: IconButton(
                      icon: Icon(FontAwesomeIcons.signOutAlt),
                      onPressed: () {
                        var auth = AuthService.of(context).auth;
                        auth.signOut();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    AuthCheck()));
                      }),
                  decoration: new BoxDecoration(
                    color: MyColors().yellowContainer,
                    borderRadius: new BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  //ANCHOR yabancı tarafından görülen kısım
  Widget threeBoxes() => Column(
        children: <Widget>[
          //ANCHOR About myself box is here
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            width: widthSize(82),
            child: FadeInImage.assetNetwork(
                placeholder: "assets/images/avatar_man.png",
                image: profilePhotoUrl),
          ),
          SizedBox(
            height: heightSize(1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: heightSize(8),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Image.asset("assets/icons/options.png"),
                ),
                decoration: new BoxDecoration(
                  color: MyColors().yellowContainer,
                  borderRadius: new BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
              ),
              SizedBox(
                width: widthSize(2),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    nameText.toUpperCase() + ' ' + surnameText.toUpperCase(),
                    style: TextStyle(
                      fontFamily: "Zona",
                      fontSize: heightSize(3),
                    ),
                  ),
                  Text(
                    "@nickname",
                    style: TextStyle(
                      fontFamily: "ZonaLight",
                      fontSize: heightSize(2),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      );

  Widget threeBoxesOwnProfile() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: <Widget>[
            //ANCHOR About myself box are here
            SizedBox(
              height: heightSize(3),
            ),
            Container(
              height: heightSize(20),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Center(
                  child: Text(
                    aboutText,
                    style: TextStyle(
                      fontFamily: "Zona",
                      fontSize: heightSize(2),
                      color: MyColors().whiteTextColor,
                    ),
                  ),
                ),
              ),
              decoration: new BoxDecoration(
                color: MyColors().blueContainer,
                borderRadius: new BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
            ),
            SizedBox(
              height: heightSize(3),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: widthSize(43),
                  height: heightSize(8),
                  decoration: new BoxDecoration(
                    color: MyColors().purpleContainer,
                    borderRadius: new BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: InkWell(
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            height: heightSize(5),
                            child: Image.asset("assets/icons/future.png"),
                          ),
                          Text(
                            "Gelecek \nEtkinlikler",
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
                  decoration: BoxDecoration(
                    color: MyColors().purpleContainer,
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: InkWell(
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            height: heightSize(5),
                            child: Image.asset("assets/icons/past.png"),
                          ),
                          Text(
                            "Geçmiş \nEtkinlikler",
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

  Widget numberDatas() => Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    "ETKİNLİK",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: MyColors().blueTextColor,
                      fontFamily: "Zona",
                      fontSize: 17,
                    ),
                  ),
                  Text(eventsText,
                      style: TextStyle(
                        color: MyColors().blueTextColor,
                        fontFamily: "ZonaLight",
                        fontSize: 25,
                      )),
                ],
              ),
              Column(
                children: <Widget>[
                  Text(
                    "TAKİP \n EDEN",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: MyColors().blueTextColor,
                      fontFamily: "Zona",
                      fontSize: 17,
                    ),
                  ),
                  Text(followersText,
                      style: TextStyle(
                        color: MyColors().blueTextColor,
                        fontFamily: "ZonaLight",
                        fontSize: 25,
                      )),
                ],
              ),
              Column(
                children: <Widget>[
                  Text("TAKİP \n EDİLEN",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: MyColors().blueTextColor,
                        fontFamily: "Zona",
                        fontSize: 17,
                      )),
                  Text(
                      //REVIEW myFollowers text should be here
                      followersText,
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
                        fontSize: 17,
                      )),
                  Text(trustText,
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

  Widget itemCard(String title, String category, String name, String imageUrl,
      String startDate) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            //ANCHOR resimlerin cache de saklanması sağlandı
            child: FadeInImage.assetNetwork(
              placeholder: 'assets/images/etkinlik.jpg',
              image: imageUrl,
              fit: BoxFit.fill,
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 200.0,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(1),
                  Colors.black.withOpacity(0.9),
                  Colors.black.withOpacity(0.8),
                  Colors.black.withOpacity(0.7),
                  Colors.black.withOpacity(0.6),
                  Colors.black.withOpacity(0.5),
                  Colors.black.withOpacity(0.4),
                  Colors.black.withOpacity(0.1),
                  Colors.black.withOpacity(0.05),
                  Colors.black.withOpacity(0.025),
                  Colors.black.withOpacity(0),
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  title ?? "",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        category ?? "",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        startDate ?? "",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
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
    //String detail = eventDatas['Detail'];
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: userWorker.findUserbyID(ownerID),
          builder: (BuildContext context,
              AsyncSnapshot<Map<String, dynamic>> userData) {
            if (userData.connectionState == ConnectionState.done) {
              String name = userData.data['Name'];
              return GestureDetector(
                  onTap: () async {
                    eventService
                        .amIparticipant(
                            userWorker.usermodel.getUserId(), eventID)
                        .then((amIparticipant) {
                      print("Kullanıcı bu etkinliğe katılmış:" +
                          amIparticipant.toString());
                      //ANCHOR tıklanınca eventPage e giden yer
                      NavigationManager(context).pushPage(EventPage(
                        eventData: eventDatas,
                        userData: userData.data,
                        amIparticipant: amIparticipant,
                      ));

                      /*
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => EventPage(
                                  //eventData: eventDatas,
                                  // userData: userData.data,
                                  //amIparticipant: amIparticipant,
                                  )));
                                  */
                    });
                  },
                  child: itemCard(title, category, name, imageUrl, startDate));
            } else
              return PageComponents().loadingOverlay(context, Colors.white);
          },
        ));
  }

  Widget eventList() {
    var eventService = Provider.of<EventService>(context);
    return FutureBuilder(
      future:
          eventService.fetchListOfUserEvents(userWorker.usermodel.getUserId()),
      builder: (BuildContext context, AsyncSnapshot fetchedlist) {
        if (fetchedlist.connectionState == ConnectionState.done) {
          List<Map<String, dynamic>> listofMaps = fetchedlist.data;
          if (listofMaps.length == 0) {
            return SliverToBoxAdapter(child: Text("Etkinlik Yok"));
          } else {
            return SliverGrid(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return eventItem(listofMaps[index]);
                }, childCount: listofMaps.length),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1));
          }
        } else
          return SliverToBoxAdapter(
              child: PageComponents().loadingOverlay(context, Colors.white));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.userID != userWorker.usermodel.userID) {
      print("Gelen userID:" + widget.userID);

      return FutureBuilder(
          future: userWorker.findUserbyID(widget.userID),
          builder:
              (BuildContext context, AsyncSnapshot<Map<String, dynamic>> data) {
            if (data.connectionState == ConnectionState.done) {
              usermodel.parseMap(data.data);
              textUpdaterByUserModel(usermodel);
              return Scaffold(
                body: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 25,
                    ),
                    Container(
                      child: TabBar(
                          indicatorColor: Colors.teal,
                          labelColor: Colors.teal,
                          unselectedLabelColor: Colors.black54,
                          controller: _tabController,
                          isScrollable: true,
                          tabs: [
                            Tab(
                              text: "Profilim",
                            ),
                            Tab(
                              text: "Bildirimler",
                            ),
                          ]),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: <Widget>[
                          CustomScrollView(
                            slivers: <Widget>[
                              SliverToBoxAdapter(
                                child: Column(
                                  children: <Widget>[
                                    avatarAndname(),
                                    numberDatas(),
                                    threeBoxes(),
                                    //eventList,
                                  ],
                                ),
                              ),
                              SliverPadding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 25),
                                sliver: eventList(), //ANCHOR Event list
                              )
                            ],
                          ),
                          Center(
                            child: PageComponents().underConstruction(context),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else
              return Center(
                child: PageComponents().loadingOverlay(context, Colors.white),
              );
          });
    } else {
      textUpdaterByUserModel(userWorker.usermodel);
      return Scaffold(
        body: Column(
          children: <Widget>[
            SizedBox(
              height: 25,
            ),
            Container(
              child: TabBar(
                  indicatorColor: Colors.teal,
                  labelColor: Colors.teal,
                  unselectedLabelColor: Colors.black54,
                  controller: _tabController,
                  isScrollable: true,
                  tabs: [
                    Tab(
                      text: "Profilim",
                    ),
                    Tab(
                      text: "Bildirimler",
                    ),
                  ]),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  CustomScrollView(
                    slivers: <Widget>[
                      SliverToBoxAdapter(
                        child: Column(
                          children: <Widget>[
                            avatarAndname(),
                            numberDatas(),
                            threeBoxesOwnProfile(),
                            //eventList,
                          ],
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        sliver: eventList(),
                      )
                    ],
                  ),
                  Center(
                    child: PageComponents().underConstruction(context),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
}
