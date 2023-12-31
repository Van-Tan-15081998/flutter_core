import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core_v3/app/screens/features/note/models/note_model.dart';
import 'package:flutter_core_v3/core/stores/icons/CoreStoreIcons.dart';
import 'package:flutter_quill/flutter_quill.dart' as flutter_quill;
import '../../../../core/components/actions/common_buttons/CoreButtonStyle.dart';
import '../../../../core/components/actions/common_buttons/CoreElevatedButton.dart';
import '../../../../core/components/containment/dialogs/CoreFullScreenDialog.dart';
import '../../../../core/components/helper_widgets/CoreHelperWidget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/stores/fonts/CoreStoreFonts.dart';
import 'controllers/note_controller.dart';
import 'widgets/functions/note_functions.dart';

enum ActionModeEnum { create, update, delete }
enum CurrentFocusNodeEnum { none, title, detailContent }

class NoteAddScreen extends StatefulWidget {
  final NoteModel? note;

  final ActionModeEnum actionMode;

  const NoteAddScreen({super.key, this.note, required this.actionMode});

  @override
  State<NoteAddScreen> createState() => _NoteAddScreenState();
}

class _NoteAddScreenState extends State<NoteAddScreen> {
  final ScrollController _controllerScrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();
  List<FocusNode> focusNodeInsidePage = [];
  final TextEditingController titleController = TextEditingController();

  bool isShowDialogSetText = false;
  bool isShowDialogSetEmoji = false;

  /// Title Setup
  final TextSelection _titleTextSelection =
      const TextSelection(baseOffset: 0, extentOffset: 0);
  flutter_quill.Document _titleDocument = flutter_quill.Document();
  late flutter_quill.QuillController _titleQuillController;
  final bool _titleReadOnly = false;
  final bool _titleAutoFocus = false;
  final bool _titleExpands = true;
  final FocusNode _titleFocusNode = FocusNode();
  final EdgeInsetsGeometry _titlePadding =
      const EdgeInsets.fromLTRB(4, 4, 4, 4);
  final ScrollController _titleScrollController = ScrollController();
  final bool _titleScrollable = true;
  bool _titleFocusNodeHasFocus = false;

  /// Detail Content Setup
  final TextSelection _detailContentTextSelection =
      const TextSelection(baseOffset: 0, extentOffset: 0);
  flutter_quill.Document _detailContentDocument = flutter_quill.Document();
  late flutter_quill.QuillController _detailContentQuillController;
  final bool _detailContentReadOnly = false;
  bool _detailContentAutoFocus = false;
  final bool _detailContentExpands = true;
  final FocusNode _detailContentFocusNode = FocusNode();
  final EdgeInsetsGeometry _detailContentPadding =
      const EdgeInsets.fromLTRB(4, 4, 4, 4);
  final ScrollController _detailContentScrollController = ScrollController();
  final bool _detailContentScrollable = true;
  bool _detailContentFocusNodeHasFocus = false;

  bool isQuillControllerSelectionUnchecked = false;
  CurrentFocusNodeEnum _CurrentFocusNodeEnum = CurrentFocusNodeEnum.none;

  double optionActionContent = 0.0;

  final fontFamilies = {
    'Sans Serif': 'sans-serif',
    'Serif': 'serif',
    'Monospace': 'monospace',
    'Ibarra Real Nova': 'ibarra-real-nova',
    'SquarePeg': 'square-peg',
    'Nunito': 'nunito',
    'Pacifico': 'pacifico',
    'Roboto Mono': 'roboto-mono',
  };

  final fontSizes = {
    'Small': 'small',
    'Large': 'large',
    'Huge': 'huge',
  };

  openOptionActionContent() {
    setState(() {
      optionActionContent = 300.0;
    });
  }

  closeOptionActionContent() {
    setState(() {
      optionActionContent = 0.0;
    });
  }

