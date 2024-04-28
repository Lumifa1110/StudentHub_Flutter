// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:studenthub/components/authappbar.dart';
import 'package:studenthub/components/chat_flow/conversation_item.dart';
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
    socketInitialize();
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

void socketInitialize() {
    socket = IO.io(
      'https://api.studenthub.dev',
      OptionBuilder()
        .setTransports(['websocket']) 
        .disableAutoConnect() 
        .build()
    );
    //Add authorization to header
    final token = ApiService.getAuthToken();
    socket.io.options?['extraHeaders'] = {
      'Authorization': 'Bearer $token',
    };
    //Add query param to url
    final userId = loadUserId();
    socket.io.options?['query'] = {
      'user_id': userId
    };
  }

  void socketConnect() {
    socket.connect();
    socket.onConnect((data) {
      print('Socket connected.');
    });
    socket.on('RECEIVE_MESSAGE', (data) {
      print('RECEIVE_MESSAGE: $data');
    });
  }

  void socketDisconnect() {
    socket.disconnect();
    socket.onDisconnect((data) {
      print('Socket disconnected.');
    });
  }

  Future<int> loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userid');
    return userId!;
  }

  void fetchMessages() async {
    final Map<String, dynamic> response = await MessageService.getAllMessage();
    setState(() {
      messages = response['result'].map<Message>((json) => Message.fromJson(json)).toList();
    });
  }

  Future<void> filterConversationList() async {
    final userId = await loadUserId();

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
    final userId = await loadUserId();
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
    );
  }
}