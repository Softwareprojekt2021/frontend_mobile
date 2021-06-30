import 'package:frontend_mobile/models/user.dart';

import 'message.dart';
import 'offer.dart';

class Chat {
  int id;
  Offer offer;
  User user;
  List<Message> messages;

  Chat({this.id, this.offer, this.user, this.messages});

  Chat.fromJson(Map<String, dynamic> json)
      : id = json['chat_id'],
        offer = Offer.fromJson(json['offer']),
        user = User.fromJson(json['user']),
        messages = json['conversation'] == null
            ? null
            : json['conversation'].map((msg) => Message.fromJson(msg)).toList().cast<Message>();

  Map<String, dynamic> toJson() => {
    'chat_id': id,
    'offer': offer,
    'conversation': messages,
  };

  Chat clone() => Chat(id: id, offer: offer, user: user,
      messages: messages != null
      ? new List<Message>.from(messages)
      : null);
}