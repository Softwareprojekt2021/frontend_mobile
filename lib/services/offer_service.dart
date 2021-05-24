import 'package:dio/dio.dart';
import 'package:frontend_mobile/models/offer.dart';
import 'package:frontend_mobile/services/http_service.dart';
import 'package:frontend_mobile/util/app_url.dart';


class OfferService {
  //TODO
  fetchCategories() async {
    //Mockup
    return ["Elektronik", "Computer", "Buch", "Sonstiges"];
  }

  createOffer(Offer offer) async {
    try {
      await HttpService.client.post(AppUrl.offer, data: offer.toJson());

    } on DioError catch (error) {
      if(error.type == DioErrorType.connectTimeout) {
        throw("Server ist nicht erreichbar");
      } else {
        throw(error);
      }
    }
  }

  offerSold(int offerId) async {
    try {
      await HttpService.client.put(AppUrl.offer, data: {'id': offerId, 'sold': 1});
    } on DioError catch (error) {
      if(error.type == DioErrorType.connectTimeout) {
        throw("Server ist nicht erreichbar");
      } else {
        throw(error);
      }
    }
  }

  deleteOffer(int offerId) async {
    try {
      await HttpService.client.delete(AppUrl.offer + "/" + offerId.toString());

    } on DioError catch (error) {
      if(error.type == DioErrorType.connectTimeout) {
        throw("Server ist nicht erreichbar");
      } else {
        throw(error);
      }
    }
  }

  updateOffer(Offer offer) async {
    try {
      await HttpService.client.put(AppUrl.offer, data: offer.toJson());
    } on DioError catch (error) {
      if(error.type == DioErrorType.connectTimeout) {
        throw("Server ist nicht erreichbar");
      } else {
        throw(error);
      }
    }
  }

  //TODO
  fetchCreatedOffers() async {
    try {
      final response = await HttpService.client.get(AppUrl.offer + "/3");

      List<Offer> offers = [];

      offers.add(Offer.fromJson(response.data));

      return offers;
    } on DioError catch (error) {
      if(error.type == DioErrorType.connectTimeout) {
        throw("Server ist nicht erreichbar");
      } else {
        throw(error);
      }
    }
  }
}