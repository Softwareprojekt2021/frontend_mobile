class Message {
  int id, userId, offerId;
  String message, timestamp;

  Message({this.id, this.message, this.timestamp, this.offerId, this.userId});

  Message.fromJson(Map<String, dynamic> json)
      : id = int.parse(json['id']),
        message = json['message'],
        timestamp = json['timestamp'],
        userId = json['user_id'],
        offerId = json['offer_id'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'message': message,
    'timestamp': timestamp,
    'user_id': userId,
    'offer_id': userId,
  };

  Message clone() => Message(id: id, message: message, timestamp: timestamp, userId: userId, offerId: offerId);
}