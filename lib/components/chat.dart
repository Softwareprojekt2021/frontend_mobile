import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend_mobile/models/chat.dart';
import 'package:frontend_mobile/screens/chat.dart';

Widget createChatCard(BuildContext context, Chat chat) {
  return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(chat.title),
            subtitle: Text(chat.user.firstName + " " + chat.user.lastName),
            leading: chat.picture == null
                ? CircleAvatar(
                child: Icon(
                    Icons.image,
                )
            )
                : CircleAvatar(
              backgroundImage: Image.memory(
                  Base64Codec().decode(chat.picture)).image,
            ),
            trailing: IconButton(
              icon: Icon(Icons.message, color: Colors.blue),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(chatId: chat.id)
                    )
                );
              },
            ),
          ),
        ],
      )
  );
}