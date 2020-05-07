import 'dart:io';
import 'package:eventizer/Services/AuthCheck.dart';
import 'package:eventizer/Services/AuthService.dart';
import 'package:eventizer/Services/Repository.dart';
import 'package:eventizer/Tools/ImageViewer.dart';
import 'package:eventizer/Tools/Message.dart';
import 'package:eventizer/assets/Colors.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  final userID;
  final isFromEvent;

  ProfilePage(this.userID, this.isFromEvent);

  @override
  _ProfilePageState createState() => _ProfilePageState(userID);
}

class _ProfilePageState extends State<ProfilePage> {
  final userID;
  List<Widget> images = [];
  int imageCounter = 0;
  List<File> _imagefile = [];
  int imageFileCounter = 0;

  _ProfilePageState(this.userID);

  void _signedOut() {
    var auth = AuthService.of(context).auth;
    auth.signOut();
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => AuthCheck()));
  }

  Future<String> getUserEmail(BuildContext context) async {
    var auth = AuthService.of(context).auth;
    String userEmail = await auth.getUserEmail();
    return userEmail;
    //setState(() {});
  }

  /*@override
  void didChangeDependencies() {
    //getUserEmail(context);
    super.didChangeDependencies();
  }*/

  Future<bool> getImageFromGalery() async {
    bool temp;
    await ImagePicker.pickImage(source: ImageSource.gallery).then((onValue) {
      if (onValue != null) {
        _imagefile.add(onValue);
        imageFileCounter++;
        temp = true;
      } else
        temp = false;
    });
    return temp;
  }

  void addImage(File image) {
    setState(() {
      print('Girdi addImage');
      images.insert(
          images.length - 1,
          Card(
            color: MyColors().blueThemeColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 4),
              child: GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ImageViewer(
                              tag: 'image' + imageCounter.toString(),
                              image: image,
                            ))),
                child: Hero(
                    tag: 'image' + imageCounter.toString(),
                    child: Image.file(image, width: 100, height: 100)),
              ),
            ),
          ));
      imageCounter++;
    });
  }

  void initImages() {
    print('Girdi initImages');
    images.add(Card(
      color: MyColors().blueThemeColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 4),
        child: GestureDetector(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ImageViewer(
                        tag: 'image' + imageCounter.toString(),
                        image: null,
                      ))),
          child: Hero(
            tag: 'image' + imageCounter.toString(),
            child: Image(
              image: AssetImage('assets/images/etkinlik.jpg'),
              height: 100,
              width: 100,
            ),
          ),
        ),
      ),
    ));
    imageCounter++;
    images.add(Card(
      color: Colors.amber,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 4),
        child: GestureDetector(
            onTap: () {
              getImageFromGalery().then((value) {
                if (value) {
                  addImage(_imagefile[imageFileCounter - 1]);
                } else
                  print("image: null");
              });
            },
            child: Icon(
              Icons.add,
              size: 64,
              color: MyColors().blueThemeColor,
            )),
      ),
    ));
    imageCounter++;
  }

  @override
  Widget build(BuildContext context) {
    //final userWorker = Provider.of<UserService>(context);
    if (images.length == 0) {
      initImages();
    }

    TextStyle baslikTextStyle = TextStyle(
        color: MyColors().blueThemeColor,
        fontSize: 16.0,
        fontWeight: FontWeight.bold);
    TextStyle normalTextStyle =
        TextStyle(color: MyColors().blueThemeColor, fontSize: 14.0);

    //String userName = userWorker.getName();

    double heightSize(double value) {
      value /= 100;
      return MediaQuery.of(context).size.height * value;
    }

    double widthSize(double value) {
      value /= 100;
      return MediaQuery.of(context).size.width * value;
    }

    List<Widget> firstPage = [
      Column(
        children: <Widget>[
          Container(
            color: MyColors().blueThemeColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(8, 16, 8, 0),
                  child: profilPhotoCard(MyColors().blueThemeColor,
                      MyColors().blueTextColor, userID),
                ),
                widget.isFromEvent
                    ? Padding(
                        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                        child: messageButtonCard(),
                      )
                    : Container(),
                Padding(
                  padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: aboutCard(
                      baslikTextStyle,
                      normalTextStyle,
                      MyColors().yellowContainer,
                      MyColors().blueThemeColor,
                      userID),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: aboutMySelf(
                      MyColors().blueThemeColor,
                      MyColors().yellowContainer,
                      MyColors().blueTextColor,
                      images,
                      userID),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                  child: infoCard(userID),
                ),
              ],
            ),
          ),
        ],
      ),
    ];
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                text: "Profilim",
              )
            ],
          ),
        ),
        body: TabBarView(
          children: firstPage,
        ),
      ),
    );
  }

