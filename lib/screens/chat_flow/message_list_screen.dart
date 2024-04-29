// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:studenthub/components/authappbar.dart';
import 'package:studenthub/components/chat_flow/conversation_item.dart';
import 'package:studenthub/components/custombottomnavbar.dart';
import 'package:studenthub/components/index.dart';
import 'package:studenthub/components/textfield/search_bar.dart';

// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:studenthub/models/index.dart';
import 'package:studenthub/services/index.dart';

class MessageListScreen extends StatefulWidget {
  const MessageListScreen({ 
    super.key
  });

  @override
  State<MessageListScreen> createState() => _MessageListScreenState();
}

class _MessageListScreenState extends State<MessageListScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late IO.Socket socket;
  late int userId;
  late List<Message> messages;
  late List<Message> conversationList;
  late List<int> messageCounts;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadUserId();
    socketConnect();
    // Filter and sort the messages to get the conversation list
    messages = [];
    conversationList = [];
    messageCounts = [];
    fetchMessages();
    filterConversationList();
    getMessageCounts();
  }

  @override
  void dispose() {
    socketDisconnect();
    super.dispose();
  }

void socketConnect() async {
    socket = IO.io(
      'https://api.studenthub.dev',
      OptionBuilder()
        .setTransports(['websocket']) 
        .disableAutoConnect() 
        .build()
    );

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print('Chat token: $token');
    socket.io.options?['extraHeaders'] = {
      'Authorization': 'Bearer $token',
    };

    socket.io.options?['query'] = {
      'project_id': 578
    };

    socket.connect();

    socket.onConnect((data) {
      print('Socket connected.');
    });

    socket.on('RECEIVE_MESSAGE', (data) {
      print('RECEIVE_MESSAGE: $data');
    });

    socket.onConnectError((data) => print('$data'));

    socket.onError((data) => print(data));
  }

  void socketDisconnect() {
    //socket.disconnect();
    socket.onDisconnect((data) {
      print('Socket disconnected.');
    });
  }

  Future<void> loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('userid')!;
    });
  }

  void fetchMessages() async {
    final Map<String, dynamic> response = await MessageService.getAllMessage();
    setState(() {
      messages = response['result'].map<Message>((json) => Message.fromJson(json)).toList();
    });
  }

  Future<void> filterConversationList() async {
    // Create a map to store the latest message for each conversation involving user
    final Map<String, Message> conversationsMap = {};

    // Iterate through each message
    for (final message in messages) {
      final sender = message.sender;
      final receiver = message.receiver;

      // Check if the message involves user
      if (sender.id == userId || receiver.id == userId) {
        final otherPerson = sender.id == userId ? receiver.fullname : sender.fullname;
        // Check if the conversation has been added to the map
        if (!conversationsMap.containsKey(otherPerson) ||
            message.createdAt.isAfter(conversationsMap[otherPerson]!.createdAt)) {
          conversationsMap[otherPerson] = message;
        }
      }
    }

    // Convert the map to a list and sort by time (latest message at the top)
    List<Message> sortedConversationList = conversationsMap.values.toList();
    sortedConversationList.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    setState(() {
      conversationList = sortedConversationList;
    });
  }

  Future<void> getMessageCounts() async {
    // Create a list to store the message counts for each conversation
    List<int> counts = [];

    // Iterate through the conversation list and get the message count for each conversation
    for (final conversation in conversationList) {
      int count = 0;
      for (final message in messages) {
        if (message.sender.id == userId && message.receiver.id == conversation.sender.id 
          || message.sender == conversation.sender && message.receiver.id == userId) {
          count++;
        }
      }
      counts.add(count);
    }
    setState(() {
      messageCounts = counts;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: const AuthAppBar(canBack: false, title: 'Chat'),
      backgroundColor: const Color(0xFFF8F8F8),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              CustomSearchBar(controller: searchController, placeholder: 'Search'),
              ButtonSimple(
                label: 'Send message',
                onPressed: () {
                  print('message sent');
                  print('userId: $userId');
                  socket.emit("SEND_MESSAGE", {
                    "content": 'Hi',
                    "projectId": 578,
                    "senderId":  userId,
                    "receiverId": 318,
                    "messageFlag": 0
                  });
                }
              ),
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