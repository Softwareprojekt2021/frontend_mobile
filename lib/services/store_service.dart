import 'package:frontend_mobile/stores/global_state.dart';
import 'package:redux/redux.dart';

class StoreService {
  static Store<GlobalState> store;

  static setupStore() {
    store = Store<GlobalState>(globalStateReducer, initialState: new GlobalState());
  }
}