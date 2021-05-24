
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:frontend_mobile/screens/create_offer.dart';
import 'package:frontend_mobile/screens/created_offers.dart';
import 'package:frontend_mobile/screens/edit_offer.dart';
import 'package:frontend_mobile/screens/home.dart';
import 'package:frontend_mobile/screens/login.dart';
import 'package:frontend_mobile/screens/profile.dart';
import 'package:frontend_mobile/screens/register.dart';
import 'package:frontend_mobile/services/http_service.dart';
import 'package:frontend_mobile/services/store_service.dart';
import 'package:frontend_mobile/stores/global_state.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:redux/redux.dart';

void main() async {
  StoreService.setupStore();
  HttpService.setup();

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
            primarySwatch: Colors.blue,
          ),
          home: Home(),
          routes: {
            '/login': (context) => Login(),
            '/home': (context) => Home(),
            '/register': (context) => Register(),
            '/profile': (context) => Profile(),
            '/createOffer': (context) => CreateOffer(),
            '/createdOffers': (context) => CreatedOffers(),
            '/editOffer': (context) => EditOffer(),
          },
        )
      )
    );
  }
}
