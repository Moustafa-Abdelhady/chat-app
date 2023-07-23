class Message {
  final String message;
  final String id;
  // final String createAt;

  Message(this.message,this.id,);

  factory Message.fromJsson(jsonData) {
    return Message(jsonData['message'],jsonData['id']);
  }
}
