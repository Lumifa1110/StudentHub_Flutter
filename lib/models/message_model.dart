class MessageModel {
  late String sender;
  late String receiver;
  late String content;
  late DateTime time;

  MessageModel(
    this.sender,
    this.receiver,
    this.content,
    this.time
  );
}