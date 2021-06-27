import 'message.dart';
import 'offer.dart';

class Chat {
  int id;
  Offer offer;
  List<Message> messages;

  Chat({this.id, this.offer, this.messages});

  Chat.fromJson(Map<String, dynamic> json)
      : id = json['chat_id'],
        offer = Offer.fromJson(json['offer']),
        messages = json['messages'];

  Map<String, dynamic> toJson() => {
    'chat_id': id,
    'offer': offer,
    'messages': messages,
  };

  Chat clone() => Chat(id: id, offer: offer,
      messages: messages != null
      ? new List<Message>.from(messages)
      : null);
}