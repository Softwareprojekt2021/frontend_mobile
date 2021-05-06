import 'dart:convert';
import 'package:frontend_mobile/models/user.dart';
import 'package:frontend_mobile/services/store_service.dart';
import 'package:frontend_mobile/util/app_url.dart';
import 'package:http/http.dart';

class UserService {
  fetchUser() async {
    Response response = await get(
      Uri.parse(AppUrl.user),
      headers: {'Authorzation': 'Bearer' + StoreService.store.state.token},
    );

    return User.fromJson(json.decode(response.body));
  }
}