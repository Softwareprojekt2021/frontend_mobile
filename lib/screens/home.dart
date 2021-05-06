import 'package:flutter/material.dart';
import 'package:frontend_mobile/components/side_bar.dart';

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

        ));
  }
}
