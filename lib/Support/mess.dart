import 'package:drivers_app/global/global.dart';
import 'package:drivers_app/models/chatmodel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/container.dart';

class MessageDao {
  final DatabaseReference _messagesRef = FirebaseDatabase.instance
      .reference()
      .child('drivers/${onlineDriverData.id}/messages');
  void saveMessage(Message message) {
    _messagesRef.push().set(message.toJson());
  }

  Query getMessageQuery() {
    return _messagesRef;
  }
}
