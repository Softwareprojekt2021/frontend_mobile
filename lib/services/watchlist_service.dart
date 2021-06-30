import 'package:dio/dio.dart';
import 'package:frontend_mobile/models/offer.dart';
import 'package:frontend_mobile/services/http_service.dart';
import 'package:frontend_mobile/util/app_url.dart';

class WatchlistService {
  Future<List<Offer>> fetchOffers() async {
    try {
      final response = await HttpService.client.get(AppUrl.watchlist);

      if(response.statusCode == 204) {
        return <Offer>[];
      }

      return response.data.map((offer) => Offer.fromJson(offer)).toList().cast<Offer>();
    } on DioError catch (error) {
      if(error.type == DioErrorType.connectTimeout) {
        throw("Server ist nicht erreichbar");
      } else if (error.type == DioErrorType.response) {
        return <Offer>[];
      } else {
        throw(error);
      }
    }
  }

  Future<void> deleteOffer(int offerId) async {
    try {
      await HttpService.client.delete(AppUrl.watchlist + "/" + offerId.toString());
    } on DioError catch (error) {
      if(error.type == DioErrorType.connectTimeout) {
        throw("Server ist nicht erreichbar");
      } else {
        throw(error);
      }
    }
  }

  Future<void> addOffer(int offerId) async {
    try {
      await HttpService.client.post(AppUrl.watchlist + "/" + offerId.toString());
    } on DioError catch (error) {
      if(error.type == DioErrorType.connectTimeout) {
        throw("Server ist nicht erreichbar");
      } else {
        throw(error);
      }
    }
  }
}