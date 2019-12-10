import 'package:eventizer/Navigation/ProfilePage.dart';
import 'package:eventizer/Services/Repository.dart';
import 'package:eventizer/Tools/Message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventPage extends StatefulWidget {
  final Map<String, dynamic> eventData;
  final Map<String, dynamic> userData;

  const EventPage({Key key, this.eventData, this.userData}) : super(key: key);

  @override
  _EventPageState createState() => _EventPageState(eventData, userData);
}

class _EventPageState extends State<EventPage> {
  final Map<String, dynamic> eventData;
  final Map<String, dynamic> userData;

  _EventPageState(this.eventData, this.userData);

  @override
  Widget build(BuildContext context) {
    UserService userService = Provider.of<UserService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(eventData['Title']),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Event sahibi : " + userData['Name']),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Material(
                  borderRadius: BorderRadius.circular(30.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                      onPressed: () async {
                        if (userService.getUserId() != eventData["OwnerID"]) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => Message(
                                      userService, eventData["OwnerID"])));
                        }
                      },
                      minWidth: 50.0,
                      height: 30.0,
                      color: Color(0xFF179CDF),
                      child: Text(
                        "Mesaj",
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Material(
                  borderRadius: BorderRadius.circular(30.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ProfilePage(eventData["OwnerID"])));
                      },
                      minWidth: 50.0,
                      height: 30.0,
                      color: Color(0xFF179CDF),
                      child: Text(
                        "Profil",
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
