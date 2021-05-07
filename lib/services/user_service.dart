import 'dart:async';
import 'dart:convert';
import 'package:frontend_mobile/models/user.dart';
import 'package:frontend_mobile/services/store_service.dart';
import 'package:frontend_mobile/util/app_url.dart';
import 'package:http/http.dart';

class UserService {

  fetchUser() async {
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
}