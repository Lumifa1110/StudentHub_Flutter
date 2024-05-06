// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:studenthub/components/authappbar.dart';
import 'package:studenthub/components/custombottomnavbar.dart';
import 'package:studenthub/components/notification/notification_item.dart';
import 'package:studenthub/models/index.dart';
import 'package:studenthub/services/index.dart';
import 'package:studenthub/utils/colors.dart';
import 'package:studenthub/utils/font.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late IO.Socket socket;
  late int userId;
  List<NotificationModel> notifications = [];

  @override
  void initState() {
    super.initState();
    loadUserId();
    fetchNotification();
    socketConnect();
  }

  Future<void> loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('userid')!;
    });
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

    socket.connect();

    socket.onConnect((data) {
      print('Socket connected.');
    });

    socket.on('NOTI_$userId', (data) {
      final receivedNotification = NotificationModel.fromJson(data['notification']);
      setState(() {
        notifications.add(receivedNotification);
      });
    });

    socket.onConnectError((data) => print('Socket connect error: $data'));

    socket.onError((data) => print('Socker error: $data'));
  }

  void fetchNotification() async {
    final response = await DefaultService.getNotification(userId);
    setState(() {
      notifications = response['result']
          .where((json) => json['notifyFlag'] == '0')
          .map<NotificationModel>((json) => NotificationModel.fromJson(json))
          .toList();
    });
  }

  void handleReadNotification(int notificationId) {
    DefaultService.readNotification(notificationId);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: const AuthAppBar(canBack: false, title: 'Notification'),
      backgroundColor: AppColor.background,
      body: SingleChildScrollView(
          child: Column(
        children: [
          if (notifications.isEmpty)
            const Center(
              child: Column(
                children: [
                  SizedBox(height: 100),
                  FaIcon(
                    FontAwesomeIcons.bell,
                    color: AppColor.primary,
                    size: 140,
                  ),
                  SizedBox(height: 20),
                  Text("You don't have any notification",
                      style: TextStyle(
                          color: AppFonts.primaryColor,
                          fontSize: AppFonts.h2FontSize,
                          fontWeight: FontWeight.w500)),
                ],
              ),
            )
          else
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                      key: ValueKey(notifications[index]),
                      onDismissed: (direction) {
                        handleReadNotification(notifications[index].id);
                        setState(() {
                          notifications.remove(notifications[index]);
                        });
                      },
                      child: NotificationItem(
                        notification: notifications[index],
                      ));
                })
        ],
      )),
      bottomNavigationBar: const CustomBottomNavBar(initialIndex: 3),
    );
  }
}
