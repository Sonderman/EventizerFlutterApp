import 'package:eventizer/data/themes.dart';
import 'package:eventizer/components/liquidglass_widgets.dart';
import 'package:eventizer/locator.dart';
import 'package:eventizer/models/user_model.dart';
import 'package:eventizer/navigation/login_page/login_page_view.dart';
import 'package:eventizer/navigation/my_events_page.dart';
import 'package:eventizer/navigation/settings_page.dart';
import 'package:eventizer/services/auth_service.dart';
import 'package:eventizer/services/repository.dart';
import 'package:eventizer/tools/image_viewer.dart';
import 'package:eventizer/tools/message.dart';
import 'package:eventizer/tools/navigation_manager.dart';
import 'package:eventizer/tools/page_components.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  final String userID;
  final bool isFromEvent;

  const ProfilePage({
    super.key,
    required this.userID,
    required this.isFromEvent,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  double heightSize(double value) {
    value /= 100;
    return MediaQuery.of(context).size.height * value;
  }

  double widthSize(double value) {
    value /= 100;
    return MediaQuery.of(context).size.width * value;
  }

  UserService? userService;
  UserModel? userModel;
  bool? amIFollowing = false, isThisProfileMine;
  String? nameText,
      surnameText,
      nickNameText,
      aboutText,
      followersText,
      followingsText,
      eventsText,
      trustText,
      profilePhotoUrl;
  TabController? _tabController;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    userService = Provider.of<UserService>(context);
    if (widget.userID != userService!.userModel!.userID) {
      isThisProfileMine = false;
      userModel = UserModel(userID: widget.userID);
      if (await userService!.amIFollowing(userModel!.userID)) {
        amIFollowing = true;
      } else {
        amIFollowing = false;
      }
    } else {
      isThisProfileMine = true;
      _tabController = TabController(length: 1, vsync: this);
      userModel = userService!.userModel;
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (_tabController != null) _tabController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isThisProfileMine!) {
      return FutureBuilder(
        future: userService!.findUserByID(widget.userID),
        builder:
            (BuildContext context, AsyncSnapshot<Map<String, dynamic>?> data) {
              if (data.connectionState == ConnectionState.done) {
                userModel!.parseMap(data.data!);
                textUpdaterByUserModel(userModel!);
                return Scaffold(
                  body: Padding(
                    padding: const EdgeInsets.all(16),
                    child: MyLiquidGlass.standartContainer(
                      child: _generatedProfileSections(
                        includeFollowActions: true,
                      ),
                    ),
                  ),
                );
              } else {
                return Center(
                  child: PageComponents(
                    context,
                  ).loadingOverlay(backgroundColor: Colors.white),
                );
              }
            },
      );
    } else {
      textUpdaterByUserModel(userService!.userModel!);
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: MyLiquidGlass.standartContainer(
            child: Column(
              children: <Widget>[
                //TODO bildirim sayfası yaparken açılacak
                /*
                Container(
                  child: TabBar(
                      indicatorColor: Colors.teal,
                      labelColor: Colors.teal,
                      unselectedLabelColor: Colors.black54,
                      controller: _tabController,
                      isScrollable: true,
                      tabs: [
                        Tab(
                          text: "Profilim",
                        ),
                        Tab(
                          text: "Bildirimler",
                        ),
                      ]),
                ),
                */
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: <Widget>[
                      _generatedProfileSections(includeFollowActions: false),
                      //Bildirim sayfası
                      /*
                      Center(
                        child: PageComponents().underConstruction(context),
                      )*/
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  Widget _generatedProfileSections({required bool includeFollowActions}) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final List<Widget> children = <Widget>[
          avatarAndName(),
          numberDatas(),
          if (includeFollowActions) followAndMessage(),
          threeBoxes(),
        ];

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: children,
            ),
          ),
        );
      },
    );
  }

  void textUpdaterByUserModel(UserModel model) {
    nameText = model.getUserName() ?? "Loading";
    surnameText = model.getUserSurname() ?? "Loading";
    nickNameText = model.getUserNickName() ?? "Loading";
    aboutText = model.getUserAbout() ?? "Loading";
    followersText = model.getUserFollowNumber().toString();
    followingsText = model.getUserFollowingNumber().toString();
    eventsText = model.getUserEventsNumber().toString();
    trustText = model.getUserTrustPointNumber().toString();
    profilePhotoUrl = model.getUserProfilePhotoUrl();
  }

  //ANCHOR "isThisProfileMine" screen should be redesign.
  Widget avatarAndName() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: MyLiquidGlass.section(
      borderRadius: 22,
      glassColor: Colors.white.withValues(alpha: 0.16),
      child: Padding(
        // Generated visual update: glass header card that fills vertical rhythm better.
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => ImageViewer(
                      tag: profilePhotoUrl!,
                      url: profilePhotoUrl!,
                    ),
                  ),
                );
              },
              child: Hero(
                tag: profilePhotoUrl!,
                child: Container(
                  width: widthSize(24.5),
                  height: widthSize(24.5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.22),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: FadeInImage.assetNetwork(
                      fit: BoxFit.cover,
                      placeholder: "assets/images/avatar_man.png",
                      image: profilePhotoUrl!,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: widthSize(3.4)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: double.infinity,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${nameText!.toUpperCase()} ${surnameText!.toUpperCase()}',
                        // Generated text-fit update: shrink text to keep full name visible.
                        style: TextStyle(
                          fontFamily: "Zona",
                          fontSize: heightSize(2.6),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: heightSize(0.24)),
                  SizedBox(
                    width: double.infinity,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "@${nickNameText!}",
                        style: TextStyle(
                          fontFamily: "ZonaLight",
                          fontSize: heightSize(2.1),
                          color: Colors.white.withValues(alpha: 0.84),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (isThisProfileMine!)
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _generatedTopActionButton(
                    iconPath: "assets/icons/options.png",
                    onTap: () => NavigationManager(
                      context,
                    ).pushPage(const SettingsPage()),
                  ),
                  SizedBox(height: heightSize(0.7)),
                  _generatedTopActionButton(
                    iconPath: "assets/icons/logout.png",
                    onTap: () {
                      var auth = locator<AuthService>();
                      auth.signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => const LoginPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
    ),
  );

  Widget _generatedTopActionButton({
    required String iconPath,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      child: SizedBox(
        width: widthSize(11.8),
        height: widthSize(11.8),
        child: MyLiquidGlass.section(
          borderRadius: 16,
          glassColor: Colors.white.withValues(alpha: 0.18),
          child: Padding(
            // Generated visual update: slightly larger controls improve balance with larger header.
            padding: const EdgeInsets.all(8),
            child: Image.asset(iconPath),
          ),
        ),
      ),
    );
  }

  Widget threeBoxes() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      children: <Widget>[
        SizedBox(
          width: double.infinity,
          child: MyLiquidGlass.section(
            borderRadius: 18,
            glassColor: Colors.white.withValues(alpha: 0.14),
            child: Padding(
              // Generated compact style: tighter paddings for profile detail section.
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Text(
                aboutText!,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: "Zona",
                  fontSize: heightSize(1.95),
                  color: MyColors.globalTextColor,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: heightSize(1.4)),
        Row(
          children: <Widget>[
            Expanded(
              child: _generatedEventHistoryCard(
                iconPath: "assets/icons/future.png",
                label: "Gelecek\nEtkinlikler",
                onTap: () => NavigationManager(context).pushPage(
                  MyEventsPage(
                    isOld: false,
                    userID: widget.isFromEvent ? widget.userID : null,
                  ),
                ),
              ),
            ),
            SizedBox(width: widthSize(2)),
            Expanded(
              child: _generatedEventHistoryCard(
                iconPath: "assets/icons/past.png",
                label: "Geçmiş\nEtkinlikler",
                onTap: () {
                  NavigationManager(context).pushPage(
                    MyEventsPage(
                      isOld: true,
                      userID: widget.isFromEvent ? widget.userID : null,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _generatedEventHistoryCard({
    required String iconPath,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: const BorderRadius.all(Radius.circular(18)),
      child: SizedBox(
        height: heightSize(8.2),
        child: MyLiquidGlass.section(
          borderRadius: 18,
          glassColor: Colors.white.withValues(alpha: 0.16),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(18)),
              gradient: LinearGradient(
                // Generated visual layer: subtle inner gradient to enhance liquid-glass depth.
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  Colors.white.withValues(alpha: 0.09),
                  Colors.white.withValues(alpha: 0.02),
                ],
              ),
            ),
            child: Padding(
              // Generated layout fix: keep icon + label compact and centered on small devices.
              padding: EdgeInsets.symmetric(horizontal: widthSize(2.2)),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    height: heightSize(3.8),
                    child: Image.asset(iconPath),
                  ),
                  SizedBox(width: widthSize(1.5)),
                  Expanded(
                    child: Text(
                      label,
                      maxLines: 2,
                      style: TextStyle(
                        fontFamily: "Zona",
                        fontSize: heightSize(1.8),
                        color: MyColors.globalTextColor,
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

  Widget numberDatas() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: MyLiquidGlass.section(
      borderRadius: 16,
      glassColor: Colors.white.withValues(alpha: 0.18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          gradient: LinearGradient(
            // Generated visual layer: slight reflective gradient to modernize stat card.
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Colors.white.withValues(alpha: 0.08),
              Colors.white.withValues(alpha: 0.03),
            ],
          ),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: _generatedStatItem(label: "ETKİNLİK", value: eventsText!),
            ),
            _generatedStatDivider(),
            Expanded(
              child: _generatedStatItem(
                label: "TAKİPÇİ",
                value: followersText!,
              ),
            ),
            _generatedStatDivider(),
            Expanded(
              child: _generatedStatItem(label: "TAKİP", value: followingsText!),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _generatedStatDivider() {
    return Container(
      height: heightSize(4),
      width: 1,
      color: Colors.white.withValues(alpha: 0.15),
    );
  }

  Widget _generatedStatItem({required String label, required String value}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: MyColors.blueTextColor,
            fontFamily: "Zona",
            fontSize: heightSize(1.65),
          ),
        ),
        SizedBox(height: heightSize(0.38)),
        Text(
          value,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: MyColors.blueTextColor,
            fontFamily: "ZonaLight",
            fontSize: heightSize(2.5),
          ),
        ),
      ],
    );
  }

  Widget followAndMessage() => Column(
    children: <Widget>[
      SizedBox(height: heightSize(1.3)),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: <Widget>[
            Expanded(
              child: _generatedCompactActionButton(
                icon: amIFollowing!
                    ? "assets/icons/unfollow.png"
                    : "assets/icons/follow.png",
                text: amIFollowing! ? "Takibi Bırak" : "Takip Et",
                backgroundColor: MyColors.lightGreen,
                onTap: () async {
                  await userService!
                      .followToggle(userModel!.getUserId())
                      .whenComplete(() {
                        setState(() {
                          amIFollowing = !amIFollowing!;
                        });
                      });
                  await userService!.userModelSync();
                },
              ),
            ),
            SizedBox(width: widthSize(2)),
            Expanded(
              child: _generatedCompactActionButton(
                icon: "assets/icons/sendMessage.png",
                text: "Mesaj Gönder",
                backgroundColor: MyColors.darkblueText,
                onTap: () async {
                  if (userService!.userModel!.getUserId() != widget.userID) {
                    await userService!.findUserByID(widget.userID).then((data) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => Message(
                            otherUserID: widget.userID,
                            otherUserName: data!['Name'],
                          ),
                        ),
                      );
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    ],
  );

  Widget _generatedCompactActionButton({
    required String icon,
    required String text,
    required Color backgroundColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: const BorderRadius.all(Radius.circular(18)),
      child: SizedBox(
        height: heightSize(6.9),
        child: MyLiquidGlass.section(
          borderRadius: 18,
          glassColor: backgroundColor.withValues(alpha: 0.68),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: widthSize(2.4)),
            child: Row(
              children: <Widget>[
                SizedBox(height: heightSize(3.45), child: Image.asset(icon)),
                SizedBox(width: widthSize(1.35)),
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        text,
                        // Generated text-fit update: keep full button labels visible on narrow screens.
                        style: TextStyle(
                          fontFamily: "Zona",
                          fontSize: heightSize(1.78),
                          color: MyColors.globalTextColor,
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
}
