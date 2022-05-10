import 'package:eventizer/Navigation/EventPage.dart';
import 'package:eventizer/Navigation/ProfilePage.dart';
import 'package:eventizer/Services/Repository.dart';
import 'package:eventizer/Tools/Dialogs.dart';
import 'package:eventizer/Tools/NavigationManager.dart';
import 'package:eventizer/Tools/PageComponents.dart';
import 'package:eventizer/assets/Colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

Widget eventItem(
    BuildContext context, Map<String, dynamic> eventDatas, bool fromExplorePage,
    {State? parentState}) {
  UserService userService = Provider.of<UserService>(context);
  EventService eventService = Provider.of<EventService>(context);
  var responsive = PageComponents(context);
  String eventID = eventDatas['eventID'];
  String title = eventDatas['Title'] ?? "null";
  String status = eventDatas['Status'] ?? "null";
  String ownerID = eventDatas['OrganizerID'];
  //String category = eventDatas['Category'];
  String imageUrl = eventDatas['EventImageUrl'];
  String startDate = eventDatas['StartDate'] ?? "null";
  String finishDate = eventDatas['FinishDate'] ?? "null";
  String location = eventDatas['Location'] ?? "null";
  String city = eventDatas['City'] ?? "null";
  String country = eventDatas['Country'] ?? "null";
  String currentParticipantNumber =
      eventDatas['CurrentParticipantNumber'].toString();
  String maxParticipantNumber = eventDatas['MaxParticipantNumber'].toString();
  Map<String, dynamic>? ownerData;
  return InkWell(
    onTap: () async {
      eventService
          .amIparticipant(userService.userModel!.getUserId(), eventID)
          .then((amIparticipant) {
        print("Kullanıcı bu etkinliğe katılmış:" + amIparticipant.toString());
        NavigationManager(context).pushPage(EventPage(
          eventData: eventDatas,
          userData: ownerData,
          amIparticipant: amIparticipant,
        ));
      });
    },
    child: ClipRRect(
      borderRadius: BorderRadius.all(
        Radius.circular(20),
      ),
      child: Container(
        width: responsive.widthSize(100),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: responsive.heightSize(2),
              ),
              Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      //ANCHOR kullanıcı profiline buradan gidiyor
                      NavigationManager(context).pushPage(ProfilePage(
                        key: UniqueKey(),
                        userID: ownerID,
                        isFromEvent: true,
                      ));
                    },
                    child: Row(
                      children: <Widget>[
                        Container(
                          height: responsive.heightSize(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          child: FutureBuilder(
                              future: userService.findUserByID(ownerID),
                              builder: (BuildContext _,
                                  AsyncSnapshot<dynamic> userData) {
                                if (userData.connectionState ==
                                    ConnectionState.done) {
                                  ownerData = userData.data;
                                  //ANCHOR user profil resmi burada
                                  return Container(
                                    height: responsive.heightSize(5),
                                    width: responsive.widthSize(10),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(userData
                                              .data['ProfilePhotoUrl'])),
                                    ),
                                  );
                                } else
                                  return Image.asset(
                                      "assets/images/avatar_man.png");
                              }),
                        ),
                        SizedBox(
                          width: responsive.widthSize(2),
                        ),
                        Text(
                          title,
                          style: TextStyle(
                            fontFamily: "Zona",
                            fontSize: responsive.heightSize(2),
                            color: MyColors().greyTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  fromExplorePage
                      ? IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.share,
                            color: MyColors().purpleContainer,
                          ),
                        )
                      : Visibility(
                          visible:
                              ownerID == userService.userModel!.getUserId() &&
                                  status != "Finished",
                          child: DropdownButton<String>(
                            items: [
                              DropdownMenuItem<String>(
                                value: "share",
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Icon(
                                        Icons.share,
                                        color: MyColors().purpleContainer,
                                        size: 30,
                                      ),
                                    ),
                                    Text("Paylaş")
                                  ],
                                ),
                              ),
                              DropdownMenuItem<String>(
                                value: "edit",
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Icon(
                                        Icons.edit,
                                        color: MyColors().purpleContainer,
                                        size: 30,
                                      ),
                                    ),
                                    Text("Düzenle")
                                  ],
                                ),
                              ),
                              DropdownMenuItem<String>(
                                value: "finish",
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Icon(
                                        Icons.stop,
                                        color: Colors.red,
                                        size: 30,
                                      ),
                                    ),
                                    Text("Bitir")
                                  ],
                                ),
                              ),
                              DropdownMenuItem<String>(
                                value: "delete",
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                        size: 30,
                                      ),
                                    ),
                                    Text("Sil")
                                  ],
                                ),
                              ),
                            ],
                            onChanged: (String? selected) {
                              //TODO Paylaş bitir ve düzenle seçenekleri için kod yazılacak
                              if (selected == "delete")
                                askingDialog(
                                        context,
                                        "Silmek istediğinize eminmisiniz?",
                                        Colors.red)
                                    .then((value) {
                                  if (value) {
                                    eventService.deleteEvent(eventID).then(
                                        (value) => print(
                                            "Silindi:" + value.toString()));
                                  }
                                });

                              if (selected == "finish")
                                askingDialog(
                                        context,
                                        "Bitirmek istediğinize eminmisiniz?",
                                        Colors.deepOrange)
                                    .then((value) async {
                                  await eventService.finishEvent(eventID).then(
                                      (value) => print(
                                          "Bitirildi:" + value.toString()));
                                  await userService.increaseNofEvents();
                                }).whenComplete(
                                        () => parentState!.setState(() {}));
                            },
                            hint: Row(
                              children: <Widget>[
                                Icon(Icons.menu,
                                    color: MyColors().purpleContainer),
                                Text("Seçenekler")
                              ],
                            ),
                          ),
                        ),
                ],
              ),
              Divider(
                thickness: 2,
                color: MyColors().loginGreyColor,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: FadeInImage.assetNetwork(
                  width: responsive.widthSize(100),
                  height: responsive.widthSize(100) * (9 / 16),
                  fit: BoxFit.fill,
                  placeholder: "assets/images/event_birthday.jpg",
                  image: imageUrl,
                ),
              ),
              Divider(
                thickness: 2,
                color: MyColors().loginGreyColor,
              ),
              Row(
                children: <Widget>[
                  //ANCHOR Start Date and Participants icons are here
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: responsive.heightSize(1),
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            child: FaIcon(
                              FontAwesomeIcons.calendarCheck,
                              color: MyColors().greyTextColor,
                            ),
                          ),
                          SizedBox(
                            width: responsive.widthSize(2),
                          ),
                          Text(
                            startDate,
                            style: TextStyle(
                              fontFamily: "Zona",
                              fontSize: responsive.heightSize(2),
                              color: MyColors().greyTextColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: responsive.heightSize(1),
                      ),
                      //TODO Katılımcı sayısı Stream ile getirilcek
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.people,
                            color: MyColors().greyTextColor,
                          ),
                          SizedBox(
                            width: responsive.widthSize(2),
                          ),
                          Text(
                            currentParticipantNumber +
                                "/" +
                                maxParticipantNumber,
                            style: TextStyle(
                              fontFamily: "Zona",
                              fontSize: responsive.heightSize(2),
                              color: MyColors().greyTextColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Spacer(),
                  //ANCHOR Finish Date and Locaition icons are here
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: responsive.heightSize(1),
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            child: FaIcon(
                              FontAwesomeIcons.calendarTimes,
                              color: MyColors().greyTextColor,
                            ),
                          ),
                          SizedBox(
                            width: responsive.widthSize(2),
                          ),
                          Text(
                            finishDate,
                            style: TextStyle(
                              fontFamily: "Zona",
                              fontSize: responsive.heightSize(2),
                              color: MyColors().greyTextColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: responsive.heightSize(1),
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.location_on,
                            color: MyColors().greyTextColor,
                          ),
                          SizedBox(
                            width: responsive.widthSize(1),
                          ),
                          //TODO Konum çift satır olmalı
                          Text(
                            location + "\n" + "$city",
                            style: TextStyle(
                              fontFamily: "Zona",
                              fontSize: responsive.heightSize(2),
                              color: MyColors().greyTextColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: responsive.heightSize(2.5),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
