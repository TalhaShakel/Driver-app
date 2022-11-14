import 'package:drivers_app/global/global.dart';

class Message {
  final String text;
  final DateTime date;
  final String sender;

  Message(this.text, this.date, this.sender);

  Message.fromJson(Map<dynamic, dynamic> json)
      : date = DateTime.parse(json['date'] as String),
        sender = json["sender"] as String,
        text = json['text'] as String;

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'date': date.toString(),
        'text': text,
        "sender": sender.toString(),
      };
}
