import 'package:eventizer/Navigation/Components/SplashScreen.dart';
import 'package:eventizer/Services/NavigationProvider.dart';
import 'package:eventizer/Services/Repository.dart';
import 'package:eventizer/firebase_options.dart';
import 'package:eventizer/locator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //ANCHOR burada ekranın dönmesi engellenir, dikey mod
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  //ANCHOR status barı transparent yapıyor
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.light,
  ));
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((value) {
    setupLocator();
  });
  return runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        child: const MaterialApp(
            debugShowMaterialGrid: false,
            debugShowCheckedModeBanner: false,
            supportedLocales: <Locale>[Locale('en', 'US'), Locale('tr', 'TR')],
            home: SplashScreen()));
  }
}
