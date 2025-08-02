import 'package:eventizer/services/auth_service.dart';
import 'package:eventizer/app_settings.dart';
import 'package:eventizer/settings/event_settings.dart';
import 'package:get_it/get_it.dart';
import 'package:eventizer/services/firebase_service.dart';

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
