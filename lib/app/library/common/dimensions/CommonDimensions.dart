import 'package:flutter/material.dart';

class CommonDimensions {
  /*
  CommonDimensions.maxHeightScreen(context)
   */
  static double maxHeightScreen(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /*
  CommonDimensions.maxWidthScreen(context)
   */
  static double maxWidthScreen(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /*
  CommonDimensions.scaffoldAppBarHeight(context);
   */
  static double scaffoldAppBarHeight(BuildContext context) {
    return AppBar().preferredSize.height + MediaQuery.of(context).padding.top;
  }
}
