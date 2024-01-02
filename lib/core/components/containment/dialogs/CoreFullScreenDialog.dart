import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core_v3/app/screens/features/note/note_list_screen.dart';
import 'package:flutter_core_v3/core/components/actions/common_buttons/CoreButtonStyle.dart';
import 'package:flutter_core_v3/core/components/actions/common_buttons/CoreElevatedButton.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../app/screens/home/home_screen.dart';
import '../../helper_widgets/CoreHelperWidget.dart';

enum AppBarActionButtonEnum { save, cancel, home }

class CoreFullScreenDialog extends StatefulWidget {
  String? title = '_CoreFullScreenDialog';

  Widget child;

  Widget optionActionContent;

  bool? isConfirmToClose = true;

  bool? isShowGeneralActionButton = true;
  bool? isShowOptionActionButton = true;

  List<Widget> bottomActionBar;
  List<Widget> bottomActionBarScrollable;

  List<FocusNode>? focusNodes = [];

  AppBarActionButtonEnum actions = AppBarActionButtonEnum.home;

  Function onSubmit;
  Function onUndo;
  Function onRedo;
  Function onBack;

  CoreFullScreenDialog(
      {super.key,
      this.title,
      required this.child,
      required this.optionActionContent,
      this.isConfirmToClose,
      required this.bottomActionBar,
      required this.bottomActionBarScrollable,
      this.focusNodes,
      required this.actions,
      required this.onSubmit,
      required this.onUndo,
      required this.onRedo,
      required this.onBack,
      this.isShowGeneralActionButton,
      this.isShowOptionActionButton});

  @override
  State<CoreFullScreenDialog> createState() => _CoreFullScreenDialogState();
}

class _CoreFullScreenDialogState extends State<CoreFullScreenDialog> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget get _fullWidthPath {
    return DottedBorder(
      customPath: (size) {
        return Path()
          ..moveTo(0, 20)
          ..lineTo(size.width, 20);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(),
      ),
    );
  }

  double _getBottomPadding() {
    double bottomPadding = 2.0;

    widget.focusNodes = widget.focusNodes ??
        []; // Để tránh lỗi 'Null check operator used on a null value'

    if (widget.focusNodes!.isNotEmpty) {
      if (!CoreHelperWidget.isShowingKeyBoard(widget.focusNodes!)) {
        bottomPadding = 24.0;
      }
    } else if (widget.focusNodes!.isEmpty) {
      bottomPadding = 24.0;
    }

    return bottomPadding;
  }

  Widget _buildAppBarActionButtons() {
    switch (widget.actions) {
      case AppBarActionButtonEnum.save:
        {
          return Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
            child: CoreElevatedButton.icon(
              icon: const FaIcon(FontAwesomeIcons.floppyDisk, size: 18.0),
              label: const Text('Save'),
              onPressed: () {
                widget.onSubmit();
              },
              coreButtonStyle: CoreButtonStyle.options(
                  coreStyle: CoreStyle.outlined,
                  coreColor: CoreColor.success,
                  coreRadius: CoreRadius.radius_6,
                  kitForegroundColorOption: Colors.black,
                  coreFixedSizeButton: CoreFixedSizeButton.medium_40),
            ),
          );
        }
        break;
      case AppBarActionButtonEnum.home:
        {
          return Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
            child: CoreElevatedButton.icon(
              icon: const FaIcon(FontAwesomeIcons.house, size: 18.0),
              label: const Text('Home'),
              onPressed: () {
                Get.offAll(const HomeScreen(title: 'Hi Tasks'));
              },
              coreButtonStyle: CoreButtonStyle.options(
                  coreStyle: CoreStyle.outlined,
                  coreColor: CoreColor.success,
                  coreRadius: CoreRadius.radius_6,
                  kitForegroundColorOption: Colors.black,
                  coreFixedSizeButton: CoreFixedSizeButton.medium_40),
            ),
          );
        }
        break;

      default:
        break;
    }

    return Container();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    widget.isShowGeneralActionButton = widget.isShowGeneralActionButton ?? true;
    widget.isShowOptionActionButton = widget.isShowOptionActionButton ?? true;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
        actions: [_buildAppBarActionButtons()],
      ),
      body: widget.child,
      floatingActionButton: Padding(
        padding: EdgeInsets.fromLTRB(8, 0, 8, _getBottomPadding()),
        child: Container(
          padding: const EdgeInsets.fromLTRB(4, 1, 4, 0),
          width:
              screenWidth, // Đặt chiều rộng của container bằng chiều ngang của màn hình
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(8.0), // Bo góc
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // _fullWidthPath,
              widget.isShowGeneralActionButton!
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CoreElevatedButton.iconOnly(
                          onPressed: () {
                            widget.onUndo();
                          },
                          coreButtonStyle: CoreButtonStyle.options(
                              coreFixedSizeButton:
                                  CoreFixedSizeButton.squareIcon4060,
                              coreStyle: CoreStyle.outlined,
                              coreColor: CoreColor.turtles,
                              coreRadius: CoreRadius.radius_6,
                              kitForegroundColorOption: Colors.black),
                          icon: const FaIcon(FontAwesomeIcons.arrowLeft,
                              size: 18.0),
                        ),
                        CoreElevatedButton.iconOnly(
                          onPressed: () {
                            widget.onRedo();
                          },
                          coreButtonStyle: CoreButtonStyle.options(
                              coreFixedSizeButton:
                                  CoreFixedSizeButton.squareIcon4060,
                              coreStyle: CoreStyle.outlined,
                              coreColor: CoreColor.turtles,
                              coreRadius: CoreRadius.radius_6,
                              kitForegroundColorOption: Colors.black),
                          icon: const FaIcon(FontAwesomeIcons.arrowRight,
                              size: 18.0),
                        ),
                        CoreElevatedButton.icon(
                          icon:
                              const FaIcon(FontAwesomeIcons.xmark, size: 18.0),
                          label: const Text('Cancel'),
                          onPressed: () async {
                            if (widget.isConfirmToClose!) {
                              if (await CoreHelperWidget.confirmFunction(
                                  context)) {
                                Navigator.pop(context);
                              }
                            } else {
                              Navigator.pop(context);
                            }
                          },
                          coreButtonStyle: CoreButtonStyle.options(
                              coreStyle: CoreStyle.filled,
                              coreColor: CoreColor.secondary,
                              coreRadius: CoreRadius.radius_6,
                              kitForegroundColorOption: Colors.black,
                              coreFixedSizeButton:
                                  CoreFixedSizeButton.medium_40),
                        ),
                        CoreElevatedButton.icon(
                          icon: const FaIcon(FontAwesomeIcons.floppyDisk,
                              size: 18.0),
                          label: const Text('Save'),
                          onPressed: () {
                            widget.onSubmit();
                          },
                          coreButtonStyle: CoreButtonStyle.options(
                              coreStyle: CoreStyle.filled,
                              coreColor: CoreColor.success,
                              coreRadius: CoreRadius.radius_6,
                              kitForegroundColorOption: Colors.black,
                              coreFixedSizeButton:
                                  CoreFixedSizeButton.medium_40),
                        )
                      ],
                    )
                  : Container(),
              widget.isShowOptionActionButton!
                  ? Padding(
                      padding: const EdgeInsets.all(0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: widget.bottomActionBar,
                          ),
                          SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: widget.bottomActionBarScrollable)),
                        ],
                      ),
                    )
                  : Container(),
              widget.optionActionContent
            ],
          ),
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
    );
  }
}

// https://pub.dev/packages/dotted_border/example
