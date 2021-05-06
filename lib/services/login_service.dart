import 'dart:convert';

import 'package:frontend_mobile/util/app_url.dart';
import 'package:http/http.dart';

class LoginService {
  Future<String> login(String email, String password) async {
    final Map<String, dynamic> loginData = {
      'email': email,
      'password': password
    };

    Response response = await post(
      Uri.parse(AppUrl.login),
      body: json.encode(loginData),
      headers: {'Content-Type': 'application/json'},
    );

    if(response.statusCode == 404) {
      throw("Anmeldeinformationen sind falsch");
    } else if (response.statusCode != 200) {
      throw("Serverfehler");
    }

    return response.body;
  }
}