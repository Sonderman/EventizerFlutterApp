import 'package:eventizer/Services/Firebase.dart';
import 'package:eventizer/locator.dart';

class EventSettings {
  final DatabaseWorks firebaseDatabaseWorks = locator<DatabaseWorks>();
  List<String> categoryItems;
  EventSettings() {
    initCategories();
  }
  void initCategories() async {
    categoryItems = await firebaseDatabaseWorks.getEventCategories();
  }
}
