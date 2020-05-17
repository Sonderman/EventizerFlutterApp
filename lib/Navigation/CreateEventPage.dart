import 'dart:typed_data';
import 'package:eventizer/Navigation/HomePage.dart';
import 'package:eventizer/Services/Repository.dart';
import 'package:eventizer/Settings/EventSettings.dart';
import 'package:eventizer/Tools/ImageEditor.dart';
import 'package:eventizer/Tools/PageComponents.dart';
import 'package:eventizer/assets/Colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../locator.dart';

class CreateEventPage extends StatefulWidget {
  @override
  _CreateEventPageState createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  double heightSize(double value) {
    value /= 100;
    return MediaQuery.of(context).size.height * value;
  }

  double widthSize(double value) {
    value /= 100;
    return MediaQuery.of(context).size.width * value;
  }

  PageController _pageController;
  @override
  void initState() {
    _pageController = PageController(
      initialPage: 0,
    );
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  Color myBlueColor = MyColors().blueThemeColor;
  TextEditingController controllerTitle = TextEditingController();
  TextEditingController controllerDetail = TextEditingController();
  List<String> categoryItems = locator<EventSettings>().categoryItems ?? [];
  bool loadingOverLay = false;
  String category;
  String eventStartDate;
  DateTime eventStartDateTime;
  String eventFinishDate;
  bool isStartDateSelected = false;
  bool isFinishDateSelected = false;
  Uint8List _image;

  Widget eventPhotoAndButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: heightSize(10),
          ),
          ClipRRect(
            borderRadius: new BorderRadius.all(
              Radius.circular(20),
            ),
            child: Container(
              color: MyColors().blackOpacityContainer,
              width: widthSize(100),
              height: heightSize(25),
              child: _image == null
                  ? Image.asset('assets/images/etkinlik.jpg', fit: BoxFit.fill)
                  : Image.memory(
                      _image,
                      fit: BoxFit.fill,
                    ),
            ),
          ),
          SizedBox(
            height: heightSize(2),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: widthSize(43),
                height: heightSize(8),
                decoration: BoxDecoration(
                  color: MyColors().blackOpacityContainer,
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: InkWell(
                  onTap: getImageFromCamera,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            height: heightSize(4),
                            child: Image.asset("assets/icons/camera.png"),
                          ),
                          Text(
                            "Kamera",
                            style: TextStyle(
                              fontFamily: "Zona",
                              fontSize: heightSize(2),
                              color: MyColors().whiteTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: widthSize(43),
                height: heightSize(8),
                decoration: new BoxDecoration(
                  color: MyColors().blackOpacityContainer,
                  borderRadius: new BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: InkWell(
                  onTap: getImageFromGallery,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            height: heightSize(4),
                            child: Image.asset("assets/icons/gallery.png"),
                          ),
                          Text(
                            "Galeri",
                            style: TextStyle(
                              fontFamily: "Zona",
                              fontSize: heightSize(2),
                              color: MyColors().whiteTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget dateButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: widthSize(43),
            height: heightSize(8),
            decoration: new BoxDecoration(
              color: MyColors().blackOpacityContainer,
              borderRadius: new BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: InkWell(
              onTap: () async {
                final datePick = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(DateTime.now().year),
                    lastDate: DateTime(DateTime.now().year + 2),
                    selectableDayPredicate: (DateTime currentDate) {
                      if (currentDate.day >= DateTime.now().day &&
                          currentDate.month >= DateTime.now().month) {
                        return true;
                      } else
                        return false;
                    });
                if (datePick != null) {
                  eventStartDateTime = datePick;
                  setState(() {
                    isStartDateSelected = true;
                    eventFinishDate = null;
                    isFinishDateSelected = false;
                    eventStartDate =
                        "${datePick.day}/${datePick.month}/${datePick.year}";
                  });
                }
              },
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        height: heightSize(4),
                        child: Image.asset("assets/icons/startDate.png"),
                      ),
                      Text(
                        "Başlangıç",
                        style: TextStyle(
                          fontFamily: "Zona",
                          fontSize: heightSize(2),
                          color: MyColors().whiteTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: widthSize(43),
            height: heightSize(8),
            decoration: new BoxDecoration(
              color: MyColors().blackOpacityContainer,
              borderRadius: new BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: InkWell(
              onTap: () async {
                final datePick = await showDatePicker(
                    context: context,
                    initialDate: eventStartDateTime,
                    firstDate: DateTime(eventStartDateTime.year),
                    lastDate: DateTime(DateTime.now().year + 1),
                    selectableDayPredicate: (DateTime currentDate) {
                      if (currentDate.day >= eventStartDateTime.day &&
                          currentDate.month >= eventStartDateTime.month) {
                        return true;
                      } else
                        return false;
                    });
                if (datePick != null) {
                  setState(() {
                    isFinishDateSelected = true;
                    eventFinishDate =
                        "${datePick.day}/${datePick.month}/${datePick.year}";
                  });
                }
              },
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        height: heightSize(4),
                        child: Image.asset("assets/icons/end_date.png"),
                      ),
                      Text(
                        "Bitiş",
                        style: TextStyle(
                          fontFamily: "Zona",
                          fontSize: heightSize(2),
                          color: MyColors().whiteTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget eventTitleAndDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: new BorderRadius.all(
              Radius.circular(20),
            ),
            child: Container(
              color: MyColors().blackOpacityContainer,
              width: widthSize(100),
              height: heightSize(8),
              child: Center(
                child: TextFormField(
                  validator: (value) => value.isEmpty ? 'boş olamaz' : null,
                  controller: controllerTitle,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Etkinlik başlığı...",
                    hintStyle: TextStyle(
                      color: MyColors().whiteTextColor,
                    ),
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Zona",
                    color: MyColors().whiteTextColor,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: heightSize(1.5),
          ),
          ClipRRect(
            borderRadius: new BorderRadius.all(
              Radius.circular(20),
            ),
            child: Container(
              color: MyColors().blackOpacityContainer,
              width: widthSize(100),
              height: heightSize(8),
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 8),
                child: TextFormField(
                  controller: controllerDetail,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Etkinlik içeriği...",
                    hintStyle: TextStyle(
                      color: MyColors().whiteTextColor,
                    ),
                  ),
                  style: TextStyle(
                    fontFamily: "ZonaLight",
                    color: MyColors().whiteTextColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget nextPageButton() {
    return InkWell(
      onTap: () {
        _pageController.nextPage(
            duration: Duration(seconds: 1), curve: Curves.easeInOutCubic);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          width: widthSize(50),
          height: heightSize(8),
          decoration: new BoxDecoration(
            color: MyColors().blackOpacityContainer,
            borderRadius: new BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 90),
              child: Text(
                "Next",
                style: TextStyle(
                  fontFamily: "Zona",
                  fontSize: heightSize(2),
                  color: MyColors().whiteTextColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget createEventButton() {
    return InkWell(
      onTap: () async {
        if (controllerTitle.text != "" &&
            category != null &&
            eventStartDate != null &&
            eventFinishDate != null) {
          setState(() {
            loadingOverLay = true;
          });

          final eventManager =
              Provider.of<EventService>(context, listen: false);
          final userID = Provider.of<UserService>(context, listen: false)
              .usermodel
              .getUserId();
          Map<String, dynamic> eventData = {
            // REVIEW Veri tabanında yazılan yer burası , burası için bir çözüm bul
            "OrganizerID": userID,
            "Title": controllerTitle.text,
            "Category": category,
            "StartDate": eventStartDate,
            "FinishDate": eventFinishDate,
            "Detail": controllerDetail.text,
            "Status": "New"
          };
          if (await eventManager.createEvent(userID, eventData, _image)) {
            print("Event oluşturma başarılı");
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => HomePage()),
                (route) => false);
          } else {
            setState(() {
              loadingOverLay = false;
            });
            print("Event oluşturulamadı");
          }
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          width: widthSize(100),
          height: heightSize(8),
          decoration: new BoxDecoration(
            color: MyColors().blackOpacityContainer,
            borderRadius: new BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 90),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    height: heightSize(4),
                    child: Image.asset("assets/icons/addEvent.png"),
                  ),
                  Text(
                    "ETKİNLİK OLUŞTUR",
                    style: TextStyle(
                      fontFamily: "Zona",
                      fontSize: heightSize(2),
                      color: MyColors().whiteTextColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void getImageFromCamera() async {
    await ImagePicker.pickImage(source: ImageSource.camera).then((image) {
      if (image != null) {
        Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => ImageEditorPage(image)))
            .then((editedImage) {
          setState(() {
            _image = editedImage;
          });
        });
      }
    });
  }

  void getImageFromGallery() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      if (image != null) {
        Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => ImageEditorPage(image)))
            .then((editedImage) {
          setState(() {
            _image = editedImage;
          });
        });
      }
    });
  }

  List<Widget> pages() {
    return [
      Column(
        children: <Widget>[
          eventPhotoAndButtons(),
          SizedBox(
            height: heightSize(3),
          ),
          dateButtons(),
          SizedBox(
            height: heightSize(3),
          ),
          eventTitleAndDetails(),
          SizedBox(
            height: heightSize(3),
          ),
          nextPageButton(),
        ],
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
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
          createEventButton(),
        ],
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[Text("3. Sayfa")],
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.deepPurpleAccent,
        body: Stack(
          children: <Widget>[
                PageView(controller: _pageController, children: pages())
              ] +
              (loadingOverLay
                  ? <Widget>[
                      PageComponents().loadingOverlay(context, Colors.white)
                    ]
                  : <Widget>[]),
        ));
  }
}
