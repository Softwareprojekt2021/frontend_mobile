import 'package:flutter/material.dart';
import 'package:frontend_mobile/components/chat.dart';
import 'package:frontend_mobile/components/side_bar.dart';
import 'package:frontend_mobile/models/chat.dart';
import 'package:frontend_mobile/services/chat_service.dart';

class Chats extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CreatedChats();
  }
}

class _CreatedChats extends State<Chats> {
  final _chatService = ChatService();
  Future myFuture;

  Widget buildBody(BuildContext context) {
    return FutureBuilder<List<Chat>>(
      future: myFuture,
      builder: (BuildContext context, AsyncSnapshot<List<Chat>> snapshot) {
        if(snapshot.hasData) {
          if(snapshot.data == null || snapshot.data.length == 0) {
            return Align(
              alignment: Alignment.center,
              child: ListTile(
                  title: Text("Keine Chats gefunden", style: TextStyle(fontSize: 20)),
                  subtitle: Text("Du hasst zurzeit keine aktiven Chats"),
                  leading: Icon(Icons.cancel)
              )
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return createChatCard(context, snapshot.data[index]);
              }
            );
          }
        } else {
          return Align(
            alignment: Alignment.center,
            child: snapshot.hasError ?
            Text(snapshot.error.toString(), style: TextStyle(fontSize: 20)) :
            CircularProgressIndicator()
          );
        }
      }
    );
  }

  @override
  void initState() {
    super.initState();
    myFuture = _chatService.fetchChats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: SideBar(),
        appBar: AppBar(
          title: Text("Meine Chats"),
          centerTitle: true,
        ),
        body: buildBody(context)
    );
  }
}