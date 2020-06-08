import 'package:eventizer/Services/AuthService.dart';
import 'package:eventizer/Settings/AppSettings.dart';
import 'package:eventizer/Settings/EventSettings.dart';
import 'package:get_it/get_it.dart';
import 'package:eventizer/Services/Firebase.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton<AppSettings>(AppSettings());
  locator.registerSingleton<DatabaseWorks>(DatabaseWorks());
  locator.registerSingleton<StorageWorks>(StorageWorks());
  locator.registerSingleton<EventSettings>(EventSettings());
  locator.registerSingleton<AuthService>(AuthService());
}

//Locator kullanacağın zaman
/*
UserWorks userWorker = locator<UserWorks>();
*/
