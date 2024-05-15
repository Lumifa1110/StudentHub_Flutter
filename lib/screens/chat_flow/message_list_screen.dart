// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:studenthub/components/authappbar.dart';
import 'package:studenthub/components/chat_flow/conversation_item.dart';
import 'package:studenthub/components/chat_flow/index.dart';
import 'package:studenthub/components/custombottomnavbar.dart';
import 'package:studenthub/components/textfield/search_bar.dart';

// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:studenthub/models/index.dart';
import 'package:studenthub/services/index.dart';
import 'package:studenthub/utils/font.dart';

class MessageListScreen extends StatefulWidget {
  const MessageListScreen({super.key});

  @override
  State<MessageListScreen> createState() => _MessageListScreenState();
}

class _MessageListScreenState extends State<MessageListScreen>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  late IO.Socket socket;
  late int userId;
  late List<Message> messages;
  late List<Message> conversationList;
  late List<int> messageCounts;
  late List<Interview> interviews;
  late List<Interview> interviewsFiltered;
  final TextEditingController searchConversationController =
      TextEditingController();
  final TextEditingController searchInterviewController =
      TextEditingController();
  TabController? tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(initialIndex: 0, length: 2, vsync: this);
    loadUserId();
    socketConnect();
    // Filter and sort the messages to get the conversation list
    messages = [];
    conversationList = [];
    messageCounts = [];
    interviews = [];
    interviewsFiltered = [];
    fetchMessages();
    fetchInterviews();
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
          .enableForceNewConnection()
          .disableAutoConnect()
          .build(),
    );

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    socket.io.options?['extraHeaders'] = {
      'Authorization': 'Bearer $token',
    };
    socket.io.options?['query'] = {'project_id': 578};

    socket.connect();
    socket.onConnect((data) {
      print('Socket connected.');
    });
    socket.on('RECEIVE_MESSAGE', (data) {
      //print('RECEIVE_MESSAGE: $data');
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

  void fetchMessages() async {
    final Map<String, dynamic> response = await MessageService.getAllMessage();
    if (mounted) {
      setState(() {
        messages = response['result']
            .map<Message>((json) => Message.fromJson(json))
            .toList();
      });
      filterConversationList();
      getMessageCounts();
    }
  }

  void fetchInterviews() async {
    final prefs = await SharedPreferences.getInstance();
    final userIdTemp = prefs.getInt('userid');
    final Map<String, dynamic> response =
        await InterviewService.getInterviewByUserId(userIdTemp!);
    if (mounted) {
      setState(() {
        interviews = response['result']
            .map<Interview>((json) => Interview.fromJson(json))
            .toList().where((interview) => interview.deletedAt == null).toList();
        interviewsFiltered = response['result']
            .map<Interview>((json) => Interview.fromJson(json))
            .toList().where((interview) => interview.deletedAt == null).toList();
      });
    }
  }

  void filterInterviewList() {
    setState(() {
      interviewsFiltered = interviews
          .where((interview) => interview.title
              .toLowerCase()
              .contains(searchInterviewController.text.toLowerCase()))
          .toList();
    });
  }

  Future<void> filterConversationList() async {
    print("Search text: ${searchConversationController.text}");
    // Create a map to store the latest message for each conversation involving user
    if (mounted) {
      final Map<String, Message> conversationsMap = {};

      // Iterate through each message
      for (final message in messages) {
        final sender = message.sender;
        final receiver = message.receiver;

        // Check if the message involves user
        if (sender!.id == userId || receiver!.id == userId) {
          final otherPerson =
              sender.id == userId ? receiver!.fullname : sender.fullname;

          // Check if the other person's name matches the search query
          if (otherPerson
              .toLowerCase()
              .contains(searchConversationController.text.toLowerCase())) {
            // Check if the conversation has been added to the map
            if (!conversationsMap.containsKey(otherPerson) ||
                message.createdAt
                    .isAfter(conversationsMap[otherPerson]!.createdAt)) {
              conversationsMap[otherPerson] = message;
            }
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
  }

  Future<void> getMessageCounts() async {
    // Create a list to store the message counts for each conversation
    List<int> counts = [];

    // Iterate through the conversation list and get the message count for each conversation
    for (final conversation in conversationList) {
      int count = 0;
      for (final message in messages) {
        if (message.sender!.id == userId &&
                message.receiver!.id == conversation.sender!.id ||
            message.sender!.id == conversation.sender!.id &&
                message.receiver!.id == userId) {
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
      backgroundColor: Theme.of(context).colorScheme.background,
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(
                  top: 20, bottom: 5, left: 20, right: 20),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    child: TabBar(
                      controller: tabController,
                      unselectedLabelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: AppFonts.h3FontSize,
                      ),
                      indicator: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      indicatorWeight: 0,
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelColor: Colors.white,
                      labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: AppFonts.h3FontSize,
                      ),
                      tabs: const [
                        Tab(text: 'Conversation'),
                        Tab(text: 'Interview')
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: TabBarView(
                controller: tabController,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 20, right: 20, left: 20),
                    child: Column(children: [
                      CustomSearchBar(
                          controller: searchConversationController,
                          placeholder: 'Search user name',
                          onChange: filterConversationList),
                      const SizedBox(height: 30),
                      Expanded(
                        child: ListView.builder(
                          itemCount: conversationList.length,
                          itemBuilder: (BuildContext context, int index) {
                            final message = conversationList[index];
                            final messageCount = messageCounts[index];
                            return ConversationItem(
                              message: message,
                              messageCount: messageCount,
                            );
                          },
                        ),
                      ),
                    ]),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 20, right: 20, left: 20),
                    child: Column(children: [
                      CustomSearchBar(
                          controller: searchInterviewController,
                          placeholder: 'Search interview title',
                          onChange: filterInterviewList),
                      const SizedBox(height: 30),
                      Expanded(
                        child: ListView.builder(
                          itemCount: interviewsFiltered.length,
                          itemBuilder: (BuildContext context, int index) {
                            final interview = interviewsFiltered[index];
                            return InterviewItemSecondary(interview: interview);
                          },
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(initialIndex: 2),
    );
  }
}
