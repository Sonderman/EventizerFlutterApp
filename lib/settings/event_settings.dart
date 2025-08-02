import 'package:eventizer/locator.dart';
import 'package:eventizer/services/firebase_service.dart';

class EventSettings {
  final DatabaseWorks firebaseDatabaseWorks = locator<DatabaseWorks>();
  List<String>? categoryItems;
  List<List<String>>? subCategoryItems;
  EventSettings() {
    getCategories();
    getSubCategories();
  }
  void getCategories() async {
    categoryItems = await firebaseDatabaseWorks.getEventCategories();
  }

  void getSubCategories() async {
    subCategoryItems = await firebaseDatabaseWorks.getEventSubCategories();
  }
}
