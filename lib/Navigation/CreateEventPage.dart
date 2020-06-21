import 'dart:typed_data';
import 'package:eventizer/Models/UserModel.dart';
import 'package:eventizer/Navigation/MyEventsPage.dart';
import 'package:eventizer/Navigation/ProfilePage.dart';
import 'package:eventizer/Services/Repository.dart';
import 'package:eventizer/Settings/EventSettings.dart';
import 'package:eventizer/Tools/ImageEditor.dart';
import 'package:eventizer/Tools/NavigationManager.dart';
import 'package:eventizer/Tools/PageComponents.dart';
import 'package:eventizer/assets/Colors.dart';
import 'package:eventizer/assets/Sehirler.dart';
import 'package:eventizer/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

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
  UserService userService;
  User userModel;

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  Color myBlueColor = MyColors().blueThemeColor;
  TextEditingController controllerTitle = TextEditingController();
  TextEditingController controllerDetail = TextEditingController();
  TextEditingController controllerLocation = TextEditingController();
  TextEditingController participantNumberController = TextEditingController();
  List<String> categoryItems = locator<EventSettings>().categoryItems ?? [];
  List<List<String>> subCategoryItems =
      locator<EventSettings>().subCategoryItems ?? [];
  MaterialLocalizations localizations;
  String subCategory,
      mainCategory,
      eventStartDate,
      eventStartTime,
      eventFinishDate,
      eventFinishTime,
      country,
      city;
  TimeOfDay eventStartTimeOfDay, eventFinishTimeOfDay;
  DateTime eventStartDateTime;
  bool isStartDateSelected = false,
      isStartTimeSelected = false,
      isFinishDateSelected = false,
      isFinishTimeSelected = false,
      isMainCategorySelected = false,
      //ANCHOR true ise Erkek
      userGender,
      oppositeGender = false,
      loadingOverLay = false;
  Uint8List _image;

  @override
  void initState() {
    participantNumberController.text = "1";
    super.initState();
  }

  @override
  void didChangeDependencies() {
    userService = Provider.of<UserService>(context);
    userModel = userService.userModel;
    userGender = userModel.getUserGender() == "Man" ? true : false;
    _pageController = NavigationManager(context).getCreateEventPageController();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    localizations = MaterialLocalizations.of(context);
    return Scaffold(
        backgroundColor: Colors.deepPurpleAccent,
        body: Stack(
          children: <Widget>[
                PageView(controller: _pageController, children: pages())
              ] +
              (loadingOverLay
                  ? <Widget>[
                      PageComponents(context)
                          .loadingOverlay(backgroundColor: Colors.white)
                    ]
                  : <Widget>[]),
        ));
  }

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
              height: widthSize(100) * (9 / 16),
              child: _image == null
                  ? Image.asset('assets/images/etkinlik.png', fit: BoxFit.cover)
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
                      if (currentDate.month > DateTime.now().month &&
                          currentDate.year >= DateTime.now().year) {
                        return true;
                      } else if (currentDate.day >= DateTime.now().day &&
                          currentDate.month >= DateTime.now().month) {
                        return true;
                      } else if (currentDate.year > DateTime.now().year)
                        return true;
                      else
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
                        eventStartDate == null
                            ? "Başlangıç"
                            : "$eventStartDate",
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
                  firstDate: eventStartDateTime,
                  lastDate: DateTime(eventStartDateTime.year + 2),
                );
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
                  padding: eventFinishDate == null
                      ? EdgeInsets.symmetric(horizontal: 40)
                      : EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        height: heightSize(4),
                        child: Image.asset("assets/icons/end_date.png"),
                      ),
                      Text(
                        eventFinishDate == null ? "Bitiş" : "$eventFinishDate",
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

  Widget timeButtons() {
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
                await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                ).then((timePick) {
                  if (timePick != null) {
                    eventStartTimeOfDay = timePick;
                    setState(() {
                      isStartTimeSelected = true;
                      eventFinishTime = null;
                      isFinishTimeSelected = false;
                      eventStartTime =
                          localizations.formatTimeOfDay(eventStartTimeOfDay);
                    });
                  }
                });
              },
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        height: heightSize(4),
                        child: Image.asset("assets/icons/startTime.png"),
                      ),
                      Text(
                        eventStartTime == null
                            ? "Başlangıç"
                            : "$eventStartTime",
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
                if (eventStartTimeOfDay != null) {
                  await showTimePicker(
                    context: context,
                    initialTime: eventStartTimeOfDay,
                  ).then((timePick) {
                    if (timePick != null) {
                      eventFinishTimeOfDay = timePick;
                      setState(() {
                        isFinishTimeSelected = true;
                        eventFinishTime =
                            localizations.formatTimeOfDay(eventFinishTimeOfDay);
                      });
                    }
                  });
                }
              },
              child: Center(
                child: Padding(
                  padding: eventFinishTime == null
                      ? EdgeInsets.symmetric(horizontal: 40)
                      : EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        height: heightSize(4),
                        child: Image.asset("assets/icons/endTime.png"),
                      ),
                      Text(
                        eventFinishTime == null ? "Bitiş" : "$eventFinishTime",
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
                      fontSize: heightSize(2.5),
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
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
            child: Container(
              color: MyColors().blackOpacityContainer,
              width: widthSize(100),
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 8),
                child: TextFormField(
                  controller: controllerDetail,
                  minLines: 2,
                  maxLines: 10,
                  keyboardType: TextInputType.multiline,
                  enableInteractiveSelection: true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Etkinlik detayı...",
                    hintStyle: TextStyle(
                      fontSize: heightSize(2.5),
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
            color: MyColors().purpleContainer,
            borderRadius: new BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Center(
            child: Text(
              "Devam Et",
              style: TextStyle(
                fontFamily: "Zona",
                fontSize: heightSize(2.5),
                color: MyColors().whiteTextColor,
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
        int maxParticipantNumber;
        if (participantNumberController.text == null ||
            participantNumberController.text == "")
          maxParticipantNumber = 2;
        else
          maxParticipantNumber = int.parse(participantNumberController.text);

        if (controllerTitle.text != "" &&
            controllerDetail.text != "" &&
            controllerLocation.text != "" &&
            maxParticipantNumber != null &&
            maxParticipantNumber != 0 &&
            _image != null &&
            subCategory != null &&
            mainCategory != null &&
            city != null &&
            //country != null &&
            eventStartDate != null &&
            eventStartTime != null &&
            eventFinishDate != null &&
            eventFinishTime != null) {
          setState(() {
            loadingOverLay = true;
          });
          String allowedGenders() {
            if (userGender & oppositeGender) return "11";
            if (userGender & !oppositeGender) return "10";
            if (!userGender & oppositeGender) return "11";
            if (!userGender & !oppositeGender) return "01";
            return null;
          }

          final eventManager =
              Provider.of<EventService>(context, listen: false);
          final userID = Provider.of<UserService>(context, listen: false)
              .userModel
              .getUserId();
          Map<String, dynamic> eventData = {
            // REVIEW Veri tabanında yazılan yer burası , burası için bir çözüm bul
            "OrganizerID": userID,
            "Title": controllerTitle.text,
            "MaxParticipantNumber": maxParticipantNumber,
            "CurrentParticipantNumber": 0,
            "MainCategory": mainCategory,
            "SubCategory": subCategory,
            "City": city,
            //"Country": country,
            "StartDate": eventStartDate,
            "FinishDate": eventFinishDate,
            "StartTime": eventStartTime,
            "FinishTime": eventFinishTime,
            "Detail": controllerDetail.text,
            "Location": controllerLocation.text,
            //ANCHOR Erkek izin verildiyse "10", kadın izin verildiyse "01" , ikiside izin verildiyse "11"
            "AllowedGenders": allowedGenders(),
            "Status": "New"
          };
          if (await eventManager.createEvent(userID, eventData, _image)) {
            print("Event oluşturma başarılı");
            //ANCHOR Event oluşturma başarılıysa profilepage e gidiyor.
            NavigationManager(context).pushPage(
                ProfilePage(
                    userID: userService.userModel.getUserId(),
                    isFromEvent: false),
                refresh: false);
            NavigationManager(context).pushPage(MyEventsPage(
              userID: userService.userModel.getUserId(),
              isOld: false,
            ));

            Fluttertoast.showToast(
                msg: "Etkinlik Oluşturuldu",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 4,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 18.0);
          } else {
            setState(() {
              loadingOverLay = false;
            });
            Fluttertoast.showToast(
                msg: "İnternet Bağlantınızı kontrol ediniz!",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 3,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 18.0);
          }
        } else {
          Fluttertoast.showToast(
              msg: "Eksik Alanları Doldurunuz!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 3,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 18.0);
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: heightSize(4),
                  child: Image.asset("assets/icons/addEvent.png"),
                ),
                SizedBox(
                  width: widthSize(3),
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
    );
  }

  Widget numberOfParticipants() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: <Widget>[
          Container(
            width: widthSize(100),
            height: heightSize(8),
            decoration: new BoxDecoration(
              color: MyColors().blackOpacityContainer,
              borderRadius: new BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: <Widget>[
                  Text(
                    "Katılım Sınırı:",
                    style: TextStyle(
                      fontSize: heightSize(2.5),
                      fontFamily: "Zona",
                      color: MyColors().whiteTextColor,
                    ),
                  ),
                  Spacer(),
                  Container(
                    width: widthSize(20),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.right,
                      maxLength: 3,
                      enableInteractiveSelection: false,
                      controller: participantNumberController,
                      expands: false,
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(
                        counterText: "",
                        border: InputBorder.none,
                        hintText: "0",
                        hintStyle: TextStyle(
                          fontFamily: "Zona",
                          color: MyColors().whiteTextColor,
                        ),
                        alignLabelWithHint: true,
                      ),
                      style: TextStyle(
                        fontSize: heightSize(2.5),
                        fontFamily: "Zona",
                        color: MyColors().whiteTextColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: heightSize(3),
          ),
        ],
      ),
    );
  }

  Widget selectGender() {
    //ANCHOR karşı cins seçili ise ona özgü renk döndürür, seçilmezse tek tip renk döndürür.
    Color getOppositeGenderColor() {
      if (oppositeGender) if (userGender)
        return Colors.pinkAccent;
      else
        return MyColors().blueContainer;
      else
        return Colors.blueAccent;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        InkWell(
          onTap: () {
            setState(() {
              oppositeGender = !oppositeGender;
            });
          },
          child: Container(
            width: widthSize(43),
            height: heightSize(5),
            decoration: new BoxDecoration(
              color: getOppositeGenderColor(),
              borderRadius: new BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  userGender ? "Kadın" : "Erkek",
                  style: TextStyle(
                    fontFamily: "Zona",
                    fontSize: heightSize(2),
                    color: MyColors().whiteTextColor,
                  ),
                ),
                Checkbox(
                    value: oppositeGender,
                    onChanged: (check) {
                      setState(() {
                        oppositeGender = check;
                      });
                    })
              ],
            ),
          ),
        ),
        SizedBox(
          height: heightSize(3),
        ),
      ],
    );
  }

  Widget selectMainCategory() {
    return Column(
      children: <Widget>[
        Padding(
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
              child: DropdownButton<String>(
                  iconEnabledColor: Colors.white,
                  dropdownColor: MyColors().purpleContainerSplash,
                  hint: Text(
                    "Kategori Seçiniz",
                    style: TextStyle(
                      fontFamily: "Zona",
                      fontSize: heightSize(2),
                      color: MyColors().whiteTextColor,
                    ),
                  ),
                  value: mainCategory != null ? mainCategory : null,
                  items: categoryItems
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(
                          fontFamily: "Zona",
                          fontSize: heightSize(2),
                          color: MyColors().whiteTextColor,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (chosen) {
                    setState(() {
                      if (mainCategory != chosen) {
                        mainCategory = chosen;
                        isMainCategorySelected = true;
                        subCategory = null;
                      }
                    });
                  }),
            ),
          ),
        ),
        SizedBox(
          height: heightSize(3),
        ),
      ],
    );
  }

  Widget selectSubCategory() {
    int selectedMainCategoryIndex =
        categoryItems.indexWhere((element) => element == mainCategory);
    return Column(
      children: <Widget>[
        Padding(
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
              child: DropdownButton<String>(
                  iconEnabledColor: Colors.white,
                  dropdownColor: MyColors().purpleContainerSplash,
                  hint: Text(
                    "Alt Kategori Seçiniz",
                    style: TextStyle(
                      fontFamily: "Zona",
                      fontSize: heightSize(2),
                      color: MyColors().whiteTextColor,
                    ),
                  ),
                  value: subCategory != null ? subCategory : null,
                  items: subCategoryItems[selectedMainCategoryIndex]
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(
                          fontFamily: "Zona",
                          fontSize: heightSize(2),
                          color: MyColors().whiteTextColor,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (chosen) {
                    setState(() {
                      subCategory = chosen;
                    });
                  }),
            ),
          ),
        ),
        SizedBox(
          height: heightSize(3),
        ),
      ],
    );
  }

  void getImageFromCamera() async {
    await ImagePicker.pickImage(source: ImageSource.camera).then((image) {
      if (image != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => ImageEditorPage(
                      image: image,
                      forCreateEvent: true,
                    ))).then((editedImage) {
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
                builder: (BuildContext context) => ImageEditorPage(
                      image: image,
                      forCreateEvent: true,
                    ))).then((editedImage) {
          setState(() {
            _image = editedImage;
          });
        });
      }
    });
  }

  Widget location() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
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
              controller: controllerLocation,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Etkinlik yeri/mekanı...",
                hintStyle: TextStyle(
                  color: MyColors().whiteTextColor,
                ),
              ),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "Zona",
                fontSize: heightSize(2.5),
                color: MyColors().whiteTextColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget cityAndCountry() {
    List<DropdownMenuItem<int>> sehirler = [];
    sehirler.add(DropdownMenuItem(value: 0, child: Text("Sehir Seçin")));
    for (int i = 1; i <= 81; i++) {
      sehirler.add(DropdownMenuItem(
        value: i,
        child: Text(Sehirler().sehirler[i - 1]),
      ));
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          /*
          Container(
            width: widthSize(43),
            height: heightSize(8),
            decoration: new BoxDecoration(
              color: MyColors().blackOpacityContainer,
              borderRadius: new BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Container(
              width: widthSize(43),
              height: heightSize(8),
              decoration: new BoxDecoration(
                color: MyColors().yellowContainer,
                borderRadius: new BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Center(
                child: DropdownButton<String>(
                  hint: Text(
                    country != null ? country : ("Ülke Seçin"),
                    style: TextStyle(
                      fontFamily: "Zona",
                      fontSize: heightSize(2),
                      color: MyColors().whiteTextColor,
                    ),
                  ),
                  items: [
                    DropdownMenuItem(
                      child: Text("Türkiye"),
                      value: "TR",
                    ),
                    DropdownMenuItem(
                      child: Text("United States"),
                      value: "US",
                    ),
                    DropdownMenuItem(
                      child: Text("United Kingdom"),
                      value: "UK",
                    ),
                  ],
                  onChanged: (con) {
                    setState(() {
                      country = con;
                    });
                  },
                ),
              ),
            ),
          ),
*/
          Container(
            height: heightSize(8),
            //TODO responsive yap
            width: widthSize(100) - 40,
            child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
              child: Container(
                color: MyColors().blackOpacityContainer,
                child: Center(
                  child: SearchableDropdown.single(
                    items: sehirler,
                    hint: Text(
                      "Şehir Seçin",
                      style: TextStyle(
                          color: Colors.white, fontSize: widthSize(4)),
                    ),
                    searchHint: "Şehir Seçin",
                    onChanged: (value) {
                      if (value != 0 && value != null) {
                        setState(() {
                          city = Sehirler().sehirler[value - 1];
                          print("CITY:" + city);
                        });
                      }
                    },
                    style:
                        TextStyle(color: Colors.white, fontSize: widthSize(4)),
                    displayClearIcon: true,
                    isExpanded: true,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> pages() {
    return [
      //ANCHOR 1. sayfa
      LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: Column(
            children: <Widget>[
              eventPhotoAndButtons(),
              SizedBox(
                height: heightSize(3),
              ),
              dateButtons(),
              SizedBox(
                height: heightSize(3),
              ),
              timeButtons(),
              SizedBox(
                height: heightSize(3),
              ),
              eventTitleAndDetails(),
              SizedBox(
                height: heightSize(3),
              ),
              cityAndCountry(),
              SizedBox(
                height: heightSize(3),
              ),
              location(),
              SizedBox(
                height: heightSize(3),
              ),
              nextPageButton(),
              constraints.maxWidth < 400
                  ? SizedBox(
                      height: heightSize(10),
                    )
                  : SizedBox(
                      height: heightSize(5),
                    ),
            ],
          ),
        ),
      ),
      //ANCHOR 2. sayfa
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
              numberOfParticipants(),
              selectGender(),
              selectMainCategory(),
            ] +
            (isMainCategorySelected
                ? <Widget>[
                    selectSubCategory(),
                  ]
                : <Widget>[]) +
            <Widget>[
              createEventButton(),
            ],
      ),
    ];
  }
}
