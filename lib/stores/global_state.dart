import 'package:frontend_mobile/models/user.dart';
import 'package:frontend_mobile/stores/token_reducer.dart';
import 'package:frontend_mobile/stores/user_reducer.dart';

class GlobalState {
  String token;
  User user;

  GlobalState({this.token, this.user});
}

GlobalState globalStateReducer(GlobalState prevState, dynamic action)
=> new GlobalState(
    user: userReducer(prevState.user, action),
    token: tokenReducer(prevState.token, action)
);