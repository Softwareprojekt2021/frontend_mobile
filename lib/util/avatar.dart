import 'dart:io';

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
    Image image;

    if(user.profilePicture.substring(0, 4) == "http") {
      image = Image.network(user.profilePicture);
    } else {
      image = Image.file(File(user.profilePicture));
    }

    return CircleAvatar(
        backgroundColor: Colors.grey,
        radius: radius,
        backgroundImage: image.image,
    );
  }
}