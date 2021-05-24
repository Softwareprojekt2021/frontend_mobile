import 'dart:convert';
import 'dart:typed_data';

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
    Uint8List bytes = Base64Codec().decode(user.profilePicture);

    return CircleAvatar(
        backgroundColor: Colors.grey,
        radius: radius,
        backgroundImage: Image.memory(bytes).image,
    );
  }
}