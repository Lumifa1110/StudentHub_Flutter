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
  final int projectId;
  final Chatter chatter;

  const MessageDetailScreen({ 
    super.key, 
    required this.projectId,
    required this.chatter
  });

  @override
  State<MessageDetailScreen> createState() => _MessageDetailScreenState();
}

class _MessageDetailScreenState extends State<MessageDetailScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  
  late IO.Socket socket;
  late int userId;
  // Controller
  late ScrollController scrollController;
  final TextEditingController messageInputController = TextEditingController();
  // State
  late List<Message> messages;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    messages = [];
    loadUserId();
    socketConnect();
    fetchMessages();
    filteredAndSortedMessages();
  }

  @override
  void dispose() {
    socketDisconnect();
    scrollController.dispose();
    super.dispose();
  }

  void fetchMessages() async {
    final response = await MessageService.getMessageByProjectIdAndUserId(widget.projectId, widget.chatter.id);
    setState(() {
      messages = response['result'].map<Message>((json) => Message.fromJson(json)).toList();
    });
  }

  void socketConnect() async {
    socket = IO.io(
      'https://api.studenthub.dev',
      OptionBuilder()
        .setTransports(['websocket'])
        .enableForceNewConnection()
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
      'project_id': widget.projectId
    };

    socket.connect();

    socket.onConnect((data) {
      print('Socket connected.');
    });

    socket.on('RECEIVE_MESSAGE', (data) {
      setState(() {
        Message newMessage = Message(
          content: data['content'],
          sender: Chatter(id: data['senderId'], fullname: ''),
          receiver: Chatter(id: data['receiverId'], fullname: ''),
          createdAt: DateTime.now()
        );
        messages.add(newMessage);
      });
      //scrollToBottom();
    });

    socket.onConnectError((data) => print('$data'));

    socket.onError((data) => print(data));
  }

  void socketDisconnect() {
    socket.disconnect();
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

  void filteredAndSortedMessages() {
    setState(() {
      messages = List.from(messages)..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    });
  }

  Future<void> handleSubmitMessage() async {
    String content = messageInputController.text;
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userid');
    socket.emit("SEND_MESSAGE", {
      "content": content,
      "projectId": widget.projectId,
      "senderId":  userId,
      "receiverId": widget.chatter.id,
      "messageFlag": 0
  });
    // Clear TextField after creating the new message
    messageInputController.clear();
    closeKeyboard();
    scrollToBottom();
  }

  void closeKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void scrollToBottom() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  List<Widget> buildMessages() {
    List<Widget> messageWidgets = [];
    DateTime? lastMessageTime;
    for (int i = 0; i < messages.length; i++) {
      final message = messages[i];
      final isMyMessage = message.sender.id == userId;
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
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.chatter.fullname,
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
              controller: scrollController,
              padding: const EdgeInsets.only(top: 20, bottom: 80, left: 20, right: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: buildMessages()
              )
              // child: Container(
              // )
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