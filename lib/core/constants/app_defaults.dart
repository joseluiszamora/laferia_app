import 'package:flutter/material.dart';

class AppDefaults {
  /// Sizes
  static const double radius = 25;
  static const double margin = 20;

  /// Font Sizes
  static const double fontSize = 16;
  static const double fontSizeTitle = 23;
  static const double fontSizeSubTitle = 16;
  static const double fontSizeForm = 12;

  static const double fontSizeTitleLarge = 25;
  static const double fontSizeTitleMedium = 18;
  static const double fontSizeTitleSmall = 15;

  static const double fontSizeLabelMedium = 12;

  /// Buttons
  static const double paddingButton = 10;
  static const double fontSizeButton = 18;
  static const double widthButtonPrimary = 300;

  /// Used For Border Radius
  static BorderRadius borderRadius = BorderRadius.circular(radius);

  /// Used For Bottom Sheet
  static BorderRadius bottomSheetRadius = const BorderRadius.only(
    topLeft: Radius.circular(radius),
    topRight: Radius.circular(radius),
  );

  /// Used For Top Sheet
  static BorderRadius topSheetRadius = const BorderRadius.only(
    bottomLeft: Radius.circular(radius),
    bottomRight: Radius.circular(radius),
  );

  /// Default Box Shadow used for containers
  static List<BoxShadow> boxShadow = [
    BoxShadow(
      blurRadius: 10,
      spreadRadius: 0,
      offset: const Offset(0, 2),
      color: Colors.black.withOpacity(0.04),
    ),
  ];

  static Duration duration = const Duration(milliseconds: 300);

  /// SHAPE BORDER
  static ShapeBorder shapeBorder = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(radius),
  );
}
