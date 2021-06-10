import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:frontend_mobile/models/chat.dart';
import 'package:frontend_mobile/services/chat_service.dart';
import 'package:frontend_mobile/services/store_service.dart';
import 'package:frontend_mobile/util/notification.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

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
  final TextEditingController textEditingController =
      new TextEditingController();

  Chat _chat;
  bool _loading = false;

  Future<void> _loadChat() async {
    await _chatService.fetchChat(widget.chatId).then((result) {
      setState(() {
        _chat = result;
      });
    });
  }

  @override
  initState() {
    super.initState();

    setState(() {
      _loading = true;
    });

    try {
      _loadChat();
    } catch (error) {
      NotificationOverlay.error(error.toString());
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _loading,
      child: Scaffold(
          appBar: AppBar(
            title: _chat == null ? Text("Chat") : Text(_chat.title),
            actions: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.delete),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.star_border),
              ),
            ],
          ),
          body: ListView(
            children: [
              _chat == null ||
                      _chat.messages == null ||
                      _chat.messages.length == 0
                  ? Padding(
                      padding: EdgeInsets.only(
                          top: 5, bottom: 5, left: 20, right: 20),
                      child: Bubble(
                        alignment: Alignment.center,
                        child: Text("Noch keine Nachrichten"),
                      ))
                  : ListView.builder(
                      itemCount: _chat.messages.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        if (_chat.messages[index].userId ==
                            StoreService.store.state.user.id) {
                          return Padding(
                              padding: EdgeInsets.only(
                                  top: 5, bottom: 5, left: 20, right: 20),
                              child: Column(children: [
                                Bubble(
                                  alignment: Alignment.centerRight,
                                  color: Colors.lightBlue,
                                  nip: BubbleNip.rightTop,
                                  child: Text(
                                    _chat.messages[index].message,
                                    style: TextStyle(fontSize: 17),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(_chat.messages[index].timestamp,
                                        style: TextStyle(fontSize: 10)),
                                  ),
                                ),
                              ]));
                        } else {
                          return Padding(
                              padding: EdgeInsets.only(
                                  top: 5, bottom: 5, left: 20, right: 20),
                              child: Column(children: [
                                Bubble(
                                  alignment: Alignment.centerLeft,
                                  nip: BubbleNip.leftTop,
                                  child: Text(
                                    _chat.messages[index].message,
                                    style: TextStyle(fontSize: 17),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(_chat.messages[index].timestamp,
                                        style: TextStyle(fontSize: 10)),
                                  ),
                                ),
                              ]));
                        }
                      }),
              Container(
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

                    // Send Message Button
                    Container(
                      margin: new EdgeInsets.symmetric(horizontal: 8.0),
                      child: new IconButton(
                        icon: new Icon(Icons.send),
                        onPressed: () => {},
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
            ],
          )),
    );
  }
}
