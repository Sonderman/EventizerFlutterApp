
import 'package:get_it/get_it.dart';
import 'package:eventizer/Services/FirebaseDb.dart';

GetIt locator = GetIt.instance;

void setupLocator(){
  locator.registerSingleton<UserWorks>(UserWorks());
  //locator.registerSingleton<GetSayac>(GetSayac()); // Testiçin
}

//Locator kullanacağın zaman
/*
UserWorks userWorker = locator<UserWorks>();
*/