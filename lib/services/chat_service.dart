import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:frontend_mobile/models/chat.dart';
import 'package:frontend_mobile/models/message.dart';
import 'package:frontend_mobile/services/http_service.dart';
import 'package:frontend_mobile/util/app_url.dart';

class ChatService {
  Future<Chat> createChat(int offerId) async {
    try {
      final response = await HttpService.client.post(AppUrl.message + "/" + offerId.toString() + "/create");

      return await fetchChat(jsonDecode(response.data)['chat_id']);
    } on DioError catch (error) {
      if(error.type == DioErrorType.connectTimeout) {
        throw("Server ist nicht erreichbar");
      } else {
        throw(error);
      }
    }
  }

  deleteChat(int chatId) async {
    try {
      await HttpService.client.delete(AppUrl.message + "/" + chatId.toString());
    } on DioError catch (error) {
      if (error.type == DioErrorType.connectTimeout) {
        throw("Server ist nicht erreichbar");
      } else {
        throw(error);
      }
    }
  }

  deleteMessage(int chatId, int messageId) async {
    try {
      await HttpService.client.delete(AppUrl.message + "/" + chatId.toString() + "/" + messageId.toString());
    } on DioError catch (error) {
      if (error.type == DioErrorType.connectTimeout) {
        throw("Server ist nicht erreichbar");
      } else {
        throw(error);
      }
    }
  }

  sendMessage(int chatId, Message message) async {
    try {
      await HttpService.client.post(AppUrl.message + "/" + chatId.toString(), data: message.toJson());
    } on DioError catch (error) {
      if(error.type == DioErrorType.connectTimeout) {
        throw("Server ist nicht erreichbar");
      } else {
        throw(error);
      }
    }
  }

  Future<List<Chat>> fetchChats() async {
    try {
      final response = await HttpService.client.get(AppUrl.messages);

      return response.data.map((chat) => Chat.fromJson(chat)).toList().cast<Chat>();
    } on DioError catch (error) {
      if(error.type == DioErrorType.connectTimeout) {
        throw("Server ist nicht erreichbar");
      } else {
        throw(error);
      }
    }
  }

  Future<Chat> fetchChat(int chatId) async {
    try {
      final response = await HttpService.client.get(AppUrl.message + "/" + chatId.toString());

      return response.data.map((chat) => Chat.fromJson(chat)).toList().cast<Chat>();
    } on DioError catch (error) {
      if(error.type == DioErrorType.connectTimeout) {
        throw("Server ist nicht erreichbar");
      } else {
        throw(error);
      }
    }
  }
}