  @override
  void initState() {
    super.initState();

    /// If edit
    if (widget.note is NoteModel) {
      /// Un focus all

      if (widget.note!.title.isNotEmpty) {
        /// Set data for input
        List<dynamic> deltaMap = jsonDecode(widget.note!.title);

        flutter_quill.Delta delta = flutter_quill.Delta.fromJson(deltaMap);
        _titleDocument = flutter_quill.Document.fromDelta(delta);

        /// Set selection
      }

      if (widget.note!.description.isNotEmpty) {
        /// Set data for input
        List<dynamic> deltaMap = jsonDecode(widget.note!.description);

        flutter_quill.Delta delta = flutter_quill.Delta.fromJson(deltaMap);
        _detailContentDocument = flutter_quill.Document.fromDelta(delta);
      }
    } else {
      setState(() {
        _detailContentAutoFocus = true;
      });
    }

    /// Title Init Setup
    _titleQuillController = flutter_quill.QuillController(
        document: _titleDocument, selection: _titleTextSelection);

    /// Detail Content Init Setup
    _detailContentQuillController = flutter_quill.QuillController(
        document: _detailContentDocument,
        selection: _detailContentTextSelection);

    /// Listen Focus And Hide Dialog SetText and SetEmoji
    _titleFocusNode.addListener(() {
      if (_titleFocusNode.hasFocus) {
        setState(() {
          _CurrentFocusNodeEnum = CurrentFocusNodeEnum.title;
          closeOptionActionContent();
          _titleQuillController.ignoreFocusOnTextChange = false;

          _titleFocusNodeHasFocus = true;
          _detailContentFocusNodeHasFocus = false;
          isShowDialogSetText = false;
          isShowDialogSetEmoji = false;
        });
      } else {}
    });
    _detailContentFocusNode.addListener(() {
      if (_detailContentFocusNode.hasFocus) {
        setState(() {
          // _controllerScrollController.

          _CurrentFocusNodeEnum = CurrentFocusNodeEnum.detailContent;
          closeOptionActionContent();
          _detailContentQuillController.ignoreFocusOnTextChange = false;

          _detailContentFocusNodeHasFocus = true;
          _titleFocusNodeHasFocus = false;
          isShowDialogSetText = false;
          isShowDialogSetEmoji = false;
        });
      } else {}
    });

    List<FocusNode> focusNodeInsidePage = [
      _titleFocusNode,
      _detailContentFocusNode
    ];
  }

  isBold(flutter_quill.QuillController quillController) {
    return quillController.getSelectionStyle().attributes['bold'];
  }

  void onQuillControllerSelectionUnchecked() {
    flutter_quill.Style selectionStyle = flutter_quill.Style();
    if (_titleFocusNodeHasFocus) {
      selectionStyle = _titleQuillController.getSelectionStyle();
    } else {
      selectionStyle = _detailContentQuillController.getSelectionStyle();
    }

    var attributeValues = selectionStyle.attributes.values;

    var results = attributeValues.toList();
    if (results.isNotEmpty) {
      if (results.last.value == flutter_quill.Attribute.unchecked.value) {
        setState(() {
          isQuillControllerSelectionUnchecked = true;
        });
        return;
      }
    }
    setState(() {
      isQuillControllerSelectionUnchecked = false;
    });
  }

  bool isShowOptionActionContent() {
    if (isShowDialogSetText || isShowDialogSetEmoji) {
      return true;
    }
    return false;
  }

