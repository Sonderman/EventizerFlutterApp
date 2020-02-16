import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventizer/Services/Repository.dart';
import 'package:eventizer/Tools/Message.dart';
import 'package:eventizer/assets/Colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatsPage extends StatefulWidget {
  ChatsPage({Key key}) : super(key: key);

  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  @override
  Widget build(BuildContext context) {
    var messageService = Provider.of<MessagingService>(context);
    var userService = Provider.of<UserService>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: MyColors().blueThemeColor,
        title: Text("Sohbetler"),
      ),
      body: StreamBuilder(
        stream: messageService.getUserChatsSnapshot(userService.getUserId()),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            //FIXME Buraya bir çözüm bul çember şekilsiz oluyor
            return CircularProgressIndicator();
          } else {
            List<DocumentSnapshot> items = snapshot.data.documents;
            int itemLenght = items.length;
            return ListView.builder(
              itemCount: itemLenght,
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
                                  CircleAvatar(
                                    child: Image.network(url),
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
                        return CircularProgressIndicator();
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
