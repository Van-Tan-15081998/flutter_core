import 'package:flutter/material.dart';

import '../containment/dialogs/CoreConfirmDialog.dart';

class CoreHelperWidget {
  static Future<bool> confirmFunction(BuildContext context) async {
    bool result = false;
    await showDialog<bool>(
        context: context,
        builder: (BuildContext context) => Form(
          onWillPop: () async { return result; },
          child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(10.0), // Điều chỉnh border radius ở đây
              ),
              child: Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.min,
                    children: [CoreConfirmDialog(
                      confirmTitle: const Text('Are you sure?'),
                      initialData: false,
                      onChanged: (value) => result = value,
                    ),]
                ),
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
}