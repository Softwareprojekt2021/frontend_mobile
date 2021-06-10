import 'package:flutter/material.dart';
import 'package:frontend_mobile/components/chat.dart';
import 'package:frontend_mobile/components/side_bar.dart';
import 'package:frontend_mobile/models/chat.dart';
import 'package:frontend_mobile/services/chat_service.dart';
import 'package:frontend_mobile/util/notification.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Chats extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CreatedChats();
  }
}

class _CreatedChats extends State<Chats> {
  final _chatService = ChatService();

  List<Chat> _chats;
  bool _loading = false;

  Future<void> _loadChats() async {
    await _chatService.fetchChats().then((result) {
      setState(() {
        _chats = result;
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
      _loadChats();
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
          drawer: SideBar(),
          appBar: AppBar(
            title: Text("Meine Chats"),
            centerTitle: true,
          ),
          body:
          _chats == null || _chats.length == 0 ? ListTile(
              title: Text("Keine Chats gefunden", style: TextStyle(fontSize: 20)),
              subtitle: Text("Du hasst zurzeit keine aktiven Chats"),
              leading: Icon(Icons.cancel)
          )
              : ListView.builder(
              itemCount: _chats.length,
              itemBuilder: (context, index) {
                return createChatCard(context, _chats[index]);
              }
          ),
        )
    );
  }
}