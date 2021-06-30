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

  updateRating(int userId, int rating) async {
    try {
      await HttpService.client.put(AppUrl.rating + "/" + userId.toString(),
          data: {'rating': rating});

    } on DioError catch (error) {
      if(error.type == DioErrorType.connectTimeout) {
        throw("Server ist nicht erreichbar");
      } else {
        throw(error);
      }
    }
  }

  deleteRating(int userId) async {
    try {
      await HttpService.client.delete(AppUrl.rating + "/" + userId.toString());
    } on DioError catch (error) {
      if(error.type == DioErrorType.connectTimeout) {
        throw("Server ist nicht erreichbar");
      } else {
        throw(error);
      }
    }
  }

  Future<int> fetchRating(int userId) async {
    try {
      final response = await HttpService.client.get(AppUrl.rating + "/" + userId.toString());

      return response.data["rating"];
    } on DioError catch (error) {
      if(error.type == DioErrorType.connectTimeout) {
        throw("Server ist nicht erreichbar");
      } else if (error.type == DioErrorType.response) {
        return 0;
      } else {
        throw(error);
      }
    }
  }
}