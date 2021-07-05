import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:frontend_mobile/components/side_bar.dart';
import 'package:frontend_mobile/models/user.dart';
import 'package:frontend_mobile/services/http_service.dart';
import 'package:frontend_mobile/services/store_service.dart';
import 'package:frontend_mobile/services/user_service.dart';
import 'package:frontend_mobile/components/avatar.dart';
import 'package:frontend_mobile/stores/user_action.dart';
import 'package:frontend_mobile/util/notification.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'home.dart';

class Profile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfileState();
  }
}

class _ProfileState extends State<Profile> {
  final formKey = GlobalKey<FormState>();
  final picker = ImagePicker();
  final _userService = UserService();

  String _passwordRepeat;
  bool _saving = false;
  //Clone Object because Flutter would instead call by Reference
  User _user = StoreService.store.state.user.clone();
  var _universities = <DropdownMenuItem>[];

  Future <void> _loadUniversities() async {
    try {
      List<String> _fetchedUniversities = await _userService.fetchUniversities();

      for (String university in _fetchedUniversities) {
        setState(() {
          _universities.add(DropdownMenuItem(child: Text(university), value: university));
        });
      }
    } catch(error) {
      NotificationOverlay.error("Unis/FHs können nicht geladen werden: " + error.toString());
    }
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        final bytes = File(pickedFile.path).readAsBytesSync();
        _user.profilePicture = base64Encode(bytes);
      }
    });
  }

  void _showDeleteDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Profil löschen"),
            content: Text("Willst du wirklich dein Profil löschen?"),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () async {
                  Navigator.pop(context, true);
                  await delete();
                },
              ),
              TextButton(
                child: Text("Abbrechen"),
                onPressed: () => Navigator.pop(context, false),
              )
            ],
          );
        }
    );
  }

  Future<void> save() async {
    var form = formKey.currentState;

    FocusScope.of(context).unfocus();

    if (form.validate()) {
      form.save();

      setState(() {
        _saving = true;
      });

      try {
        await _userService.updateUser(_user);

        StoreService.store.dispatch(SetUserAction(_user));

        NotificationOverlay.success("Profil wurde aktualisiert");
      } catch (error) {
        NotificationOverlay.error(error.toString());
      } finally {
        setState(() {
          _saving = false;
        });
      }
    }

  }

  Future<void> delete() async {
    setState(() {
      _saving = true;
    });

    try {
      await _userService.deleteAccount();

      setState(() {
        _saving = false;
      });

      StoreService.setupStore();
      HttpService.removeAuthHeader();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => Home()
          ),
          ModalRoute.withName("/home")
      );
      NotificationOverlay.success("Profil wurde gelöscht");
    } catch (error) {
      setState(() {
        _saving = false;
      });

      NotificationOverlay.error(error.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUniversities();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _saving,
      child: Scaffold(
      drawer: SideBar(),
      appBar: AppBar(
        title: Text("Dein Profil"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                _showDeleteDialog();
              },
              icon: Icon(Icons.delete)
          ),
        ],
      ),
      body: Form(
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
                            tooltip: 'Bild hinzufügen',
                            onPressed: getImage,
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
              ],
            ),
          )
      ),
    );
  }
}