import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class support extends StatelessWidget {
  const support({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: mobileBackgroundColor,
        title: const Text(
          'Support',
        ),
        centerTitle: false,
      ),
      body: Column(children: [
        
      ],),
    );
  }
}

class CommentCard extends StatelessWidget {
  final snap;
  const CommentCard({Key? key, required this.snap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return snap == null
        ? CircularProgressIndicator()
        : Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage:
                      NetworkImage(snap.data()["photoUrl"].toString()),
                  radius: 18,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // RichText(
                        //   text: TextSpan(
                        //     children: [
                        //       TextSpan(
                        //           text: snap.data()['name'],
                        //           style: const TextStyle(
                        //             fontWeight: FontWeight.bold,
                        //           )),
                        //       TextSpan(
                        //         text: ' ${snap}',
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        Text(snap.data()['name']),
                        Text(snap.data()['comment']),
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            DateFormat.yMMMd().format(
                              snap.data()['datePublished'].toDate(),
                            ),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: const Icon(
                    Icons.favorite,
                    size: 16,
                  ),
                )
              ],
            ),
          );
  }
}
