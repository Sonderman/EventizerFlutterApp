import 'package:eventizer/firebase_options.dart';
import 'package:eventizer/locator.dart';
import 'package:eventizer/components/liquidglass_widgets.dart';
import 'package:eventizer/services/navigation_provider.dart';
import 'package:eventizer/services/repository.dart';
import 'package:eventizer/services/theme_service.dart';
import 'package:eventizer/routes/app_pages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetStorage for theme persistence
  await GetStorage.init();

  //ANCHOR Screen rotation is prevented here, vertical mode
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  //ANCHOR Makes status bar transparent
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarBrightness: Brightness.light),
  );

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Liquid Glass shader'larını önceden derle
  await LiquidGlassWidgets.initialize();

  setupLocator();
  setupServices();
  return runApp(
    LiquidGlassWidgets.wrap(
      child: const MyApp(),
      adaptiveQuality: true,
      brightnessResolver: Theme.maybeBrightnessOf,
      theme: GlassThemeData(
        light: GlassThemeVariant(
          settings: GlassThemeSettings(
            blur: 0,
            glassColor: Color(0x00000000),
            thickness: 8,
            lightAngle: 0.75 * 3.141592653589793,
            lightIntensity: 0.9,
            ambientStrength: 0.12,
            refractiveIndex: 0.82,
            saturation: 1.0,
            chromaticAberration: 0.008,
            specularSharpness: GlassSpecularSharpness.medium,
          ),
        ),
        dark: GlassThemeVariant(
          settings: GlassThemeSettings(
            blur: 0,
            glassColor: Color(0x00000000),
            thickness: 8,
            lightAngle: 0.75 * 3.141592653589793,
            lightIntensity: 0.9,
            ambientStrength: 0.12,
            refractiveIndex: 0.82,
            saturation: 1.0,
            chromaticAberration: 0.008,
            specularSharpness: GlassSpecularSharpness.medium,
          ),
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize theme service
    final themeService = Get.put(ThemeService());

    return Sizer(
      builder: (context, orientation, deviceType) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider<EventService>(create: (context) => EventService()),
            ChangeNotifierProvider<MessagingService>(create: (context) => MessagingService()),
            ChangeNotifierProvider<NavigationProvider>(create: (context) => NavigationProvider()),
            ChangeNotifierProvider<UserService>(create: (context) => UserService()),
          ],
          child: Obx(
            () => GetMaterialApp(
              title: 'Eventizer',
              debugShowMaterialGrid: false,
              debugShowCheckedModeBanner: false,
              supportedLocales: const <Locale>[Locale('en', 'US'), Locale('tr', 'TR')],

              // GetX routing configuration
              initialRoute: AppPages.initial,
              getPages: AppPages.routes,

              // Default transition settings
              defaultTransition: Transition.rightToLeft,
              transitionDuration: const Duration(milliseconds: 300),

              // FlexColorScheme theme configuration
              theme: themeService.getLightTheme(),
              darkTheme: themeService.getDarkTheme(),
              themeMode: themeService.themeMode,

              // High contrast theme support
              highContrastTheme: themeService.getLightTheme().copyWith(brightness: Brightness.light),
              highContrastDarkTheme: themeService.getDarkTheme().copyWith(brightness: Brightness.dark),
              builder: (context, child) {
                return MyLiquidGlass.appShell(child: child ?? const SizedBox.shrink());
              },
            ),
          ),
        );
      },
    );
  }
}

void setupServices() {
  Get.put(ThemeService(), permanent: true);
  Get.put(UserService(), permanent: true);
}
