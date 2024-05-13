import 'package:animate_do/animate_do.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core_v3/app/screens/setting/providers/setting_notifier.dart';

import '../../../app/library/common/languages/CommonLanguages.dart';
import '../../../app/library/common/utils/CommonAudioOnPressButton.dart';

enum CoreNotificationStatus { success, error, warning }

enum CoreNotificationAction { create, update, delete, restore }

class CoreNotification {
  /*
  Function Show Notification With BuildContext
   */
  static show(
      BuildContext context,
      SettingNotifier settingNotifier,
      CoreNotificationStatus status,
      CoreNotificationAction action,
      String resourceName) {
    CommonAudioOnPressButton audio = CommonAudioOnPressButton();
    audio.playAudioOnNotification();

    final snackBar = buildContent(context, settingNotifier, status,
        getNotificationContent(status, action, resourceName));
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    // audio.dispose();
  }

  static showMessage(BuildContext context, SettingNotifier settingNotifier,
      CoreNotificationStatus status, String message) {
    CommonAudioOnPressButton audio = CommonAudioOnPressButton();

    if (status == CoreNotificationStatus.warning ||
        status == CoreNotificationStatus.error) {
      audio.playAudioOnMessage();
    } else {
      audio.playAudioOnNotification();
    }

    final snackBar = buildContent(context, settingNotifier, status, message);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    // audio.dispose();
  }

