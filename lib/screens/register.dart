import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegisterState();
  }
}

class _RegisterState extends State<Register> {
  final formKey = GlobalKey<FormState>();
  String _email, _password, _passwordRepeat, _firstName, _lastName, _course;
  //??
  String _university;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Registrierung"),
          centerTitle: true,
        ),
        body: Form(
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
                    _email = value,
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
                    _firstName = value,
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
                    _lastName = value,
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
                      _password = value,
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
                    _course = value,
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
          ),
    );
  }

  Future<void> onPressed() async {
    var form = formKey.currentState;

    if (form.validate()) {
      form.save();

    }
  }
}