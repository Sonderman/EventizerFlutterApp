import 'package:eventizer/Models/EventModel.dart';
import 'package:flutter/widgets.dart';
import 'package:eventizer/Services/Firebase.dart';

class EventManager with ChangeNotifier {
  Event _event;
  final DatabaseWorks firebaseDatabaseWorks;
  final StorageWorks firebaseStorageWorks;

  EventManager(this.firebaseDatabaseWorks, this.firebaseStorageWorks);

  Future<bool> createEvent(
      String userId, Map<String, dynamic> eventData) async {
    return await firebaseDatabaseWorks.createEvent(userId, eventData);
  }

  void initEventData() {}

  Future<List<Map<String, dynamic>>> fetchActiveEventLists() {
    return firebaseDatabaseWorks.fetchActiveEventLists();
  }
}
/*
Provider kullanımı
final  eventManager = Provider.of<EventManager>(context);
*/
