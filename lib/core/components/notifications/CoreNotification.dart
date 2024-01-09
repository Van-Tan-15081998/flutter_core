import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

enum CoreNotificationStatus { success, error, warning }

enum CoreNotificationAction { create, update, delete }

// CoreNotification.show(context, CoreNotificationStatus.success, CoreNotificationAction.create, '');
// CoreNotification.show(context, CoreNotificationStatus.error, CoreNotificationAction.create, '');

class CoreNotification {
  static show(BuildContext context, CoreNotificationStatus status,
      CoreNotificationAction action, String resourceName) {
    final snackBar = buildContent(context, status, getNotificationContent(status, action, resourceName));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static SnackBar buildContent(BuildContext context,
      CoreNotificationStatus status, String contentString) {

    switch (status) {
      case CoreNotificationStatus.success:
        return SnackBar(
          padding: const EdgeInsets.all(6.0),
          backgroundColor: Colors.green[400],
          content: Padding(
            padding: const EdgeInsets.fromLTRB(4.0, 2.0, 2.0,2.0),
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
                          child: const Icon(Icons.done_rounded, color: Colors.white, size: 34.0,)),
                    )),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 2.0, 6.0, 2.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Successfully', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 20.0)),
                        Text(contentString,maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w300, color: Colors.white, fontSize: 15.0)),
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
            padding: const EdgeInsets.fromLTRB(4.0, 2.0, 2.0,2.0),
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
                          child: const Icon(Icons.error_outline_rounded, color: Colors.white, size: 34.0,)),
                    )),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 2.0, 6.0, 2.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Error', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 20.0)),
                        Text(contentString,maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w300, color: Colors.white, fontSize: 15.0)),
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
            padding: const EdgeInsets.fromLTRB(4.0, 2.0, 2.0,2.0),
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
                          child: const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 34.0,)),
                    )),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 2.0, 6.0, 2.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Error', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 20.0)),
                        Text(contentString,maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w300, color: Colors.white, fontSize: 15.0)),
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
          backgroundColor: Colors.black,
          content: Padding(
            padding: const EdgeInsets.fromLTRB(4.0, 2.0, 2.0,2.0),
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
                          color: Colors.black,
                          child: const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 34.0,)),
                    )),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 2.0, 6.0, 2.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Error', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 20.0)),
                        Text(contentString,maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w300, color: Colors.white, fontSize: 15.0)),
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
          result = '$resourceName created  successfully';
          break;
        case CoreNotificationAction.update:
          result = '$resourceName updated  successfully';
          break;
        case CoreNotificationAction.delete:
          result = '$resourceName deleted  successfully';
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
        default:
          result = 'Default notification';
      }
    }
    if (status == CoreNotificationStatus.warning) {}

    return result;
  }
}
