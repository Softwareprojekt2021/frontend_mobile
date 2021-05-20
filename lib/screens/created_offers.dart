import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../components/side_bar.dart';

class CreatedOffers extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CreatedOffers();
  }
}

class _CreatedOffers extends State<CreatedOffers> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _loading,
      child: Scaffold(
        drawer: SideBar(),
        appBar: AppBar(
          title: Text("Meine erstellten Angebote"),
          centerTitle: true,
        ),
        body: ListView (
          children: [

          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, "/createOffer"),
          tooltip: 'Increment Counter',
          child: const Icon(Icons.add),
        ),
      )
    );
  }
}