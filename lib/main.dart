import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:frontend_mobile/screens/home.dart';
import 'package:frontend_mobile/screens/login.dart';
import 'package:frontend_mobile/services/store_service.dart';
import 'package:frontend_mobile/stores/global_state.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:redux/redux.dart';

void main() async {
  StoreService.setupStore();

  runApp(MyApp(store: StoreService.store));
}

class MyApp extends StatelessWidget {
  final Store<GlobalState> store;

  MyApp({Key key, this.store}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StoreProvider<GlobalState>(
    store: store,
      child: OverlaySupport.global(
        child: MaterialApp(
          title: 'Studibörse',
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.blue,
          ),
          home: Home(),
          routes: {
            '/login': (context) => Login(),
            '/home': (context) => Home()
          },
        )
      )
    );
  }
}
