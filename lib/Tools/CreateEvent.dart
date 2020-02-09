import 'dart:io';
import 'dart:typed_data';
import 'package:eventizer/Services/Repository.dart';
import 'package:eventizer/Tools/ImageEditor.dart';
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
  Color myBlueColor = Color(0XFF001970);
  TextEditingController controllerAd = TextEditingController();

  String category;
  List<String> categoryItems = [
    "Doğumgünü Partisi",
    "Balık Tutma",
    "Turistik Gezi"
  ];
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
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          child: Container(
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
                              borderRadius: BorderRadius.circular(120.0),
                            ),
                            child: Icon(FontAwesomeIcons.camera))),
                    GestureDetector(
                        onTap: getImageFromGallery,
                        child: Container(
                            width: 50.0,
                            height: 50.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(120.0),
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
                        .map<DropdownMenuItem<String>>((String value) {
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: controllerAd,
                    decoration: InputDecoration(labelText: 'Etkinlik Adı'),
                    validator: (value) => value.isEmpty ? 'boş olamaz' : null,
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
                                  firstDate: DateTime(DateTime.now().year),
                                  lastDate: DateTime(DateTime.now().year + 2),
                                  selectableDayPredicate:
                                      (DateTime currentDate) {
                                    if (currentDate.day >= DateTime.now().day &&
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
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: (<Widget>[
                              Text("Bitiş Tarihi Seçiniz :"),
                              GestureDetector(
                                  child: Icon(Icons.date_range),
                                  onTap: () async {
                                    final datePick = await showDatePicker(
                                        context: context,
                                        initialDate: eventStartDateTime,
                                        firstDate:
                                            DateTime(eventStartDateTime.year),
                                        lastDate:
                                            DateTime(DateTime.now().year + 1),
                                        selectableDayPredicate:
                                            (DateTime currentDate) {
                                          if (currentDate.day >=
                                                  eventStartDateTime.day &&
                                              currentDate.month >=
                                                  eventStartDateTime.month) {
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
                        final eventManager =
                            Provider.of<EventService>(context, listen: false);
                        final userID =
                            Provider.of<UserService>(context, listen: false)
                                .getUserId();
                        Map<String, dynamic> eventData = {
                          //Veri tabanında yazılan yer burası , burası için bir çözüm bul
                          "OrganizerID": userID,
                          "Title": controllerAd.text,
                          "Category": category
                        };
                        if (controllerAd.text != "" &&
                            category != null &&
                            await eventManager.createEvent(userID, eventData)) {
                          print("Event oluşturma başarılı");
                          Navigator.pop(context);
                        } else {
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
