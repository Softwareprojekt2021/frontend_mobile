import 'package:flutter/material.dart';
import 'package:frontend_mobile/services/store_service.dart';
import 'package:frontend_mobile/components/avatar.dart';
import 'package:frontend_mobile/util/notification.dart';

class SideBar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SideBarState();
  }
}

class _SideBarState extends State<SideBar> {
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
          )
        ],
      ) : ListView(
        children: [
          UserAccountsDrawerHeader(
            accountEmail: Text(StoreService.store.state.user.email),
            accountName: Text(StoreService.store.state.user.firstName + " " + StoreService.store.state.user.lastName),
            currentAccountPicture: setupAvatar(StoreService.store.state.user, 20)
          ),
          ListTile(
            title: Text("Startseite"),
            trailing: Icon(Icons.home),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/home");
            },
          ),
          ListTile(
            title: Text("Meine Angebote"),
            trailing: Icon(Icons.local_offer),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/createdOffers");
            },
          ),
          ListTile(
            title: Text("Profil"),
            trailing: Icon(Icons.account_circle),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/profile");
            },
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
