import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core_v3/app/screens/features/note/note_list_screen.dart';
import 'package:flutter_core_v3/core/components/actions/common_buttons/CoreButtonStyle.dart';
import 'package:flutter_core_v3/core/components/actions/common_buttons/CoreElevatedButton.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/library/common/styles/CommonStyles.dart';
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

  Widget _buildAppBarActionButtons() {
    switch (widget.actions) {
      case AppBarActionButtonEnum.save:
        {
          return Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
            child: CoreElevatedButton.icon(
              icon: const FaIcon(FontAwesomeIcons.floppyDisk, size: 18.0),
              label: Text('Save', style: CommonStyles.labelTextStyle),
              onPressed: () {
                widget.onSubmit();
              },
              coreButtonStyle: CoreButtonStyle.options(
                  coreStyle: CoreStyle.outlined,
                  coreColor: CoreColor.dark,
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
                  coreColor: CoreColor.dark,
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
        title: Text(
            widget.title!,
          style: GoogleFonts.montserrat(
            fontStyle: FontStyle.italic,
            fontSize: 26,
            color: const Color(0xFF404040),
            fontWeight: FontWeight.bold),
        ),
        actions: [_buildAppBarActionButtons()],
        backgroundColor: const Color(0xFF202124),
        iconTheme: const IconThemeData(
          color: Color(0xFF404040), // Set the color you desire
        ),
      ),
      body: widget.child,
      backgroundColor: const Color(0xFF202124),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Container(
          padding: const EdgeInsets.fromLTRB(4, 1, 4, 0),
          width:
              screenWidth, // Đặt chiều rộng của container bằng chiều ngang của màn hình
          decoration: BoxDecoration(
            color: const Color(0xFF404040),
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
                              coreColor: CoreColor.dark,
                              coreRadius: CoreRadius.radius_6,
                              kitForegroundColorOption: Colors.black,
                              coreFixedSizeButton:
                                  CoreFixedSizeButton.medium_40),
                        ),
                        CoreElevatedButton.icon(
                          icon: const FaIcon(FontAwesomeIcons.floppyDisk,
                              size: 18.0),
                          label: Text('Save', style: CommonStyles.labelTextStyle),
                          onPressed: () {
                            widget.onSubmit();
                          },
                          coreButtonStyle: CoreButtonStyle.options(
                              coreStyle: CoreStyle.filled,
                              coreColor: CoreColor.dark,
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
