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
  final String? title;

  final Widget child;

  final Widget? optionActionContent;

  final bool? isConfirmToClose;

  final bool? isShowBottomActionButton;
  final bool? isShowGeneralActionButton;
  final bool? isShowOptionActionButton;

  final List<Widget>? bottomActionBar;
  final List<Widget>? bottomActionBarScrollable;

  final AppBarActionButtonEnum actions;

  String? homeLabel;

  final Function? onSubmit;
  final Function? onUndo;
  final Function? onRedo;
  final Function? onBack;
  final Function? onGoHome;

  CoreFullScreenDialog(
      {super.key,
      required this.title,
      required this.child,
      required this.optionActionContent,
      required this.isConfirmToClose,
      required this.bottomActionBar,
      required this.bottomActionBarScrollable,
      required this.actions,
      required this.onSubmit,
      required this.onUndo,
      required this.onRedo,
      required this.onBack,
      required this.onGoHome,
        this.homeLabel,
      required this.isShowGeneralActionButton,
      required this.isShowOptionActionButton,
      required this.isShowBottomActionButton});

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
                if (widget.onSubmit != null) {
                  widget.onSubmit!();
                }
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
              label: Text(widget.homeLabel != null ? widget.homeLabel! : 'Home',  style: CommonStyles.buttonTextStyle),
              onPressed: () {
                if (widget.onGoHome != null) {
                  widget.onGoHome!();
                }
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
        child: widget.isShowBottomActionButton!
            ? Container(
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
                                  if (widget.onUndo != null) {
                                    widget.onUndo!();
                                  }
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
                                  if (widget.onRedo != null) {
                                    widget.onRedo!();
                                  }
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
                                icon: const FaIcon(FontAwesomeIcons.xmark,
                                    size: 18.0),
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
                                label: Text('Save',
                                    style: CommonStyles.labelTextStyle),
                                onPressed: () {
                                  if (widget.onSubmit != null) {
                                    widget.onSubmit!();
                                  }
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
                                  children: widget.bottomActionBar != null ? widget.bottomActionBar! :  [Container()],
                                ),
                                SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children:
                                            widget.bottomActionBarScrollable != null ? widget.bottomActionBarScrollable! : [Container()])),
                              ],
                            ),
                          )
                        : Container(),
                    widget.optionActionContent != null ? widget.optionActionContent! : Container()
                  ],
                ),
              )
            : Container(),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
    );
  }
}

// https://pub.dev/packages/dotted_border/example
