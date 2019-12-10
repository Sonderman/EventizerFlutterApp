import 'package:eventizer/Services/Repository.dart';
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
    UserService userWorker = Provider.of<UserService>(context);
    return Scaffold(
      body: Center(child: Text("Chat Page")),
    );
  }
}
