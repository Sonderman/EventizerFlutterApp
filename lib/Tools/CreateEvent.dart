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
  TextEditingController controllerAd;
  @override
  Widget build(BuildContext context) {
    controllerAd = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: myBlueColor,
        title: Text("Etkinlik oluştur"),
      ),
      body: Center(
        child: Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: controllerAd,
                  decoration: InputDecoration(labelText: 'Etkinlik Adı'),
                  validator: (value) => value.isEmpty ? 'boş olamaz' : null,
                  onSaved: (value) => null,
                ),
              ),
              Material(
                borderRadius: BorderRadius.circular(30.0),
                //elevation: 5.0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MaterialButton(
                    onPressed: () async {
                      final eventManager = Provider.of<EventService>(context);
                      final userID =
                          Provider.of<UserService>(context).getUserId();
                      Map<String, dynamic> eventData = {
                        "OwnerID": userID,
                        "Title": controllerAd.text
                      };
                      if (controllerAd.text != null &&
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
