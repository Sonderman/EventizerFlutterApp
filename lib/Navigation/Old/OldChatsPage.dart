import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventizer/Services/Repository.dart';
import 'package:eventizer/Tools/Message.dart';
import 'package:eventizer/Tools/PageComponents.dart';
import 'package:eventizer/assets/Colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OldChatsPage extends StatefulWidget {
  OldChatsPage({Key key}) : super(key: key);

  @override
  _OldChatsPageState createState() => _OldChatsPageState();
}

class _OldChatsPageState extends State<OldChatsPage> {
  @override
  Widget build(BuildContext context) {
    var messageService = Provider.of<MessagingService>(context);
    var userService = Provider.of<UserService>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: MyColors().blueThemeColor,
        title: Text("Gelen Kutusu"),
      ),
      body: StreamBuilder(
        stream: messageService
            .getUserChatsSnapshot(userService.usermodel.getUserId()),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return PageComponents().loadingOverlay(context, Colors.white);
          } else {
            List<DocumentSnapshot> items = snapshot.data.documents;
            int itemLength = items.length;
            return ListView.builder(
              itemCount: itemLength,
              itemBuilder: (context, index) {
                String userID = items[index].data['OtherUserID'];
                return FutureBuilder(
                  future: userService.findUserbyID(
                      userID), //ANCHOR Burada karşıdaki kişinin bütün bilgileri geliyor
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.done:
                        String url = snapshot.data['ProfilePhotoUrl'];
                        String userName = snapshot.data['Name'];
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          Message(userID, userName)));
                            },
                            child: Card(
                              child: Row(
                                children: <Widget>[
                                  Container(
                                      width: 50.0,
                                      height: 50.0,
                                      decoration: new BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: new DecorationImage(
                                              fit: BoxFit.fill,
                                              image: new NetworkImage(url)))),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(userName)
                                ],
                              ),
                            ),
                          ),
                        );
                        break;
                      case ConnectionState.none:
                        return Text("Hata");
                      case ConnectionState.waiting:
                        return PageComponents()
                            .loadingOverlay(context, Colors.white);
                      default:
                        return Text("Beklenmedik durum");
                    }
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