  Widget buildOptionActionContent(BuildContext context) {
    List listFontFamiliesParsed = CoreStoreFonts.listFontFamiliesParsed();

    if (isShowDialogSetText) {
      return Container(
        padding: const EdgeInsets.all(4.0),
        constraints: const BoxConstraints(maxHeight: 300.0),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.black,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(6.0)),
        child: DefaultTabController(
          length: 5,
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),

              /// Đặt kích thước tùy chỉnh cho AppBar
              child: AppBar(
                automaticallyImplyLeading: false, // Ẩn nút back
                title: null,

                /// Ẩn tiêu đề
                elevation: 0,

                /// Loại bỏ độ đổ bóng
                bottom: const TabBar(
                  tabs: [
                    Tab(icon: FaIcon(FontAwesomeIcons.font, size: 18.0)),
                    Tab(
                        icon: Row(
                      children: [
                        FaIcon(FontAwesomeIcons.bold, size: 18.0),
                      ],
                    )),
                    Tab(icon: FaIcon(FontAwesomeIcons.paintbrush, size: 18.0)),
                    Tab(icon: FaIcon(FontAwesomeIcons.textHeight, size: 18.0)),
                    Tab(icon: FaIcon(FontAwesomeIcons.gears, size: 18.0)),
                  ],
                ),
              ),
            ),
            body: TabBarView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: GridView.builder(
                    padding: const EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 80.0),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 150.0,

                      /// Kích thước tối đa của một cột
                      crossAxisSpacing: 10.0,

                      /// Khoảng cách giữa các cột
                      mainAxisSpacing: 10.0,

                      /// Khoảng cách giữa các hàng
                    ),
                    itemCount: listFontFamiliesParsed.length,
                    itemBuilder: (context, index) {
                      return CoreElevatedButton.iconOnly(
                        onPressed: () {},
                        coreButtonStyle: CoreButtonStyle.options(
                            coreFixedSizeButton:
                                CoreFixedSizeButton.squareIcon4060,
                            coreStyle: CoreStyle.outlined,
                            coreColor: CoreColor.turtles,
                            coreRadius: CoreRadius.radius_6,
                            kitForegroundColorOption: Colors.black),
                        icon: Center(
                          child: Text(
                            'Hi Task',
                            style: listFontFamiliesParsed[index],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: GridView.builder(
                    padding: const EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 80.0),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 150.0,

                      /// Kích thước tối đa của một cột
                      crossAxisSpacing: 10.0,

                      /// Khoảng cách giữa các cột
                      mainAxisSpacing: 10.0,

                      /// Khoảng cách giữa các hàng
                    ),
                    itemCount: CoreStoreFonts.fontStyles.length,
                    itemBuilder: (context, index) {
                      return CoreElevatedButton.iconOnly(
                        onPressed: () {},
                        coreButtonStyle: CoreButtonStyle.options(
                            coreFixedSizeButton:
                                CoreFixedSizeButton.squareIcon4060,
                            coreStyle: CoreStyle.outlined,
                            coreColor: CoreColor.turtles,
                            coreRadius: CoreRadius.radius_6,
                            kitForegroundColorOption: Colors.black),
                        icon: Center(
                          child: Text(
                            CoreStoreFonts.fontStyles[index].name,
                            style:
                                CoreStoreFonts.parseTextStyleFromCoreFontStyle(
                                    coreFontStyle:
                                        CoreStoreFonts.fontStyles[index]),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: GridView.builder(
                    padding: const EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 80.0),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 150.0,

                      /// Kích thước tối đa của một cột
                      crossAxisSpacing: 10.0,

                      /// Khoảng cách giữa các cột
                      mainAxisSpacing: 10.0,

                      /// Khoảng cách giữa các hàng
                    ),
                    itemCount: CoreStoreFonts.fontColors.length,
                    itemBuilder: (context, index) {
                      return CoreElevatedButton.iconOnly(
                        onPressed: () {},
                        coreButtonStyle: CoreButtonStyle.options(
                            coreFixedSizeButton:
                                CoreFixedSizeButton.squareIcon4060,
                            coreStyle: CoreStyle.outlined,
                            coreColor: CoreColor.turtles,
                            coreRadius: CoreRadius.radius_6,
                            kitForegroundColorOption: Colors.black,
                            kitBackgroundColorOption:
                                CoreStoreFonts.fontColors[index].color),
                        icon: Container(),
                      );
                    },
                  ),
                ),
                Container(),
                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: flutter_quill.QuillToolbar.basic(
                      controller: _detailContentQuillController),
                )
              ],
            ),
          ),
        ),
      );
    }

    if (isShowDialogSetEmoji) {
      return Container(
          margin: const EdgeInsets.fromLTRB(0, 4.0, 0, 4.0),
          padding: const EdgeInsets.all(4.0),
          constraints: BoxConstraints(maxHeight: 300.0),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.black, // Màu đường viền
                width: 1.0, // Độ dày của đường viền
              ),
              borderRadius: BorderRadius.circular(6.0)),
          child: DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(kToolbarHeight),

                /// Đặt kích thước tùy chỉnh cho AppBar
                child: AppBar(
                  automaticallyImplyLeading: false, // Ẩn nút back
                  title: null,

                  /// Ẩn tiêu đề
                  elevation: 0,

                  /// Loại bỏ độ đổ bóng
                  bottom: TabBar(
                    tabs: [
                      Tab(icon: Text(CoreStoreIcons.emoji_001)),
                      Tab(icon: Text(CoreStoreIcons.emoji_260)),
                      Tab(icon: Icon(Icons.directions_car)),
                    ],
                  ),
                ),
              ),
              body: TabBarView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: GridView.builder(
                      padding: const EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 80.0),
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 60.0,

                        /// Kích thước tối đa của một cột
                        crossAxisSpacing: 10.0,

                        /// Khoảng cách giữa các cột
                        mainAxisSpacing: 10.0,

                        /// Khoảng cách giữa các hàng
                      ),
                      itemCount: CoreStoreIcons.emojis.length,
                      itemBuilder: (context, index) {
                        return CoreElevatedButton.iconOnly(
                          onPressed: () {
                            if (_titleFocusNodeHasFocus) {
                              setState(() {
                                NoteFunctions.addStringToQuillContent(
                                    quillController: _titleQuillController,
                                    selection: _titleTextSelection,
                                    object: widget.note,
                                    insertString: CoreStoreIcons.emojis[index]
                                        .toString());
                              });
                            } else if (_detailContentFocusNodeHasFocus) {
                              setState(() {
                                NoteFunctions.addStringToQuillContent(
                                    quillController:
                                        _detailContentQuillController,
                                    selection: _detailContentTextSelection,
                                    object: widget.note,
                                    insertString: CoreStoreIcons.emojis[index]
                                        .toString());
                              });
                            }
                          },
                          coreButtonStyle: CoreButtonStyle.options(
                              coreFixedSizeButton:
                                  CoreFixedSizeButton.squareIcon4060,
                              coreStyle: CoreStyle.outlined,
                              coreColor: CoreColor.turtles,
                              coreRadius: CoreRadius.radius_6,
                              kitForegroundColorOption: Colors.black),
                          icon: Center(
                            child: Text(
                              CoreStoreIcons.emojis[index],
                              style: const TextStyle(fontSize: 18.0),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: GridView.builder(
                      padding: const EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 80.0),
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 60.0,

                        /// Kích thước tối đa của một cột
                        crossAxisSpacing: 10.0,

                        /// Khoảng cách giữa các cột
                        mainAxisSpacing: 10.0,

                        /// Khoảng cách giữa các hàng
                      ),
                      itemCount: CoreStoreIcons.natureAndAnimals.length,
                      itemBuilder: (context, index) {
                        return CoreElevatedButton.iconOnly(
                          onPressed: () {
                            if (_titleFocusNodeHasFocus) {
                              setState(() {
                                NoteFunctions.addStringToQuillContent(
                                    quillController: _titleQuillController,
                                    selection: _titleTextSelection,
                                    object: widget.note,
                                    insertString: CoreStoreIcons
                                        .natureAndAnimals[index]
                                        .toString());
                              });
                            } else if (_detailContentFocusNodeHasFocus) {
                              setState(() {
                                NoteFunctions.addStringToQuillContent(
                                    quillController:
                                        _detailContentQuillController,
                                    selection: _detailContentTextSelection,
                                    object: widget.note,
                                    insertString: CoreStoreIcons
                                        .natureAndAnimals[index]
                                        .toString());
                              });
                            }
                          },
                          coreButtonStyle: CoreButtonStyle.options(
                              coreFixedSizeButton:
                                  CoreFixedSizeButton.squareIcon4060,
                              coreStyle: CoreStyle.outlined,
                              coreColor: CoreColor.turtles,
                              coreRadius: CoreRadius.radius_6,
                              kitForegroundColorOption: Colors.black),
                          icon: Center(
                            child: Text(
                              CoreStoreIcons.natureAndAnimals[index],
                              style: const TextStyle(fontSize: 18.0),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: GridView.builder(
                      padding: const EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 80.0),
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 60.0,

                        /// Kích thước tối đa của một cột
                        crossAxisSpacing: 10.0,

                        /// Khoảng cách giữa các cột
                        mainAxisSpacing: 10.0,

                        /// Khoảng cách giữa các hàng
                      ),
                      itemCount: CoreStoreIcons.emojis.length,
                      itemBuilder: (context, index) {
                        return CoreElevatedButton.iconOnly(
                          onPressed: () {
                            if (_titleFocusNodeHasFocus) {
                              setState(() {});
                            } else if (_detailContentFocusNodeHasFocus) {
                              setState(() {
                                NoteFunctions.addStringToQuillContent(
                                    quillController:
                                        _detailContentQuillController,
                                    selection: _detailContentTextSelection,
                                    object: widget.note,
                                    insertString: CoreStoreIcons.emojis[index]
                                        .toString());
                              });
                            }
                          },
                          coreButtonStyle: CoreButtonStyle.options(
                              coreFixedSizeButton:
                                  CoreFixedSizeButton.squareIcon4060,
                              coreStyle: CoreStyle.outlined,
                              coreColor: CoreColor.turtles,
                              coreRadius: CoreRadius.radius_6,
                              kitForegroundColorOption: Colors.black),
                          icon: Center(
                            child: Text(
                              CoreStoreIcons.emojis[index],
                              style: const TextStyle(fontSize: 18.0),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ));
    }

    return Container();
  }

  _buildIconOnToolbar() {
    if (_titleFocusNode.hasFocus) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 8.0, 4.0, 4.0),
        child: flutter_quill.QuillIconButton(
          size: 24.0 * flutter_quill.kIconButtonFactor,
          onPressed: () {
            setState(() {
              FocusScope.of(context).unfocus();
              isShowDialogSetEmoji = !isShowDialogSetEmoji;
            });
          },
          icon: const Icon(
            Icons.emoji_emotions_outlined,
            size: 24,
          ),
          highlightElevation: 0,
          hoverElevation: 0,
          fillColor: Colors.white,
          borderRadius: 2,
        ),
      );
    } else if (_detailContentFocusNode.hasFocus) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 8.0, 4.0, 4.0),
        child: flutter_quill.QuillIconButton(
          size: 24.0 * flutter_quill.kIconButtonFactor,
          onPressed: () {
            setState(() {
              FocusScope.of(context).unfocus();
              isShowDialogSetEmoji = !isShowDialogSetEmoji;
            });
          },
          icon: const Icon(
            Icons.emoji_emotions_outlined,
            size: 24,
          ),
          highlightElevation: 0,
          hoverElevation: 0,
          fillColor: Colors.white,
          borderRadius: 2,
        ),
      );
    }
    return Container();
  }

  _buildUndoOnToolbar() {
    if (_titleFocusNode.hasFocus) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 8.0, 2.0, 4.0),
        child: flutter_quill.QuillIconButton(
          size: 24.0 * flutter_quill.kIconButtonFactor,
          onPressed: () {
            _titleQuillController.undo();
          },
          icon: const Icon(
            Icons.undo_outlined,
            size: 24,
          ),
          highlightElevation: 0,
          hoverElevation: 0,
          fillColor: Colors.white,
          borderRadius: 2,
        ),
      );
    } else if (_detailContentFocusNode.hasFocus) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 8.0, 2.0, 4.0),
        child: flutter_quill.QuillIconButton(
          size: 24.0 * flutter_quill.kIconButtonFactor,
          onPressed: () {
           _detailContentQuillController.undo();
          },
          icon: const Icon(
            Icons.undo_outlined,
            size: 24,
          ),
          highlightElevation: 0,
          hoverElevation: 0,
          fillColor: Colors.white,
          borderRadius: 2,
        ),
      );
    }
    return Container();
  }

  _buildRedoOnToolbar() {
    if (_titleFocusNode.hasFocus) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 4.0),
        child: flutter_quill.QuillIconButton(
          size: 24.0 * flutter_quill.kIconButtonFactor,
          onPressed: () {
            _titleQuillController.redo();
          },
          icon: const Icon(
            Icons.redo_outlined,
            size: 24,
          ),
          highlightElevation: 0,
          hoverElevation: 0,
          fillColor: Colors.white,
          borderRadius: 2,
        ),
      );
    } else if (_detailContentFocusNode.hasFocus) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 4.0),
        child: flutter_quill.QuillIconButton(
          size: 24.0 * flutter_quill.kIconButtonFactor,
          onPressed: () {
            _detailContentQuillController.redo();
          },
          icon: const Icon(
            Icons.redo_outlined,
            size: 24,
          ),
          highlightElevation: 0,
          hoverElevation: 0,
          fillColor: Colors.white,
          borderRadius: 2,
        ),
      );
    }
    return Container();
  }

  _buildCheckboxButtonOnToolbar() {
    if (_titleFocusNode.hasFocus) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 8.0, 4.0, 4.0),
        child: flutter_quill.ToggleCheckListButton(
            icon: Icons.check_box_outlined,
            controller: _titleQuillController,
            attribute: flutter_quill.Attribute.unchecked,
            iconSize: 24),
      );
    } else if (_detailContentFocusNode.hasFocus) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 8.0, 4.0, 4.0),
        child: flutter_quill.ToggleCheckListButton(
            icon: Icons.check_box_outlined,
            controller: _detailContentQuillController,
            attribute: flutter_quill.Attribute.unchecked,
            iconSize: 24),
      );
    }
    return Container();
  }

  _buildBoldTextOnToolbar() {
    if (_titleFocusNode.hasFocus) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 8.0, 2.0, 4.0),
        child: flutter_quill.ToggleStyleButton(
            icon: Icons.format_bold,
            controller: _titleQuillController,
            attribute: flutter_quill.Attribute.bold,
            iconSize: 24),
      );
    } else if (_detailContentFocusNode.hasFocus) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 8.0, 2.0, 4.0),
        child: flutter_quill.ToggleStyleButton(
            icon: Icons.format_bold,
            controller: _detailContentQuillController,
            attribute: flutter_quill.Attribute.bold,
            iconSize: 24),
      );
    }
    return Container();
  }

  _buildItalicTextOnToolbar() {
    if (_titleFocusNode.hasFocus) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 8.0, 2.0, 4.0),
        child: flutter_quill.ToggleStyleButton(
            icon: Icons.format_italic,
            controller: _titleQuillController,
            attribute: flutter_quill.Attribute.italic,
            iconSize: 24),
      );
    } else if (_detailContentFocusNode.hasFocus) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 8.0, 2.0, 4.0),
        child: flutter_quill.ToggleStyleButton(
            icon: Icons.format_italic,
            controller: _detailContentQuillController,
            attribute: flutter_quill.Attribute.italic,
            iconSize: 24),
      );
    }
    return Container();
  }

  _buildUnderlineTextOnToolbar() {
    if (_titleFocusNode.hasFocus) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 8.0, 4.0, 4.0),
        child: flutter_quill.ToggleStyleButton(
            icon: Icons.format_underline,
            controller: _titleQuillController,
            attribute: flutter_quill.Attribute.underline,
            iconSize: 24),
      );
    } else if (_detailContentFocusNode.hasFocus) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 8.0, 4.0, 4.0),
        child: flutter_quill.ToggleStyleButton(
            icon: Icons.format_underline,
            controller: _detailContentQuillController,
            attribute: flutter_quill.Attribute.underline,
            iconSize: 24),
      );
    }
    return Container();
  }

  /// Scroll Toolbar

  _buildFontFamilyOnToolbar() {
    if (_titleFocusNode.hasFocus) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 8.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(4.0)),
              border: Border.all(width: 1.0)),
          child: flutter_quill.QuillFontFamilyButton(
              rawItemsMap: fontFamilies,
              controller: _titleQuillController,
              attribute: flutter_quill.Attribute.font,
              iconSize: 24),
        ),
      );
    } else if (_detailContentFocusNode.hasFocus) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 8.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(4.0)),
              border: Border.all(width: 1.0)),
          child: flutter_quill.QuillFontFamilyButton(
            rawItemsMap: fontFamilies,
            controller: _detailContentQuillController,
            attribute: flutter_quill.Attribute.font,
            iconSize: 24,
          ),
        ),
      );
    }
    return Container();
  }

  _buildTextSizeOnToolbar() {
    if (_titleFocusNode.hasFocus) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 4.0, 4.0, 8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(4.0)),
              border: Border.all(width: 1.0)),
          child: flutter_quill.QuillFontSizeButton(
              rawItemsMap: fontSizes,
              controller: _titleQuillController,
              attribute: flutter_quill.Attribute.size,
              iconSize: 24),
        ),
      );
    } else if (_detailContentFocusNode.hasFocus) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 4.0, 4.0, 8.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(4.0)),
              border: Border.all(width: 1.0)),
          child: flutter_quill.QuillFontSizeButton(
              rawItemsMap: fontSizes,
              controller: _detailContentQuillController,
              attribute: flutter_quill.Attribute.size,
              iconSize: 24),
        ),
      );
    }
    return Container();
  }

  _buildTextColorOnToolbar() {
    if (_titleFocusNode.hasFocus) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 4.0, 2.0, 8.0),
        child: flutter_quill.ColorButton(
            background: false,
            icon: Icons.format_color_text_outlined,
            controller: _titleQuillController,
            iconSize: 24),
      );
    } else if (_detailContentFocusNode.hasFocus) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 4.0, 2.0, 8.0),
        child: flutter_quill.ColorButton(
            background: false,
            icon: Icons.format_color_text_outlined,
            controller: _detailContentQuillController,
            iconSize: 24),
      );
    }
    return Container();
  }

  _buildTextBackgroundColorOnToolbar() {
    if (_titleFocusNode.hasFocus) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 4.0, 3.0, 8.0),
        child: flutter_quill.ColorButton(
            background: true,
            icon: Icons.format_color_fill,
            controller: _titleQuillController,
            iconSize: 24),
      );
    } else if (_detailContentFocusNode.hasFocus) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 4.0, 3.0, 8.0),
        child: flutter_quill.ColorButton(
            background: true,
            icon: Icons.format_color_fill,
            controller: _detailContentQuillController,
            iconSize: 24),
      );
    }
    return Container();
  }

  _buildHeadingOnToolbar() {
    if (_titleFocusNode.hasFocus) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 4.0, 3.0, 8.0),
        child: flutter_quill.SelectHeaderStyleButton(
            controller: _titleQuillController, iconSize: 24),
      );
    } else if (_detailContentFocusNode.hasFocus) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 4.0, 3.0, 8.0),
        child: flutter_quill.SelectHeaderStyleButton(
            controller: _detailContentQuillController, iconSize: 24),
      );
    }
    return Container();
  }

  _buildIndentIncreaseOnToolbar() {
    if (_titleFocusNode.hasFocus) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 4.0, 2.0, 8.0),
        child: flutter_quill.IndentButton(
            isIncrease: true,
            icon: Icons.format_indent_increase,
            controller: _titleQuillController,
            iconSize: 24),
      );
    } else if (_detailContentFocusNode.hasFocus) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 4.0, 2.0, 8.0),
        child: flutter_quill.IndentButton(
            isIncrease: true,
            icon: Icons.format_indent_increase,
            controller: _detailContentQuillController,
            iconSize: 24),
      );
    }
    return Container();
  }

  _buildIndentDecreaseOnToolbar() {
    if (_titleFocusNode.hasFocus) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 4.0, 4.0, 8.0),
        child: flutter_quill.IndentButton(
            isIncrease: false,
            icon: Icons.format_indent_decrease,
            controller: _titleQuillController,
            iconSize: 24),
      );
    } else if (_detailContentFocusNode.hasFocus) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 4.0, 4.0, 8.0),
        child: flutter_quill.IndentButton(
            isIncrease: false,
            icon: Icons.format_indent_decrease,
            controller: _detailContentQuillController,
            iconSize: 24),
      );
    }
    return Container();
  }

  _buildListOnToolbar() {
    if (_titleFocusNode.hasFocus) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 4.0, 2.0, 8.0),
        child: flutter_quill.ToggleStyleButton(
            icon: Icons.format_list_bulleted,
            controller: _titleQuillController,
            attribute: flutter_quill.Attribute.ul,
            iconSize: 24),
      );
    } else if (_detailContentFocusNode.hasFocus) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 4.0, 2.0, 8.0),
        child: flutter_quill.ToggleStyleButton(
            icon: Icons.format_list_bulleted,
            controller: _detailContentQuillController,
            attribute: flutter_quill.Attribute.ul,
            iconSize: 24),
      );
    }
    return Container();
  }

  _buildNumberListOnToolbar() {
    if (_titleFocusNode.hasFocus) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 4.0, 0, 8.0),
        child: flutter_quill.ToggleStyleButton(
            icon: Icons.format_list_numbered,
            controller: _titleQuillController,
            attribute: flutter_quill.Attribute.ol,
            iconSize: 24),
      );
    } else if (_detailContentFocusNode.hasFocus) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 4.0, 0, 8.0),
        child: flutter_quill.ToggleStyleButton(
            icon: Icons.format_list_numbered,
            controller: _detailContentQuillController,
            attribute: flutter_quill.Attribute.ol,
            iconSize: 24),
      );
    }
    return Container();
  }

  _buildLeftAlignmentSelectOnToolbar() {
    if (_titleFocusNode.hasFocus) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 4.0, 0, 8.0),
        child: flutter_quill.SelectAlignmentButton(
            controller: _titleQuillController,
            showLeftAlignment: true,
            showCenterAlignment: false,
            showRightAlignment: false,
            showJustifyAlignment: false,
            iconSize: 24),
      );
    } else if (_detailContentFocusNode.hasFocus) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 4.0, 0, 8.0),
        child: flutter_quill.SelectAlignmentButton(
          controller: _detailContentQuillController,
          showLeftAlignment: true,
          showCenterAlignment: false,
          showRightAlignment: false,
          showJustifyAlignment: false,
          iconSize: 24,
        ),
      );
    }
    return Container();
  }

  _buildCenterAlignmentOnToolbar() {
    if (_titleFocusNode.hasFocus) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 4.0, 0, 8.0),
        child: flutter_quill.SelectAlignmentButton(
            controller: _titleQuillController,
            showLeftAlignment: false,
            showCenterAlignment: true,
            showRightAlignment: false,
            showJustifyAlignment: false,
            iconSize: 24),
      );
    } else if (_detailContentFocusNode.hasFocus) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 4.0, 0, 8.0),
        child: flutter_quill.SelectAlignmentButton(
          controller: _detailContentQuillController,
          showLeftAlignment: false,
          showCenterAlignment: true,
          showRightAlignment: false,
          showJustifyAlignment: false,
          iconSize: 24,
        ),
      );
    }
    return Container();
  }

  _buildRightAlignmentOnToolbar() {
    if (_titleFocusNode.hasFocus) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 4.0, 2.0, 8.0),
        child: flutter_quill.SelectAlignmentButton(
            controller: _titleQuillController,
            showLeftAlignment: false,
            showCenterAlignment: false,
            showRightAlignment: true,
            showJustifyAlignment: false,
            iconSize: 24),
      );
    } else if (_detailContentFocusNode.hasFocus) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 4.0, 2.0, 8.0),
        child: flutter_quill.SelectAlignmentButton(
          controller: _detailContentQuillController,
          showLeftAlignment: false,
          showCenterAlignment: false,
          showRightAlignment: true,
          showJustifyAlignment: false,
          iconSize: 24,
        ),
      );
    }
    return Container();
  }

  _buildJustifyAlignmentOnToolbar() {
    if (_titleFocusNode.hasFocus) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 4.0, 0, 8.0),
        child: flutter_quill.SelectAlignmentButton(
            controller: _titleQuillController,
            showLeftAlignment: false,
            showCenterAlignment: false,
            showRightAlignment: false,
            showJustifyAlignment: true,
            iconSize: 24),
      );
    } else if (_detailContentFocusNode.hasFocus) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 4.0, 0, 8.0),
        child: flutter_quill.SelectAlignmentButton(
          controller: _detailContentQuillController,
          showLeftAlignment: false,
          showCenterAlignment: false,
          showRightAlignment: false,
          showJustifyAlignment: true,
          iconSize: 24,
        ),
      );
    }
    return Container();
  }

  _buildCloseButtonSetEmojiOnToolbar() {
    if (isShowDialogSetEmoji) {
      return CoreElevatedButton.iconOnly(
        icon: const FaIcon(FontAwesomeIcons.check, size: 18.0),
        onPressed: () {
          setState(() {
            isShowDialogSetEmoji = false;

            if (_CurrentFocusNodeEnum == CurrentFocusNodeEnum.title) {
              // _titleFocusNode.requestFocus();
              FocusScope.of(context).requestFocus(_titleFocusNode);
            } else if (_CurrentFocusNodeEnum == CurrentFocusNodeEnum.detailContent) {
              // _detailContentFocusNode.requestFocus();
              FocusScope.of(context).requestFocus(_detailContentFocusNode);
            } else {
              FocusScope.of(context).requestFocus(_detailContentFocusNode);
            }
          });
        },
        coreButtonStyle: CoreButtonStyle.options(
            coreStyle: CoreStyle.outlined,
            coreColor: CoreColor.success,
            coreRadius: CoreRadius.radius_6,
            kitForegroundColorOption: Colors.black,
            coreFixedSizeButton: CoreFixedSizeButton.medium_40),
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    NoteController controller = NoteController();

    List listFontFamiliesParsed = CoreStoreFonts.listFontFamiliesParsed();

    return CoreFullScreenDialog(
      title: widget.note == null ? 'Add a note' : 'Edit note',
      isConfirmToClose: true,
      focusNodes: [_titleFocusNode, _detailContentFocusNode],
      isShowGeneralActionButton: false,
      optionActionContent: buildOptionActionContent(context),
      onSubmit: () async {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();

          final title =
              jsonEncode(_titleQuillController.document.toDelta().toJson());

          final description = jsonEncode(
              _detailContentQuillController.document.toDelta().toJson());

          if (title.isEmpty || description.isEmpty) {
            return;
          }

          final NoteModel model = NoteModel(
              title: title, description: description, id: widget.note?.id);
          if (widget.note == null &&
              widget.actionMode == ActionModeEnum.create) {
            if (await controller.onCreateNote(model)) {}
          } else if (widget.note != null &&
              widget.actionMode == ActionModeEnum.update) {
            var result = await controller.onUpdateNote(model);
          }
        }
      },
      onRedo: () {
        // _quillToolbarController.redo();
      },
      onUndo: () {
        // _quillToolbarController.undo();
      },
      bottomActionBar: [
        Column(
          children: [
            Row(
              children: [
                _buildIconOnToolbar(),
                _buildCheckboxButtonOnToolbar(),
                _buildBoldTextOnToolbar(),
                _buildItalicTextOnToolbar(),
                _buildUnderlineTextOnToolbar(),
                _buildUndoOnToolbar(),
                _buildRedoOnToolbar(),
                _buildCloseButtonSetEmojiOnToolbar(),
              ],
            ),
          ],
        ),
      ],
      bottomActionBarScrollable: [
        _buildFontFamilyOnToolbar(),
        _buildTextSizeOnToolbar(),
        _buildTextColorOnToolbar(),
        _buildTextBackgroundColorOnToolbar(),
        _buildLeftAlignmentSelectOnToolbar(),
        _buildCenterAlignmentOnToolbar(),
        _buildJustifyAlignmentOnToolbar(),
        _buildRightAlignmentOnToolbar(),
        _buildHeadingOnToolbar(),
        _buildIndentIncreaseOnToolbar(),
        _buildIndentDecreaseOnToolbar(),
        _buildListOnToolbar(),
        _buildNumberListOnToolbar()
      ],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          onWillPop: () async {
            if (await CoreHelperWidget.confirmFunction(context)) {
              return true;
            }
            return false;
          },
          child: SingleChildScrollView(
            controller: _controllerScrollController,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Title:',
                      style: GoogleFonts.montserrat(
                          fontStyle: FontStyle.italic, fontSize: 16),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blue,
                        width: 1.0,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(12.0))),
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    constraints: const BoxConstraints(maxHeight: 60.0),
                    margin: const EdgeInsets.all(4.0),
                    padding: const EdgeInsets.all(6.0),
                    child: flutter_quill.QuillEditor(
                      controller: _titleQuillController,
                      readOnly: _titleReadOnly,
                      autoFocus: _titleAutoFocus,
                      expands: _titleExpands,
                      focusNode: _titleFocusNode,
                      padding: _titlePadding,
                      scrollController: _titleScrollController,
                      scrollable: _titleScrollable,
                    ),
                  ),
                ),
                const SizedBox(height: 5.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Content:',
                      style: GoogleFonts.montserrat(
                          fontStyle: FontStyle.italic, fontSize: 16),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blue,
                        width: 1.0,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(12.0))),
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    constraints: const BoxConstraints(
                        minHeight: 150.0, maxHeight: 200.0),
                    margin: const EdgeInsets.all(4.0),
                    padding: const EdgeInsets.all(6.0),
                    child: flutter_quill.QuillEditor(
                      controller: _detailContentQuillController,
                      readOnly: _detailContentReadOnly,
                      autoFocus: _detailContentAutoFocus,
                      expands: _detailContentExpands,
                      focusNode: _detailContentFocusNode,
                      padding: _detailContentPadding,
                      scrollController: _detailContentScrollController,
                      scrollable: _detailContentScrollable,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                const SizedBox(
                  height: 200,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
