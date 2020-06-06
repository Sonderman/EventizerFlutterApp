import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:eventizer/Navigation/Components/CustomScroll.dart';
import 'package:eventizer/Services/Repository.dart';
import 'package:eventizer/Tools/Message.dart';
import 'package:eventizer/Tools/PageComponents.dart';
import 'package:eventizer/assets/Colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  double heightSize(double value) {
    value /= 100;
    return MediaQuery.of(context).size.height * value;
  }

  double widthSize(double value) {
    value /= 100;
    return MediaQuery.of(context).size.width * value;
  }

  //NOTE The group chat buttons are not include of image.
  // Just selectable of color.
  // Because this is more plain and looks like colorful and stable than with image.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: <Widget>[
            /*
            SizedBox(
              height: heightSize(10),
            ),
            groupChatButtons(),
            */
            SizedBox(
              height: heightSize(5),
            ),
            chatRows(),
            SizedBox(
              height: heightSize(5),
            ),
          ],
        ),
      ),
    );
  }

  Widget chatRows() {
    var messageService = Provider.of<MessagingService>(context);
    var userService = Provider.of<UserService>(context);
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Mesajlar",
            style: TextStyle(
              fontFamily: "Zona",
              fontSize: heightSize(3),
              color: MyColors().loginGreyColor,
            ),
          ),
          SizedBox(
            height: heightSize(3),
          ),
          Expanded(
            child: StreamBuilder(
              stream: messageService
                  .getUserChatsSnapshot(userService.userModel.getUserId()),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return PageComponents(context)
                      .loadingOverlay(backgroundColor: Colors.white);
                } else {
                  List<DocumentSnapshot> items = snapshot.data.documents;
                  int itemLength = items.length;
                  return ScrollConfiguration(
                    behavior: NoScrollEffectBehavior(),
                    child: ListView.separated(
                        separatorBuilder: (BuildContext context, int index) =>
                            Divider(
                              height: 50,
                            ),
                        itemCount: itemLength,
                        itemBuilder: (context, index) {
                          String otherUserID = items[index].data['OtherUserID'];
                          String chatID = items[index].documentID;
                          return FutureBuilder(
                              future: userService.findUserByID(otherUserID),
                              builder: (context, snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.done:
                                    String url =
                                        snapshot.data['ProfilePhotoUrl'];
                                    String userName = snapshot.data['Name'];

                                    return InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        Message(otherUserID,
                                                            userName)));
                                      },
                                      child: StreamBuilder(
                                          stream: messageService
                                              .getChatPoolSnapshot(chatID),
                                          builder: (_, lastMessageSnap) {
                                            if (lastMessageSnap.hasData) {
                                              var lastMessagemap =
                                                  lastMessageSnap.data;
                                              String message =
                                                  lastMessagemap["LastMessage"]
                                                      ["Message"];

                                              String formattedTime = DateFormat(
                                                      'kk:mm')
                                                  .format(DateTime
                                                      .fromMillisecondsSinceEpoch(
                                                          lastMessagemap[
                                                                  "LastMessage"]
                                                              ["createdAt"]));

                                              return Row(
                                                children: <Widget>[
                                                  Container(
                                                    height: heightSize(7),
                                                    width: widthSize(14),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image:
                                                            NetworkImage(url),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: widthSize(3),
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text(
                                                        "$userName",
                                                        style: TextStyle(
                                                          fontFamily: "Zona",
                                                          fontSize:
                                                              heightSize(2.5),
                                                          color: MyColors()
                                                              .loginGreyColor,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: widthSize(62),
                                                        child: Text(
                                                          message,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                            height:
                                                                heightSize(0.2),
                                                            fontFamily:
                                                                "ZonaLight",
                                                            fontSize:
                                                                heightSize(2),
                                                            color: MyColors()
                                                                .greyTextColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Spacer(),
                                                  Text(
                                                    formattedTime,
                                                    style: TextStyle(
                                                      height: heightSize(0.2),
                                                      fontFamily: "ZonaLight",
                                                      fontSize: heightSize(2),
                                                      color: MyColors()
                                                          .greyTextColor,
                                                    ),
                                                  )
                                                ],
                                              );
                                            } else
                                              return Text("null");
                                          }),
                                    );
                                    break;
                                  case ConnectionState.none:
                                    return Center(child: Text("Hata"));
                                  case ConnectionState.waiting:
                                    return PageComponents(context)
                                        .loadingCustomOverlay(
                                            spinColor:
                                                MyColors().blueThemeColor,
                                            spinSize: 40);
                                  default:
                                    return Center(
                                        child: Text("Beklenmedik durum"));
                                }
                              });
                        }),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget groupChatButtons() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              addNewGroupChatVoid();
            },
            child: Container(
              width: widthSize(30),
              height: heightSize(20),
              decoration: BoxDecoration(
                border: Border.all(
                  color: MyColors().blackOpacityContainer,
                  width: 2,
                ),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.add,
                    size: heightSize(6),
                    color: MyColors().greyTextColor,
                  ),
                  SizedBox(
                    height: heightSize(2),
                  ),
                  Text(
                    "Yeni grup konuşması",
                    style: TextStyle(
                      fontFamily: "ZonaLight",
                      fontSize: heightSize(2),
                      color: MyColors().greyTextColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          //ANCHOR new container are start here
          SizedBox(
            width: widthSize(5),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: widthSize(30),
              height: heightSize(20),
              decoration: BoxDecoration(
                color: MyColors().yellowContainer,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Center(
                child: Text(
                  "Doğa Fotoğrafçıları",
                  style: TextStyle(
                    fontFamily: "Zona",
                    fontSize: heightSize(2),
                    color: MyColors().whiteTextColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          //ANCHOR new container are start here
          SizedBox(
            width: widthSize(5),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: widthSize(30),
              height: heightSize(20),
              decoration: BoxDecoration(
                color: MyColors().purpleContainer,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Center(
                child: Text(
                  "Konferans Hazırlığı",
                  style: TextStyle(
                    fontFamily: "Zona",
                    fontSize: heightSize(2),
                    color: MyColors().whiteTextColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          //ANCHOR new container are start here
          SizedBox(
            width: widthSize(5),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: widthSize(30),
              height: heightSize(20),
              decoration: BoxDecoration(
                color: MyColors().lightBlueContainer,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Center(
                child: Text(
                  "Yurtdışı Gezimiz Hakkında",
                  style: TextStyle(
                    fontFamily: "Zona",
                    fontSize: heightSize(2),
                    color: MyColors().whiteTextColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          //ANCHOR new container are start here
          SizedBox(
            width: widthSize(5),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: widthSize(30),
              height: heightSize(20),
              decoration: BoxDecoration(
                color: MyColors().orangeContainer,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Center(
                child: Text(
                  "Doğum Günü Partisi Hazırlıkları",
                  style: TextStyle(
                    fontFamily: "Zona",
                    fontSize: heightSize(2),
                    color: MyColors().whiteTextColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void addNewGroupChatVoid() {}
}
