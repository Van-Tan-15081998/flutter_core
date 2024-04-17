import 'package:flutter/material.dart';

import '../../../app/library/common/styles/CommonStyles.dart';
import '../../../app/library/common/utils/CommonAudioOnPressButton.dart';
import '../containment/dialogs/CoreConfirmDialog.dart';

class CoreHelperWidget {
  static Future<bool> confirmFunction(BuildContext context) async {
    bool result = false;
    CommonAudioOnPressButton audio = CommonAudioOnPressButton();
    audio.playAudioOnOpenPopup();

    await showDialog<bool>(
        context: context,
        builder: (BuildContext context) => Form(
          onWillPop: () async { return result; },
          child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(10.0), // Điều chỉnh border radius ở đây
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.min,
                  children: [CoreConfirmDialog(
                    confirmTitle: Text('Are you sure?', style: CommonStyles.labelTextStyle),
                    initialData: false,
                    onChanged: (value) => result = value,
                  ),]
              )),
        ));

    if (!result) {
      return true;
    } else {
      return false;
    }
  }

  static bool isShowingKeyBoard(List<FocusNode> focusNode) {

    bool result = false;

    for (var element in focusNode) {
      if(element.hasFocus) {
        result = true;
      }
    }

    return result;
  }

  static String getTimeString(int time) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(time);

    int year = dateTime.year;
    int month = dateTime.month;
    int day = dateTime.day;
    int hour = dateTime.hour;
    int minute = dateTime.minute;

    return '$hour:$minute $day/$month/$year';
  }
}
