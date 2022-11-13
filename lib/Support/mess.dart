import 'package:drivers_app/models/chatmodel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/container.dart';

class MessageDao {
  final DatabaseReference _messagesRef =
      FirebaseDatabase.instance.reference().child('messages');
  void saveMessage(Message message) {
    _messagesRef.push().set(message.toJson());
  }

  Query getMessageQuery() {
    return _messagesRef;
  }
}


class mess extends StatelessWidget {
  const mess({super.key});
void _sendMessage() {
  // if (_canSendMessage()) {
  //   final message = Message(_messageController.text, DateTime.now());
  //   widget.messageDao.saveMessage(message);
  //   _messageController.clear();
  //   setState(() {});
  // }
}

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}