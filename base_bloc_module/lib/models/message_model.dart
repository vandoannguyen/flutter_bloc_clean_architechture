class MessageModel {
  String mess;
  MessageType messageType;

  MessageModel({
    required this.mess,
    this.messageType = MessageType.success,
  });
}

enum MessageType {
  error,
  success,
  waring,
}
