import 'package:eventizer/tools/getx_bottom_navigation.dart';
import 'package:eventizer/tools/dialogs.dart';
import 'package:eventizer/tools/page_components.dart';
import 'package:eventizer/components/liquidglass_widgets.dart';
import 'package:eventizer/navigation/home_page/home_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var responsive = PageComponents(context);

    // Initialize HomeController if not already initialized
    if (!Get.isRegistered<HomeController>()) {
      Get.put(HomeController());
    }

    //ANCHOR willpopscope back button control
    return WillPopScope(
      onWillPop: onBackButtonPressed,
      child: Scaffold(
        drawerEnableOpenDragGesture: true,
        drawer: Drawer(
          backgroundColor: Colors.transparent,
          child: MyLiquidGlass.standartContainer(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: responsive.heightSize(20)),
                Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Bu uygulama\n",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: responsive.widthSize(4),
                          ),
                        ),
                        TextSpan(
                          text: "Ali Haydar AYAR\n",
                          style: TextStyle(
                            color: Colors.lightBlueAccent,
                            decoration: TextDecoration.underline,
                            fontSize: responsive.widthSize(4),
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              const url =
                                  'https://www.linkedin.com/in/alihaydar-ayar-b45a4315b/';
                              if (await canLaunchUrl(Uri.parse(url))) {
                                await launchUrl(Uri.parse(url));
                              }
                            },
                        ),
                        TextSpan(
                          text: " Ve\n",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: responsive.widthSize(4),
                          ),
                        ),
                        TextSpan(
                          style: TextStyle(
                            color: Colors.lightBlueAccent,
                            decoration: TextDecoration.underline,
                            fontSize: responsive.widthSize(4),
                          ),
                          text: "Murat ALTINTAŞ\n",
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              const url =
                                  'https://www.linkedin.com/in/murat-alt%C4%B1nta%C5%9F-bb58b4145/';
                              if (await canLaunchUrl(Uri.parse(url))) {
                                await launchUrl(Uri.parse(url));
                              }
                            },
                        ),
                        TextSpan(
                          text: "tarafından geliştirilmiştir.\n\n",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: responsive.widthSize(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                MaterialButton(
                  color: Colors.green,
                  onPressed: () {
                    StoreRedirect.redirect();
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.play_arrow),
                      Text("Play Store"),
                    ],
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    feedbackDialog(context);
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.feedback, size: 40),
                      ),
                      Text("Sorun Bildir"),
                    ],
                  ),
                ),
                SizedBox(height: responsive.heightSize(10)),
              ],
            ),
          ),
        ),
        // Use GetX compatible navigation
        body: getXNavigatedPage(context),
        bottomNavigationBar: getXBottomNavigationBar(context),
      ),
    );
  }

  //ANCHOR Check if there's a widget in stack, if yes pop it
  Future<bool> onBackButtonPressed() async {
    // Use GetX back functionality
    if (Get.isDialogOpen! || Get.isBottomSheetOpen! || Get.isSnackbarOpen) {
      Get.back();
      return Future.value(false);
    } else {
      return await askForQuit(context);
    }
  }
}
