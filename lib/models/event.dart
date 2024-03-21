class Event {
  final int? id;
  final DateTime date;
  final String? text;

  Event({this.id, required this.date, this.text});

  Map<String, dynamic> toMap() {
    return {"id": id, "date": date.millisecondsSinceEpoch, "text": text};
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
        id: map["id"],
        date: DateTime.fromMillisecondsSinceEpoch(map["date"]),
        text: map["text"]);
  }
}
