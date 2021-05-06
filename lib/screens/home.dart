import 'package:flutter/material.dart';
import 'package:frontend_mobile/components/side_bar.dart';
import 'package:frontend_mobile/services/store_service.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: SideBar(),
        appBar: AppBar(
          title: Text("Startseite"),
          centerTitle: true,
        ),
        body: Center(
            child: ElevatedButton(
              onPressed: () {
                print(StoreService.store.state.token);
                print(StoreService.store.state.user.email);
              },
              child: Text("DEBUG"),
            ),
          )
    );
  }
}
