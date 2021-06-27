import 'dart:async';
import 'dart:developer';

import 'package:bubble/bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend_mobile/models/chat.dart';
import 'package:frontend_mobile/models/message.dart';
import 'package:frontend_mobile/services/chat_service.dart';
import 'package:frontend_mobile/services/store_service.dart';
import 'package:frontend_mobile/util/notification.dart';

class ChatScreen extends StatefulWidget {
  final int chatId;

  ChatScreen({this.chatId});

  @override
  State<StatefulWidget> createState() {
    return _CreatedChatScreen();
  }
}

class _CreatedChatScreen extends State<ChatScreen> {
  final _chatService = ChatService();
  final TextEditingController textEditingController = new TextEditingController();
  Stream<Chat> chatStream;

  Future<void> _deleteChat(Chat chat) async {
    try {
      await _chatService.deleteChat(chat.id);

      Navigator.pushNamed(context, "/chats");
      NotificationOverlay.success("Chat wurde gelöscht");
    } catch (error) {
      NotificationOverlay.error(error.toString());
    }
  }

  Future<void> _deleteMessage(Chat chat, Message message) async {
    try {
      await _chatService.deleteMessage(chat.id, message.id);

      setState(() {
        chat.messages.remove(message);
      });

      NotificationOverlay.success("Nachricht wurde gelöscht");
    } catch (error) {
      NotificationOverlay.error(error.toString());
    }
  }

  Future<void> _sendMessage(Chat chat) async {
    if(textEditingController.text.length != 0) {

      Message message = new Message(
          message: textEditingController.text,
          userId: StoreService.store.state.user.id,
          timestamp: DateTime.now().toString().split(".")[0],
          offerId: chat.offerId);

      try {
        await _chatService.sendMessage(chat.id, message);

        if(chat.messages == null) {
          chat.messages = [];
        }

        setState(() {
          chat.messages.add(message);
        });

        textEditingController.clear();
      } catch (error) {
        NotificationOverlay.error(error.toString());
      }
    }
  }

  void _showDeleteDialogMessage(Chat chat, Message message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Nachricht löschen"),
            content: Text("Willst du wirklich diese Nachricht löschen?"),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () async {
                  Navigator.pop(context, true);
                  await _deleteMessage(chat, message);
                },
              ),
              TextButton(
                child: Text("Abbrechen"),
                onPressed: () => Navigator.pop(context, false),
              )
            ],
          );
        }
    );
  }

  void _showDeleteDialogChat(Chat chat) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Chat löschen"),
            content: Text("Willst du wirklich den Chat löschen?"),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () async {
                  Navigator.pop(context, true);
                  await _deleteChat(chat);
                },
              ),
              TextButton(
                child: Text("Abbrechen"),
                onPressed: () => Navigator.pop(context, false),
              )
            ],
          );
        }
    );
  }

  Stream<Chat> _refreshChat(Duration interval) async* {
    while (true) {
      log(DateTime.now().toString() + " Refreshing Chat..");
      yield await _chatService.fetchChat(widget.chatId);
      await Future.delayed(interval);
    }
  }

  Widget buildTextBox(BuildContext context, Chat chat) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        child: Row(
          children: <Widget>[
            // Text input
            Flexible(
              child: Container(
                margin: new EdgeInsets.symmetric(horizontal: 10.0),
                child: TextField(
                  style: TextStyle(fontSize: 15.0),
                  controller: textEditingController,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Schreibe eine Nachricht',
                  ),
                ),
              ),
            ),
            Container(
              margin: new EdgeInsets.symmetric(horizontal: 8.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: () {
                  _sendMessage(chat);
                },
              ),
            ),
          ],
        ),
        width: double.infinity,
        height: 50.0,
        decoration: new BoxDecoration(
            border: new Border(top: new BorderSide(width: 0.5)),
            color: Colors.white),
      )
    );
  }

  Widget buildBody(BuildContext context, AsyncSnapshot<Chat> snapshot) {
    if(snapshot.hasData) {
      if(snapshot.data.messages == null || snapshot.data.messages.length == 0) {
        return Padding(
          padding: EdgeInsets.only(
              top: 5, bottom: 5, left: 20, right: 20),
          child: Bubble(
            alignment: Alignment.center,
            child: Text("Keine Nachrichten"),
          ));
      } else {
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
              itemCount: snapshot.data.messages.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                if (snapshot.data.messages[index].userId ==
                    StoreService.store.state.user.id) {
                  return Padding(
                      padding: EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
                      child: Column(children: [
                        Bubble(
                          alignment: Alignment.centerRight,
                          color: Colors.lightBlue,
                          nip: BubbleNip.rightTop,
                          child: Text(
                            snapshot.data.messages[index].message,
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 1),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(snapshot.data.messages[index].timestamp,
                                    style: TextStyle(fontSize: 10)),
                                IconButton(
                                    onPressed: () {
                                      _showDeleteDialogMessage(snapshot.data ,snapshot.data.messages[index]);
                                    },
                                    icon: Icon(Icons.delete, size: 20))
                              ]
                          ),
                        ),
                      ],
                      )
                  );
                } else {
                  return Padding(
                      padding: EdgeInsets.only(
                          top: 5, bottom: 5, left: 20, right: 20),
                      child: Column(children: [
                        Bubble(
                          alignment: Alignment.centerLeft,
                          nip: BubbleNip.leftTop,
                          child: Text(
                            snapshot.data.messages[index].message,
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(snapshot.data.messages[index].timestamp,
                                style: TextStyle(fontSize: 10)),
                          ),
                        ),
                      ]));
                }
              })
              ),
              buildTextBox(context, snapshot.data),
          ],
        );
      }
    } else {
      if(snapshot.hasError) {
        return SnackBar(
            content: Text(snapshot.error.toString())
        );
      } else {
        return CircularProgressIndicator();
      }
    }
  }

  @override
  initState() {
    super.initState();
    chatStream = _refreshChat(Duration(seconds: 5));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Chat>(
      stream: chatStream,
      builder: (BuildContext context, AsyncSnapshot<Chat> snapshot) {
        return Scaffold(
            appBar: AppBar(
              title: snapshot.data == null ? Text("Chat") : Text(snapshot.data.title),
              actions: [
                IconButton(
                  onPressed: () {
                    _showDeleteDialogChat(snapshot.data);
                  },
                  icon: Icon(Icons.delete),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.star_border),
                ),
              ],
            ),
            body: buildBody(context, snapshot)
        );
      }
    );
  }
}