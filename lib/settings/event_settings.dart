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
    try {
      categoryItems = await firebaseDatabaseWorks.getEventCategories();
    } catch (_) {
      // Generated safeguard: keep settings initialization resilient against remote fetch failures.
      categoryItems = <String>[];
    }
  }

  void getSubCategories() async {
    try {
      subCategoryItems = await firebaseDatabaseWorks.getEventSubCategories();
    } catch (_) {
      // Generated safeguard: keep settings initialization resilient against remote fetch failures.
      subCategoryItems = <List<String>>[];
    }
  }
}
