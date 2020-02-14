import 'package:eventizer/Navigation/ProfilePage.dart';
import 'package:eventizer/Services/Repository.dart';
import 'package:eventizer/assets/Colors.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class EventPage extends StatefulWidget {
  final Map<String, dynamic> eventData;
  final Map<String, dynamic> userData;
  final bool amIparticipant;
  const EventPage({Key key, this.eventData, this.userData, this.amIparticipant})
      : super(key: key);
//ANCHOR User ve Event verileri parametre ile geliyor ve statefull class a gönderiliyor
  @override
  _EventPageState createState() =>
      _EventPageState(eventData, userData, amIparticipant);
}

class _EventPageState extends State<EventPage> {
  final Map<String, dynamic> eventData;
  final Map<String, dynamic> organizerData;
  bool katilbutton;
  _EventPageState(this.eventData, this.organizerData, this.katilbutton);

  void toggleJoinButton() {
    katilbutton ? katilbutton = false : katilbutton = true;
  }

  @override
  Widget build(BuildContext context) {
    // ANCHOR Provider ile userServis nesnesi getiriliyor , bu sayede içerisindeki metodlara ulaşıyoruz.
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
                    // REVIEW  Resim yüksekliğine göre uzunluk veren bir metod kullan
                    expandedHeight: MediaQuery.of(context).size.height * 0.45,
                    floating: true,
                    pinned: true,
                    snap: false,
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
                                    // ANCHOR Koyuluk oluşturuyor
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
                      indicatorWeight: 4,
                      indicatorColor: Colors.green,
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
                aboutPage(context, eventData, katilbutton),
                commentsPage(userService),
                participantsPage(),
              ],
            )),
      ),
    );
  }

  //ANCHOR Detay kısmı
  Widget aboutPage(
      BuildContext context, Map<String, dynamic> eventData, bool katilbutton) {
    var eventService = Provider.of<EventService>(context);
    var userService = Provider.of<UserService>(context);
    print("Katilbutton:" + katilbutton.toString());
    return Scaffold(
      bottomNavigationBar: Container(
        color: MyColors().blueThemeColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            katilbutton
                ? SizedBox(
                    width: MediaQuery.of(context).size.width *
                        0.3, // ANCHOR ekran genişliğinin 3de1 uzunluğunu veriyor
                    child: FlatButton.icon(
                      icon: Icon(LineAwesomeIcons.user_times),
                      color: Colors.green,
                      label: Text(
                        "Katılma",
                        style: TextStyle(fontSize: 12.0),
                      ),
                      textColor: Colors.black,
                      onPressed: () async {
                        //TODO Databaseden etkinliğin participants bölümünden kullanıcının idsini sil
                        //Bu sayede kullanıcı katılma işlemini iptal etmiş olur
                      },
                    ),
                  )
                : SizedBox(
                    width: MediaQuery.of(context).size.width *
                        0.3, // ANCHOR ekran genişliğinin 3de1 uzunluğunu veriyor
                    child: FlatButton.icon(
                      icon: Icon(LineAwesomeIcons.user_plus),
                      color: Colors.green,
                      label: Text(
                        "Katıl",
                        style: TextStyle(fontSize: 15.0),
                      ),
                      textColor: Colors.black,
                      onPressed: () async {
                        if (await eventService.joinEvent(
                            userService.getUserId(), eventData['eventID'])) {
                          setState(() {
                            toggleJoinButton();
                            print("Katıldı");
                          });
                        }
                      },
                    ),
                  ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: FlatButton.icon(
                icon: Icon(LineAwesomeIcons.black_tie),
                color: Colors.green,
                label: Text(
                  "İletişim\nKur",
                  style: TextStyle(fontSize: 10.0),
                ),
                textColor: Colors.black,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              ProfilePage(eventData["OrganizerID"], true)));
                },
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: FlatButton.icon(
                icon: Icon(Icons.share),
                color: Colors.green,
                label: Text(
                  "Paylaş",
                  style: TextStyle(fontSize: 15.0),
                ),
                textColor: Colors.black,
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
      // TODO  Burada Sayfa tasarımı yapılacak
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Text("Organizator : " +
                organizerData['Name'] +
                "\n Detay:" +
                eventData['Detail']),
          ),
        ],
      ),
    );
  }

  // TODO Yorum Sayfası tasarımı yapılacak
  Widget commentsPage(UserService userService) {
    return SingleChildScrollView();
  }

  // TODO Katılımcılar Sayfası tasarımı yapılacak
  Widget participantsPage() {
    return SingleChildScrollView();
  }
}
