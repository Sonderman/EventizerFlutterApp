import 'package:eventizer/Models/UserModel.dart';
import 'package:eventizer/Navigation/MyEventsPage.dart';
import 'package:eventizer/Navigation/SettingsPage.dart';
import 'package:eventizer/Services/AuthCheck.dart';
import 'package:eventizer/Services/AuthService.dart';
import 'package:eventizer/Services/Repository.dart';
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

  UserService userService;
  User userModel;
  bool amIFollowing = false, isThisProfileMine;
  String nameText,
      surnameText,
      aboutText,
      followersText,
      eventsText,
      trustText,
      profilePhotoUrl;

  TabController _tabController;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    userService = Provider.of<UserService>(context);
    if (widget.userID != userService.userModel.userID) {
      isThisProfileMine = false;
      userModel = User(userID: widget.userID);
      if (await userService.amIFollowing(userModel.userID)) {
        amIFollowing = true;
      } else {
        amIFollowing = false;
      }
    } else {
      isThisProfileMine = true;
      _tabController = TabController(length: 2, vsync: this);
      userModel = User(userID: widget.userID);
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

  Widget avatarAndName() => Container(
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
                Visibility(
                  //replacement: SizedBox(),
                  visible: isThisProfileMine,
                  child: InkWell(
                    onTap: () =>
                        NavigationManager(context).pushPage(SettingsPage()),
                    child: Container(
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
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      nameText.toUpperCase() + ' ' + surnameText.toUpperCase(),
                      style: TextStyle(
                        fontFamily: "Zona",
                        fontSize: widthSize(4),
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
                Visibility(
                  replacement: SizedBox(),
                  visible: isThisProfileMine,
                  child: Container(
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
                ),
              ],
            ),
          ],
        ),
      );

  Widget threeBoxes() => Padding(
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
                InkWell(
                  onTap: () {
                    NavigationManager(context).pushPage(MyEventsPage(
                      isOld: false,
                      userID: null,
                    ));
                  },
                  child: Container(
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
                ),
                InkWell(
                  onTap: () {
                    NavigationManager(context).pushPage(MyEventsPage(
                      isOld: true,
                      userID: null,
                    ));
                  },
                  child: Container(
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

  @override
  Widget build(BuildContext context) {
    if (!isThisProfileMine) {
      return FutureBuilder(
          future: userService.findUserByID(widget.userID),
          builder:
              (BuildContext context, AsyncSnapshot<Map<String, dynamic>> data) {
            if (data.connectionState == ConnectionState.done) {
              userModel.parseMap(data.data);
              textUpdaterByUserModel(userModel);
              return Scaffold(
                body: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 25,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            avatarAndName(),
                            numberDatas(),
                            threeBoxes(),
                          ],
                        ),
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
      textUpdaterByUserModel(userService.userModel);
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
                  SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        avatarAndName(),
                        numberDatas(),
                        threeBoxes(),
                      ],
                    ),
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
