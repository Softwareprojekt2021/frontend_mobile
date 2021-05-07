import 'dart:async';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:frontend_mobile/models/user.dart';
import 'package:frontend_mobile/services/user_service.dart';
import 'package:frontend_mobile/util/notification.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:overlay_support/overlay_support.dart';

class Register extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegisterState();
  }
}

class _RegisterState extends State<Register> {
  final formKey = GlobalKey<FormState>();
  final _userService = UserService();
  String _passwordRepeat;
  bool _saving = false;
  User _user = new User();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Registrierung"),
          centerTitle: true,
        ),
        body: ModalProgressHUD(
          inAsyncCall: _saving,
          child: Form(
              key: formKey,
              child: ListView(
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
                      !EmailValidator.validate(value) ? "E-Mail ist nicht gültig" : null,
                      onSaved: (value) =>
                      _user.email = value,
                    ),
                  ),
                  Padding(
                    padding:
                    EdgeInsets.only(top: 5, bottom: 5, left: 50, right: 60),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: "Vorname",
                        icon: Icon(Icons.badge),
                      ),
                      autocorrect: false,
                      validator: (value) =>
                      value.isEmpty ? "Vorname darf nicht leer sein" : null,
                      onSaved: (value) =>
                      _user.firstName = value,
                    ),
                  ),
                  Padding(
                    padding:
                    EdgeInsets.only(top: 5, bottom: 5, left: 50, right: 60),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: "Nachname",
                        icon: Icon(Icons.badge),
                      ),
                      autocorrect: false,
                      validator: (value) =>
                      value.isEmpty ? "Nachname darf nicht leer sein" : null,
                      onSaved: (value) =>
                      _user.lastName = value,
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
                        value.length <= 7 ? "Passwort muss mindestens 8 Zeichen haben" : null,
                      onSaved: (value) =>
                        _user.password = value,
                      onChanged: (value) =>
                        _passwordRepeat = value,
                    ),
                  ),
                  Padding(
                    padding:
                    EdgeInsets.only(top: 5, bottom: 5, left: 50, right: 60),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: "Passwort wiederholen",
                        icon: Icon(Icons.lock_rounded),
                      ),
                      obscureText: true,
                      autocorrect: false,
                      validator: (value) {
                        if (value != _passwordRepeat)
                          return "Die Passwörter müssen übereinstimmen";
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding:
                    EdgeInsets.only(top: 5, bottom: 5, left: 50, right: 60),
                    //TODO Add Data
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        labelText: "Deine Uni/FH",
                        icon: Icon(Icons.apartment),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                    EdgeInsets.only(top: 5, bottom: 5, left: 50, right: 60),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: "Dein Studiengang",
                        icon: Icon(Icons.work),
                      ),
                      autocorrect: false,
                      validator: (value) =>
                      value.isEmpty ? "Studiengang darf nicht leer sein" : null,
                      onSaved: (value) =>
                      _user.course = value,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                    child: ElevatedButton(
                      onPressed: onPressed,
                      child: Text("Registrieren"),
                    ),
                  ),
                ],
              ),
            )
        ),
    );
  }

  Future<void> onPressed() async {
    var form = formKey.currentState;

    if (form.validate()) {
      form.save();

      setState(() {
        _saving = true;
      });

      try {
        await _userService.registerUser(_user);

        setState(() {
          _saving = false;
        });

        NotificationOverlay.success("Benutzer wurde erstellt");
        Navigator.pushNamed(context, "/login");
      } catch (error) {
        setState(() {
        _saving = false;
        });

        NotificationOverlay.error(error.toString());
      }
    }
  }
}