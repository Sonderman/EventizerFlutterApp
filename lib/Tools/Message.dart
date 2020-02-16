import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:eventizer/Services/Repository.dart';
import 'package:eventizer/assets/Colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Message extends StatefulWidget {
  //ANCHOR Karşıdak kullanıcının Idsi ve ismi geliyor
  final otherUserID;
  final otherUserName;
  Message(this.otherUserID, this.otherUserName);

  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  final GlobalKey<DashChatState> _chatViewKey = GlobalKey<DashChatState>();
  List<ChatMessage> messages = List<ChatMessage>();
  UserService userService;
  var m = List<ChatMessage>();
  var scrollController = ScrollController();
  String chatID;
  String currentUserID;
  String otherUserID;
  String currentUserPhotoUrl;
  var i = 0;
  bool runFutureOnce = false;

  ChatUser user;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //ANCHOR Providerda context e ihtiyacımız olduğundan didchangedependecies ile contexte ulaşabiliyoruz, bu bir nevi initstate işlevi görüyor
    userService = Provider.of<UserService>(context);
    currentUserID = userService.getUserId();
    otherUserID = widget.otherUserID;
    currentUserPhotoUrl = userService.getUserProfilePhotoUrl();
    //ANCHOR Buradaki user sağ tarafta görülen kendimiz
    user = ChatUser(
      name: userService.getUserName(),
      uid: currentUserID,
      avatar: currentUserPhotoUrl, // Kendi url miz
    );
  }

  @override
  Widget build(BuildContext context) {
    var messageService = Provider.of<MessagingService>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors().blueThemeColor,
        title: Text(widget.otherUserName),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: messageService.checkConversation(currentUserID, otherUserID),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done ||
              runFutureOnce) {
            // ANCHOR bu Future builder in birden çok defa çalışması textfield a tıklandığında
            //bütün widgetin rebuild olması sebebiyle keyboardın sürekli sıfırlanamsına sebep olmakta.
            runFutureOnce = true;
            if (!snapshot.hasError &&
                snapshot.hasData &&
                snapshot.data != "bos") {
              if (chatID == null) chatID = snapshot.data;
            } else {
              chatID = "temp";
            }

            print("ChatID:" + chatID);
            return StreamBuilder(
                stream: messageService.getSnapshot(chatID),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor,
                        ),
                      ),
                    );
                  } else {
                    List<DocumentSnapshot> items = snapshot.data.documents;
                    var messages =
                        items.map((i) => ChatMessage.fromJson(i.data)).toList();
                    return DashChat(
                      key: _chatViewKey,
                      scrollController: scrollController,
                      onSend: (ChatMessage message) {
                        messageService
                            .sendMessage(
                                chatID, message, currentUserID, otherUserID)
                            .whenComplete(() {
                          setState(() {});
                        });
                      },
                      shouldShowLoadEarlier: true,
                      showLoadEarlierWidget: () => CircularProgressIndicator(),
                      onLoadEarlier: () {
                        print("loading...");
                      },
                      user: user,
                      inputDecoration:
                          InputDecoration.collapsed(hintText: "Mesaj gönderin"),
                      dateFormat: DateFormat('yyyy-MMM-dd'),
                      timeFormat: DateFormat('HH:mm'),
                      messages: messages,
                      showUserAvatar: false,
                      showAvatarForEveryMessage: false,
                      onPressAvatar: (ChatUser user) {
                        print("OnPressAvatar: ${user.name}");
                      },
                      onLongPressAvatar: (ChatUser user) {
                        print("OnLongPressAvatar: ${user.name}");
                      },
                      inputMaxLines: 5,
                      messageContainerPadding:
                          EdgeInsets.only(left: 5.0, right: 5.0),
                      inputTextStyle: TextStyle(fontSize: 16.0),
                      inputContainerStyle: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(width: 0.0),
                        color: Colors.white,
                      ),
                      //REVIEW ScrolltoBottom problemini çöz
                      scrollToBottom: false,
                      //TODO Gerçek emoji mesajları gönderebilmeyi sağla
                      leading: <Widget>[
                        IconButton(
                            icon: Icon(
                              FontAwesomeIcons.smile,
                              color: Colors.deepOrange[700],
                            ),
                            onPressed: () {})
                      ],
                      inputCursorColor: MyColors().blueThemeColor,
                      trailing: <Widget>[
                        IconButton(
                          icon: Icon(Icons.photo),
                          onPressed: () async {
                            File result = await ImagePicker.pickImage(
                              source: ImageSource.gallery,
                              imageQuality: 100,
                              maxHeight: 300,
                              maxWidth: 300,
                            );
                            if (result != null) {
                              String time = DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString();
                              await messageService.sendImageMessage(
                                  result, user, currentUserID, chatID, time);
                            }
                          },
                        )
                      ],
                    );
                  }
                });
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
