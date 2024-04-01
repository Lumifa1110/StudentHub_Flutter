import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:studenthub/components/chat_flow/message_item.dart';
import 'package:studenthub/data/test/data_message.dart';
import 'package:studenthub/models/message_model.dart';
import 'package:studenthub/utils/colors.dart';
import 'package:studenthub/utils/font.dart';

class MessageDetailScreen extends StatefulWidget {
  final String chatter;

  const MessageDetailScreen({ 
    super.key, 
    required this.chatter
  });

  @override
  State<MessageDetailScreen> createState() => _MessageDetailScreenState();
}

class _MessageDetailScreenState extends State<MessageDetailScreen> {
  // Controller
  final TextEditingController messageInputController = TextEditingController();
  // State
  late List<MessageModel> _messages;

  @override
  void initState() {
    super.initState();
    _messages = filteredAndSortedMessages(dataMessage);
  }

  List<MessageModel> filteredAndSortedMessages(List<MessageModel> messages) {
    List<MessageModel> filteredMessages = messages.where((message) => message.sender == widget.chatter || message.receiver == widget.chatter).toList();
    filteredMessages.sort((a, b) => a.time.compareTo(b.time));
    return filteredMessages;
  }

  void handleSubmitMessage() {
    String content = messageInputController.text;
    if (content.isNotEmpty) {
      MessageModel newMessage = MessageModel('Vu', widget.chatter, content, DateTime.now());
      setState(() {
        _messages.add(newMessage);
      });
    }
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
      if (lastMessageTime == null || message.time.day != lastMessageTime.day) {
        messageWidgets.add(buildTimestamp(message.time));
      }
      // Add the message item
      messageWidgets.add(MessageItem(message: message, isMyMessage: isMyMessage));
      lastMessageTime = message.time;
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
          widget.chatter,
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
                  const Expanded(
                    flex: 1,
                    child: FaIcon(
                      FontAwesomeIcons.calendarCheck, // Use the FontAwesome icon you want
                      size: 34, // Adjust the size as needed
                      color: AppColor.primary, // Specify the color
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