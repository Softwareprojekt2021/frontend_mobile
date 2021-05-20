import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:frontend_mobile/models/user.dart';
import 'package:frontend_mobile/services/login_service.dart';
import 'package:frontend_mobile/services/store_service.dart';
import 'package:frontend_mobile/services/user_service.dart';
import 'package:frontend_mobile/stores/token_action.dart';
import 'package:frontend_mobile/stores/user_action.dart';
import 'package:frontend_mobile/util/notification.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  final _loginService = LoginService();
  final _userService = UserService();
  bool _saving = false;

  String _email, _password;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _saving,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Anmelden"),
          centerTitle: true,
        ),
        body: Center(
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
                        _email = value,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(top: 5, bottom: 5, left: 50, right: 60),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: "Passwort",
                        icon: Icon(Icons.lock),
                      ),
                      obscureText: true,
                      autocorrect: false,
                      validator: (value) =>
                        value.length <= 7 ? "Passwort muss mindestens 8 Zeichen haben" : null,
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
          )
        )
    );
  }

  Future<void> onPressed() async {
    var form = formKey.currentState;

    FocusScope.of(context).unfocus();

    if (form.validate()) {
      form.save();
      setState(() {
        _saving = true;
      });

      try {
        //TODO Remove if Backend is working
        if (_email == "test@test.de" && _password == "12345678") {
          //DEBUG
          User debugUser = new User(id: 0, email: "test@test.de", firstName: "Max", lastName: "Mustermann", course: "Informatik", university: "FH Bielefeld (Minden)", admin: 0, profilePicture: "https://ih1.redbubble.net/image.450287996.4220/flat,1000x1000,075,f.u1.jpg");

          StoreService.store.dispatch(SetUserAction(debugUser));
          StoreService.store.dispatch(SetTokenAction("aaaaaaaaaaaaaaaaaaaaaaaaaa"));
        } else {
          String token = await _loginService.login(_email, _password);
          StoreService.store.dispatch(SetTokenAction(token));

          User user = await _userService.fetchUser();
          StoreService.store.dispatch(SetUserAction(user));
        }

        setState(() {
          _saving = false;
        });

        NotificationOverlay.success("Erfolgreich angemeldet");
        Navigator.pushNamed(context, "/home");
      } catch (error) {
        setState(() {
          _saving = false;
        });

        NotificationOverlay.error(error.toString());
      }
    }
  }
}
