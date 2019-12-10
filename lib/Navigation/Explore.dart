import 'package:eventizer/Navigation/EventPage.dart';
import 'package:eventizer/Services/Repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExplorePage extends StatefulWidget {
  ExplorePage({Key key}) : super(key: key);

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  @override
  Widget build(BuildContext context) {
    final EventService _eventManager = Provider.of<EventService>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Keşfet"),
        ),
        body: Center(
          child: FutureBuilder(
            future: _eventManager.fetchActiveEventLists(),
            builder: (BuildContext context, AsyncSnapshot fetchedlist) {
              if (fetchedlist.connectionState == ConnectionState.done) {
                List<Map<String, dynamic>> listofMaps = fetchedlist.data;

                return ListView.builder(
                  itemCount: listofMaps.length,
                  itemBuilder: (context, index) {
                    return listofMaps.isNotEmpty
                        ? eventItem(listofMaps[index])
                        : Text("Etkinlik Yok");
                  },
                );
              } else
                return CircularProgressIndicator();
            },
          ),
        ));
  }

  Widget eventItem(Map<String, dynamic> eventDatas) {
    UserService userWorker = Provider.of<UserService>(context);
    Color myBlueColor = Color(0XFF001970);
    String title = eventDatas['Title'];
    String ownerID = eventDatas['OwnerID'];
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: userWorker.findUserbyID(ownerID),
          builder: (BuildContext context,
              AsyncSnapshot<Map<String, dynamic>> userData) {
            if (userData.connectionState == ConnectionState.done) {
              String name = userData.data['Name'];
              return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => EventPage(
                                  eventData: eventDatas,
                                  userData: userData.data,
                                )));
                  },
                  child: Card(
                      color: myBlueColor,
                      child: Text(
                          ("Etkinlik adı: $title\nEtkinlik sahibi: $name"),
                          style: TextStyle(color: Colors.white))));
            } else
              return CircularProgressIndicator();
          },
        ));
  }
}
