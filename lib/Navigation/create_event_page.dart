import 'dart:typed_data';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:eventizer/data/themes.dart';
import 'package:eventizer/data/cities.dart';
import 'package:eventizer/models/user_model.dart';
import 'package:eventizer/components/liquidglass_widgets.dart';
import 'package:eventizer/locator.dart';
import 'package:eventizer/navigation/my_events_page.dart';
import 'package:eventizer/navigation/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../services/repository.dart';
import '../settings/event_settings.dart';
import '../tools/navigation_manager.dart';
import '../tools/page_components.dart';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({super.key});

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
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

  PageController? _pageController;
  UserService? userService;
  UserModel? userModel;

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  Color myBlueColor = MyColors.blueThemeColor;
  TextEditingController controllerTitle = TextEditingController();
  TextEditingController controllerDetail = TextEditingController();
  TextEditingController controllerLocation = TextEditingController();
  TextEditingController participantNumberController = TextEditingController();
  List<String> categoryItems = locator<EventSettings>().categoryItems ?? [];
  List<List<String>> subCategoryItems =
      locator<EventSettings>().subCategoryItems ?? [];
  MaterialLocalizations? localizations;
  String? subCategory,
      mainCategory,
      eventStartDate,
      eventStartTime,
      eventFinishDate,
      eventFinishTime,
      country,
      city;
  TimeOfDay? eventStartTimeOfDay, eventFinishTimeOfDay;
  DateTime? eventStartDateTime;
  bool? isStartDateSelected = false,
      isStartTimeSelected = false,
      isFinishDateSelected = false,
      isFinishTimeSelected = false,
      isMainCategorySelected = false,
      //ANCHOR true ise Erkek
      userGender,
      oppositeGender = false,
      loadingOverLay = false;
  Uint8List? _image;

  @override
  void initState() {
    participantNumberController.text = "1";
    super.initState();
  }

  @override
  void didChangeDependencies() {
    userService = Provider.of<UserService>(context);
    userModel = userService?.userModel;
    userGender = userModel?.getUserGender() == "Man" ? true : false;
    _pageController = NavigationManager(context).getCreateEventPageController();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    localizations = MaterialLocalizations.of(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children:
            <Widget>[
              Padding(
                padding: const EdgeInsets.all(12), // Slightly smaller padding
                child: MyLiquidGlass.standartContainer(
                  child: PageView(
                    controller: _pageController,
                    physics: const BouncingScrollPhysics(),
                    children: pages(),
                  ),
                ),
              ),
            ] +
            (loadingOverLay!
                ? <Widget>[
                    PageComponents(context).loadingOverlay(
                      backgroundColor: Colors.white.withValues(alpha: 0.1),
                    ),
                  ]
                : <Widget>[]),
      ),
    );
  }

  Widget _buildCompactButton({
    required String iconPath,
    required String label,
    required VoidCallback onTap,
    EdgeInsets? padding,
    double? height,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: MyLiquidGlass.section(
          glassColor: MyColors.blackOpacityContainer,
          borderRadius: 20,
          child: Padding(
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 12),
            child: SizedBox(
              height: height ?? heightSize(7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(iconPath, height: heightSize(3.2)),
                  const SizedBox(width: 8),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        label,
                        style: TextStyle(
                          fontFamily: "Zona",
                          fontSize: heightSize(1.8),
                          color: MyColors.globalTextColor,
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
    );
  }

  Widget eventPhotoAndButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: heightSize(3)), // Reduced top spacing
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(24)),
            child: Container(
              color: MyColors.blackOpacityContainer,
              width: widthSize(100),
              height: widthSize(100) * (9 / 16),
              child: _image == null
                  ? Image.asset('assets/images/etkinlik.png', fit: BoxFit.cover)
                  : Image.memory(_image!, fit: BoxFit.fill),
            ),
          ),
          SizedBox(height: heightSize(1.5)),
          Row(
            children: <Widget>[
              _buildCompactButton(
                iconPath: "assets/icons/camera.png",
                label: "Kamera",
                onTap: getImageFromCamera,
              ),
              const SizedBox(width: 12),
              _buildCompactButton(
                iconPath: "assets/icons/gallery.png",
                label: "Galeri",
                onTap: getImageFromGallery,
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
        children: <Widget>[
          _buildCompactButton(
            iconPath: "assets/icons/startDate.png",
            label: eventStartDate ?? "Başlangıç",
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
                },
              );
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
          ),
          const SizedBox(width: 12),
          _buildCompactButton(
            iconPath: "assets/icons/end_date.png",
            label: eventFinishDate ?? "Bitiş",
            onTap: () async {
              if (eventStartDateTime == null) {
                Fluttertoast.showToast(msg: "Önce başlangıç tarihini seçin");
                return;
              }
              final datePick = await showDatePicker(
                context: context,
                initialDate: eventStartDateTime!,
                firstDate: eventStartDateTime!,
                lastDate: DateTime(eventStartDateTime!.year + 2),
              );
              if (datePick != null) {
                setState(() {
                  isFinishDateSelected = true;
                  eventFinishDate =
                      "${datePick.day}/${datePick.month}/${datePick.year}";
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget timeButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: <Widget>[
          _buildCompactButton(
            iconPath: "assets/icons/startTime.png",
            label: eventStartTime ?? "Başlangıç",
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
                    eventStartTime = localizations!.formatTimeOfDay(
                      eventStartTimeOfDay!,
                    );
                  });
                }
              });
            },
          ),
          const SizedBox(width: 12),
          _buildCompactButton(
            iconPath: "assets/icons/endTime.png",
            label: eventFinishTime ?? "Bitiş",
            onTap: () async {
              if (eventStartTimeOfDay == null) {
                Fluttertoast.showToast(msg: "Önce başlangıç saatini seçin");
                return;
              }
              await showTimePicker(
                context: context,
                initialTime: eventStartTimeOfDay!,
              ).then((timePick) {
                if (timePick != null) {
                  eventFinishTimeOfDay = timePick;
                  setState(() {
                    isFinishTimeSelected = true;
                    eventFinishTime = localizations!.formatTimeOfDay(
                      eventFinishTimeOfDay!,
                    );
                  });
                }
              });
            },
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
          MyLiquidGlass.section(
            borderRadius: 20,
            glassColor: MyColors.blackOpacityContainer,
            child: SizedBox(
              height: heightSize(7), // More compact
              child: Center(
                child: TextFormField(
                  validator: (value) => value!.isEmpty ? 'boş olamaz' : null,
                  controller: controllerTitle,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    hintText: "Etkinlik başlığı...",
                    hintStyle: TextStyle(
                      fontSize: heightSize(2.2),
                      color: MyColors.globalTextColor,
                    ),
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Zona",
                    fontSize: heightSize(2.2),
                    color: MyColors.globalTextColor,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: heightSize(1)), // Reduced gap
          MyLiquidGlass.section(
            borderRadius: 20,
            glassColor: MyColors.blackOpacityContainer,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextFormField(
                controller: controllerDetail,
                minLines: 2,
                maxLines: 6, // Reduced max lines for better fit
                keyboardType: TextInputType.multiline,
                enableInteractiveSelection: true,
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  hintText: "Etkinlik detayı...",
                  hintStyle: TextStyle(
                    fontSize: heightSize(2.1),
                    color: MyColors.globalTextColor,
                  ),
                ),
                style: TextStyle(
                  fontFamily: "ZonaLight",
                  fontSize: heightSize(2.1),
                  color: MyColors.globalTextColor,
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
        _pageController!.nextPage(
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOutCubic,
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: MyLiquidGlass.section(
          borderRadius: 20,
          glassColor: MyColors.purpleContainer,
          child: SizedBox(
            width: widthSize(50),
            height: heightSize(7), // More compact
            child: Center(
              child: Text(
                "Devam Et",
                style: TextStyle(
                  fontFamily: "Zona",
                  fontSize: heightSize(
                    2.2,
                  ), // Slightly smaller font for compact feel
                  color: MyColors.globalTextColor,
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
        // ... (onTap logic remains same)
        int maxParticipantNumber;
        if (participantNumberController.text == "") {
          maxParticipantNumber = 2;
        } else {
          maxParticipantNumber = int.parse(participantNumberController.text);
        }

        if (controllerTitle.text != "" &&
            controllerDetail.text != "" &&
            controllerLocation.text != "" &&
            maxParticipantNumber != 0 &&
            _image != null &&
            subCategory != null &&
            mainCategory != null &&
            city != null &&
            eventStartDate != null &&
            eventStartTime != null &&
            eventFinishDate != null &&
            eventFinishTime != null) {
          setState(() {
            loadingOverLay = true;
          });
          String? allowedGenders() {
            if (userGender! & oppositeGender!) return "11";
            if (userGender! & !oppositeGender!) return "10";
            if (!userGender! & oppositeGender!) return "11";
            if (!userGender! & !oppositeGender!) return "01";
            return null;
          }

          final eventManager = Provider.of<EventService>(
            context,
            listen: false,
          );
          final userID = Provider.of<UserService>(
            context,
            listen: false,
          ).userModel!.getUserId();
          Map<String, dynamic> eventData = {
            "OrganizerID": userID,
            "Title": controllerTitle.text,
            "MaxParticipantNumber": maxParticipantNumber,
            "CurrentParticipantNumber": 0,
            "MainCategory": mainCategory,
            "SubCategory": subCategory,
            "City": city,
            "StartDate": eventStartDate,
            "FinishDate": eventFinishDate,
            "StartTime": eventStartTime,
            "FinishTime": eventFinishTime,
            "Detail": controllerDetail.text,
            "Location": controllerLocation.text,
            "AllowedGenders": allowedGenders(),
            "Status": "New",
          };
          if (await eventManager.createEvent(userID, eventData, _image!)) {
            NavigationManager(context).pushPage(
              ProfilePage(
                userID: userService!.userModel!.getUserId(),
                isFromEvent: false,
              ),
              refresh: false,
            );
            NavigationManager(context).pushPage(
              MyEventsPage(
                userID: userService!.userModel!.getUserId(),
                isOld: false,
              ),
            );

            Fluttertoast.showToast(msg: "Etkinlik Oluşturuldu");
          } else {
            setState(() {
              loadingOverLay = false;
            });
            Fluttertoast.showToast(msg: "Bağlantınızı kontrol ediniz!");
          }
        } else {
          Fluttertoast.showToast(msg: "Eksik Alanları Doldurunuz!");
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: MyLiquidGlass.section(
          borderRadius: 20,
          glassColor: MyColors.purpleContainer,
          child: SizedBox(
            height: heightSize(7),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    "assets/icons/addEvent.png",
                    height: heightSize(3),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "ETKİNLİK OLUŞTUR",
                    style: TextStyle(
                      fontFamily: "Zona",
                      fontSize: heightSize(1.9),
                      color: MyColors.globalTextColor,
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

  Widget numberOfParticipants() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: <Widget>[
          MyLiquidGlass.section(
            borderRadius: 20,
            glassColor: MyColors.blackOpacityContainer,
            child: Container(
              height: heightSize(7),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: <Widget>[
                  Text(
                    "Katılım Sınırı:",
                    style: TextStyle(
                      fontSize: heightSize(2.1),
                      fontFamily: "Zona",
                      color: MyColors.globalTextColor,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: widthSize(20),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.right,
                      maxLength: 3,
                      enableInteractiveSelection: false,
                      controller: participantNumberController,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: InputDecoration(
                        isDense: true,
                        counterText: "",
                        border: InputBorder.none,
                        hintText: "0",
                        hintStyle: TextStyle(
                          fontFamily: "Zona",
                          color: MyColors.globalTextColor,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: heightSize(2.1),
                        fontFamily: "Zona",
                        color: MyColors.globalTextColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: heightSize(1.5)),
        ],
      ),
    );
  }

  Widget selectGender() {
    //ANCHOR karşı cins seçili ise ona özgü renk döndürür, seçilmezse tek tip renk döndürür.
    Color getOppositeGenderColor() {
      if (oppositeGender!)
        if (userGender!) {
          return Colors.pinkAccent;
        } else {
          return MyColors.blueContainer;
        }
      else {
        return Colors.blueAccent;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        InkWell(
          onTap: () {
            setState(() {
              oppositeGender = !oppositeGender!;
            });
          },
          borderRadius: BorderRadius.circular(20),
          child: MyLiquidGlass.section(
            borderRadius: 20,
            glassColor: getOppositeGenderColor(),
            child: Container(
              width: widthSize(50),
              height: heightSize(6), // Compact
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    userGender! ? "Kadın" : "Erkek",
                    style: TextStyle(
                      fontFamily: "Zona",
                      fontSize: heightSize(1.9),
                      color: MyColors.globalTextColor,
                    ),
                  ),
                  Checkbox(
                    value: oppositeGender,
                    activeColor: Colors.white,
                    checkColor: getOppositeGenderColor(),
                    onChanged: (check) {
                      setState(() {
                        oppositeGender = check;
                      });
                    },
                  ),
                  Text(
                    oppositeGender!
                        ? (userGender! ? "Erkek" : "Kadın")
                        : "Sadece",
                    style: TextStyle(
                      fontFamily: "Zona",
                      fontSize: heightSize(1.9),
                      color: MyColors.globalTextColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: heightSize(1.5)),
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
            decoration: BoxDecoration(
              color: MyColors.blackOpacityContainer,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
            child: Center(
              child: DropdownButton<String>(
                iconEnabledColor: Colors.white,
                dropdownColor: MyColors.purpleContainerSplash,
                hint: Text(
                  "Kategori Seçiniz",
                  style: TextStyle(
                    fontFamily: "Zona",
                    fontSize: heightSize(2),
                    color: MyColors.globalTextColor,
                  ),
                ),
                value: mainCategory,
                items: categoryItems.map<DropdownMenuItem<String>>((
                  String value,
                ) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(
                        fontFamily: "Zona",
                        fontSize: heightSize(2),
                        color: MyColors.globalTextColor,
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
                },
              ),
            ),
          ),
        ),
        SizedBox(height: heightSize(3)),
      ],
    );
  }

  Widget selectSubCategory() {
    int selectedMainCategoryIndex = categoryItems.indexWhere(
      (element) => element == mainCategory,
    );
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            width: widthSize(100),
            height: heightSize(8),
            decoration: BoxDecoration(
              color: MyColors.blackOpacityContainer,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
            child: Center(
              child: DropdownButton<String>(
                iconEnabledColor: Colors.white,
                dropdownColor: MyColors.purpleContainerSplash,
                hint: Text(
                  "Alt Kategori Seçiniz",
                  style: TextStyle(
                    fontFamily: "Zona",
                    fontSize: heightSize(2),
                    color: MyColors.globalTextColor,
                  ),
                ),
                value: subCategory,
                items: subCategoryItems[selectedMainCategoryIndex]
                    .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(
                            fontFamily: "Zona",
                            fontSize: heightSize(2),
                            color: MyColors.globalTextColor,
                          ),
                        ),
                      );
                    })
                    .toList(),
                onChanged: (chosen) {
                  setState(() {
                    subCategory = chosen;
                  });
                },
              ),
            ),
          ),
        ),
        SizedBox(height: heightSize(3)),
      ],
    );
  }

  void getImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      final Uint8List imageBytes = await image.readAsBytes();
      setState(() {
        _image = imageBytes;
      });
    }
  }

  void getImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final Uint8List imageBytes = await image.readAsBytes();
      setState(() {
        _image = imageBytes;
      });
    }
  }

  Widget location() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: Container(
          color: MyColors.blackOpacityContainer,
          width: widthSize(100),
          height: heightSize(8),
          child: Center(
            child: TextFormField(
              validator: (value) => value!.isEmpty ? 'boş olamaz' : null,
              controller: controllerLocation,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Etkinlik yeri/mekanı...",
                hintStyle: TextStyle(color: MyColors.globalTextColor),
              ),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "Zona",
                fontSize: heightSize(2.5),
                color: MyColors.globalTextColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget cityAndCountry() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: MyLiquidGlass.section(
        borderRadius: 20,
        glassColor: MyColors.blackOpacityContainer,
        child: SizedBox(
          height: heightSize(7),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DropdownSearch<String>(
              items: (String filter, dynamic loadProps) => citiesTR,
              dropdownBuilder: (context, selectedItem) {
                return Text(
                  selectedItem ?? "Şehir seçiniz",
                  style: TextStyle(
                    fontFamily: "Zona",
                    fontSize: heightSize(2.2),
                    color: MyColors.globalTextColor,
                  ),
                );
              },
              decoratorProps: DropDownDecoratorProps(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                baseStyle: TextStyle(
                  fontFamily: "Zona",
                  fontSize: heightSize(2.2),
                  color: MyColors.globalTextColor,
                ),
              ),
              popupProps: PopupProps.menu(
                showSearchBox: true,
                menuProps: MenuProps(
                  backgroundColor: MyColors.blackOpacityContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                searchFieldProps: TextFieldProps(
                  style: TextStyle(fontFamily: "Zona", color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Şehir ara...",
                    hintStyle: TextStyle(
                      fontFamily: "ZonaLite",
                      color: Colors.white70,
                    ),
                    prefixIcon: Icon(Icons.search, color: Colors.white70),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.white24),
                    ),
                  ),
                ),
                itemBuilder: (context, item, isSelected, isHighlighted) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Text(
                      item,
                      style: TextStyle(
                        fontFamily: "Zona",
                        fontSize: heightSize(2),
                        color: isSelected
                            ? MyColors.blueThemeColor
                            : Colors.white,
                      ),
                    ),
                  );
                },
              ),
              onSelected: (value) {
                if (value != null) {
                  setState(() {
                    city = value;
                  });
                }
              },
              selectedItem: city,
            ),
          ),
        ),
      ),
    );
  }

  Widget cityAndCountryLittle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: MyLiquidGlass.section(
        borderRadius: 20,
        glassColor: MyColors.blackOpacityContainer,
        child: SizedBox(
          height: heightSize(6),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DropdownSearch<String>(
              items: (String filter, dynamic loadProps) => citiesTR,
              dropdownBuilder: (context, selectedItem) {
                return Text(
                  selectedItem ?? "Şehir seçiniz",
                  style: TextStyle(
                    fontFamily: "Zona",
                    fontSize: heightSize(1.9),
                    color: MyColors.globalTextColor,
                  ),
                );
              },
              decoratorProps: DropDownDecoratorProps(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                baseStyle: TextStyle(
                  fontFamily: "Zona",
                  fontSize: heightSize(1.9),
                  color: MyColors.globalTextColor,
                ),
              ),
              popupProps: PopupProps.menu(
                showSearchBox: true,
                menuProps: MenuProps(
                  backgroundColor: MyColors.blackOpacityContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                searchFieldProps: TextFieldProps(
                  style: TextStyle(fontFamily: "Zona", color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Şehir ara...",
                    hintStyle: TextStyle(
                      fontFamily: "ZonaLite",
                      color: Colors.white70,
                    ),
                    prefixIcon: Icon(Icons.search, color: Colors.white70),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.white24),
                    ),
                  ),
                ),
                itemBuilder: (context, item, isSelected, isHighlighted) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Text(
                      item,
                      style: TextStyle(
                        fontFamily: "Zona",
                        fontSize: heightSize(1.8),
                        color: isSelected
                            ? MyColors.blueThemeColor
                            : Colors.white,
                      ),
                    ),
                  );
                },
              ),
              onSelected: (value) {
                if (value != null) {
                  setState(() {
                    city = value;
                  });
                }
              },
              selectedItem: city,
            ),
          ),
        ),
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
              SizedBox(height: heightSize(3)),
              dateButtons(),
              SizedBox(height: heightSize(3)),
              timeButtons(),
              SizedBox(height: heightSize(3)),
              eventTitleAndDetails(),
              SizedBox(height: heightSize(3)),
              constraints.maxWidth < 400
                  ? cityAndCountryLittle()
                  : cityAndCountry(),
              SizedBox(height: heightSize(3)),
              location(),
              SizedBox(height: heightSize(3)),
              nextPageButton(),
              constraints.maxWidth < 400
                  ? SizedBox(height: heightSize(10))
                  : SizedBox(height: heightSize(5)),
            ],
          ),
        ),
      ),
      //ANCHOR 2. sayfa
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:
            <Widget>[
              numberOfParticipants(),
              selectGender(),
              selectMainCategory(),
            ] +
            (isMainCategorySelected!
                ? <Widget>[selectSubCategory()]
                : <Widget>[]) +
            <Widget>[createEventButton()],
      ),
    ];
  }
}

//NOTE old country select are here;
/*
          Container(
            width: widthSize(43),
            height: heightSize(8),
            decoration: new BoxDecoration(
              color: MyColors.blackOpacityContainer,
              borderRadius: new BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Container(
              width: widthSize(43),
              height: heightSize(8),
              decoration: new BoxDecoration(
                color: MyColors.yellowContainer,
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
                      color: MyColors.whiteTextColor,
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
