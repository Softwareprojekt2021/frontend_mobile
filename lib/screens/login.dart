import 'package:flutter/material.dart';
import 'package:frontend_mobile/services/login_service.dart';
import 'package:frontend_mobile/services/store_service.dart';
import 'package:frontend_mobile/stores/token_action.dart';
import 'package:overlay_support/overlay_support.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  final _loginService = LoginService();

  String _email, _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Anmelden"),
          centerTitle: true,
        ),
        body: Center(
          child: Form(
            key: formKey,
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
                    autocorrect: false,
                    validator: (value) =>
                    value.isEmpty ? "E-Mail darf nicht leer sein" : null,
                    onSaved: (value) =>
                      _email = value,
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
                    validator: (value) =>
                      value.length <= 7 ? "Passwort muss mindestens 8 Zeichen lang sein" : null,
                    onSaved: (value) =>
                      _password = value,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                  child: ElevatedButton(
                    onPressed: onPressed,
                    child: Text("Anmelden"),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Future<void> onPressed() async {
    var form = formKey.currentState;

    if (form.validate()) {
      form.save();

      String token;

      try {
        token = await _loginService.login(_email, _password);

        StoreService.store.dispatch(SetTokenAction(token));
        Navigator.pushNamed(context, "/home");
      } catch (error) {
        showSimpleNotification(
          Text("Fehler: " + error.toString()),
          background: Colors.red
        );
      }
    }
  }
}
