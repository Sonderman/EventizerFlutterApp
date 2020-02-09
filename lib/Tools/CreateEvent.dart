import 'package:eventizer/Services/Repository.dart';
import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: myBlueColor,
        title: Text("Etkinlik oluştur"),
      ),
      body: Center(
        child: Container(
          child: Column(
            children: <Widget>[
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
                    color: Color(0xFF179CDF),
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
    );
  }
}
