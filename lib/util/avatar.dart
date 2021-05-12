import 'package:flutter/material.dart';
import 'package:frontend_mobile/models/user.dart';
import 'package:frontend_mobile/services/store_service.dart';

Widget setupAvatar(double radius) {
  User _user = StoreService.store.state.user;

  if (_user.profilePicture == null) {
    return CircleAvatar(
        backgroundColor: Colors.grey,
        radius: radius,
        child: Text(
          _user.firstName[0] + _user.lastName[0],
          textScaleFactor: 2,
          style: TextStyle(color: Colors.white),
        )
    );
  } else {
    return CircleAvatar(
        backgroundColor: Colors.grey,
        radius: radius,
        backgroundImage: Image.network(_user.profilePicture).image,
    );
  }
}