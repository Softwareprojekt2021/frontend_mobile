import 'package:dio/dio.dart';
import 'package:frontend_mobile/models/offer.dart';
import 'package:frontend_mobile/services/http_service.dart';
import 'package:frontend_mobile/util/app_url.dart';

class WatchlistService {
  Future<List<Offer>> fetchOffers() async {
    //TODO Backend
    try {
      final response = await HttpService.client.get(AppUrl.offers);

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
    //TODO Backend

    await Future.delayed(Duration(seconds: 2));
    return;
  }

  Future<void> addOffer(int offerId) async {
    //TODO Backend

    await Future.delayed(Duration(seconds: 2));
    return;
  }
}