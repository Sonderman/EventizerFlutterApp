import 'package:eventizer/Models/UserModel.dart';
import 'package:eventizer/Navigation/MyEventsPage.dart';
import 'package:eventizer/Navigation/SettingsPage.dart';
import 'package:eventizer/Services/AuthCheck.dart';
import 'package:eventizer/Services/AuthService.dart';
import 'package:eventizer/Services/Repository.dart';
import 'package:eventizer/Tools/Message.dart';
import 'package:eventizer/Tools/NavigationManager.dart';
import 'package:eventizer/Tools/PageComponents.dart';
import 'package:eventizer/assets/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
      _tabController = TabController(length: 1, vsync: this);
      userModel = User(userID: widget.userID);
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (_tabController != null) _tabController.dispose();
  }

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
                            followAndMessage(),
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
            //TODO bildirim sayfası yaparken açılacak
            /*
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
            */
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        avatarAndName(),
                        SizedBox(
                          height: heightSize(3),
                        ),
                        numberDatas(),
                        threeBoxes(),
                      ],
                    ),
                  ),
                  //Bildirim sayfası
                  /*
                  Center(
                    child: PageComponents().underConstruction(context),
                  )*/
                ],
              ),
            ),
          ],
        ),
      );
    }
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

//ANCHOR "isThisProfileMine" screen should be redesign.
  Widget avatarAndName() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: FadeInImage.assetNetwork(
                height: heightSize(30),
                fit: BoxFit.cover,
                placeholder: "assets/images/avatar_man.png",
                image: profilePhotoUrl,
              ),
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
                      height: heightSize(7),
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
                        fontSize: heightSize(3),
                      ),
                    ),
                    Text(
                      "@nickname",
                      style: TextStyle(
                        fontFamily: "ZonaLight",
                        fontSize: heightSize(2.5),
                      ),
                    ),
                  ],
                ),
                Visibility(
                  replacement: SizedBox(),
                  visible: isThisProfileMine,
                  child: InkWell(
                    onTap: () {
                      var auth = AuthService.of(context).auth;
                      auth.signOut();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => AuthCheck()));
                    },
                    child: Container(
                      height: heightSize(7),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset(
                          "assets/icons/logout.png",
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
              height: heightSize(2),
            ),
            Container(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  aboutText,
                  style: TextStyle(
                    fontFamily: "Zona",
                    fontSize: heightSize(2),
                    color: MyColors().whiteTextColor,
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

  Widget numberDatas() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
      );

  Widget followAndMessage() => Column(
        children: <Widget>[
          SizedBox(
            height: heightSize(3),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                InkWell(
                  onTap: () async {
                    await userService
                        .followToggle(userModel.getUserId())
                        .whenComplete(() {
                      setState(() {
                        amIFollowing = !amIFollowing;
                      });
                    });
                  },
                  child: Container(
                    width: widthSize(43),
                    height: heightSize(8),
                    decoration: new BoxDecoration(
                      color: MyColors().lightGreen,
                      borderRadius: new BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              height: heightSize(5),
                              child: amIFollowing
                                  ? Image.asset("assets/icons/unfollow.png")
                                  : Image.asset("assets/icons/follow.png"),
                            ),
                            Spacer(),
                            Text(
                              amIFollowing ? "Takibi \nBırak" : "Takip \nEt",
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
                  onTap: () async {
                    // ANCHOR  Mesaj sayfasına gitmek için
                    if (userService.userModel.getUserId() != widget.userID) {
                      //ANCHOR mesajlaşma sayfasında karşıdaki kişinin ismini getirip parametre olarak veriyoruz,
                      //Bu sayede appbarda ismi görünüyor
                      await userService
                          .findUserByID(widget.userID)
                          .then((data) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    Message(widget.userID, data['Name'])));
                      });
                    }
                  },
                  child: Container(
                    width: widthSize(43),
                    height: heightSize(8),
                    decoration: BoxDecoration(
                      color: MyColors().darkblueText,
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    child: InkWell(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Row(
                            children: <Widget>[
                              Container(
                                height: heightSize(4.2),
                                child:
                                    Image.asset("assets/icons/sendMessage.png"),
                              ),
                              Spacer(),
                              Text(
                                "Mesaj \nGönder",
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
                ),
              ],
            ),
          ),
        ],
      );
}
