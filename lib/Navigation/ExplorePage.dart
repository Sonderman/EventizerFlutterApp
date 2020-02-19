import 'package:eventizer/Navigation/EventPage.dart';
import 'package:eventizer/Services/Repository.dart';
import 'package:eventizer/Settings/EventSettings.dart';
import 'package:eventizer/assets/Colors.dart';
import 'package:eventizer/locator.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExplorePage extends StatefulWidget {
  ExplorePage({Key key}) : super(key: key);

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  List<String> categoryItems = locator<EventSettings>().categoryItems ?? [];
  String category;
  @override
  Widget build(BuildContext context) {
    var _eventManager = Provider.of<EventService>(context);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: MyColors().blueThemeColor,
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
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
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
    var eventService = Provider.of<EventService>(context);
    String eventID = eventDatas['eventID'];
    String title = eventDatas['Title'];
    String ownerID = eventDatas['OrganizerID'];
    String category = eventDatas['Category'];
    String imageUrl = eventDatas['EventImageUrl'];
    String startDate = eventDatas['StartDate'];
    //String detail = eventDatas['Detail'];
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: userWorker.findUserbyID(ownerID),
          builder: (BuildContext context,
              AsyncSnapshot<Map<String, dynamic>> userData) {
            if (userData.connectionState == ConnectionState.done) {
              String name = userData.data['Name'];
              return GestureDetector(
                  onTap: () async {
                    eventService
                        .amIparticipant(userWorker.getUserId(), eventID)
                        .then((amIparticipant) {
                      print("Kullanıcı bu etkinliğe katılmış:" +
                          amIparticipant.toString());
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => EventPage(
                                    eventData: eventDatas,
                                    userData: userData.data,
                                    amIparticipant: amIparticipant,
                                  )));
                    });
                  },
                  child: itemCard(title, category, name, imageUrl, startDate));
            } else
              return CircularProgressIndicator();
          },
        ));
  }

  Widget itemCard(String title, String category, String name, String imageUrl,
      String startDate) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            //ANCHOR resimlerin cache de saklanması sağlandı
            child: FadeInImage.assetNetwork(
              placeholder: 'assets/images/etkinlik.jpg',
              image: imageUrl,
              fit: BoxFit.fill,
            ),
            /*imageUrl != 'none'
                  ? ExtendedImage.network(
                      imageUrl,
                      fit: BoxFit.fill,
                      cache: true,
                    )
                  : Image.asset('assets/images/etkinlik.jpg', fit: BoxFit.fill)*/
            /* imageUrl != 'none'
                ? Image.network(
                    imageUrl,
                    fit: BoxFit.fill,
                  )
                : Image.asset('assets/images/etkinlik.jpg', fit: BoxFit.fill),*/
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 200.0,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        category,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        startDate,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
