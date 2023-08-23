import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final String senderId;
  final String content;
  final DateTime dateTime;

  const Message({
    required this.senderId,
    required this.content,
    required this.dateTime,
  });

  Message.fromFirebase(Map<String, dynamic> map)
      : senderId = map['senderId'],
        content = map['content'],
        dateTime = DateTime.fromMillisecondsSinceEpoch(
            (map['dateTime'] as Timestamp).millisecondsSinceEpoch);

  Map<String, dynamic> toFirebase() => {
        'senderId': senderId,
        'content': content,
        'dateTime': dateTime,
      };

  @override
  List<Object?> get props => [senderId, content, dateTime];
}
