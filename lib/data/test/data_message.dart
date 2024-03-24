import 'package:studenthub/models/index.dart';

List<MessageModel> dataMessage = [
  MessageModel('Alice', 'Hey, how\'s it going?', DateTime.now().subtract(const Duration(minutes: 10))),
  MessageModel('Bob', 'Not bad, thanks. What about you?', DateTime.now().subtract(const Duration(minutes: 8))),
  MessageModel('Alice', 'I\'m doing great, thanks for asking.', DateTime.now().subtract(const Duration(minutes: 5))),
  MessageModel('Charlie', 'Hey everyone, what\'s up?', DateTime.now().subtract(const Duration(minutes: 3))),
  MessageModel('David', 'Not much, just chilling.', DateTime.now().subtract(const Duration(minutes: 1))),
  MessageModel('Alice', 'Did you guys see the new movie?', DateTime.now().subtract(const Duration(hours: 2))),
  MessageModel('Charlie', 'Yeah, I watched it yesterday.', DateTime.now().subtract(const Duration(hours: 1))),
  MessageModel('David', 'I haven\'t had the chance to see it yet.', DateTime.now().subtract(const Duration(hours: 1, minutes: 30))),
  MessageModel('Alice', 'It\'s really good, you should check it out.', DateTime.now().subtract(const Duration(hours: 1, minutes: 15))),
  MessageModel('Bob', 'I heard it\'s amazing, definitely on my list.', DateTime.now().subtract(const Duration(hours: 1, minutes: 10))),
  MessageModel('Charlie', 'I might watch it tonight. Wanna come over and watch it together?', DateTime.now().subtract(const Duration(hours: 1, minutes: 5))),
  MessageModel('David', 'Let me know how it is!', DateTime.now().subtract(const Duration(hours: 1))),
  MessageModel('Alice', 'Sure thing!', DateTime.now().subtract(const Duration(minutes: 45))),
  MessageModel('Bob', 'I\'m heading out for lunch, anyone wants to join?', DateTime.now().subtract(const Duration(minutes: 30))),
  MessageModel('Charlie', 'I\'m in!', DateTime.now().subtract(const Duration(minutes: 25))),
  MessageModel('David', 'I\'m busy, maybe next time.', DateTime.now().subtract(const Duration(minutes: 20))),
  MessageModel('Alice', 'I\'ll join you guys.', DateTime.now().subtract(const Duration(minutes: 15))),
  MessageModel('Bob', 'Great! Let\'s meet at the usual spot.', DateTime.now().subtract(const Duration(minutes: 10))),
  MessageModel('Charlie', 'See you there!', DateTime.now().subtract(const Duration(minutes: 5))),
  MessageModel('David', 'Alright, I have to head out. Enjoy your lunch!', DateTime.now()),
];