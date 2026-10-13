import 'package:flutter/material.dart';

String formatMoney(int value) {
  final digits = value.toString();
  final formatted = StringBuffer();

  for (var index = 0; index < digits.length; index++) {
    if (index > 0 && (digits.length - index) % 3 == 0) {
      formatted.write(' ');
    }
    formatted.write(digits[index]);
  }

  return formatted.toString();
}

IconData projectIcon(String icon) => switch (icon) {
  'bi-mortarboard-fill' => Icons.school,
  'bi-house-heart-fill' => Icons.volunteer_activism,
  'bi-android' => Icons.pets,
  'bi-car-front-fill' => Icons.accessible,
  'bi-tree-fill' => Icons.park,
  _ => Icons.favorite,
};
