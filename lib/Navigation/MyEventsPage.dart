import 'package:eventizer/Navigation/Components/CustomScroll.dart';
import 'package:eventizer/Navigation/Components/Event_Item.dart';
import 'package:eventizer/Services/Repository.dart';
import 'package:eventizer/Tools/PageComponents.dart';
import 'package:eventizer/assets/Colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyEventsPage extends StatefulWidget {
  final String? userID;
  final bool isOld;

  const MyEventsPage({super.key, this.userID, required this.isOld});

  @override
  _MyEventsPageState createState() => _MyEventsPageState();
}

class _MyEventsPageState extends State<MyEventsPage> {
  bool? isMine, isOld;
  PageController? _pageController;
  @override
  void initState() {
    super.initState();
    widget.userID == null ? isMine = false : isMine = true;
    widget.isOld ? isOld = true : isOld = false;
    _pageController = PageController(
      initialPage: isOld! ? 1 : 0,
    );
  }

  double heightSize(double value) {
    value /= 100;
    return MediaQuery.of(context).size.height * value;
  }

  double widthSize(double value) {
    value /= 100;
    return MediaQuery.of(context).size.width * value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          children: <Widget>[
            eventList(false),
            eventList(true),
          ],
        ),
      ),
    );
  }

  Widget eventList(bool isOld) {
    var eventManager = Provider.of<EventService>(context);

    String userID = widget.userID == null
        ? Provider.of<UserService>(context, listen: false)
            .userModel!
            .getUserId()
        : widget.userID!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: heightSize(5),
          ),
          titleText(isOld),
          SizedBox(
            height: heightSize(2),
          ),
          //ANCHOR event list start are here---------------------------------------------
          SizedBox(
              height: heightSize(75),
              child: FutureBuilder(
                  future: eventManager.fetchEventListsForUser(userID, isOld),
                  builder: (BuildContext context, AsyncSnapshot fetchedlist) {
                    if (fetchedlist.connectionState == ConnectionState.done) {
                      List<Map<String, dynamic>> listofMaps = fetchedlist.data;
                      if (listofMaps.isEmpty) {
                        return const Center(child: Card(child: Text("Etkinlik Yok")));
                      } else {
                        return ScrollConfiguration(
                          behavior: NoScrollEffectBehavior(),
                          child: ListView.separated(
                              separatorBuilder:
                                  //ANCHOR ayıraç burada
                                  (BuildContext context, int index) => SizedBox(
                                        height: heightSize(3),
                                      ),
                              itemCount: listofMaps.length,
                              itemBuilder: (context, index) {
                                return eventItem(
                                    context, listofMaps[index], false,
                                    parentState: this);
                              }),
                        );
                      }
                    } else {
                      return PageComponents(context)
                          .loadingOverlay(spinColor: Colors.white);
                    }
                  })),
        ],
      ),
    );
  }

  Widget titleText(bool isOld) {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: isOld ? "Geçmiş" : "Gelecek",
            style: TextStyle(fontFamily: "Zona", fontSize: heightSize(3)),
          ),
          TextSpan(
            text: " Etkinlikler",
            style: TextStyle(fontFamily: "ZonaLight", fontSize: heightSize(3)),
          ),
        ],
      ),
    );
  }

  Widget categoryList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: heightSize(5),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: <Widget>[
                Container(
                  width: widthSize(20),
                  height: heightSize(8),
                  decoration: BoxDecoration(
                    color: MyColors().lightBlueContainer,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Hepsi",
                      style: TextStyle(
                        fontFamily: "Zona",
                        color: MyColors().whiteTextColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: widthSize(2),
                ),
                Container(
                  width: widthSize(40),
                  height: heightSize(8),
                  decoration: BoxDecoration(
                    color: MyColors().purpleContainer,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          SizedBox(
                            height: heightSize(4),
                            child: Image.asset(
                                "assets/icons/birthdayCategory.png"),
                          ),
                          Text(
                            "Doğum Günü",
                            style: TextStyle(
                              fontFamily: "Zona",
                              color: MyColors().whiteTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: widthSize(2),
                ),
                Container(
                  width: widthSize(40),
                  height: heightSize(8),
                  decoration: BoxDecoration(
                    color: MyColors().purpleContainer,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          SizedBox(
                            height: heightSize(4),
                            child:
                                Image.asset("assets/icons/travelCategory.png"),
                          ),
                          Text(
                            "Gezi Turu",
                            style: TextStyle(
                              fontFamily: "Zona",
                              color: MyColors().whiteTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: widthSize(2),
                ),
                Container(
                  width: widthSize(40),
                  height: heightSize(8),
                  decoration: BoxDecoration(
                    color: MyColors().purpleContainer,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          SizedBox(
                            height: heightSize(4),
                            child: Image.asset(
                                "assets/icons/worldtravelCategory.png"),
                          ),
                          Text(
                            "Dünya Turu",
                            style: TextStyle(
                              fontFamily: "Zona",
                              color: MyColors().whiteTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: widthSize(2),
                ),
                Container(
                  width: widthSize(50),
                  height: heightSize(8),
                  decoration: BoxDecoration(
                    color: MyColors().purpleContainer,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        SizedBox(
                          height: heightSize(4),
                          child: Image.asset("assets/icons/cameraCategory.png"),
                        ),
                        Text(
                          "Doğa Fotoğrafçılığı",
                          style: TextStyle(
                            fontFamily: "Zona",
                            color: MyColors().whiteTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: widthSize(2),
                ),
                Container(
                  width: widthSize(40),
                  height: heightSize(8),
                  decoration: BoxDecoration(
                    color: MyColors().purpleContainer,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          SizedBox(
                            height: heightSize(4),
                            child: Image.asset(
                                "assets/icons/conferenceCategory.png"),
                          ),
                          Text(
                            "Konferans",
                            style: TextStyle(
                              fontFamily: "Zona",
                              color: MyColors().whiteTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: widthSize(2),
                ),
                Container(
                  width: widthSize(30),
                  height: heightSize(8),
                  decoration: BoxDecoration(
                    color: MyColors().purpleContainer,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          SizedBox(
                            height: heightSize(4),
                            child: Image.asset("assets/icons/campCategory.png"),
                          ),
                          Text(
                            "Kamp",
                            style: TextStyle(
                              fontFamily: "Zona",
                              color: MyColors().whiteTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: widthSize(2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
