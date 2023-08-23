import 'package:equatable/equatable.dart';
import 'package:touriso/models/message.dart';

class Chat extends Equatable {
  final Message lastMessage;
  final List<Message> messages;

  const Chat({required this.lastMessage, required this.messages});

  Chat.fromFirebase(Map<String, dynamic> map)
      : lastMessage = Message.fromFirebase(map['lastMessage']),
        messages = (map['messages'] as List)
            .map((e) => Message.fromFirebase(e))
            .toList();

  @override
  List<Object?> get props => [lastMessage, messages];
}