  static SnackBar buildContent(
      BuildContext context,
      SettingNotifier settingNotifier,
      CoreNotificationStatus status,
      String contentString) {
    switch (status) {
      case CoreNotificationStatus.success:
        return SnackBar(
          duration: const Duration(milliseconds: 1500),
          padding: const EdgeInsets.all(6.0),
          backgroundColor: Colors.green[400],
          content: Padding(
            padding: const EdgeInsets.fromLTRB(4.0, 2.0, 2.0, 2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                DottedBorder(
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(30),
                    color: Colors.white,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      child: Container(
                          width: 50,
                          height: 50,
                          color: Colors.green[400],
                          child: const Icon(
                            Icons.done_rounded,
                            color: Colors.white,
                            size: 34.0,
                          )),
                    )),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 2.0, 6.0, 2.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            CommonLanguages.convert(
                                lang: settingNotifier.languageString ??
                                    CommonLanguages.languageStringDefault(),
                                word: 'notification.action.titleCompleted'),
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontSize: 20.0)),
                        Text(contentString,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.w300,
                                color: Colors.white,
                                fontSize: 15.0)),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
        break;
      case CoreNotificationStatus.error:
        return SnackBar(
          padding: const EdgeInsets.all(6.0),
          backgroundColor: Colors.red[400],
          content: Padding(
            padding: const EdgeInsets.fromLTRB(4.0, 2.0, 2.0, 2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                DottedBorder(
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(30),
                    color: Colors.white,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      child: Container(
                          width: 50,
                          height: 50,
                          color: Colors.red[400],
                          child: const Icon(
                            Icons.error_outline_rounded,
                            color: Colors.white,
                            size: 34.0,
                          )),
                    )),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 2.0, 6.0, 2.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            CommonLanguages.convert(
                                lang: settingNotifier.languageString ??
                                    CommonLanguages.languageStringDefault(),
                                word: 'notification.action.titleError'),
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontSize: 20.0)),
                        Text(contentString,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.w300,
                                color: Colors.white,
                                fontSize: 15.0)),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
        break;
      case CoreNotificationStatus.warning:
        return SnackBar(
          padding: const EdgeInsets.all(6.0),
          backgroundColor: Colors.orange[400],
          content: Padding(
            padding: const EdgeInsets.fromLTRB(4.0, 2.0, 2.0, 2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                DottedBorder(
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(30),
                    color: Colors.white,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      child: Container(
                          width: 50,
                          height: 50,
                          color: Colors.orange[400],
                          child: const Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.white,
                            size: 34.0,
                          )),
                    )),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 2.0, 6.0, 2.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            CommonLanguages.convert(
                                lang: settingNotifier.languageString ??
                                    CommonLanguages.languageStringDefault(),
                                word: 'notification.action.titleWarning'),
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontSize: 20.0)),
                        Text(contentString,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.w300,
                                color: Colors.white,
                                fontSize: 15.0)),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
        break;
      default:
        return SnackBar(
          padding: const EdgeInsets.all(6.0),
          backgroundColor: const Color(0xff1f1f1f),
          content: Padding(
            padding: const EdgeInsets.fromLTRB(4.0, 2.0, 2.0, 2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                DottedBorder(
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(30),
                    color: Colors.white,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      child: Container(
                          width: 50,
                          height: 50,
                          color: const Color(0xff1f1f1f),
                          child: const Icon(
                            Icons.notifications_none_rounded,
                            color: Colors.white,
                            size: 34.0,
                          )),
                    )),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 2.0, 6.0, 2.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Error',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontSize: 20.0)),
                        Text(contentString,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.w300,
                                color: Colors.white,
                                fontSize: 15.0)),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
        break;
    }
  }

  static SnackBar buildContentNotification(
      CoreNotificationStatus status, String contentString) {
    switch (status) {
      case CoreNotificationStatus.success:
        return SnackBar(
          padding: const EdgeInsets.all(6.0),
          backgroundColor: Colors.green[400],
          content: Padding(
            padding: const EdgeInsets.fromLTRB(4.0, 2.0, 2.0, 2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                DottedBorder(
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(30),
                    color: Colors.white,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      child: Container(
                          width: 50,
                          height: 50,
                          color: Colors.green[400],
                          child: const Icon(
                            Icons.done_rounded,
                            color: Colors.white,
                            size: 34.0,
                          )),
                    )),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 2.0, 6.0, 2.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Successfully',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontSize: 20.0)),
                        Text(contentString,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.w300,
                                color: Colors.white,
                                fontSize: 15.0)),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
        break;
      case CoreNotificationStatus.error:
        return SnackBar(
          padding: const EdgeInsets.all(6.0),
          backgroundColor: Colors.red[400],
          content: Padding(
            padding: const EdgeInsets.fromLTRB(4.0, 2.0, 2.0, 2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                DottedBorder(
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(30),
                    color: Colors.white,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      child: Container(
                          width: 50,
                          height: 50,
                          color: Colors.red[400],
                          child: const Icon(
                            Icons.error_outline_rounded,
                            color: Colors.white,
                            size: 34.0,
                          )),
                    )),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 2.0, 6.0, 2.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Error',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontSize: 20.0)),
                        Text(contentString,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.w300,
                                color: Colors.white,
                                fontSize: 15.0)),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
        break;
      case CoreNotificationStatus.warning:
        return SnackBar(
          padding: const EdgeInsets.all(6.0),
          backgroundColor: Colors.orange[400],
          content: Padding(
            padding: const EdgeInsets.fromLTRB(4.0, 2.0, 2.0, 2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                DottedBorder(
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(30),
                    color: Colors.white,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      child: Container(
                          width: 50,
                          height: 50,
                          color: Colors.orange[400],
                          child: const Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.white,
                            size: 34.0,
                          )),
                    )),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 2.0, 6.0, 2.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Error',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontSize: 20.0)),
                        Text(contentString,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.w300,
                                color: Colors.white,
                                fontSize: 15.0)),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
        break;
      default:
        return SnackBar(
          padding: const EdgeInsets.all(6.0),
          backgroundColor: const Color(0xff1f1f1f),
          content: Padding(
            padding: const EdgeInsets.fromLTRB(4.0, 2.0, 2.0, 2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                DottedBorder(
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(30),
                    color: Colors.white,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      child: Container(
                          width: 50,
                          height: 50,
                          color: const Color(0xff1f1f1f),
                          child: const Icon(
                            Icons.notifications_none_rounded,
                            color: Colors.white,
                            size: 34.0,
                          )),
                    )),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 2.0, 6.0, 2.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Error',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontSize: 20.0)),
                        Text(contentString,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.w300,
                                color: Colors.white,
                                fontSize: 15.0)),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
        break;
    }
  }

  static Widget buildIcon(CoreNotificationStatus status) {
    switch (status) {
      case CoreNotificationStatus.success:
        return DottedBorder(
            borderType: BorderType.RRect,
            radius: const Radius.circular(30),
            color: Colors.lightGreen,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(30)),
              child: Container(
                  width: 50,
                  height: 50,
                  color: Colors.lightGreen,
                  child: const Icon(Icons.notifications_none_rounded)),
            ));
        break;
      case CoreNotificationStatus.error:
        return DottedBorder(
            borderType: BorderType.RRect,
            radius: const Radius.circular(30),
            color: Colors.redAccent,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(30)),
              child: Container(
                  width: 50,
                  height: 50,
                  color: Colors.redAccent,
                  child: const Icon(Icons.notifications_none_rounded)),
            ));
        break;
      case CoreNotificationStatus.warning:
        return DottedBorder(
            borderType: BorderType.RRect,
            radius: const Radius.circular(30),
            color: Colors.orangeAccent,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(30)),
              child: Container(
                  width: 50,
                  height: 50,
                  color: Colors.orangeAccent,
                  child: const Icon(Icons.notifications_none_rounded)),
            ));
        break;
      default:
        return DottedBorder(
            borderType: BorderType.RRect,
            radius: const Radius.circular(30),
            color: Colors.lightGreen,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(30)),
              child: Container(
                  width: 50,
                  height: 50,
                  color: Colors.white,
                  child: const Icon(Icons.notifications_none_rounded)),
            ));
        break;
    }
  }

  static String getNotificationContent(CoreNotificationStatus status,
      CoreNotificationAction action, String resourceName) {
    String result = '';

    if (status == CoreNotificationStatus.success) {
      switch (action) {
        case CoreNotificationAction.create:
          result = '$resourceName created successfully';
          break;
        case CoreNotificationAction.update:
          result = '$resourceName updated successfully';
          break;
        case CoreNotificationAction.delete:
          result = '$resourceName deleted successfully';
          break;
        case CoreNotificationAction.restore:
          result = '$resourceName restored successfully';
          break;
        default:
          result = 'Default notification';
      }
    }
    if (status == CoreNotificationStatus.error) {
      switch (action) {
        case CoreNotificationAction.create:
          result = 'An error occurred while performing the create';
          break;
        case CoreNotificationAction.update:
          result = 'An error occurred while performing the update';
          break;
        case CoreNotificationAction.delete:
          result = 'An error occurred while performing the delete';
          break;
        case CoreNotificationAction.restore:
          result = 'An error occurred while performing the restore';
          break;
        default:
          result = 'Default notification';
      }
    }
    if (status == CoreNotificationStatus.warning) {}

    return result;
  }
}
