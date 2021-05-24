import 'package:dio/dio.dart';
import 'package:frontend_mobile/services/store_service.dart';

class HttpService {
  static Dio client = new Dio();

  static setup() async {
    client.options.connectTimeout = 10000;
    client.options.receiveTimeout = 10000;
  }

  static setupAuthHeader() async {
    var token = StoreService.store.state.token;

    if(token == null)
      return;

    client.options.headers['Authorization'] = "Bearer " + token;
  }

  static removeAuthHeader() async {
    client.options.headers['Authorization'] = null;
  }
}