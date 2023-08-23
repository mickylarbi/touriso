import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:touriso/models/chat.dart';
import 'package:touriso/screens/shared/custom_text_form_field.dart';
import 'package:touriso/screens/tab_view/chat/chat_bubble.dart';
import 'package:touriso/utils/colors.dart';
import 'package:touriso/utils/dialogs.dart';
import 'package:touriso/utils/firebase_helper.dart';
import 'package:touriso/models/message.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // message text controller
  final TextEditingController _textController = TextEditingController();

  // list of messages that will be displayed on the screen

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        const SliverAppBar(
          title: Text('Chat'),
          centerTitle: false,
          pinned: true,
        ),
        SliverFillRemaining(
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder<DocumentSnapshot<Object?>>(
                  stream: chatsCollection.doc(uid).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text('An error occurred'),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator.adaptive());
                    }

                    if (snapshot.data == null ||
                        snapshot.data!.data() == null) {
                      return const Center(
                        child: Text(
                          'No messages to show',
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }

                    Chat chat = Chat.fromFirebase(
                        snapshot.data!.data() as Map<String, dynamic>);

                    List<Message> messages = chat.messages;
                    messages.sort((a, b) => a.dateTime.compareTo(b.dateTime));

                    return messages.isEmpty
                        ? const Center(
                            child: Text(
                              'No messages to show',
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(8.0),
                            itemBuilder: (context, int index) {
                              return ChatBubble(message: messages[index]);
                            },
                            itemCount: messages.length,
                          );
                  },
                ),
              ),
              StatefulBuilder(builder: (context, setState) {
                return Container(
                  padding: const EdgeInsets.all(8),
                  color: Theme.of(context).cardColor,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        child: CustomTextFormField(
                          controller: _textController,
                          onFieldSubmitted: (val) {},
                          onChanged: (val) {
                            setState(() {});
                          },
                          hintText: 'Send a message',
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.send,
                          color: _textController.text.trim().isEmpty
                              ? Colors.grey
                              : primaryColor,
                        ),
                        onPressed: () {
                          try {
                            Map<String, dynamic> messageMap = Message(
                                    senderId: uid,
                                    content: _textController.text.trim(),
                                    dateTime: DateTime.now())
                                .toFirebase();

                            chatDocument.set(
                              {
                                'messages': FieldValue.arrayUnion([messageMap]),
                                'lastMessage': messageMap,
                              },
                              SetOptions(merge: true),
                            );

                            _textController.clear();
                          } catch (e) {
                            print(e);
                            showAlertDialog(context, message: e.toString());
                          }
                        },
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
