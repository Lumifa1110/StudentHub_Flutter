// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';
import 'package:studenthub/components/bottomsheet_schedule.dart';
import 'package:studenthub/components/chat_flow/message_item.dart';
import 'package:studenthub/models/index.dart';
import 'package:studenthub/services/index.dart';
import 'package:studenthub/utils/colors.dart';
import 'package:studenthub/utils/font.dart';

class MessageDetailScreen extends StatefulWidget {
  final Chatter receiver;
  final List<Message> messages;

  const MessageDetailScreen({ 
    super.key, 
    required this.receiver,
    required this.messages
  });

  @override
  State<MessageDetailScreen> createState() => _MessageDetailScreenState();
}

class _MessageDetailScreenState extends State<MessageDetailScreen> {
  late IO.Socket socket;
  // Controller
  final TextEditingController messageInputController = TextEditingController();
  // State
  late List<Message> _messages;

  @override
  void initState() {
    super.initState();
    socketInitialize();
    socketConnect();
    _messages = filteredAndSortedMessages(widget.messages);
  }

  @override
  void dispose() {
    socketDisconnect();
    super.dispose();
  }

  Future<int> loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userid');
    return userId!;
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

  List<Message> filteredAndSortedMessages(List<Message> messages) {
    List<Message> filteredMessages = messages;
    filteredMessages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return filteredMessages;
  }

  Future<void> handleSubmitMessage() async {
    String content = messageInputController.text;
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userid');
    final fullname = prefs.getString('username');
    if (content.isNotEmpty) {
      Message newMessage = Message(
        content: content,
        sender: Chatter(id: userId!, fullname: fullname!),
        receiver: widget.receiver,
        createdAt: DateTime.now()
      );
      setState(() {
        _messages.add(newMessage);
      });
    }
    socket.emit("SEND_MESSAGE", {
      "content": content,
      "projectId": 1,
      "senderId":  userId,
      "receiverId": widget.receiver.id,
      "messageFlag": 0 // default 0 for message, 1 for interview
  });
    // Clear TextField after creating the new message
    messageInputController.clear();
  }

  List<Widget> buildMessages() {
    List<Widget> messageWidgets = [];
    DateTime? lastMessageTime;
    for (int i = 0; i < _messages.length; i++) {
      final message = _messages[i];
      final isMyMessage = message.sender == 'Vu';
      // Check if this is the first message or the time has changed since the last message
      if (lastMessageTime == null || message.createdAt.day != lastMessageTime.day) {
        messageWidgets.add(buildTimestamp(message.createdAt));
      }
      // Add the message item
      messageWidgets.add(MessageItem(message: message, isMyMessage: isMyMessage));
      lastMessageTime = message.createdAt;
    }
    return messageWidgets;
  }

  Widget buildTimestamp(DateTime time) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const Expanded(
            child: Divider(
              color: Colors.grey,
              height: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              DateFormat('EEEE, MMMM d, yyyy').format(time),
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Expanded(
            child: Divider(
              color: Colors.grey,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.receiver.fullname,
          style: const TextStyle(
            color: Colors.white
          )
        ),
        backgroundColor: mainColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: const Color(0xFFF8F8F8),
      body: Column(
        children:[ 
          Expanded(
            flex: 7,
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: buildMessages()
                )
              )
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: AppColor.background,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 2,
                    offset: const Offset(0, -2), // Change the Y offset to make it appear at the top
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () => {
                        showModalBottomSheet(
                          context: context,
                          barrierColor: Colors.black.withAlpha(1),
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(0)),
                          ),
                          builder: (BuildContext context) {
                            return Container(
                              decoration: BoxDecoration(
                                color: lightestgrayColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: blackTextColor.withOpacity(0.5),
                                    spreadRadius: 6,
                                    blurRadius: 9,
                                    offset: const Offset(
                                        0, 1), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height * 5 / 9,
                                child: BottomSheetSchedule(
                                  title: '',
                                  startDate: DateTime.now(),
                                  endDate: DateTime.now()
                                )
                              ),
                            );
                          },
                        )
                      },
                      child: const FaIcon(
                        FontAwesomeIcons.calendarCheck, // Use the FontAwesome icon you want
                        size: 34, // Adjust the size as needed
                        color: AppColor.primary, // Specify the color
                      ),
                    )
                  ),
                  Expanded(
                    flex: 6,
                    child: Container(
                      height: 3 * (AppFonts.h3FontSize) * 1.5,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white, // Change to your desired background color
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: lightergrayColor),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2), // Shadow color
                            spreadRadius: 2,
                            blurRadius: 2,
                            offset: const Offset(0, 2), // Changes the position of the shadow
                          ),
                        ]
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: messageInputController,
                              cursorColor: AppColor.primary,
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              style: const TextStyle(
                                fontSize: AppFonts.h3FontSize
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () => {
                          handleSubmitMessage()
                        },
                        child: const FaIcon(
                          FontAwesomeIcons.play,
                          size: 30, // Adjust the size as needed
                          color: AppColor.primary, // Adjust the color as needed
                        ),
                      ),
                    )
                  ),
                ]
              ),
            ),
          )
        ]
      )
    );
  }
}