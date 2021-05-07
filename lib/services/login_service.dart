import 'dart:async';
import 'dart:convert';
import 'package:frontend_mobile/util/app_url.dart';
import 'package:http/http.dart';

class LoginService {
  Future<String> login(String email, String password) async {
    final Map<String, dynamic> loginData = {
      'email': email,
      'password': password
    };

    try {
      Response response = await post(
        Uri.parse(AppUrl.login),
        body: json.encode(loginData),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if(response.statusCode == 404) {
        throw("Anmeldeinformationen sind falsch");
      } else if (response.statusCode != 200) {
        throw(response.body);
      }

      return response.body;
    } on TimeoutException catch (error) {
      throw("Server ist nicht erreichbar");
    }
  }
}