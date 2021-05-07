import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

class NotificationOverlay {
  static void success(String message) {
    showSimpleNotification(
        Text(message),
        background: Colors.lightGreen,
        position: NotificationPosition.bottom,
        slideDismissDirection: DismissDirection.down,
    );
  }

  static void error(String message) {
    showSimpleNotification(
        Text(message),
        background: Colors.redAccent,
        position: NotificationPosition.bottom,
        slideDismissDirection: DismissDirection.down,
    );
  }

  static void warning(String message) {
    showSimpleNotification(
        Text(message),
        background: Colors.orange,
        position: NotificationPosition.bottom,
        slideDismissDirection: DismissDirection.down,
    );
  }
}