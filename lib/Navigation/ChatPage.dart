import 'package:eventizer/Services/UserWorker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  ChatPage({Key key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    UserWorker userWorker = Provider.of<UserWorker>(context);
    return Scaffold(
      body: Center(child: Text("Chat Page")),
    );
  }
}
