import 'dart:async';
import 'dart:convert';
import 'package:frontend_mobile/models/user.dart';
import 'package:frontend_mobile/services/store_service.dart';
import 'package:frontend_mobile/util/app_url.dart';
import 'package:http/http.dart';

//TODO Backend
class UserService {

  fetchUser() async {
    //Mockup
    if(StoreService.store.state.token == "aaaaaaaaaaaaaaaaaaaaaaaaaa")
      return new User(
          id: 0,
          email: "test@test.de",
          firstName: "Max",
          lastName: "Mustermann",
          course: "Informatik",
          university: "FH Bielefeld (Minden)",
          admin: 0,
          profilePicture: "https://ih1.redbubble.net/image.450287996.4220/flat,1000x1000,075,f.u1.jpg");

    try {
      Response response = await get(
        Uri.parse(AppUrl.user),
        headers: {'Authorization': 'Bearer ' + StoreService.store.state.token},
      ).timeout(const Duration(seconds: 10));

      if(response.statusCode != 200) {
        throw(response.body);
      }

      return User.fromJson(json.decode(response.body));
    } on TimeoutException {
      throw("Server ist nicht erreichbar");
    }
  }

  registerUser(User user) async {
    try {
      Response response = await post(
        Uri.parse(AppUrl.user),
        body: json.encode(user.toJson()),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if(response.statusCode == 409) {
        throw("Ein Benutzer mit der E-Mail wurde bereits angelegt");
      } else if(response.statusCode != 200) {
        throw(response.body);
      }

      return;
    } on TimeoutException {
      throw("Server ist nicht erreichbar");
    }
  }

  updateUser(User user) async {

  }

  deleteAccount() async {
    try {
      Response response = await delete(
        Uri.parse(AppUrl.user),
        headers: {'Authorization': 'Bearer ' + StoreService.store.state.token}
      ).timeout(const Duration(seconds: 10));

      if(response.statusCode != 200) {
        throw(response.body);
      }

      return;
    } on TimeoutException {
      throw("Server ist nicht erreichbar");
    }
  }

  fetchUniversities() async {
    //Mockup
    return ["FH Bielefeld", "FH Bielefeld (Minden)", "Uni Bielefeld"];
  }
}