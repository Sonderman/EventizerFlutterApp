import 'package:eventizer/Navigation/Components/CustomScroll.dart';
import 'package:eventizer/Navigation/Components/Event_Item.dart';
import 'package:eventizer/Services/Repository.dart';
import 'package:eventizer/Settings/EventSettings.dart';
import 'package:eventizer/Tools/PageComponents.dart';
import 'package:eventizer/assets/Colors.dart';
import 'package:eventizer/locator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExploreEventPage extends StatefulWidget {
  const ExploreEventPage({super.key});

  @override
  _ExploreEventPageState createState() => _ExploreEventPageState();
}

class _ExploreEventPageState extends State<ExploreEventPage> {
  double heightSize(double value) {
    value /= 100;
    return MediaQuery.of(context).size.height * value;
  }

  double widthSize(double value) {
    value /= 100;
    return MediaQuery.of(context).size.width * value;
  }

  String? category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // textField(),
            subCategoryList(),
            Expanded(child: eventList()),
          ],
        ),
      ),
    );
  }

  Widget eventList() {
    var eventManager = Provider.of<EventService>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: heightSize(5),
          ),
          displayedCategoryTitle(),
          SizedBox(
            height: heightSize(2),
          ),
          //ANCHOR event list start are here---------------------------------------------
          Expanded(
            child: Container(
                child: FutureBuilder(
                    future: (category == null || category == "Hepsi")
                        ? eventManager.fetchActiveEventLists()
                        : eventManager
                            .fetchActiveEventListsByCategory(category!),
                    builder: (BuildContext context, AsyncSnapshot fetchedlist) {
                      if (fetchedlist.connectionState == ConnectionState.done) {
                        List<Map<String, dynamic>> listofMaps =
                            fetchedlist.data;
                        if (listofMaps.isEmpty) {
                          return Center(
                              child: Text(
                            "Etkinlik Yok",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: widthSize(5)),
                          ));
                        } else {
                          return ScrollConfiguration(
                            behavior: NoScrollEffectBehavior(),
                            child: ListView.separated(
                                separatorBuilder:
                                    //ANCHOR ayıraç burada
                                    (BuildContext context, int index) =>
                                        SizedBox(
                                          height: heightSize(3),
                                        ),
                                itemCount: listofMaps.length,
                                itemBuilder: (context, index) {
                                  return eventItem(
                                      context, listofMaps[index], true);
                                }),
                          );
                        }
                      } else {
                        return Center(
                            child: PageComponents(context)
                                .loadingCustomOverlay(spinColor: Colors.white));
                      }
                    })),
          ),
          SizedBox(
            height: heightSize(4),
          ),
        ],
      ),
    );
  }

  Widget displayedCategoryTitle() {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: category ?? "En Yeni",
            style: TextStyle(fontFamily: "Zona", fontSize: heightSize(3)),
          ),
          TextSpan(
            text: category != null ? " Etkinlikleri" : " Etkinlikler",
            style: TextStyle(fontFamily: "ZonaLight", fontSize: heightSize(3)),
          ),
        ],
      ),
    );
  }

  Widget subCategoryList() {
    print(locator<EventSettings>().subCategoryItems);
    print(category);
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
                InkWell(
                  onTap: () {
                    setState(() {
                      category = null;
                    });
                  },
                  child: Container(
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
                          fontSize: heightSize(2),
                          color: MyColors().whiteTextColor,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: widthSize(2),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      category = "Doğum Günü";
                    });
                  },
                  child: Container(
                    width: widthSize(42),
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
                SizedBox(
                  width: widthSize(2),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      category = "Yurtiçi Gezisi";
                    });
                  },
                  child: Container(
                    width: widthSize(42),
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
                                  "assets/icons/travelCategory.png"),
                            ),
                            Text(
                              "Yurtiçi Gezi",
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
                SizedBox(
                  width: widthSize(2),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      category = "Yurtdışı Gezisi";
                    });
                  },
                  child: Container(
                    width: widthSize(45),
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
                              "Yurtdışı Gezisi",
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
                SizedBox(
                  width: widthSize(2),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      category = "Doğa Fotoğraflama";
                    });
                  },
                  child: Container(
                    width: widthSize(58),
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
                                  "assets/icons/cameraCategory.png"),
                            ),
                            Text(
                              "Doğa Fotoğraflama",
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
                SizedBox(
                  width: widthSize(2),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      category = "Konferans&Seminer";
                    });
                  },
                  child: Container(
                    width: widthSize(45),
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
                SizedBox(
                  width: widthSize(2),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      category = "Kamp";
                    });
                  },
                  child: Container(
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
                              child:
                                  Image.asset("assets/icons/campCategory.png"),
                            ),
                            Text(
                              "Kamp",
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

  Widget searchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        height: heightSize(8),
        width: widthSize(90),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: MyColors().purpleContainer,
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: TextFormField(
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(
                Icons.search,
                color: MyColors().whiteTextColor,
                size: heightSize(4),
              ),
              hintText: "Arama",
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
    );
  }
}
