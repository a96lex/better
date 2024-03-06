class Event {
  final int? id;
  final DateTime date;

  Event({this.id, required this.date});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "date": date.millisecondsSinceEpoch,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
        id: map["id"], date: DateTime.fromMillisecondsSinceEpoch(map["date"]));
  }
}
