import 'dart:async';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:frontend_mobile/components/side_bar.dart';
import 'package:frontend_mobile/models/user.dart';
import 'package:frontend_mobile/services/store_service.dart';
import 'package:frontend_mobile/util/avatar.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Profile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfileState();
  }
}

class _ProfileState extends State<Profile> {
  final formKey = GlobalKey<FormState>();
  String _passwordRepeat;
  bool _saving = false;
  //Clone Object because Flutter would instead call by Reference
  User _user = StoreService.store.state.user.clone();
  var _universities = <DropdownMenuItem>[];

  //TODO Get Data from Backend
  _loadUniversities() {
    setState(() {
      _universities.add(DropdownMenuItem(child: Text("FH Bielefeld"), value: "FH Bielefeld"));
      _universities.add(DropdownMenuItem(child: Text("FH Bielefeld (Minden)"), value: "FH Bielefeld (Minden)"));
      _universities.add(DropdownMenuItem(child: Text("Uni Bielefeld"), value: "Uni Bielefeld"));
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUniversities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBar(),
      appBar: AppBar(
        title: Text("Dein Profil"),
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
                  EdgeInsets.only(top: 10, bottom: 5, left: 50, right: 60),
                  child: Column(
                    children: [
                      setupAvatar(_user, 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.upload_rounded, color: Colors.blue),
                            tooltip: 'Bild hochladen',
                            onPressed: () {

                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.blue),
                            tooltip: 'Bild löschen',
                            onPressed: () {
                              setState(() {
                                _user.profilePicture = null;
                              });
                            },
                          )
                        ],
                      )
                    ]
                  ),
                ),
                Padding(
                  padding:
                  EdgeInsets.only(top: 5, bottom: 5, left: 50, right: 60),
                  child: TextFormField(
                    initialValue: _user.email,
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
                    initialValue: _user.firstName,
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
                    initialValue: _user.lastName,
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
                    value.length <= 7 && value.isNotEmpty ? "Passwort muss mindestens 8 Zeichen haben" : null,
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
                      if (value != _passwordRepeat && _passwordRepeat != null)
                        return "Die Passwörter müssen übereinstimmen";
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding:
                  EdgeInsets.only(top: 5, bottom: 5, left: 50, right: 60),
                  child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        icon: Icon(Icons.apartment),
                      ),
                      items: _universities,
                      value: _user.university,
                      hint: Text("Deine Uni/FH"),
                      validator: (value) =>
                      value == null ? "Uni/FH darf nicht leer sein" : null,
                      onChanged: (value) {
                        setState(() {
                          _user.university = value;
                        });
                      }
                  ),
                ),
                Padding(
                  padding:
                  EdgeInsets.only(top: 5, bottom: 5, left: 50, right: 60),
                  child: TextFormField(
                    initialValue: _user.course,
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
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                  child: ElevatedButton(
                    onPressed: save,
                    child: Text("Änderungen speichern"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                  child: ElevatedButton(
                    onPressed: delete,
                    child: Text("Profil löschen"),
                  ),
                ),
              ],
            ),
          )
      ),
    );
  }

  Future<void> save() async {
    var form = formKey.currentState;

    if (form.validate()) {
      form.save();

      /*
      setState(() {
        _saving = true;
      });
       */

    }
  }

  Future<void> delete() async {

  }
}