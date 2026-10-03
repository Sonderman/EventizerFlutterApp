import 'dart:async';
import 'dart:io';
import 'package:eventizer/components/glass_inputs.dart';
import 'package:eventizer/data/themes.dart';
import 'package:eventizer/models/chat_message.dart';
import 'package:eventizer/services/repository.dart';
import 'package:eventizer/tools/page_components.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Message extends StatefulWidget {
  //ANCHOR Karşıdaki kullanıcının Idsi ve ismi geliyor
  final String otherUserID;
  final String otherUserName;

  const Message({
    super.key,
    required this.otherUserID,
    required this.otherUserName,
  });

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {
  List<ChatMessage>? messages;
  StreamSubscription? messageStream;
  late UserService userService;
  late MessagingService messageService;

  // reverse: true liste ile mesajlar en alttan başlar; yeni mesaj geldiğinde
  // offset 0'da kalındığı için otomatik olarak en alt görünür kalır.
  final ScrollController scrollController = ScrollController();

  final TextEditingController messageController = TextEditingController();

  String chatID = "temp";
  String currentUserID = "";
  String? otherUserID;
  String? currentUserPhotoUrl;
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
    messageStream?.cancel();
    scrollController.dispose();
    messageController.dispose();
    super.dispose();
  }

  /// Metin mesajı gönderir; konuşma yoksa önce oluşturulur.
  Future<void> _sendTextMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty || user == null) return;

    final message = ChatMessage(
      user: user!,
      text: text,
      createdAt: DateTime.now(),
    );

    messageController.clear();
    setState(() {});

    final id = await messageService
        .sendMessage(chatID, message, currentUserID, otherUserID!);
    if (chatID == "temp") {
      //ANCHOR İlk mesaj: konuşma oluşturuldu, gerçek chatID geldi.
      if (mounted) {
        setState(() {
          chatID = id;
        });
      }
    }
  }

  /// Galeriden foto seçip Storage'a yükleyip mesaj olarak gönderir.
  Future<void> _sendImageMessage() async {
    final XFile? result = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
      maxHeight: 300,
      maxWidth: 300,
    );
    if (result == null || user == null) return;

    final String time = DateTime.now().millisecondsSinceEpoch.toString();
    await messageService.sendImageMessage(
      File(result.path),
      user!,
      currentUserID,
      chatID,
      time,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.blueThemeColor,
        title: Text(
          widget.otherUserName,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder(
        future: messageService.checkConversation(currentUserID, otherUserID!),
        builder: (context, AsyncSnapshot snapshot) {
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
              messageStream = messageService.getMessagesSnapshot(chatID).listen(
                (snapshot) {
                  if (mounted) {
                    setState(() {
                      //ANCHOR Firestore sıralaması en eski → en yeni; reverse: true
                      //listede en yeni (ilk öğe) en altta görünür.
                      messages = snapshot.docs
                          .map((i) => ChatMessage.fromJson(i.data()))
                          .toList()
                          .reversed
                          .toList();
                    });
                  }
                },
              );
            }

            return Column(
              children: <Widget>[
                Expanded(
                  child: messages == null
                      ? PageComponents(context)
                          .loadingOverlay(spinColor: Colors.blue)
                      : messages!.isEmpty
                          ? const Center(
                              child: Text(
                                "İlk mesajı sen yaz!",
                                style: TextStyle(color: Colors.white70),
                              ),
                            )
                          : messagesList(),
                ),
                messageInputBar(),
              ],
            );
          } else {
            return PageComponents(
              context,
            ).loadingOverlay(spinColor: Colors.blue);
          }
        },
      ),
    );
  }

  /// Mesaj balonları — giden sağda mavi, gelen solda koyu cam.
  Widget messagesList() {
    return ListView.builder(
      controller: scrollController,
      reverse: true,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      itemCount: messages!.length,
      itemBuilder: (context, index) {
        final ChatMessage message = messages![index];
        final bool isMine = message.user.id == currentUserID;
        return messageBubble(message, isMine);
      },
    );
  }

  Widget messageBubble(ChatMessage message, bool isMine) {
    final bool hasMedia = (message.medias?.isNotEmpty ?? false);
    final timeText = DateFormat('HH:mm').format(message.createdAt);

    final bubble = Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.72,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isMine
            ? MyColors.blueThemeColor
            : Colors.white.withValues(alpha: 0.13),
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(18),
          topRight: const Radius.circular(18),
          bottomLeft: Radius.circular(isMine ? 18 : 4),
          bottomRight: Radius.circular(isMine ? 4 : 18),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (hasMedia)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                message.medias!.first.url,
                width: 220,
                height: 220,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 220,
                  height: 150,
                  color: Colors.white10,
                  child: const Icon(Icons.broken_image,
                      color: Colors.white54, size: 40),
                ),
              ),
            ),
          if (message.text.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: hasMedia ? 8 : 0),
              child: Text(
                message.text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontFamily: "Zona",
                ),
              ),
            ),
          const SizedBox(height: 4),
          Text(
            timeText,
            style: TextStyle(
              fontSize: 10,
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
            isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[bubble],
      ),
    );
  }

  /// Alt giriş çubuğu — cam input + foto + gönder.
  Widget messageInputBar() {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 6, 12, 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: GlassInputField(
                controller: messageController,
                hint: "Mesajınızı yazın...",
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _sendImageMessage,
              child: Icon(
                Icons.photo,
                size: 28,
                color: Colors.white.withValues(alpha: 0.85),
              ),
            ),
            const SizedBox(width: 6),
            GestureDetector(
              onTap: _sendTextMessage,
              child: Icon(
                Icons.send,
                size: 28,
                color: MyColors.blueThemeColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}