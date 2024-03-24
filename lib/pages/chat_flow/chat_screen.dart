import 'package:flutter/material.dart';
import 'package:studenthub/components/app_bar.dart';
import 'package:studenthub/components/chat_flow/conversation_item.dart';
import 'package:studenthub/components/textfield/search_bar.dart';
import 'package:studenthub/data/test/data_message.dart';
import 'package:studenthub/models/message_model.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({ super.key });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late Map<String, MessageModel> latestMessages;
  late Map<String, int> messageCounts;

  void updateLatestMessages() {
    latestMessages = {};
    messageCounts = {};
    for (final message in dataMessage) {
      final sender = message.sender;
      if (!latestMessages.containsKey(sender) ||
          message.time.isAfter(latestMessages[sender]!.time)) {
        latestMessages[sender] = message;
      }
      messageCounts[sender] = (messageCounts[sender] ?? 0) + 1;
    }
  }

  @override
  void initState() {
    super.initState();
    updateLatestMessages();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: MyAppBar(title: 'Chat')
      ),
      backgroundColor: const Color(0xFFF8F8F8),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const ChatSearchBar(placeholder: 'Search...'),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: latestMessages.length,
                itemBuilder: (BuildContext context, int index) {
                  final sender = latestMessages.keys.elementAt(index);
                  final message = latestMessages[sender]!;
                  final messageCount = messageCounts[sender] ?? 0;
                  return ConversationItem(
                    message: message,
                    messageCount: messageCount,
                  );
                }
              ),
            ],
          )
        )
      )
    );
  }
}