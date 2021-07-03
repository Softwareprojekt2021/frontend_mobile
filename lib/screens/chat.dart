import 'dart:async';
import 'dart:developer';

import 'package:bubble/bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend_mobile/components/side_bar.dart';
import 'package:frontend_mobile/models/chat.dart';
import 'package:frontend_mobile/models/message.dart';
import 'package:frontend_mobile/models/user.dart';
import 'package:frontend_mobile/screens/view_offer.dart';
import 'package:frontend_mobile/services/chat_service.dart';
import 'package:frontend_mobile/services/rating_service.dart';
import 'package:frontend_mobile/services/store_service.dart';
import 'package:frontend_mobile/util/notification.dart';

class ChatScreen extends StatefulWidget {
  final int chatId;
  final bool drawBar;

  ChatScreen({this.chatId, this.drawBar});

  @override
  State<StatefulWidget> createState() {
    return _CreatedChatScreen();
  }
}

class _CreatedChatScreen extends State<ChatScreen> {
  final _chatService = ChatService();
  final _ratingService = RatingService();
  final TextEditingController textEditingController = new TextEditingController();
  Stream<Chat> chatStream;
  bool stop = false;

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
          timestamp: DateTime.now().toString().split(".")[0]);

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
      if(stop == true)
        return;

      log(DateTime.now().toString() + " Refreshing Chat..");
      try {
        yield await _chatService.fetchChat(widget.chatId);
      } catch (error) {
        NotificationOverlay.error("Nachrichten können nicht geladen werden: " + error.toString());
      } finally {
        await Future.delayed(interval);
      }
    }
  }

  Widget rateDialog(BuildContext context, User user) {
    return FutureBuilder<int>(
      future: _ratingService.fetchRating(user.id),
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator()
            ),
          );
        } else {
          if (snapshot.hasError) {
            return Scaffold(
                body: Align(
                    alignment: Alignment.center,
                    child: Text(snapshot.error.toString(),
                        style: TextStyle(fontSize: 20))
                )
            );
          } else {
            int rating = snapshot.data;

            Widget buildStar(BuildContext context, setState, int index) {
              return IconButton(
                  onPressed: () {
                    setState(() {
                      rating = index;
                    });
                  },
                  icon: Icon(rating >= index
                      ? Icons.star
                      : Icons.star_border)
              );
            }

            return AlertDialog(
              title: Center(
                child: snapshot.data != 0
                  ? Text("Bewertung ändern von\n" + user.firstName + " " + user.lastName)
                  : Text("Bewerte " + user.firstName + " " + user.lastName),
              ),
              content: StatefulBuilder(
                builder: (context, setState) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      for(int i = 1; i < 6; i++) buildStar(context, setState, i)
                    ],
                  );
                }
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Abbrechen'),
                  onPressed: () => Navigator.pop(context, false),
                ),
                if(snapshot.data != 0)
                  TextButton(
                    child: Text('Löschen'),
                    onPressed: () async {
                      try {
                        await _ratingService.deleteRating(user.id);

                        NotificationOverlay.success("Bewertung gelöscht");
                        Navigator.pop(context, true);
                      } catch(error) {
                        NotificationOverlay.error(error.toString());
                      }
                    }
                  ),
                TextButton(
                  child: Text('OK'),
                  onPressed: () async {
                    if (rating == 0) {
                      NotificationOverlay.error(
                          "Du musst mindestens einen Stern vergeben");
                    } else {
                      try {
                        snapshot.data == 0
                            ? await _ratingService.rateSeller(user.id, rating)
                            : await _ratingService.updateRating(user.id, rating);

                        NotificationOverlay.success("Bewertung abgeschickt");
                        Navigator.pop(context, true);
                      } catch (error) {
                        NotificationOverlay.error(error.toString());
                      }
                    }
                  },
                ),
              ],
            );
          }
        }
    });
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
        return Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    top: 5, bottom: 5, left: 20, right: 20),
                child: Bubble(
                  alignment: Alignment.topCenter,
                  child: Text("Keine Nachrichten"),
                )),
            ),
            buildTextBox(context, snapshot.data),
          ],
        );
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
        return Align(
          alignment: Alignment.center,
          child: CircularProgressIndicator()
        );
      }
    }
  }

  @override
  void dispose() {
    stop = true;
    super.dispose();
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
          drawer: widget.drawBar == true ? SideBar() : null,
          appBar: AppBar(
            title: snapshot.data == null ? Text("Chat") : Text(snapshot.data.offer.title),
            actions: [
              IconButton(
                onPressed: () {
                  if(snapshot.data != null)
                    _showDeleteDialogChat(snapshot.data);
                },
                icon: Icon(Icons.delete),
              ),
              IconButton(
                onPressed: () {
                  if(snapshot.data != null)
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewOffer(offerId: snapshot.data.offer.id)
                        )
                    );
                },
                icon: Icon(Icons.local_offer),
              ),
              IconButton(
                onPressed: () {
                  if(snapshot.data != null)
                    showDialog(
                        context: context,
                        builder: (context) {
                          return rateDialog(context, StoreService.store.state.user.id == snapshot.data.user.id
                              ? snapshot.data.offer.user
                              : snapshot.data.user);
                        }
                    );
                },
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