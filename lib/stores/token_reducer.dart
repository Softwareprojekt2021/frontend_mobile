import 'package:frontend_mobile/stores/token_action.dart';
import 'package:redux/redux.dart';

String setTokenReducer(String token, SetTokenAction action) {
  return action.token;
}

Reducer<String> tokenReducer = combineReducers<String>([
  new TypedReducer<String, SetTokenAction>(setTokenReducer)
]);