import 'dart:io';
import 'package:eventizer/Providers/AuthProvider.dart';
import 'package:eventizer/Services/AuthCheck.dart';
import 'package:eventizer/Services/UserWorker.dart';
import 'package:eventizer/Tools/ImageViewer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Widget> images = [];
  int imageCounter = 0;
  List<File> _imagefile = [];
  int imageFileCounter = 0;
  Color myBlueColor = Color(0XFF001970);

  void _signedOut() {
    var auth = AuthProvider.of(context).auth;
    auth.signOut();
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => AuthCheck()));
  }

  Future<String> getUserEmail(BuildContext context) async {
    var auth = AuthProvider.of(context).auth;
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
            color: myBlueColor,
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
      color: myBlueColor,
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
              color: myBlueColor,
            )),
      ),
    ));
    imageCounter++;
  }

  @override
  Widget build(BuildContext context) {
    //final userWorker = Provider.of<UserWorker>(context);
    if (images.length == 0) {
      initImages();
    }

    TextStyle baslikTextStyle = TextStyle(
        color: myBlueColor, fontSize: 16.0, fontWeight: FontWeight.bold);
    TextStyle normalTextStyle = TextStyle(color: myBlueColor, fontSize: 14.0);

    //String userName = userWorker.getName();

    return Scaffold(

        /*CircleAvatar(
                                      backgroundImage: ExactAssetImage('assets/images/user.png'),
                                      radius: 30.0,
                                    ),
                            Text('Kullanıcı Adı')
                          */

        body: CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          //leading: Icon(Icons.chevron_left),
          elevation: 0.0,
          title: Text('Profil'),
          backgroundColor: myBlueColor,
          centerTitle: true,
          expandedHeight: 280.0,
          floating: false,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
              background: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 76.0, 0.0, 0.0),
            child: Image.asset('assets/images/etkinlik.jpg', fit: BoxFit.fill),
          )),
          actions: <Widget>[
            Card(
              color: myBlueColor,
              child: IconButton(
                onPressed: _signedOut,
                icon: Icon(FontAwesomeIcons.signOutAlt),
              ),
            )
          ],
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: SingleChildScrollView(
            child: Container(
              color: myBlueColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(8, 16, 8, 0),
                    child: profilPhotoCard(myBlueColor),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
                    child: aboutCard(
                        baslikTextStyle, normalTextStyle, myBlueColor),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
                    child: slidePicturesCard(myBlueColor, images),
                  ),
                  SizedBox(
                    height: 400.0,
                  )
                ],
              ),
            ),
          ),
        )
      ],
    ));
  }

  Card aboutCard(
      TextStyle baslikTextStyle, TextStyle normalTextStyle, Color myBlueColor) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Align(
              alignment: Alignment.topLeft,
              child: Text(
                ' Hakkında:',
                style: baslikTextStyle,
              )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              style: normalTextStyle,

              cursorColor: myBlueColor,
              //expands: true,
              enableInteractiveSelection: true,
              maxLength: 256,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (text) {},
              decoration: InputDecoration(
                labelText: 'Düzenlemek için dokun.',
                labelStyle: normalTextStyle,
                errorStyle: TextStyle(
                  color: Colors.red,
                ),
                fillColor: myBlueColor,
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: myBlueColor)),
                //counterText: '',
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(width: 1, color: myBlueColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(width: 1, color: myBlueColor),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Card profilPhotoCard(Color myBlueColor) {
    var userWorker = Provider.of<UserWorker>(context);
    return Card(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: FutureBuilder(
              future: userWorker.firebaseDatabaseWorks
                  .getUserProfilePhotoUrl(userWorker.getUserId()),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Container(
                    width: 150.0,
                    height: 150.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(snapshot.data), fit: BoxFit.fill),
                      borderRadius: BorderRadius.circular(120.0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(120.0),
                    ),
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text("Takipçi",
                        style: TextStyle(
                            color: myBlueColor, fontWeight: FontWeight.bold)),
                    Text("56",
                        style: TextStyle(
                            color: myBlueColor, fontWeight: FontWeight.bold)),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text("Etkinlik",
                        style: TextStyle(
                            color: myBlueColor, fontWeight: FontWeight.bold)),
                    Text("56",
                        style: TextStyle(
                            color: myBlueColor, fontWeight: FontWeight.bold)),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text("Güven Puanı",
                        style: TextStyle(
                            color: myBlueColor, fontWeight: FontWeight.bold)),
                    Text("105",
                        style: TextStyle(
                            color: myBlueColor, fontWeight: FontWeight.bold)),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Card slidePicturesCard(Color myBlueColor, List<Widget> images) {
    return Card(
      child: Column(
        children: <Widget>[
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: images)),
        ],
      ),
    );
  }
}
