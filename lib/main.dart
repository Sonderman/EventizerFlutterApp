import 'package:eventizer/Navigation/Components/SplashScreen.dart';
import 'package:eventizer/Services/NavigationProvider.dart';
import 'package:eventizer/Services/Repository.dart';
import 'package:eventizer/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  //ANCHOR burada ekranın dönmesi engellenir, dikey mod
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  //ANCHOR status barı transparent yapıyor
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.light,
  ));
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<EventService>(
              create: (context) => EventService()),
          ChangeNotifierProvider<MessagingService>(
              create: (context) => MessagingService()),
          ChangeNotifierProvider<NavigationProvider>(
            create: (context) => NavigationProvider(),
          ),
          ChangeNotifierProvider<UserService>(
              create: (context) => UserService()),
        ],
        child: MaterialApp(
            debugShowMaterialGrid: false,
            debugShowCheckedModeBanner: false,
            supportedLocales: const <Locale>[
              Locale('en', 'US'),
              Locale('tr', 'TR')
            ],
            home: SplashScreen()));
  }
}
