import 'dart:async';
import 'dart:io';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:eventizer/Services/Repository.dart';
import 'package:eventizer/Tools/PageComponents.dart';
import 'package:eventizer/assets/Colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Message extends StatefulWidget {
  //ANCHOR Karşıdaki kullanıcının Idsi ve ismi geliyor
  final otherUserID;
  final otherUserName;
  const Message(this.otherUserID, this.otherUserName, {super.key});

  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  //final GlobalKey<DashChatState> _chatViewKey = GlobalKey<DashChatState>();
  List<ChatMessage>? messages;
  StreamSubscription? messageStream;
  late UserService userService;
  late MessagingService messageService;
  List<ChatMessage>? m;
  var scrollController = ScrollController();
  String chatID = "temp";
  String currentUserID = "";
  String? otherUserID;
  String? currentUserPhotoUrl;
  var i = 0;
  bool runFutureOnce = false;
  ChatUser? user;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //ANCHOR Providerda context e ihtiyacımız olduğundan didchangedependecies ile contexte ulaşabiliyoruz, bu bir nevi initstate işlevi görüyor
    userService = Provider.of<UserService>(context, listen: false);
    currentUserID = userService.userModel!.getUserId();
    otherUserID = widget.otherUserID;
    currentUserPhotoUrl = userService.userModel!.getUserProfilePhotoUrl();
    messageService = Provider.of<MessagingService>(context, listen: false);

    //ANCHOR Buradaki user sağ tarafta görülen kendimiz
    user = ChatUser(
      firstName: userService.userModel!.getUserName(),
      id: currentUserID,
      profileImage: currentUserPhotoUrl, // Kendi url miz
    );
  }

  @override
  void dispose() {
    if (messageStream != null) messageStream!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors().blueThemeColor,
        title: Text(widget.otherUserName),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: messageService.checkConversation(currentUserID, otherUserID!),
        builder: (context, AsyncSnapshot snapshot) {
          print("Control Future");
          if (snapshot.connectionState == ConnectionState.done ||
              runFutureOnce) {
            // ANCHOR bu Future builder in birden çok defa çalışması textfield a tıklandığında
            //bütün widgetin rebuild olması sebebiyle keyboardın sürekli sıfırlanamsına sebep olmakta.
            runFutureOnce = true;
            if (!snapshot.hasError &&
                snapshot.hasData &&
                snapshot.data != "bos") {
              if (chatID == "temp") chatID = snapshot.data;
            }

            if (messageStream == null && chatID != "temp") {
              messageStream =
                  messageService.getMessagesSnapshot(chatID).listen((snapshot) {
                print("Subscribe oldu");
                setState(() {
                  messages = snapshot.docs
                      .map((i) => ChatMessage.fromJson(i.data()))
                      .toList();
                });
              });
            }

            print("ChatID:$chatID");
            return DashChat(
              // key: _chatViewKey,
              currentUser: user!,
              onSend: (ChatMessage message) {
                messageService
                    .sendMessage(chatID, message, currentUserID, otherUserID!)
                    .then((id) {
                  if (messages == null) {
                    print("ilkmesaj");
                    setState(() {
                      chatID = id;
                    });
                  }
                });
              },
              messages: messages ?? [],
              /*
              shouldShowLoadEarlier: true,
              showLoadEarlierWidget: () => const CircularProgressIndicator(),
              onLoadEarlier: () {
                print("loading...");
              },
              scrollController: scrollController,
              inputDecoration:
                  const InputDecoration.collapsed(hintText: "Mesaj gönderin"),
              dateFormat: DateFormat('yyyy-MMM-dd'),
              timeFormat: DateFormat('HH:mm'),
              
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
                  const EdgeInsets.only(left: 5.0, right: 5.0),
              inputTextStyle: const TextStyle(fontSize: 16.0),
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
                  icon: const Icon(Icons.photo),
                  onPressed: () async {
                    PickedFile? result = await ImagePicker.platform.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 100,
                      maxHeight: 300,
                      maxWidth: 300,
                    );
                    if (result != null) {
                      String time =
                          DateTime.now().millisecondsSinceEpoch.toString();
                      await messageService.sendImageMessage(File(result.path),
                          user!, currentUserID!, chatID, time);
                    }
                  },
                )
              ],*/
            );
          } else {
            return PageComponents(context)
                .loadingOverlay(spinColor: Colors.blue);
          }
        },
      ),
    );
  }
}
