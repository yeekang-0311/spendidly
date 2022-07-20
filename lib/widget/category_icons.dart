import 'package:flutter/material.dart';

class CatIcons {
  static String food = "assets/icons/food.svg";
  static String entertainment = "assets/icons/entertainment.svg";
  static String sports = "assets/icons/sports.svg";
  static String transportation = "assets/icons/car.svg";
  static String general = "assets/icons/general.svg";

  static String getIcon(category) {
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
