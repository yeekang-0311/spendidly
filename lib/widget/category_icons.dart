import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CatIcons {
  static IconData food = Icons.food_bank_outlined;
  static IconData entertainment = Icons.gamepad;
  static IconData sports = Icons.sports_basketball;
  static IconData transportation = Icons.bus_alert;
  static IconData general = Icons.abc;

  static IconData getIcon(category) {
    switch (category) {
      case 'Food':
        {
          return food;
        }
      case 'Entertainment':
        {
          return entertainment;
        }
      case 'General':
        {
          return general;
        }
      case 'Transportation':
        {
          return transportation;
        }
      case 'Sports':
        {
          return sports;
        }
      default:
        {
          return general;
        }
    }
  }
}
