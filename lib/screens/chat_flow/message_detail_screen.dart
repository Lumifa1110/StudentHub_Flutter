// ignore_for_file: avoid_print
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:studenthub/components/bottomsheet_schedule.dart';
import 'package:studenthub/components/chat_flow/index.dart';
import 'package:studenthub/models/index.dart';
import 'package:studenthub/services/index.dart';
import 'package:studenthub/utils/colors.dart';
import 'package:studenthub/utils/font.dart';

class MessageDetailScreen extends StatefulWidget {
  final int projectId;
  final Chatter chatter;

  const MessageDetailScreen(
      {super.key, required this.projectId, required this.chatter});

  @override
  State<MessageDetailScreen> createState() => _MessageDetailScreenState();
}

class _MessageDetailScreenState extends State<MessageDetailScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late IO.Socket socket;
  late int userId;
  // Controller
  late List<Widget> messageWidgets = [];
  late ScrollController scrollController;
  final TextEditingController messageInputController = TextEditingController();
  // State
  late List<Message> messages = [];

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    loadUserId();
    socketConnect();
    fetchMessages();
  }

  @override
  void dispose() {
    socketDisconnect();
    scrollController.dispose();
    super.dispose();
  }

  void socketConnect() async {
    socket = IO.io(
        'https://api.studenthub.dev',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .enableForceNewConnection()
            .disableAutoConnect()
            .build());

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    socket.io.options?['extraHeaders'] = {
      'Authorization': 'Bearer $token',
    };

    socket.io.options?['query'] = {'project_id': widget.projectId};

    socket.connect();

    socket.onConnect((data) {
      print('Socket connected.');
    });

    socket.on('RECEIVE_MESSAGE', (data) {
      setState(() {
        Message newMessage = Message(
            content: data['notification']['message']['content'],
            sender:
                Chatter(id: data['notification']['sender']['id'], fullname: ''),
            receiver: Chatter(
                id: data['notification']['receiver']['id'], fullname: ''),
            createdAt: DateTime.parse(data['notification']['createdAt']));
        messages.add(newMessage);
        messageWidgets.add(MessageItem(
            message: newMessage,
            isMyMessage: data['notification']['sender']['id'] == userId));
      });
      //scrollToBottom();
    });

    socket.on('RECEIVE_INTERVIEW', (data) {
      print('RECEIVE_INTERVIEW: $data');
      final receivedInterview =
          Interview.fromJson(data['notification']['interview']);
      setState(() {
        messageWidgets.add(InterviewItem(
            interview: Interview(
              id: receivedInterview.id,
              title: receivedInterview.title,
              startTime: receivedInterview.startTime,
              endTime: receivedInterview.endTime,
              disableFlag: receivedInterview.disableFlag,
              meetingRoomId: receivedInterview.meetingRoomId,
              meetingRoom: MeetingRoom.fromJson(data['notification']['meetingRoom'])
            ),
            handleEditInterview: handleEditInterview,
            handleDeleteInterview: handleDeleteInterview));
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollToBottom();
      });
    });

    socket.onConnectError((data) => print('Socket connect error: $data'));

    socket.onError((data) => print('Socker error: $data'));
  }

  void socketDisconnect() {
    socket.disconnect();
    socket.onDisconnect((data) {
      print('Socket disconnected.');
    });
  }

  void fetchMessages() async {
    final response = await MessageService.getMessageByProjectIdAndUserId(
        widget.projectId, widget.chatter.id);
    setState(() {
      messages = response['result']
          .map<Message>((json) => Message.fromJson(json))
          .toList();
      filteredAndSortedMessages();
      buildMessages();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToBottom();
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
      messages = List.from(messages)
        ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    });
  }

  Future<void> handleSubmitMessage() async {
    String content = messageInputController.text.trim();
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userid');
    socket.emit("SEND_MESSAGE", {
      "content": content,
      "projectId": widget.projectId,
      "senderId": userId,
      "receiverId": widget.chatter.id,
      "messageFlag": 0
    });
    // Clear TextField after creating the new message
    messageInputController.clear();
    closeKeyboard();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToBottom();
    });
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

  void buildMessages() {
    List<Widget> tempWidgets = [];
    DateTime? lastMessageTime;
    for (int i = 0; i < messages.length; i++) {
      final message = messages[i];
      if (message.interview != null) {
        tempWidgets.add(InterviewItem(
            interview: message.interview!,
            handleEditInterview: handleEditInterview,
            handleDeleteInterview: handleDeleteInterview));
      } else {
        final isMyMessage = message.sender.id == userId;
        // Check if this is the first message or the time has changed since the last message
        if (lastMessageTime == null ||
            message.createdAt.day != lastMessageTime.day) {
          tempWidgets.add(buildTimestamp(message.createdAt));
        }
        // Add the message item
        tempWidgets
            .add(MessageItem(message: message, isMyMessage: isMyMessage));
        lastMessageTime = message.createdAt;
      }
    }
    // Update messageWidgets once all messages are processed
    setState(() {
      messageWidgets = List.from(tempWidgets);
    });
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

  String generateRandomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }

  void handleCreateInterview(
      String title, DateTime startTime, DateTime endTime) {
    // Create meeting room
    final String roomCode = generateRandomString(10);
    final String roomId = generateRandomString(10);
    // Send socket
    socket.emit("SCHEDULE_INTERVIEW", {
      "title": title,
      "content": 'New interview scheduled.',
      "startTime": startTime.toString(),
      "endTime": endTime.toString(),
      "projectId": widget.projectId,
      "senderId": userId,
      "receiverId": widget.chatter.id,
      "meeting_room_code": roomCode,
      "meeting_room_id": roomId
    });
  }

  void handleEditInterview(
      int interviewId, String title, DateTime startTime, DateTime endTime) {
    socket.emit("UPDATE_INTERVIEW", {
      "interviewId": interviewId,
      "title": title,
      "projectId": widget.projectId,
      "senderId": userId,
      "receiverId": widget.chatter.id,
      "updateAction": true
    });
  }

  void handleDeleteInterview(
      int interviewId, String title, DateTime startTime, DateTime endTime) {
    socket.emit("UPDATE_INTERVIEW", {
      "interviewId": interviewId,
      "title": title,
      "projectId": widget.projectId,
      "senderId": userId,
      "receiverId": widget.chatter.id,
      "deleteAction": true
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.chatter.fullname,
              style: const TextStyle(color: Colors.white)),
          backgroundColor: mainColor,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        backgroundColor: const Color(0xFFF8F8F8),
        body: Column(children: [
          Expanded(
            flex: 7,
            child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.only(
                    top: 20, bottom: 20, left: 20, right: 20),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: messageWidgets)),
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
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
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
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      5 /
                                      9,
                                  child: BottomSheetSchedule(
                                    title: '',
                                    startDate: DateTime.now(),
                                    endDate: DateTime.now(),
                                    enableEdit: false,
                                    handleCreateInterview:
                                        handleCreateInterview,
                                  )),
                            );
                          },
                        )
                      },
                      child: const FaIcon(
                        FontAwesomeIcons.calendarCheck,
                        size: 34,
                        color: AppColor.primary,
                      ),
                    )),
                Expanded(
                    flex: 6,
                    child: Container(
                      height: 3 * (AppFonts.h3FontSize) * 1.5,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: lightergrayColor),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 2,
                              offset: const Offset(0, 2),
                            ),
                          ]),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: messageInputController,
                              cursorColor: AppColor.primary,
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              style: const TextStyle(
                                  fontSize: AppFonts.h3FontSize),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () => {handleSubmitMessage()},
                        child: const FaIcon(
                          FontAwesomeIcons.play,
                          size: 30, // Adjust the size as needed
                          color: AppColor.primary, // Adjust the color as needed
                        ),
                      ),
                    )),
              ]),
            ),
          )
        ]));
  }
}
