import 'package:dio/dio.dart';
import 'package:frontend_mobile/services/http_service.dart';
import 'package:frontend_mobile/util/app_url.dart';

class RatingService {
  rateSeller(int userId, int rating) async {
    try {
      await HttpService.client.post(AppUrl.rating + "/" + userId.toString(),
          data: {'rating': rating});

    } on DioError catch (error) {
      if(error.type == DioErrorType.connectTimeout) {
        throw("Server ist nicht erreichbar");
      } else {
        throw(error);
      }
    }
  }
}