//NOTE - InfoCard is here
  Widget infoCard(userID) {
    UserService userWorker = Provider.of<UserService>(context);

    List<Widget> mapList() {
      List<Widget> wlist = [];

      var userMap = userWorker.usermodel.toMap();
      userMap.forEach((k, v) {
        wlist.add(Text("$k: $v"));
      });
      return wlist;
    }

    List<Widget> mapListTemp(Map<String, dynamic> data) {
      List<Widget> wlist = [];
      data.forEach((k, v) {
        wlist.add(Text("$k: $v"));
      });
      return wlist;
    }

    //ANCHOR bu sayfaya gelen kişinin cihaza kayıtlı olan kişimi yoksa başkasımı anlıyoruz
    if (userID == userWorker.usermodel.getUserId()) {
      return Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: mapList(),
        ),
      );
    } else {
      return FutureBuilder(
        future: userWorker.findUserbyID(userID),
        builder: (BuildContext context, AsyncSnapshot<dynamic> infoData) {
          if (infoData.connectionState == ConnectionState.done) {
            return Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: mapListTemp(infoData.data),
              ),
            );
          } else
            return Card(child: CircularProgressIndicator());
        },
      );
    }
  }

  Column aboutCard(TextStyle baslikTextStyle, TextStyle normalTextStyle,
      Color myBlueColor, Color yellowContainer, userID) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          height: 60,
          child: Row(
            children: <Widget>[
              Container(
                height: 20,
                //child: Image.asset("assets/icons/options.png"),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Text("Profil Ayarlarım"),
              ),
            ],
          ),
          decoration: new BoxDecoration(
            color: Colors.orange.shade200,
            borderRadius: new BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
      ],
    );
  }

  //NOTE - Profil photo card is here
  Column profilPhotoCard(Color myBlueColor, blueTextColor, userID) {
    var userWorker = Provider.of<UserService>(context);
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(8.0),
          child: FutureBuilder(
            future:
                userWorker.firebaseDatabaseWorks.getUserProfilePhotoUrl(userID),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Column(
                  children: <Widget>[
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: ExtendedNetworkImageProvider(snapshot.data,
                                cache: true),
                            fit: BoxFit.fill),
                        borderRadius: BorderRadius.circular(120.0),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(120.0),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          "Murat Altıntaş",
                          style: TextStyle(
                            fontFamily: "Zona",
                            fontSize: 25,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "@altintas",
                          style: TextStyle(
                            fontFamily: "ZonaLight",
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              } else
                return Container(
                  height: 150,
                  width: 150,
                  child: CircularProgressIndicator(),
                );
            },
          ),
        ),
      ],
    );
  }

  Column aboutMySelf(Color myBlueColor, Color yellowContainer,
      Color blueTextColor, List<Widget> images, userID) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          height: 60,
          child: Padding(
            padding: const EdgeInsets.only(left: 30, top: 20),
            child: Text("Hakkımda..."),
          ),
          decoration: new BoxDecoration(
            color: Colors.orange.shade200,
            borderRadius: new BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    "TAKİPÇİ",
                    style: TextStyle(
                      color: blueTextColor,
                      fontFamily: "Zona",
                      fontSize: 20,
                    ),
                  ),
                  Text("56",
                      style: TextStyle(
                        color: blueTextColor,
                        fontFamily: "ZonaLight",
                        fontSize: 25,
                      )),
                ],
              ),
              Column(
                children: <Widget>[
                  Text("ETKİNLİK",
                      style: TextStyle(
                        color: blueTextColor,
                        fontFamily: "Zona",
                        fontSize: 20,
                      )),
                  Text("56",
                      style: TextStyle(
                        color: blueTextColor,
                        fontFamily: "ZonaLight",
                        fontSize: 25,
                      )),
                ],
              ),
              Column(
                children: <Widget>[
                  Text("GÜVEN PUANI",
                      style: TextStyle(
                        color: blueTextColor,
                        fontFamily: "Zona",
                        fontSize: 20,
                      )),
                  Text("105",
                      style: TextStyle(
                        color: blueTextColor,
                        fontFamily: "ZonaLight",
                        fontSize: 25,
                      )),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Column messageButtonCard() {
    UserService userService = Provider.of<UserService>(context);
    return Column(
      children: <Widget>[
        Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width *
                0.3, // ANCHOR ekran genişliğinin 3de1 uzunluğunu veriyor
            child: FlatButton.icon(
              icon: Icon(LineAwesomeIcons.envelope),
              color: Colors.green,
              label: Text(
                "Mesaj\nGönder",
                style: TextStyle(fontSize: 10.0),
              ),
              textColor: Colors.black,
              onPressed: () async {
                // ANCHOR  Mesaj sayfasına gitmek için
                if (userService.usermodel.getUserId() != widget.userID) {
                  //ANCHOR mesajlaşma sayfasında karşıdaki kişinin ismini getirip parametre olarak veriyoruz,
                  //Bu sayede appbarda ismi görünüyor
                  await userService.findUserbyID(widget.userID).then((data) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                Message(widget.userID, data['Name'])));
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
