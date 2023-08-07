import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:dialogflow_grpc/dialogflow_grpc.dart';
import 'package:dialogflow_grpc/generated/google/cloud/dialogflow/v2beta1/session.pb.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:touriso/screens/shared/custom_text_form_field.dart';
import 'package:touriso/screens/tab_view/chat/chat_bubble.dart';
import 'package:touriso/utils/colors.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // message text controller
  final TextEditingController _textController = TextEditingController();

  // list of messages that will be displayed on the screen
  final List<ChatBubble> _messages = <ChatBubble>[];

  // for changing recording icon
  bool _isRecording = false;

  late final SpeechToText speechToText;
  late StreamSubscription _recorderStatus;
  late StreamSubscription<List<int>> _audioStreamSubscription;
  late DialogflowGrpcV2Beta1 dialogflow;

  Future<void> initPlugin() async {
    // initializing speech t otext plugin
    speechToText = SpeechToText();

    // requiried for setting up dialogflow
    final serviceAccount = ServiceAccount.fromString(
      await rootBundle.loadString('assets/cred.json'),
    );

    // dialogflow setup
    dialogflow = DialogflowGrpcV2Beta1.viaServiceAccount(serviceAccount);
    setState(() {});

    // Initialize speech recognition services, returns true if successful, false if failed.
    await speechToText.initialize(
      options: [SpeechToText.androidIntentLookup],
    );
  }

  void stopStream() async {
    await _audioStreamSubscription.cancel();
  }

  void handleSubmitted(text) async {
    _textController.clear();

    ChatBubble message = ChatBubble(
      text: text,
      name: "You",
      type: true,
    );

    setState(() {
      _messages.insert(0, message);
    });

    // callling dialogflow api
    DetectIntentResponse data = await dialogflow.detectIntent(text, 'en-US');

    // getting meaningful response text
    String fulfillmentText = data.queryResult.fulfillmentText;
    if (fulfillmentText.isNotEmpty) {
      ChatBubble botMessage = ChatBubble(
        text: fulfillmentText,
        name: "Bot",
        type: false,
      );

      setState(() {
        _messages.insert(0, botMessage);
      });
    }
  }

  void _onSpeechResult(SpeechRecognitionResult result) async {
    String lastWords = result.recognizedWords;

    // setting textediting controller to the speech value and moving cursor at the end
    _textController.text = lastWords;
    _textController.selection = TextSelection.collapsed(
      offset: _textController.text.length,
    );

    setState(() {
      _isRecording = false;
    });
    await Future.delayed(const Duration(seconds: 5));
    _stopListening();
  }

  void handleStream() async {
    setState(() {
      _isRecording = true;
    });
    await speechToText.listen(
      onResult: _onSpeechResult,
    );
  }

  void _stopListening() async {
    await speechToText.stop();
  }

  @override
  void initState() {
    //TODO: test this on simulator
    //TODO: firebase stream things

    super.initState();
    initPlugin();

    _textController.addListener(() {
      setState(() {});
    });
  }

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
                child: ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  reverse: true,
                  itemBuilder: (ctx, int index) => _messages[index],
                  itemCount: _messages.length,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                color: Theme.of(context).cardColor,
                margin:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: CustomTextFormField(
                        controller: _textController,
                        onFieldSubmitted: handleSubmitted,
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
                        handleSubmitted(_textController.text);
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        _isRecording ? Icons.mic : Icons.mic_off,
                        color: primaryColor,
                      ),
                      onPressed: () {
                        handleStream();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _recorderStatus.cancel();
    _audioStreamSubscription.cancel();
    speechToText.stop();
    _textController.dispose();
    super.dispose();
  }
}
