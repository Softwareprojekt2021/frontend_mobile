import 'package:dio/dio.dart';
import 'package:frontend_mobile/models/user.dart';
import 'package:frontend_mobile/services/http_service.dart';
import 'package:frontend_mobile/util/app_url.dart';

class UserService {
  fetchUser() async {
    try {
      final response = await HttpService.client.get(AppUrl.user);

      return User.fromJson(response.data);
    } on DioError catch (error) {
      if(error.type == DioErrorType.connectTimeout) {
        throw("Server ist nicht erreichbar");
      } else {
        throw(error);
      }
    }
  }

  registerUser(User user) async {
    try {
      await HttpService.client.post(AppUrl.user, data: user.toJson());

    } on DioError catch (error) {
      if(error.type == DioErrorType.connectTimeout) {
        throw("Server ist nicht erreichbar");
      } else if (error.response.statusCode == 409) {
        throw("Ein Benutzer mit der E-Mail wurde bereits angelegt");
      } else {
        throw(error);
      }
    }
  }

  updateUser(User user) async {
    try {
      await HttpService.client.put(AppUrl.user, data: user.toJson());

    } on DioError catch (error) {
      if(error.type == DioErrorType.connectTimeout) {
        throw("Server ist nicht erreichbar");
      } else if (error.response.statusCode == 409) {
        throw("Die E-Mail ist bereits vergeben");
      } else {
        throw(error);
      }
    }
  }

  deleteAccount() async {
    try {
      await HttpService.client.delete(AppUrl.user);

    } on DioError catch (error) {
      if(error.type == DioErrorType.connectTimeout) {
        throw("Server ist nicht erreichbar");
      } else {
        throw(error);
      }
    }
  }

  fetchUniversities() async {
    try {
      final response = await HttpService.client.get(AppUrl.universities);

      return List<String>.from(response.data);
    } on DioError catch (error) {
      if(error.type == DioErrorType.connectTimeout) {
        throw("Server ist nicht erreichbar");
      } else {
        throw(error);
      }
    }
  }
}