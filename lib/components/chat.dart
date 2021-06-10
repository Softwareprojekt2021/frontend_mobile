import 'package:flutter/material.dart';
import 'package:frontend_mobile/components/avatar.dart';
import 'package:frontend_mobile/models/chat.dart';

Widget createChatCard(BuildContext context, Chat chat) {
  return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(chat.title),
            subtitle: Text("Anbieter: " + chat.user.firstName + " " + chat.user.lastName),
            leading: setupAvatar(chat.user, 30.0),
            trailing: IconButton(
              icon: Icon(Icons.message, color: Colors.blue),
              onPressed: () {},
            ),
          ),
        ],
      )
  );
}