class Event {
  final String eventId;
  final String organizerId;
  String? title;

  Event(this.eventId, this.organizerId);

  Map<String, dynamic> toMap() {
    return {"OrganizerID": organizerId, "Title": title};
  }
}
