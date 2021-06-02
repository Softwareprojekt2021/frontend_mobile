import 'package:dio/dio.dart';
import 'package:frontend_mobile/models/offer.dart';
import 'package:frontend_mobile/services/http_service.dart';
import 'package:frontend_mobile/util/app_url.dart';


class OfferService {
  fetchCategories() async {
    try {
      final response = await HttpService.client.get(AppUrl.categories);

      return List<String>.from(response.data);
    } on DioError catch (error) {
      if(error.type == DioErrorType.connectTimeout) {
        throw("Server ist nicht erreichbar");
      } else {
        throw(error);
      }
    }
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

  fetchCreatedOffers() async {
    try {
      final response = await HttpService.client.get(AppUrl.offers);

      return response.data.map((offer) => Offer.fromJson(offer)).toList().cast<Offer>();
    } on DioError catch (error) {
      if(error.type == DioErrorType.connectTimeout) {
        throw("Server ist nicht erreichbar");
      } else {
        throw(error);
      }
    }
  }

  //TODO Change route, when Backend in implemented
  fetchRecommendedOffers() async {
    try {
      final response = await HttpService.client.get(AppUrl.offers);

      return response.data.map((offer) => Offer.fromJson(offer)).toList().cast<Offer>();
    } on DioError catch (error) {
      if(error.type == DioErrorType.connectTimeout) {
        throw("Server ist nicht erreichbar");
      } else {
        throw(error);
      }
    }
  }

  //TODO Change route, when Backend in implemented, add search Parameters
  searchOffers({String text, String university, String category, priceBegin, priceEnd}) async {
    try {
      final response = await HttpService.client.get(AppUrl.offers);

      return response.data.map((offer) => Offer.fromJson(offer)).toList().cast<Offer>();
    } on DioError catch (error) {
      if(error.type == DioErrorType.connectTimeout) {
        throw("Server ist nicht erreichbar");
      } else {
        throw(error);
      }
    }
  }
}