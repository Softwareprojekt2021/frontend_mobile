class Message {
  int id, userId;
  String message, timestamp;

  Message({this.id, this.message, this.timestamp, this.userId});

  Message.fromJson(Map<String, dynamic> json)
      : id = json['message_id'],
        message = json['text'],
        timestamp = json['timestamp'],
        userId = json['user_id'];

  Map<String, dynamic> toJson() => {
    'message_id': id,
    'text': message,
    'timestamp': timestamp,
    'user_id': userId,
  };

  Message clone() => Message(id: id, message: message, timestamp: timestamp, userId: userId);
}