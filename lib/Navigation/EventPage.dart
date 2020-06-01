import 'package:eventizer/Navigation/CommentsPageDetails/CommentsPageDetails.dart';
import 'package:eventizer/Navigation/ProfilePage.dart';
import 'package:eventizer/Services/Repository.dart';
import 'package:eventizer/Tools/NavigationManager.dart';
import 'package:eventizer/Tools/PageComponents.dart';
import 'package:eventizer/assets/Colors.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
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
  bool joinButton;
  TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    joinButton = widget.amIparticipant;
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  void toggleJoinButton() {
    joinButton = !joinButton;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: <Widget>[
              TabBar(
                  labelColor: MyColors().darkblueText,
                  unselectedLabelColor: MyColors().darkblueText,
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
                        genderAndParticipantsBoxes(),
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
                  //ANCHOR Comments page
                  commentsPage(),
                  //ANCHOR Participants page
                  participantsPage(),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget participantsPage() {
    var eventService = Provider.of<EventService>(context);
    var userService = Provider.of<UserService>(context);
    return FutureBuilder(
      future: eventService.getParticipants(widget.eventData['eventID']),
      builder: (BuildContext context,
          AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data.length == 0) {
            return Center(child: Text("Katılımcı Yok"));
          } else {
            return ListView.separated(
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: heightSize(3),
                );
              },
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return FutureBuilder(
                  future: userService
                      .findUserByID(snapshot.data[index]['ParticipantID']),
                  builder: (BuildContext context, AsyncSnapshot user) {
                    if (user.connectionState == ConnectionState.done) {
                      return InkWell(
                        onTap: () {
                          //TODO ProfilePage e userID yerine usermodel gitmeli direk olarak
                          NavigationManager(context).pushPage(ProfilePage(
                            isFromEvent: true,
                            userID: user.data['UserID'],
                          ));
                        },
                        child: Container(
                          height: heightSize(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: MyColors().lightGreen,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  height: heightSize(7),
                                  width: widthSize(14),
                                  decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: ExtendedNetworkImageProvider(
                                          user.data['ProfilePhotoUrl'],
                                          cache: true),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: widthSize(3),
                                ),
                                Text(
                                  user.data['Name'] + user.data['Surname'],
                                  style: TextStyle(
                                    fontFamily: "Zona",
                                    fontSize: heightSize(2.5),
                                    color: MyColors().darkblueText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                );
              },
            );
          }
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget commentsPage() {
    var eventService = Provider.of<EventService>(context);
    var userService = Provider.of<UserService>(context);
    return Column(
      children: <Widget>[
        Expanded(
          child: FutureBuilder(
              future: eventService.getComments(widget.eventData['eventID']),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data.length == 0) {
                    return Center(child: Text("Henüz yorum yapılmadı"));
                  } else
                    return ListView.separated(
                        //physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        separatorBuilder: (ctx, index) =>
                            SizedBox(height: heightSize(3)),
                        itemBuilder: (BuildContext context, int index) {
                          return ProfileListItem(
                              jsonData: snapshot.data[index]);
                        });
                } else
                  return PageComponents().loadingOverlay(context, Colors.white);
              }),
        ),
        SizedBox(
          height: heightSize(5),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Wrap(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(5, 3, 5, 1),
                        child: TextField(
                          style: TextStyle(
                            fontFamily: "ZonaLight",
                            fontSize: heightSize(2),
                            color: MyColors().darkblueText,
                          ),
                          controller: commentController,
                          keyboardType: TextInputType.text,
                          enableInteractiveSelection: true,
                          cursorColor: MyColors().blueThemeColor,
                          maxLength: 256,
                          textCapitalization: TextCapitalization.sentences,
                          onChanged: (text) {},
                          decoration: InputDecoration(
                            labelText: 'Yorum yapın.',
                            labelStyle: TextStyle(
                              fontFamily: "ZonaLight",
                              fontSize: heightSize(2),
                              color: MyColors().darkblueText,
                            ),
                            errorStyle: TextStyle(
                              color: Colors.red,
                            ),
                            fillColor: MyColors().blueThemeColor,
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: MyColors().blueThemeColor)),
                            counterText: '',
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              borderSide: BorderSide(
                                  width: 1, color: MyColors().blueThemeColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              borderSide: BorderSide(
                                  width: 1, color: MyColors().blueThemeColor),
                            ),
                          ),
                        )),
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(5, 3, 5, 1),
                      child: FlatButton(
                        onPressed: () async {
                          //ANCHOR  Yorum gönderme backend işlemleri
                          if (commentController.text != "") {
                            await eventService.sendComment(
                                widget.eventData['eventID'],
                                userService.userModel.getUserId(),
                                commentController.text);
                            setState(() {
                              commentController.text = '';
                            });
                            print("Yorum yapıldı");
                            /* nestedScrollController.jumpTo(
                                nestedScrollController
                                        .position.maxScrollExtent
                                    );*/
                          }
                        },
                        child: Text(
                          "Gönder",
                          style: TextStyle(
                            fontFamily: "Zona",
                            fontSize: heightSize(2),
                            color: MyColors().darkblueText,
                          ),
                        ),
                      ))
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: heightSize(5),
        )
      ],
    );
  }

  Widget userPhotoAndName() {
    return FlatButton(
      padding: EdgeInsets.all(0),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
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
    String startTime = widget.eventData['StartTime'] ?? "null";
    String finishTime = widget.eventData['FinishTime'] ?? "null";
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: widthSize(43),
              height: heightSize(6),
              decoration: new BoxDecoration(
                color: MyColors().darkblueText,
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
                          text: " | " + startTime,
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
                color: MyColors().darkblueText,
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
                          text: " | " + finishTime,
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
            color: MyColors().lightBlueContainer,
            width: widthSize(100),
            height: heightSize(20),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                widget.eventData['Detail'],
                style: TextStyle(
                  fontFamily: "Zona",
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

  Widget genderAndParticipantsBoxes() {
    String gender;
    //ANCHOR cinsiyetlere göre durumları
    switch (widget.eventData['AllowedGenders']) {
      case "10":
        gender = "Erkek";
        break;
      case "01":
        gender = "Kadın";
        break;
      case "11":
        gender = "Erkek/Kadın";
        break;
    }
    String currentParticipantNumber =
        widget.eventData['CurrentParticipantNumber'].toString();
    String maxParticipantNumber =
        widget.eventData['MaxParticipantNumber'].toString();

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
                gender,
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
            color: MyColors().orangeContainer,
            borderRadius: new BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                currentParticipantNumber +
                    "/" +
                    maxParticipantNumber +
                    " Katılımcı",
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
        color: MyColors().purpleContainer,
        borderRadius: new BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Text(
          widget.eventData['MainCategory'] +
              " | " +
              widget.eventData['SubCategory'],
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

    if (joinButton) {
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
                  var eventService =
                      Provider.of<EventService>(context, listen: false);
                  var userService =
                      Provider.of<UserService>(context, listen: false);
                  if (joinButton) {
                    if (await eventService.leaveEvent(
                        userService.userModel.getUserId(),
                        widget.eventData['eventID'])) {
                      setState(() {
                        toggleJoinButton();
                        print("Ayrıldı");
                      });
                    } else {
                      print("Hata");
                    }
                  } else {
                    if (await eventService.joinEvent(
                        userService.userModel.getUserId(),
                        widget.eventData['eventID'])) {
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
