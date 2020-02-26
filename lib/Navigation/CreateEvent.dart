import 'dart:typed_data';
import 'package:eventizer/Services/Repository.dart';
import 'package:eventizer/Settings/EventSettings.dart';
import 'package:eventizer/Tools/ImageEditor.dart';
import 'package:eventizer/Tools/PageComponents.dart';
import 'package:eventizer/assets/Colors.dart';
import 'package:eventizer/locator.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CreateEvent extends StatefulWidget {
  CreateEvent({Key key}) : super(key: key);

  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  Color myBlueColor = MyColors().blueThemeColor;
  TextEditingController controllerAd = TextEditingController();
  TextEditingController controllerDetay = TextEditingController();
  List<String> categoryItems = locator<EventSettings>().categoryItems ?? [];
  bool loadingOverLay = false;
  String category;
  String eventStartDate;
  DateTime eventStartDateTime;
  String eventFinishDate;
  bool isStartDateSelected = false;
  bool isFinishDateSelected = false;
  Uint8List _image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: myBlueColor,
        title: Text("Etkinlik oluştur"),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
              Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                  child: Container(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            height: MediaQuery.of(context).size.height * 0.3,
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: _image == null
                                ? Image.asset('assets/images/etkinlik.jpg',
                                    fit: BoxFit.fill)
                                : Image.memory(
                                    _image,
                                    fit: BoxFit.fill,
                                  ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text("Etkinlik için Resim Seçin :"),
                              GestureDetector(
                                  onTap: getImageFromCamera,
                                  child: Container(
                                      width: 50.0,
                                      height: 50.0,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(120.0),
                                      ),
                                      child: Icon(FontAwesomeIcons.camera))),
                              GestureDetector(
                                  onTap: getImageFromGallery,
                                  child: Container(
                                      width: 50.0,
                                      height: 50.0,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(120.0),
                                        /*border: Border.all(
                                                        width: 3.0,
                                                        color: Colors.red,
                                                      ),*/
                                      ),
                                      child: Icon(FontAwesomeIcons.images))),
                            ],
                          ),
                          DropdownButton<String>(
                              hint: Text("Kategori Seçiniz"),
                              value: category != null ? category : null,
                              items: categoryItems
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
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
                          Form(
                            key: formkey,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: controllerAd,
                                decoration:
                                    InputDecoration(labelText: 'Etkinlik Adı'),
                                validator: (value) =>
                                    value.isEmpty ? 'boş olamaz' : null,
                              ),
                            ),
                          ),
                          TextField(
                            style:
                                TextStyle(color: myBlueColor, fontSize: 14.0),
                            controller: controllerDetay,
                            cursorColor: myBlueColor,
                            maxLines: null,
                            minLines: null,
                            enableInteractiveSelection: true,
                            maxLength: 256,
                            textCapitalization: TextCapitalization.sentences,
                            onChanged: (text) {},
                            decoration: InputDecoration(
                              labelText: 'Düzenlemek için dokun.',
                              labelStyle:
                                  TextStyle(color: myBlueColor, fontSize: 14.0),
                              errorStyle: TextStyle(
                                color: Colors.red,
                              ),
                              fillColor: myBlueColor,
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: myBlueColor)),
                              //counterText: '',
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                borderSide:
                                    BorderSide(width: 1, color: myBlueColor),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                borderSide:
                                    BorderSide(width: 1, color: myBlueColor),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: (<Widget>[
                                  Text("Başlangıç Tarihi Seçiniz :"),
                                  GestureDetector(
                                      child: Icon(Icons.date_range),
                                      onTap: () async {
                                        final datePick = await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate:
                                                DateTime(DateTime.now().year),
                                            lastDate: DateTime(
                                                DateTime.now().year + 2),
                                            selectableDayPredicate:
                                                (DateTime currentDate) {
                                              if (currentDate.day >=
                                                      DateTime.now().day &&
                                                  currentDate.month >=
                                                      DateTime.now().month) {
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
                                      }),
                                ] +
                                (eventStartDate != null
                                    ? <Widget>[Text(eventStartDate)]
                                    : <Widget>[])),
                          ),
                          eventStartDateTime != null
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: (<Widget>[
                                        Text("Bitiş Tarihi Seçiniz :"),
                                        GestureDetector(
                                            child: Icon(Icons.date_range),
                                            onTap: () async {
                                              final datePick =
                                                  await showDatePicker(
                                                      context: context,
                                                      initialDate:
                                                          eventStartDateTime,
                                                      firstDate: DateTime(
                                                          eventStartDateTime
                                                              .year),
                                                      lastDate: DateTime(
                                                          DateTime.now().year +
                                                              1),
                                                      selectableDayPredicate:
                                                          (DateTime
                                                              currentDate) {
                                                        if (currentDate.day >=
                                                                eventStartDateTime
                                                                    .day &&
                                                            currentDate.month >=
                                                                eventStartDateTime
                                                                    .month) {
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
                                            }),
                                      ] +
                                      (eventFinishDate != null
                                          ? <Widget>[Text(eventFinishDate)]
                                          : <Widget>[])),
                                )
                              : Text("Bitiş  Tarihi:"),
                          Material(
                            borderRadius: BorderRadius.circular(30.0),
                            //elevation: 5.0,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: MaterialButton(
                                onPressed: () async {
                                  setState(() {
                                    loadingOverLay = true;
                                  });
                                  formkey.currentState.validate();
                                  final eventManager =
                                      Provider.of<EventService>(context,
                                          listen: false);
                                  final userID = Provider.of<UserService>(
                                          context,
                                          listen: false)
                                      .getUserId();
                                  Map<String, dynamic> eventData = {
                                    // REVIEW Veri tabanında yazılan yer burası , burası için bir çözüm bul
                                    "OrganizerID": userID,
                                    "Title": controllerAd.text,
                                    "Category": category,
                                    "StartDate": eventStartDate,
                                    "FinishDate": eventFinishDate,
                                    "Detail": controllerDetay.text
                                  };
                                  if (controllerAd.text != "" &&
                                      category != null &&
                                      eventStartDate != null &&
                                      await eventManager.createEvent(
                                          userID, eventData, _image)) {
                                    print("Event oluşturma başarılı");
                                    Navigator.pop(context);
                                  } else {
                                    setState(() {
                                      loadingOverLay = false;
                                    });
                                    print("Event oluşturulamadı");
                                  }
                                },
                                minWidth: 50.0,
                                height: 30.0,
                                color: myBlueColor,
                                child: Text(
                                  "Oluştur",
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
                    ),
                  ),
                ),
              ),
            ] +
            (loadingOverLay
                ? <Widget>[PageComponents().loadingOverlay(context)]
                : <Widget>[]),
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
}
