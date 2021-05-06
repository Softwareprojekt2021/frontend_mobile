import 'package:frontend_mobile/models/user.dart';
import 'package:frontend_mobile/stores/user_action.dart';
import 'package:redux/redux.dart';

User setUserReducer(User user, SetUserAction action) {
  return action.user;
}

Reducer<User> userReducer = combineReducers<User> ([
  new TypedReducer<User, SetUserAction>(setUserReducer)
]);