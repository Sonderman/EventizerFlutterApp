import 'package:eventizer/Services/Firebase.dart';
import 'package:eventizer/locator.dart';

class EventSettings {
  final DatabaseWorks firebaseDatabaseWorks = locator<DatabaseWorks>();
  List<String> categoryItems;
  EventSettings() {
    getCategories();
  }
  void getCategories() async {
    categoryItems = await firebaseDatabaseWorks.getEventCategories();
  }
}
