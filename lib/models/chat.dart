import 'package:frontend_mobile/models/user.dart';
import 'message.dart';

class Chat {
  int id, offerId;
  String title, picture;
  List<Message> messages;
  User user;

  Chat({this.id, this.offerId, this.title, this.picture, this.user, this.messages});

  Chat.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        offerId = json['offer_id'],
        title = json['title'],
        picture = json['picture'],
        user = json['user'],
        messages = json['messages'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'offer_id': offerId,
    'title': title,
    'picture': picture,
    'user': user,
    'messages': messages,
  };

  Chat clone() => Chat(id: id, offerId: offerId, title: title, picture: picture, user: user,
      messages: messages != null
      ? new List<Message>.from(messages)
      : null);
}