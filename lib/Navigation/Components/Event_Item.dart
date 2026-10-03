import 'package:eventizer/components/liquidglass_widgets.dart';
import 'package:eventizer/navigation/event_page.dart';
import 'package:eventizer/navigation/profile_page.dart';
import 'package:eventizer/services/repository.dart';
import 'package:eventizer/tools/dialogs.dart';
import 'package:eventizer/tools/navigation_manager.dart';
import 'package:eventizer/tools/page_components.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:provider/provider.dart';

/// Etkinlik kartı — net cam (katalog tarzı).
///
/// - Görsel ağırlıklı: 16:9 görsel + cam bilgi bloğu
/// - GestureDetector: cam yüzey üstünde InkWell/Material refraction'ı öldürür,
///   bu yüzden tüm tıklanabilir alanlar GestureDetector'dur.
/// - Koyu temada beyaz metinler, cyan vurgu ikonları.
Widget eventItem(
  BuildContext context,
  Map<String, dynamic> eventDatas,
  bool fromExplorePage, {
  State? parentState,
}) {
  UserService userService = Provider.of<UserService>(context);
  EventService eventService = Provider.of<EventService>(context);
  var responsive = PageComponents(context);
  String eventID = eventDatas['eventID'];
  String title = eventDatas['Title'] ?? "null";
  String status = eventDatas['Status'] ?? "null";
  String ownerID = eventDatas['OrganizerID'];
  String imageUrl = eventDatas['EventImageUrl'];
  String startDate = eventDatas['StartDate'] ?? "null";
  String finishDate = eventDatas['FinishDate'] ?? "null";
  String location = eventDatas['Location'] ?? "null";
  String city = eventDatas['City'] ?? "null";
  String currentParticipantNumber = eventDatas['CurrentParticipantNumber']
      .toString();
  String maxParticipantNumber = eventDatas['MaxParticipantNumber'].toString();
  Map<String, dynamic>? ownerData;

  const Color cyan = Color(0xFF1BC8D9);

  return GestureDetector(
    onTap: () async {
      eventService
          .amIparticipant(userService.userModel!.getUserId(), eventID)
          .then((amIparticipant) {
            NavigationManager(context).pushPage(
              EventPage(
                eventData: eventDatas,
                userData: ownerData,
                amIparticipant: amIparticipant,
              ),
            );
          });
    },
    child: GlassContainer(
      shape: const LiquidRoundedSuperellipse(borderRadius: 26),
      padding: EdgeInsets.zero,
      settings: MyLiquidGlass.overlay,
      useOwnLayer: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // -------------------------------------------------------------------
          // Üst satır: organizatör (avatar + etkinlik başlığı) + aksiyon
          // -------------------------------------------------------------------
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: responsive.widthSize(4),
              vertical: responsive.heightSize(1.8),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      //ANCHOR kullanıcı profiline buradan gidiyor
                      NavigationManager(context).pushPage(
                        ProfilePage(
                          key: UniqueKey(),
                          userID: ownerID,
                          isFromEvent: true,
                        ),
                      );
                    },
                    child: Row(
                      children: <Widget>[
                        Container(
                          height: responsive.heightSize(5),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: FutureBuilder(
                            future: userService.findUserByID(ownerID),
                            builder:
                                (
                                  BuildContext _,
                                  AsyncSnapshot<dynamic> userData,
                                ) {
                                  if (userData.connectionState ==
                                      ConnectionState.done) {
                                    ownerData = userData.data;
                                    //ANCHOR user profil resmi burada
                                    return Container(
                                      height: responsive.heightSize(5),
                                      width: responsive.widthSize(10),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: cyan.withValues(alpha: 0.55),
                                          width: 1.2,
                                        ),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                            userData.data['ProfilePhotoUrl'],
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Image.asset(
                                      "assets/images/avatar_man.png",
                                    );
                                  }
                                },
                          ),
                        ),
                        SizedBox(width: responsive.widthSize(2.5)),
                        Expanded(
                          child: Text(
                            title,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: "Zona",
                              fontSize: responsive.heightSize(2.2),
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: responsive.widthSize(2)),
                if (fromExplorePage)
                  _ShareButton(iconColor: cyan)
                else
                  Visibility(
                    visible:
                        ownerID == userService.userModel!.getUserId() &&
                        status != "Finished",
                    child: _EventMenu(
                      parentState: parentState,
                      eventID: eventID,
                      cyan: cyan,
                      askingDelete: () => askingDialog(
                        context,
                        "Silmek istediğinize eminmisiniz?",
                        Colors.red,
                      ).then((value) {
                        if (value) {
                          eventService
                              .deleteEvent(eventID)
                              .then((value) => print("Silindi:$value"));
                        }
                      }),
                      askingFinish: () => askingDialog(
                        context,
                        "Bitirmek istediğinize eminmisiniz?",
                        Colors.deepOrange,
                      ).then((value) async {
                        if (value) {
                          await eventService.finishEvent(eventID);
                          await userService.increaseNofEvents();
                        }
                      }).whenComplete(
                        () => parentState?.setState(() {}),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // -------------------------------------------------------------------
          // Görsel — cam kartın içinde yumuşak köşeli
          // -------------------------------------------------------------------
          Padding(
            padding: EdgeInsets.symmetric(horizontal: responsive.widthSize(4)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: FadeInImage.assetNetwork(
                  fit: BoxFit.cover,
                  placeholder: "assets/images/event_birthday.jpg",
                  image: imageUrl,
                ),
              ),
            ),
          ),
          // -------------------------------------------------------------------
          // Bilgi bloğu — beyaz metinler, cyan vurgular
          // -------------------------------------------------------------------
          Padding(
            padding: EdgeInsets.fromLTRB(
              responsive.widthSize(4),
              responsive.heightSize(1.6),
              responsive.widthSize(4),
              responsive.heightSize(2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: "Zona",
                    fontSize: responsive.heightSize(2.6),
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: responsive.heightSize(1.2)),
                Row(
                  children: <Widget>[
                    FaIcon(FontAwesomeIcons.calendarCheck,
                        size: 15, color: cyan),
                    SizedBox(width: responsive.widthSize(2)),
                    Expanded(
                      child: Text(
                        "$startDate  •  $finishDate",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: "Zona",
                          fontSize: responsive.heightSize(1.9),
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: responsive.heightSize(1)),
                Row(
                  children: <Widget>[
                    Icon(Icons.location_on, size: 17, color: cyan),
                    SizedBox(width: responsive.widthSize(2)),
                    Expanded(
                      child: Text(
                        "$city${location != "null" && location.isNotEmpty ? ", $location" : ""}",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: "Zona",
                          fontSize: responsive.heightSize(1.9),
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: responsive.heightSize(1)),
                Row(
                  children: <Widget>[
                    Icon(Icons.people_alt, size: 17, color: cyan),
                    SizedBox(width: responsive.widthSize(2)),
                    Text(
                      "$currentParticipantNumber/$maxParticipantNumber katılımcı",
                      style: TextStyle(
                        fontFamily: "Zona",
                        fontSize: responsive.heightSize(1.9),
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

/// Paylaş butonu — cam üzerinde GestureDetector (refraction güvenli).
class _ShareButton extends StatelessWidget {
  const _ShareButton({required this.iconColor});

  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(Icons.share, color: iconColor, size: 22),
      ),
    );
  }
}

/// Sekme menüsü (Paylaş / Düzenle / Bitir / Sil) — davranışlar korunur.
class _EventMenu extends StatelessWidget {
  const _EventMenu({
    required this.parentState,
    required this.eventID,
    required this.cyan,
    required this.askingDelete,
    required this.askingFinish,
  });

  final State? parentState;
  final String eventID;
  final Color cyan;
  final Future<void> Function() askingDelete;
  final Future<void> Function() askingFinish;

  @override
  Widget build(BuildContext context) {
    var responsive = PageComponents(context);
    return DropdownButton<String>(
      items: [
        DropdownMenuItem<String>(
          value: "share",
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Icon(Icons.share, color: cyan, size: 26),
              ),
              Text(
                "Paylaş",
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: responsive.heightSize(2),
                ),
              ),
            ],
          ),
        ),
        DropdownMenuItem<String>(
          value: "edit",
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Icon(Icons.edit, color: cyan, size: 26),
              ),
              Text(
                "Düzenle",
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: responsive.heightSize(2),
                ),
              ),
            ],
          ),
        ),
        DropdownMenuItem<String>(
          value: "finish",
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Icon(Icons.stop, color: Colors.redAccent, size: 26),
              ),
              Text(
                "Bitir",
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: responsive.heightSize(2),
                ),
              ),
            ],
          ),
        ),
        DropdownMenuItem<String>(
          value: "delete",
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Icon(Icons.delete, color: Colors.redAccent, size: 26),
              ),
              Text(
                "Sil",
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: responsive.heightSize(2),
                ),
              ),
            ],
          ),
        ),
      ],
      onChanged: (String? selected) {
        //TODO Paylaş bitir ve düzenle seçenekleri için kod yazılacak
        if (selected == "delete") {
          askingDelete();
        }
        if (selected == "finish") {
          askingFinish();
        }
      },
      hint: Row(
        children: <Widget>[
          Icon(Icons.more_vert, color: Colors.white.withValues(alpha: 0.9)),
        ],
      ),
      dropdownColor: const Color(0xFF16243A),
      iconEnabledColor: Colors.white.withValues(alpha: 0.9),
    );
  }
}