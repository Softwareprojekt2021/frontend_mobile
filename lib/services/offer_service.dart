import 'package:dio/dio.dart';
import 'package:frontend_mobile/models/offer.dart';
import 'package:frontend_mobile/services/http_service.dart';
import 'package:frontend_mobile/util/app_url.dart';


class OfferService {
  Future<List<String>> fetchCategories() async {
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

  Future<List<Offer>> fetchCreatedOffers() async {
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

  Future<List<Offer>> fetchRecommendedOffers() async {
    try {
      final response = await HttpService.client.get(AppUrl.recommended);

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

  Future<List<Offer>> searchOffers(Map search) async {
    try {
      final response = await HttpService.client.get(AppUrl.filtered, queryParameters: {
        if(search["text"] != null) "title": search["text"],
        if(search["category"] != null) "category": search["category"],
        if(search["university"] != null) "university": search["university"],
        if(search["type"] != null) "compensation_type": search["type"] == 1 ? "Bar" : "Tausch",
        if(search["priceEnd"] != null) "max_price": search["priceEnd"],
        if(search["priceBegin"] != null) "min_price": search["priceBegin"]
      });

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
}