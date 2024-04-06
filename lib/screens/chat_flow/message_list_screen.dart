import 'package:flutter/material.dart';
import 'package:studenthub/components/authappbar.dart';
import 'package:studenthub/components/chat_flow/conversation_item.dart';
import 'package:studenthub/components/custombottomnavbar.dart';
import 'package:studenthub/components/textfield/search_bar.dart';
import 'package:studenthub/data/test/data_message.dart';
import 'package:studenthub/models/message_model.dart';

class MessageListScreen extends StatefulWidget {
  const MessageListScreen({ super.key });

  @override
  State<MessageListScreen> createState() => _MessageListScreenState();
}

class _MessageListScreenState extends State<MessageListScreen> {
  late List<MessageModel> conversationList;
  late List<int> messageCounts;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Filter and sort the messages to get the conversation list
    conversationList = filterConversationList();
    // Get the message counts for each conversation
    messageCounts = getMessageCounts();
  }

  List<MessageModel> filterConversationList() {
    // Create a map to store the latest message for each conversation involving 'Vu'
    final Map<String, MessageModel> conversationsMap = {};

    // Iterate through each message
    for (final message in dataMessage) {
      final sender = message.sender;
      final receiver = message.receiver;

      // Check if the message involves 'Vu'
      if (sender == 'Vu' || receiver == 'Vu') {
        final otherPerson = sender == 'Vu' ? receiver : sender;
        // Check if the conversation has been added to the map
        if (!conversationsMap.containsKey(otherPerson) ||
            message.time.isAfter(conversationsMap[otherPerson]!.time)) {
          conversationsMap[otherPerson] = message;
        }
      }
    }

    // Convert the map to a list and sort by time (latest message at the top)
    List<MessageModel> sortedConversationList = conversationsMap.values.toList();
    sortedConversationList.sort((a, b) => b.time.compareTo(a.time));

    return sortedConversationList;
  }

  List<int> getMessageCounts() {
    // Create a list to store the message counts for each conversation
    List<int> counts = [];
    // Iterate through the conversation list and get the message count for each conversation
    for (final conversation in conversationList) {
      int count = 0;
      for (final message in dataMessage) {
        if (message.sender == 'Vu' && message.receiver == conversation.sender ||
            message.sender == conversation.sender && message.receiver == 'Vu') {
          count++;
        }
      }
      counts.add(count);
    }
    return counts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AuthAppBar(canBack: false, title: 'Chat'),
      backgroundColor: const Color(0xFFF8F8F8),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              CustomSearchBar(controller: searchController, placeholder: 'Search'),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: conversationList.length,
                itemBuilder: (BuildContext context, int index) {
                  final message = conversationList[index];
                  final messageCount = messageCounts[index];
                  return ConversationItem(
                    message: message,
                    messageCount: messageCount,
                  );
                }
              ),
            ],
          )
        )
      ),
      bottomNavigationBar: const CustomBottomNavBar(initialIndex: 2),
    );
  }
}