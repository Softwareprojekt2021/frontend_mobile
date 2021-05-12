import 'package:flutter/material.dart';
import 'package:frontend_mobile/models/user.dart';

Widget setupAvatar(User user, double radius) {
  if (user.profilePicture == null) {
    return CircleAvatar(
        backgroundColor: Colors.grey,
        radius: radius,
        child: Text(
          user.firstName[0] + user.lastName[0],
          textScaleFactor: 2,
          style: TextStyle(color: Colors.white),
        )
    );
  } else {
    return CircleAvatar(
        backgroundColor: Colors.grey,
        radius: radius,
        backgroundImage: Image.network(user.profilePicture).image,
    );
  }
}