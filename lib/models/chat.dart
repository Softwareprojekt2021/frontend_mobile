import 'package:frontend_mobile/models/user.dart';

import 'message.dart';

class Chat {
  int id, offerId;
  String title;
  List<Message> messages;
  User user;

  Chat({this.id, this.offerId, this.title, this.user, this.messages});

  Chat.fromJson(Map<String, dynamic> json)
      : id = int.parse(json['id']),
        offerId = json['offer_id'],
        title = json['title'],
        user = json['user'],
        messages = json['messages'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'offer_id': offerId,
    'title': title,
    'user': user,
    'messages': messages,
  };

  Chat clone() => Chat(id: id, offerId: offerId, title: title, user: user,
      messages: messages != null
      ? new List<Message>.from(messages)
      : null);
}