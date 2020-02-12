import 'package:eventizer/Navigation/ProfilePage.dart';
import 'package:eventizer/Services/Repository.dart';
import 'package:eventizer/Tools/Message.dart';
import 'package:eventizer/assets/Colors.dart';
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
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                    // leading: Icon(Icons.chevron_left),
                    elevation: 0.0,
                    title: Text(eventData['Title']),
                    backgroundColor: MyColors().blueThemeColor,
                    centerTitle: true,
                    expandedHeight: MediaQuery.of(context).size.height * 0.45,
                    floating: true,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                        background: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(0.0, 76.0, 0.0, 0.0),
                            child: Stack(
                              children: <Widget>[
                                Positioned.fill(
                                    child: eventData['EventImageUrl'] != 'none'
                                        ? Image.network(
                                            eventData['EventImageUrl'],
                                            fit: BoxFit.fill)
                                        : Image.asset(
                                            'assets/images/etkinlik.jpg',
                                            fit: BoxFit.fill)),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    height: 140.0,
                                    width: double.infinity,
                                    //color: Colors.black.withOpacity(0.6),
                                    decoration: BoxDecoration(
                                      //borderRadius: BorderRadius.circular(10.0),
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          Colors.black.withOpacity(1),
                                          Colors.black.withOpacity(0.9),
                                          Colors.black.withOpacity(0.8),
                                          Colors.black.withOpacity(0.7),
                                          Colors.black.withOpacity(0.6),
                                          Colors.black.withOpacity(0.5),
                                          Colors.black.withOpacity(0.4),
                                          Colors.black.withOpacity(0.1),
                                          Colors.black.withOpacity(0.05),
                                          Colors.black.withOpacity(0.025),
                                          Colors.black.withOpacity(0),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ))),
                    bottom: TabBar(
                      tabs: <Tab>[
                        Tab(
                          text: "Detaylar",
                        ),
                        Tab(
                          text: "Yorumlar",
                        ),
                        Tab(
                          text: "Katılımcılar",
                        ),
                      ],
                    )),
              ];
            },
            body: TabBarView(
              children: <Widget>[
                aboutPage(context, userService, eventData),
                aboutPage(context, userService, eventData),
                aboutPage(context, userService, eventData),
              ],
            )),
      ),
    );
  }

  Widget aboutPage(
      BuildContext context, userService, Map<String, dynamic> eventData) {
    return Scaffold(
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: MaterialButton(
              onPressed: () {},
              minWidth: 50.0,
              height: 30.0,
              color: Color(0xFF179CDF),
              child: Text(
                "Katıl",
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: Material(
              borderRadius: BorderRadius.circular(30.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: MaterialButton(
                  onPressed: () async {
                    if (userService.getUserId() != eventData["OrganizerID"]) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => Message(
                                  userService, eventData["OrganizerID"])));
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
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: Material(
              borderRadius: BorderRadius.circular(30.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: MaterialButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ProfilePage(eventData["OrganizerID"])));
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
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Organizator : " +
                userData['Name'] +
                "\n Detay:" +
                eventData['Detail']),
          ],
        ),
      ),
    );
  }

  Widget commentsPage(UserService userService) {
    return SingleChildScrollView(
      child: null,
    );
  }
}
