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
  List<String> categoryItems = [
    "Doğumgünü Partisi",
    "Balık Tutma",
    "Turistik Gezi"
  ];
  String category;
  @override
  Widget build(BuildContext context) {
    final EventService _eventManager = Provider.of<EventService>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Keşfet"),
        ),
        body: Column(children: <Widget>[
          DropdownButton<String>(
              hint: Text("Kategori Seçiniz"),
              value: category != null ? category : null,
              items:
                  categoryItems.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (chosen) {
                setState(() {
                  category = chosen;
                });
              }),
          Expanded(
            child: Center(
              child: FutureBuilder(
                future: category == null
                    ? _eventManager.fetchActiveEventLists()
                    : _eventManager.fetchActiveEventListsByCategory(category),
                builder: (BuildContext context, AsyncSnapshot fetchedlist) {
                  if (fetchedlist.connectionState == ConnectionState.done) {
                    List<Map<String, dynamic>> listofMaps = fetchedlist.data;
                    if (listofMaps.length == 0) {
                      return Text("Etkinlik Yok");
                    } else {
                      return ListView.builder(
                        itemCount: listofMaps.length,
                        itemBuilder: (context, index) {
                          return eventItem(listofMaps[index]);
                        },
                      );
                    }
                  } else
                    return CircularProgressIndicator();
                },
              ),
            ),
          ),
        ]));
  }

  Widget eventItem(Map<String, dynamic> eventDatas) {
    UserService userWorker = Provider.of<UserService>(context);
    Color myBlueColor = Color(0XFF001970);
    String title = eventDatas['Title'];
    String ownerID = eventDatas['OrganizerID'];
    String category = eventDatas['Category'];
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
                          ("Etkinlik adı: $title\nKategori: $category\nEtkinlik sahibi: $name"),
                          style: TextStyle(color: Colors.white))));
            } else
              return CircularProgressIndicator();
          },
        ));
  }
}
