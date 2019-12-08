class Event {
  final String eventId;
  final String ownerId;
  String title;

  Event(this.eventId, this.ownerId);

  Map<String, dynamic> toMap() {
    return {"OwnerID": ownerId, "Title": title};
  }
}
