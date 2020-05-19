import 'package:cloud_firestore/cloud_firestore.dart';
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
                  .getUserChatsSnapshot(userService.usermodel.getUserId()),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return PageComponents().loadingOverlay(context, Colors.white);
                } else {
                  List<DocumentSnapshot> items = snapshot.data.documents;
                  int itemLength = items.length;
                  return ListView.separated(
                      separatorBuilder: (BuildContext context, int index) =>
                          Divider(
                            height: 50,
                          ),
                      itemCount: itemLength,
                      itemBuilder: (context, index) {
                        String userID = items[index].data['OtherUserID'];
                        return FutureBuilder(
                            future: userService.findUserbyID(userID),
                            builder: (context, snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.done:
                                  String url = snapshot.data['ProfilePhotoUrl'];
                                  String userName = snapshot.data['Name'];

                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  Message(userID, userName)));
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
                                              image: NetworkImage(url),
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
                                                text: "$userName\n",
                                                style: TextStyle(
                                                  fontFamily: "Zona",
                                                  fontSize: heightSize(2.5),
                                                  color:
                                                      MyColors().loginGreyColor,
                                                ),
                                              ),
                                              TextSpan(
                                                text: "Eventizer tutsa bari",
                                                style: TextStyle(
                                                  height: heightSize(0.2),
                                                  fontFamily: "ZonaLight",
                                                  fontSize: heightSize(2),
                                                  color:
                                                      MyColors().greyTextColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                  break;
                                case ConnectionState.none:
                                  return Text("Hata");
                                case ConnectionState.waiting:
                                  return PageComponents()
                                      .loadingSmallOverlay(40);
                                default:
                                  return Text("Beklenmedik durum");
                              }
                            });
                      });
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

/*

Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: heightSize(3),
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        height: heightSize(7),
                        width: widthSize(14),
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage("assets/images/avatar_man.png"),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: widthSize(3),
                      ),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: "Murat Altıntaş\n",
                                style: TextStyle(
                                  fontFamily: "Zona",
                                  fontSize: heightSize(2.5),
                                  color: MyColors().loginGreyColor,
                                ),
                              ),
                              TextSpan(
                                text:
                                    "Senin karşında 'Hello World' yazan ben yok artık...",
                                style: TextStyle(
                                  height: heightSize(0.2),
                                  fontFamily: "ZonaLight",
                                  fontSize: heightSize(2),
                                  color: MyColors().greyTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: heightSize(5),
                  ),
                  //ANCHOR another chat row are start here
                  Row(
                    children: <Widget>[
                      Container(
                        height: heightSize(7),
                        width: widthSize(14),
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage("assets/images/avatar_man.png"),
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
                              text: "Ali Bey\n",
                              style: TextStyle(
                                fontFamily: "Zona",
                                fontSize: heightSize(2.5),
                                color: MyColors().loginGreyColor,
                              ),
                            ),
                            TextSpan(
                              text: "Eventizer tutsa bari",
                              style: TextStyle(
                                height: heightSize(0.2),
                                fontFamily: "ZonaLight",
                                fontSize: heightSize(2),
                                color: MyColors().greyTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: heightSize(5),
                  ),
                  //ANCHOR another chat row are start here
                  Row(
                    children: <Widget>[
                      Container(
                        height: heightSize(7),
                        width: widthSize(14),
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage("assets/images/avatar_women.png"),
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
                              text: "Şukufe\n",
                              style: TextStyle(
                                fontFamily: "Zona",
                                fontSize: heightSize(2.5),
                                color: MyColors().loginGreyColor,
                              ),
                            ),
                            TextSpan(
                              text: "Sarma sarmayı öğretir misiniz?",
                              style: TextStyle(
                                height: heightSize(0.2),
                                fontFamily: "ZonaLight",
                                fontSize: heightSize(2),
                                color: MyColors().greyTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: heightSize(5),
                  ),
                  //ANCHOR another chat row are start here
                  Row(
                    children: <Widget>[
                      Container(
                        height: heightSize(7),
                        width: widthSize(14),
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage("assets/images/avatar_man.png"),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: widthSize(3),
                      ),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: "Ramiz Dayı\n",
                                style: TextStyle(
                                  fontFamily: "Zona",
                                  fontSize: heightSize(2.5),
                                  color: MyColors().loginGreyColor,
                                ),
                              ),
                              TextSpan(
                                text:
                                    "Bizim zamanımızda Flutter vardı da biz mi app yapmadık yeğen?",
                                style: TextStyle(
                                  height: heightSize(0.2),
                                  fontFamily: "ZonaLight",
                                  fontSize: heightSize(2),
                                  color: MyColors().greyTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: heightSize(5),
                  ),
                  //ANCHOR another chat row are start here
                  Row(
                    children: <Widget>[
                      Container(
                        height: heightSize(7),
                        width: widthSize(14),
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage("assets/images/avatar_man.png"),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: widthSize(3),
                      ),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: "Vehpi Dede\n",
                                style: TextStyle(
                                  fontFamily: "Zona",
                                  fontSize: heightSize(2.5),
                                  color: MyColors().loginGreyColor,
                                ),
                              ),
                              TextSpan(
                                text: "Vay benim gençliğim...",
                                style: TextStyle(
                                  height: heightSize(0.2),
                                  fontFamily: "ZonaLight",
                                  fontSize: heightSize(2),
                                  color: MyColors().greyTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        

*/
