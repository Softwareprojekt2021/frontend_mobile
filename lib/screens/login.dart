import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Login"),
          centerTitle: true,
        ),
        body: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(top: 5, bottom: 5, left: 50, right: 60),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "E-Mail",
                      icon: Icon(Icons.email_rounded),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(top: 5, bottom: 5, left: 50, right: 60),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "Passwort",
                      icon: Icon(Icons.lock_rounded),
                    ),
                    obscureText: true,
                    autocorrect: false,
                    validator: (value) {
                      if (value.isEmpty) return "Bitte ein Passwort eingeben";
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                  child: ElevatedButton(
                    onPressed: () async {

                    },
                    child: Text("Login"),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
