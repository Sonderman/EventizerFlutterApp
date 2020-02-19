import 'package:eventizer/Navigation/ProfilePage.dart';
import 'package:eventizer/Services/Repository.dart';
import 'package:eventizer/assets/Colors.dart';
import 'package:extended_image/extended_image.dart';
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
  var commentController = TextEditingController();
  var nestedScrollController = ScrollController();

  _EventPageState(this.eventData, this.organizerData, this.katilbutton);

  //ANCHOR katıl butonunun değişmesi için
  void toggleJoinButton() {
    katilbutton ? katilbutton = false : katilbutton = true;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        //NOTE iç içe scrolllar olacaksa bu kesinlikle olmalı
        body: NestedScrollView(
            controller: nestedScrollController,
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
                                        ? ExtendedImage.network(
                                            eventData['EventImageUrl'],
                                            cache: true,
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
                aboutPage(eventData, katilbutton),
                commentsPage(),
                participantsPage(),
              ],
            )),
      ),
    );
  }

  //ANCHOR Detay kısmı
  Widget aboutPage(Map<String, dynamic> eventData, bool katilbutton) {
    // ANCHOR Provider ile userServis nesnesi getiriliyor , bu sayede içerisindeki metodlara ulaşıyoruz.
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
                        if (await eventService.leaveEvent(
                            userService.getUserId(), eventData['eventID'])) {
                          setState(() {
                            toggleJoinButton();
                            print("Ayrıldın");
                          });
                        } else {
                          print("Hata");
                        }
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
                        } else {
                          print("Hata");
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

  // REVIEW  Yorum Sayfası tasarımı gözden geçir
  Widget commentsPage() {
    var eventService = Provider.of<EventService>(context);
    var userService = Provider.of<UserService>(context);

    /* bottomNavigationBar: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 5,
              child: Padding(
                  padding: EdgeInsets.fromLTRB(5, 3, 5, 1),
                  child: TextField(
                    keyboardType: TextInputType.text,
                  )),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(5, 3, 5, 1),
                  child: FlatButton(
                      onPressed: () {},
                      child: Container(
                          color: Colors.green, child: Text("Yorum Yap")))),
            ),
          ],
        ),
      ),*/
    //NOTE iç içe scrolling yaparken içerdeki widgeti sakın scaffold ile yeniden sarmalama
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Expanded(
          //ANCHOR Yorumlar burada listelenmekte
          child: FutureBuilder(
            future: eventService.getComments(eventData['eventID']),
            builder: (BuildContext context,
                AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                print(snapshot.data);
                if (snapshot.data.length == 0) {
                  return Text("Henüz yorum yapılmadı");
                } else
                  //REVIEW yukarı kaydırmada bozulma var
                  //Sliverlist dene
                  //olmazsa manuel birşeyler yap (scrollview içinde column gibi)
                  return ListView.builder(
                      physics: ClampingScrollPhysics(),
                      //shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return FutureBuilder(
                          //ANCHOR Her bir list itemi için kullanıcı bilgisi getirir
                          future: userService.findUserbyID(
                              snapshot.data[index]['CommentOwnerID']),
                          builder: (BuildContext context, AsyncSnapshot user) {
                            if (user.connectionState == ConnectionState.done) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                //TODO Zaman göstergeci ekle
                                child: Card(
                                    child: Row(
                                  children: <Widget>[
                                    Expanded(
                                        flex: 3,
                                        child: AspectRatio(
                                          aspectRatio: 1,
                                          child: CircleAvatar(
                                            radius: 120,
                                            backgroundImage:
                                                ExtendedNetworkImageProvider(
                                                    user.data[
                                                        'ProfilePhotoUrl'],
                                                    cache: true),
                                          ),
                                        )),
                                    Expanded(flex: 1, child: SizedBox()),
                                    Expanded(
                                        flex: 8,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(user.data['Name'] +
                                                " " +
                                                user.data['Surname']),
                                            Divider(
                                              height: 5,
                                            ),
                                            Text(
                                                snapshot.data[index]['Comment'])
                                          ],
                                        ))
                                  ],
                                )),
                              );
                            } else {
                              return CircularProgressIndicator();
                            }
                          },
                        );
                      });
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Wrap(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(5, 3, 5, 1),
                        child: TextField(
                          controller: commentController,
                          maxLines: null,
                          minLines: null,
                          keyboardType: TextInputType.text,
                          enableInteractiveSelection: true,
                          cursorColor: MyColors().blueThemeColor,
                          maxLength: 256,
                          textCapitalization: TextCapitalization.sentences,
                          onChanged: (text) {},
                          decoration: InputDecoration(
                            labelText: 'Yorum yapın.',
                            labelStyle: TextStyle(
                                color: MyColors().blueThemeColor,
                                fontSize: 14.0),
                            errorStyle: TextStyle(
                              color: Colors.red,
                            ),
                            fillColor: MyColors().blueThemeColor,
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: MyColors().blueThemeColor)),
                            counterText: '',
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              borderSide: BorderSide(
                                  width: 1, color: MyColors().blueThemeColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              borderSide: BorderSide(
                                  width: 1, color: MyColors().blueThemeColor),
                            ),
                          ),
                        )),
                  ),
                  Expanded(
                      flex: 1,
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(5, 3, 5, 1),
                          child: Container(
                            color: Colors.green,
                            child: FlatButton(
                              onPressed: () async {
                                //ANCHOR  Yorum gönderme backend işlemleri
                                if (await eventService.sendComment(
                                    eventData['eventID'],
                                    userService.getUserId(),
                                    commentController.text)) {
                                  /* nestedScrollController.jumpTo(
                                      nestedScrollController
                                              .position.maxScrollExtent
                                          );*/
                                  setState(() {
                                    commentController.text = '';
                                  });

                                  print("Yorum yapıldı");
                                }
                              },
                              child: Text("Yorum Yap"),
                            ),
                          )))
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  //ANCHOR Katılımcıların listelendiği sayfa
  Widget participantsPage() {
    var eventService = Provider.of<EventService>(context);
    var userService = Provider.of<UserService>(context);
    return FutureBuilder(
      future: eventService.getParticipants(eventData['eventID']),
      builder: (BuildContext context,
          AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data.length == 0) {
            return Text("Katılımcı Yok");
          } else {
            return ListView.separated(
              separatorBuilder: (BuildContext context, int index) => Divider(),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return FutureBuilder(
                  future: userService
                      .findUserbyID(snapshot.data[index]['ParticipantID']),
                  builder: (BuildContext context, AsyncSnapshot user) {
                    if (user.connectionState == ConnectionState.done) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                  flex: 3,
                                  child: AspectRatio(
                                    aspectRatio: 1,
                                    child: CircleAvatar(
                                      radius: 120,
                                      backgroundImage:
                                          ExtendedNetworkImageProvider(
                                              user.data['ProfilePhotoUrl'],
                                              cache: true),
                                    ),
                                  )),
                              Expanded(flex: 1, child: SizedBox()),
                              Expanded(
                                flex: 8,
                                child: Text(user.data['Name'] +
                                    " " +
                                    user.data['Surname']),
                              )
                            ],
                          ),
                        ),
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                );
              },
            );
          }
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
