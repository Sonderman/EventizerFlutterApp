import 'package:eventizer/navigation/home_page/home_page.dart';
import 'package:eventizer/navigation/login_page/login_page_view.dart';
import 'package:eventizer/locator.dart';
import 'package:eventizer/components/liquidglass_widgets.dart';
import 'package:eventizer/services/auth_service.dart';
import 'package:eventizer/services/repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:store_redirect/store_redirect.dart';
import '../../services/firebase_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void authChecking(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      String? userID = locator<AuthService>().getUserUid();

      if (userID != null) {
        if (kDebugMode) {
          print("UserID:$userID");
        }
        Provider.of<UserService>(
          context,
          listen: false,
        ).userInitializer(userID).then((value) {
          if (value) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => const HomePage(),
              ),
            );
          }
        });
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const LoginPage(),
          ),
        );
      }
    });
  }

  Future<bool> checkUpdate() async {
    String? appVersion;
    String? serverVersion;
    bool needToUpdate = false;
    try {
      appVersion = await PackageInfo.fromPlatform().then((
        PackageInfo packageInfo,
      ) {
        if (kDebugMode) {
          print("appVersion:${packageInfo.version}");
        }
        return packageInfo.version;
      });
      serverVersion = await locator<DatabaseWorks>().getServerVersion();
      if (kDebugMode) {
        print("serverVersion:$serverVersion");
      }

      // Generated safeguard: if version payload is missing, skip forced-update flow.
      if (appVersion == null || serverVersion == null) {
        return false;
      }

      final List<String> temp = appVersion.split(".");
      final List<String> temp2 = serverVersion.split(".");
      final int loopLength = temp.length < temp2.length
          ? temp.length
          : temp2.length;

      for (int i = 0; i < loopLength; i++) {
        final int serverPart = int.tryParse(temp2[i]) ?? 0;
        final int appPart = int.tryParse(temp[i]) ?? 0;
        if (serverPart > appPart) {
          needToUpdate = true;
          break;
        } else if (serverPart < appPart) {
          break;
        }
      }
      return needToUpdate;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    checkUpdate().then((value) {
      if (kDebugMode) {
        print(value);
      }
      if (!value) {
        authChecking(context);
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => Scaffold(
              body: Center(
                child: MyLiquidGlass.standartDialog(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Text("Lütfen Uygulamayı Güncelleyin!"),
                        const SizedBox(height: 20),
                        MaterialButton(
                          color: Colors.green,
                          onPressed: () {
                            StoreRedirect.redirect();
                          },
                          child: const Text("Güncelle"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MyLiquidGlass.standartContainer(
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Eventizer",
                style: TextStyle(
                  decoration: TextDecoration.none,
                  fontFamily: 'IndieFlower',
                  fontSize: 50,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 40.0),
              SpinKitFoldingCube(
                color: Colors.white,
                size: 100.0,
                duration: Duration(seconds: 2),
              ),
              SizedBox(height: 30.0),
              Text(
                "Loading",
                style: TextStyle(
                  decoration: TextDecoration.none,
                  fontFamily: 'IndieFlower',
                  color: Colors.white,
                  fontSize: 20,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
