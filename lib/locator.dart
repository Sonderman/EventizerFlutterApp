import 'package:eventizer/Settings/EventSettings.dart';
import 'package:get_it/get_it.dart';
import 'package:eventizer/Services/Firebase.dart';
import 'package:eventizer/Settings/AppSettings.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton<DatabaseWorks>(DatabaseWorks());
  locator.registerSingleton<StorageWorks>(StorageWorks());
  locator.registerSingleton<EventSettings>(EventSettings());
  //locator.registerSingleton<AppSettings>(AppSettings());
  //locator.registerSingleton<GetSayac>(GetSayac()); // Testiçin
}

//Locator kullanacağın zaman
/*
UserWorks userWorker = locator<UserWorks>();
*/
