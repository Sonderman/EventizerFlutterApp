import 'package:eventizer/Models/UserModel.dart';
import 'package:eventizer/Navigation/EventPage.dart';
import 'package:eventizer/Services/Repository.dart';
import 'package:eventizer/Tools/Message.dart';
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

class _ProfilePageState extends State<ProfilePage> with TickerProviderStateMixin {
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
    _tabController = TabController(length: 3, vsync: this);
    usermodel = User(userID: widget.userID);
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    userWorker = Provider.of<UserService>(context);
    if (widget.userID != userWorker.usermodel.userID) if (await userWorker.amIFollowing(usermodel.userID)) {
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

  @override
  Widget build(BuildContext context) {
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
                //NOTE Currently avatar size is extreme big for default "avatar_man.png". But not for your "Mandolian" avatar. :)
                width: widthSize(82),
                child: FadeInImage.assetNetwork(placeholder: "assets/images/avatar_man.png", image: profilePhotoUrl),
              ),
              SizedBox(
                height: heightSize(1),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
          ),
        );

    //ANCHOR yabancı tarafından görülen kısım
    Widget threeBoxes() => Column(
          children: <Widget>[
            //ANCHOR About myself box is here
            Container(
              height: heightSize(8),
              width: widthSize(85),
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
                color: MyColors().yellowContainer,
                borderRadius: new BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
            ],
          ),
          decoration: new BoxDecoration(
            color: Colors.orange.shade200,
            borderRadius: new BorderRadius.all(
              Radius.circular(10),
            ),
            SizedBox(
              height: heightSize(3),
            ),
            //ANCHOR Chat and Follow boxes are here
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                // ANCHOR  Mesaj sayfasına gitmek için
                InkWell(
                  onTap: () {
                    //ANCHOR mesajlaşma sayfasında karşıdaki kişinin ismini getirip parametre olarak veriyoruz,
                    //Bu sayede appbarda ismi görünüyor
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Message(widget.userID, usermodel.getUserName())));
                  },
                  child: Container(
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
                ),
                amIFollowing
                    ? InkWell(
                        onTap: () async {
                          userWorker.followToggle(usermodel.userID).whenComplete(() {
                            setState(() {
                              amIFollowing = !amIFollowing;
                            });
                          });
                        },
                        child: Container(
                          height: heightSize(8),
                          width: widthSize(35),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                child: Image.asset("assets/icons/unfollow.png"),
                                height: heightSize(4),
                              ),
                              SizedBox(
                                width: widthSize(2),
                              ),
                              Text(
                                "Takip Etme",
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
                      )
                    : InkWell(
                        onTap: () async {
                          userWorker.followToggle(usermodel.userID).whenComplete(() {
                            setState(() {
                              amIFollowing = !amIFollowing;
                            });
                          });
                        },
                        child: Container(
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
                  color: MyColors().yellowContainer,
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
                    decoration:  BoxDecoration(
                      color: MyColors().purpleContainer,
                      borderRadius:  BorderRadius.all(
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
            SizedBox(
              height: heightSize(5),
            ),
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
            SizedBox(
              height: heightSize(5),
            ),
          ],
        );
/*
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
  }

  Column aboutMySelf(Color myBlueColor, Color yellowContainer,
      Color blueTextColor, List<Widget> images, userID) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          height: 60,
          child: Padding(
            padding: const EdgeInsets.only(left: 30, top: 20),
            child: Text("Hakkımda..."),
          ),
          decoration: new BoxDecoration(
            color: Colors.orange.shade200,
            borderRadius: new BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    "TAKİPÇİ",
                    style: TextStyle(
                      color: blueTextColor,
                      fontFamily: "Zona",
                      fontSize: 20,
                    ),
                  ),
                  Text("56",
                      style: TextStyle(
                        color: blueTextColor,
                        fontFamily: "ZonaLight",
                        fontSize: 25,
                      )),
                ],
              ),
              Column(
                children: <Widget>[
                  Text("ETKİNLİK",
                      style: TextStyle(
                        color: blueTextColor,
                        fontFamily: "Zona",
                        fontSize: 20,
                      )),
                  Text("56",
                      style: TextStyle(
                        color: blueTextColor,
                        fontFamily: "ZonaLight",
                        fontSize: 25,
                      )),
                ],
              ),
              Column(
                children: <Widget>[
                  Text("GÜVEN PUANI",
                      style: TextStyle(
                        color: blueTextColor,
                        fontFamily: "Zona",
                        fontSize: 20,
                      )),
                  Text("105",
                      style: TextStyle(
                        color: blueTextColor,
                        fontFamily: "ZonaLight",
                        fontSize: 25,
                      )),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Column messageButtonCard() {
    UserService userService = Provider.of<UserService>(context);
    return Column(
      children: <Widget>[
        Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width *
                0.3, // ANCHOR ekran genişliğinin 3de1 uzunluğunu veriyor
            child: FlatButton.icon(
              icon: Icon(LineAwesomeIcons.envelope),
              color: Colors.green,
              label: Text(
                "Mesaj\nGönder",
                style: TextStyle(fontSize: 10.0),
              ),
              textColor: Colors.black,
              onPressed: () async {
                // ANCHOR  Mesaj sayfasına gitmek için
                if (userService.usermodel.getUserId() != widget.userID) {
                  //ANCHOR mesajlaşma sayfasında karşıdaki kişinin ismini getirip parametre olarak veriyoruz,
                  //Bu sayede appbarda ismi görünüyor
                  await userService.findUserbyID(widget.userID).then((data) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                Message(widget.userID, data['Name'])));
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
    */
  }
}
