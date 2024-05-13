import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/library/common/languages/CommonLanguages.dart';
import '../../../app/library/common/styles/CommonStyles.dart';
import '../../../app/library/common/utils/CommonAudioOnPressButton.dart';
import '../../../app/screens/setting/providers/setting_notifier.dart';
import '../containment/dialogs/CoreConfirmDialog.dart';

class CoreHelperWidget {
  static Future<bool> confirmFunction({
    required BuildContext context,
    required SettingNotifier settingNotifier,
    bool? isOnlyWarning,
    String? title,
    bool? confirmExitScreen,
    bool? confirmDelete,
    bool? confirmUnlock,
  }) async {
    bool result = false;
    String defaultTitle = 'Are you sure?';
    if (confirmExitScreen == true) {
      defaultTitle = CommonLanguages.convert(
          lang: settingNotifier.languageString ??
              CommonLanguages.languageStringDefault(),
          word: 'notification.action.confirm.exitScreen');
    }
    if (confirmDelete == true) {
      defaultTitle = CommonLanguages.convert(
          lang: settingNotifier.languageString ??
              CommonLanguages.languageStringDefault(),
          word: 'notification.action.confirm.delete');
    }
    if (confirmUnlock == true) {
      defaultTitle = CommonLanguages.convert(
          lang: settingNotifier.languageString ??
              CommonLanguages.languageStringDefault(),
          word: 'notification.action.confirm.unlock');
    }

    CommonAudioOnPressButton audio = CommonAudioOnPressButton();
    audio.playAudioOnOpenPopup();

    await showDialog<bool>(
        context: context,
        builder: (BuildContext context) => Form(
              onWillPop: () async {
                return result;
              },
              child: Dialog(
                  insetPadding : const EdgeInsets.all(5.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CoreConfirmDialog(
                            confirmTitle: Text(title ?? defaultTitle,
                                style: CommonStyles.labelTextStyle),
                            initialData: false,
                            onChanged: (value) => result = value,
                            isOnlyWarning: isOnlyWarning),
                      ])),
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
      if (element.hasFocus) {
        result = true;
      }
    }
    return result;
  }
}
