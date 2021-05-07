import 'package:flutter/material.dart';
import 'package:frontend_mobile/services/store_service.dart';
import 'package:frontend_mobile/util/notification.dart';
import 'package:overlay_support/overlay_support.dart';

class SideBar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SideBarState();
  }
}

class _SideBarState extends State<SideBar> {
  //TODO Debug
  final String fName = "Max";
  final String lName = "Mustermann";

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: StoreService.store.state.user == null ? ListView(
        children: [
          ListTile(
            title: Text("Anmelden"),
            trailing: Icon(Icons.login),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/login");
            },
          ),
          ListTile(
            title: Text("Registrieren"),
            trailing: Icon(Icons.app_registration),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/register");
            },
          ),
        ],
      ) : ListView(
        children: [
          UserAccountsDrawerHeader(
            //TODO If Backend has been implemented
            accountEmail: Text(StoreService.store.state.user.email),
            //accountName: Text(StoreService.store.state.user.firstName + " " + StoreService.store.state.user.lastName),
            accountName: Text(fName + " " + lName),
            currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 70,
                child: Text(
                  //TODO Placeholder
                  fName[0] + lName[0],
                  textScaleFactor: 2,
                  style: TextStyle(color: Colors.white),
                )
            )
          ),
          ListTile(
            title: Text("Abmelden"),
            trailing: Icon(Icons.logout),
            onTap: () {
              StoreService.setupStore();
              Navigator.pushNamed(context, "/home");
              NotificationOverlay.success("Erfolgreich abgemeldet");
            },
          ),
        ],
      ),
    );
  }
}
