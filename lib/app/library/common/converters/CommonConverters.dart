import 'dart:math';

import 'package:intl/intl.dart';

class CommonConverters {
  /*
  CommonConverters.getFullTimeString(time)
   */
  static String toTimeString({required int time, String? format}) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(time);

    return DateFormat(format ?? 'HH:mm  dd/MM/yyyy').format(dateTime);
  }

  /*
  CommonConverters.getRandomNumber(maxNumber:)
   */
  static int getRandomNumber({required maxNumber}) {
    Random random = Random();
    return random.nextInt(maxNumber); // Trả về số ngẫu nhiên từ 0 đến 8
  }
}
