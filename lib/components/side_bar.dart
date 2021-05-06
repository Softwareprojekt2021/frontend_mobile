import 'package:flutter/material.dart';

class SideBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: Text("Login"),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/login");
            },
          ),
        ],
      ),
    );
  }
}
