import 'package:intl/intl.dart';

class CommonConverters {
  /*
  CommonConverters.getFullTimeString(time)
   */
  static String toTimeString({required int time, String? format}) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(time);

    return DateFormat(format ?? 'HH:mm  dd/MM/yyyy').format(dateTime);
  }


}
