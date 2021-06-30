import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:frontend_mobile/services/http_service.dart';
import 'package:frontend_mobile/util/app_url.dart';

class LoginService {
  Future<String> login(String email, String password) async {
    final Map<String, dynamic> loginData = {
      'email': email,
      'password': password
    };

    try {
      final response = await HttpService.client.post(AppUrl.login, data: json.encode(loginData));

      if(response.statusCode == 204) {
        throw("Anmeldeinformationen sind falsch");
      }

      return response.data;
    } on DioError catch (error) {
      if(error.type == DioErrorType.connectTimeout) {
        throw("Server ist nicht erreichbar");
      } else if(error.response.statusCode == 404) {
        throw("Anmeldeinformationen sind falsch");
      } else {
        throw(error);
      }
    }
  }
}