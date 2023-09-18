import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../actions/common_buttons/CoreButtonStyle.dart';
import '../../actions/common_buttons/CoreElevatedButton.dart';
import '../dialogs/CoreConfirmDialog.dart';

enum CoreStandardBottomHeight { half, twoThird }

class CoreStandardBottomSheet extends StatefulWidget {
  Widget child;

  CoreStandardBottomHeight? coreStandardBottomHeight;

  CoreStandardBottomSheet({super.key, required this.child, this.coreStandardBottomHeight});

  @override
  State<CoreStandardBottomSheet> createState() =>
      _CoreStandardBottomSheetState();
}

class _CoreStandardBottomSheetState extends State<CoreStandardBottomSheet> {
  Future<bool> confirmFunction() async {
    bool result = false;
    await showDialog<bool>(
        context: context,
        builder: (BuildContext context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(10.0), // Điều chỉnh border radius ở đây
            ),
            child: Container(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CoreConfirmDialog(
                      confirmTitle: const Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Are you sure?')
                        ],
                      ),
                      initialData: false,
                      onChanged: (value) => result = value,
                    ),
                  ]),
            )));
    if (!result) {
      return true;
    } else {
      return false;
    }
  }

  double _getMaxHeight(CoreStandardBottomHeight? coreStandardBottomHeight) {
    double maxHeight = 0.7;

    switch (coreStandardBottomHeight) {
      case CoreStandardBottomHeight.half :
        maxHeight = 0.5;
        break;
      case CoreStandardBottomHeight.twoThird:
        maxHeight = 0.66666666666;
        break;

      default: {
        //statements;
      }
    }

    return maxHeight;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(children: [
      Container(
          padding: EdgeInsets.fromLTRB(0, 26, 0, 0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), // Bo tròn góc trên bên trái
              topRight: Radius.circular(20.0), // Bo tròn góc trên bên phải
            ),
          ),
          constraints: BoxConstraints(
            maxHeight:  MediaQuery.of(context).size.height *
                _getMaxHeight(widget.coreStandardBottomHeight), // Chiều cao tối đa của modal sheet
          ),
          child: Scaffold(

              body: widget.child,
              floatingActionButton: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CoreElevatedButton.icon(
                    icon: Icon(Icons.cancel),
                    label: const Text('Cancel'),
                    onPressed: () async {
                      if (await confirmFunction()) {
                        Navigator.pop(context);
                      }
                    },
                    coreButtonStyle: CoreButtonStyle.options(
                        coreStyle: CoreStyle.filled,
                        coreColor: CoreColor.secondary,
                        coreRadius: CoreRadius.radius_6,
                        kitForegroundColorOption: Colors.black,
                        coreFixedSizeButton: CoreFixedSizeButton.medium_40),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  CoreElevatedButton.icon(
                    icon: Icon(Icons.save),
                    label: const Text('Save'),
                    onPressed: () {},
                    coreButtonStyle: CoreButtonStyle.options(
                        coreStyle: CoreStyle.filled,
                        coreColor: CoreColor.success,
                        coreRadius: CoreRadius.radius_6,
                        kitForegroundColorOption: Colors.black,
                        coreFixedSizeButton: CoreFixedSizeButton.medium_40),
                  )
                ],
              )))
    ]);

    return Wrap(
      children: [
        Container(
          padding: EdgeInsets.all(16.0),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height *
                0.7, // Chiều cao tối đa của modal sheet
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Modal Bottom Sheet'),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(labelText: 'Your Input'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
