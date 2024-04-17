import 'dart:async';
import 'dart:convert';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core_v3/app/library/extensions/extensions.dart';
import 'package:flutter_core_v3/app/screens/features/note/note_list_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_quill/flutter_quill.dart' as flutter_quill;
import 'package:provider/provider.dart';
import '../../../../core/components/actions/common_buttons/CoreButtonStyle.dart';
import '../../../../core/components/actions/common_buttons/CoreElevatedButton.dart';
import '../../../../core/components/containment/dialogs/CoreFullScreenDialog.dart';
import '../../../../core/components/helper_widgets/CoreHelperWidget.dart';
import '../../../../core/components/notifications/CoreNotification.dart';
import '../../../../core/stores/icons/CoreStoreIcons.dart';
import '../../../library/common/styles/CommonStyles.dart';
import '../../../library/enums/CommonEnums.dart';
import '../label/databases/label_db_manager.dart';
import '../label/models/label_model.dart';
import '../subjects/databases/subject_db_manager.dart';
import '../subjects/models/subject_model.dart';
import 'databases/note_db_manager.dart';
import 'models/note_model.dart';
import 'note_detail_screen.dart';
import 'providers/note_notifier.dart';
import 'widgets/functions/note_functions.dart';

enum CurrentFocusNodeEnum { none, title, detailContent }

class NoteCreateScreen extends StatefulWidget {
  final NoteModel? note;
  final SubjectModel? subject;
  final ActionModeEnum actionMode;

  const NoteCreateScreen(
      {super.key, this.note, required this.subject, required this.actionMode});

  @override
  State<NoteCreateScreen> createState() => _NoteCreateScreenState();
}

class _NoteCreateScreenState extends State<NoteCreateScreen> {
  final ScrollController _controllerScrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();

  bool isShowDialogSetLabel = false;
  bool isShowDialogSetEmoji = false;

  /*
   Title's Parameters
   */
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

  /*
   Detail Content's Parameters
   */
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
  CurrentFocusNodeEnum _currentFocusNodeEnum = CurrentFocusNodeEnum.none;

  double optionActionContent = 0.0;

  double _detailContentContainerHeight = 300.0;

  late StreamController<List<SubjectModel>?> _subjectStreamController;
  late Stream<List<SubjectModel>?> _subjectStream;

  List<LabelModel>? selectedNoteLabels = [];
  List<LabelModel>? labelList = [];
  List<SubjectModel>? subjectList = [];
  SubjectModel? selectedSubject;
  List<dynamic> selectedLabelIds = [];

  // bien nay de danh dau sau khi du load data de update da thuc hien xong, khong load lai lan nao nua khi rebuild giao dien (co setState)
  bool selectedLabelDataLoaded = false;
  bool selectedSubjectDataLoaded = false;

  final _detailContentKeyForScroll = GlobalKey();
  Future _scrollToDetailContent() async {
    final context = _detailContentKeyForScroll.currentContext;

    await Scrollable.ensureVisible(
      context!,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

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

  /*
  Get Labels From DB
   */
  Future<List<LabelModel>?> _fetchLabels() async {
    List<LabelModel>? labels = await LabelDatabaseManager.all();

    return labels;
  }

  /*
  Get Subjects From DB
   */
  Future<List<SubjectModel>?> _fetchSubjects() async {
    List<SubjectModel>? subjects = await SubjectDatabaseManager.all();

    return subjects;
  }

  @override
  void initState() {
    super.initState();

    _subjectStreamController = StreamController<List<SubjectModel>?>();
    _subjectStream = _subjectStreamController.stream;
    _subjectStreamController.add(subjectList);

    // Fetch Labels and Subjects
    _fetchLabels().then((labels) {
      if (labels != null && labels.isNotEmpty) {
        setState(() {
          labelList = labels;
        });
        _setSelectedLabels();
      }
    });
    _fetchSubjects().then((subjects) {
      if (subjects != null && subjects.isNotEmpty) {
        setState(() {
          /*
          Limit the subject list for choose
           */
          if (widget.subject != null && subjects.isNotEmpty) {
            List<SubjectModel>? mySubjects = subjects
                .where((element) => element.id == widget.subject!.id)
                .toList();
            if (mySubjects.isNotEmpty) {
              subjectList!.add(mySubjects.first);
            }
          } else if (widget.subject == null) {
            subjectList = subjects;
          }
        });

        _subjectStreamController.add(subjectList);
      }
    });

    /// If edit
    if (widget.note is NoteModel) {
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
      _detailContentAutoFocus = true;
    }

    /// Title Init Setup
    _titleQuillController = flutter_quill.QuillController(
        document: _titleDocument, selection: _titleTextSelection);

    /// Detail Content Init Setup
    _detailContentQuillController = flutter_quill.QuillController(
        document: _detailContentDocument,
        selection: _detailContentTextSelection);

    // Listen Focus And Hide Dialog SetText and SetEmoji
    _titleFocusNode.addListener(() {
      if (_titleFocusNode.hasFocus) {
        setState(() {
          _currentFocusNodeEnum = CurrentFocusNodeEnum.title;
          closeOptionActionContent();
          _titleQuillController.ignoreFocusOnTextChange = false;

          _titleFocusNodeHasFocus = true;
          _detailContentFocusNodeHasFocus = false;
          isShowDialogSetEmoji = false;
          isShowDialogSetLabel = false;
        });
      } else {
        print('unfocus');
      }
    });
    _detailContentFocusNode.addListener(() {
      if (_detailContentFocusNode.hasFocus) {
        setState(() {
          _detailContentContainerHeight = 200.0;
          _currentFocusNodeEnum = CurrentFocusNodeEnum.detailContent;
          closeOptionActionContent();
          _detailContentQuillController.ignoreFocusOnTextChange = false;

          _detailContentFocusNodeHasFocus = true;
          _titleFocusNodeHasFocus = false;
          isShowDialogSetEmoji = false;
          isShowDialogSetLabel = false;
        });

        _scrollToDetailContent();
      } else {
        print('unfocus');
      }
    });
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
    if (isShowDialogSetEmoji) {
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    _subjectStreamController.close();
    super.dispose();
  }

  Widget buildOptionActionContent(BuildContext context) {
    if (isShowDialogSetEmoji) {
      return Container(
          margin: const EdgeInsets.fromLTRB(0, 4.0, 0, 4.0),
          padding: const EdgeInsets.all(4.0),
          constraints: const BoxConstraints(maxHeight: 300.0),
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
                preferredSize: const Size.fromHeight(kToolbarHeight),

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
                                    insertString: CoreStoreIcons.emojis[index]
                                        .toString());
                              });
                            } else if (_detailContentFocusNodeHasFocus) {
                              setState(() {
                                NoteFunctions.addStringToQuillContent(
                                    quillController:
                                        _detailContentQuillController,
                                    selection: _detailContentTextSelection,
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
                ],
              ),
            ),
          ));
    }

    if (isShowDialogSetLabel) {
      if (labelList != null && labelList!.isNotEmpty) {
        return Container(
          margin: const EdgeInsets.fromLTRB(0, 4.0, 0, 4.0),
          padding: const EdgeInsets.all(4.0),
          constraints: const BoxConstraints(maxHeight: 300.0),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.black, // Màu đường viền
                width: 1.0, // Độ dày của đường viền
              ),
              borderRadius: BorderRadius.circular(6.0)),
          child: ListView.builder(
              itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (selectedLabelIds
                              .contains(labelList![index].id!)) {
                            selectedLabelIds.remove(labelList![index].id!);
                          } else {
                            selectedLabelIds.add(labelList![index].id!);
                          }
                          selectedNoteLabels = labelList!
                              .where((model) =>
                                  selectedLabelIds.contains(model.id))
                              .toList();
                        });
                      },
                      child: Row(
                        children: [
                          selectedLabelIds.contains(labelList![index].id!)
                              ? const Icon(
                                  Icons.check_box_outlined,
                                  size: 26.0,
                                )
                              : const Icon(
                                  Icons.check_box_outline_blank_outlined,
                                  size: 26.0,
                                ),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: DottedBorder(
                                  borderType: BorderType.RRect,
                                  radius: const Radius.circular(12),
                                  color: labelList![index].color.toColor(),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12)),
                                    child: Container(
                                        color: Colors.white,
                                        child: Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                  Icons.label_important_rounded,
                                                  color: labelList![index]
                                                      .color
                                                      .toColor()),
                                              Flexible(
                                                  child: Text(
                                                      labelList![index].title,
                                                      maxLines: 1,
                                                      overflow: TextOverflow
                                                          .ellipsis)),
                                            ],
                                          ),
                                        )),
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              itemCount: labelList!.length),
        );
      }
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
        padding: const EdgeInsets.fromLTRB(0, 4.0, 4.0, 8.0),
        child: flutter_quill.ToggleStyleButton(
            icon: Icons.format_list_numbered,
            controller: _titleQuillController,
            attribute: flutter_quill.Attribute.ol,
            iconSize: 24),
      );
    } else if (_detailContentFocusNode.hasFocus) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 4.0, 4.0, 8.0),
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

            if (_currentFocusNodeEnum == CurrentFocusNodeEnum.title) {
              // _titleFocusNode.requestFocus();
              FocusScope.of(context).requestFocus(_titleFocusNode);
            } else if (_currentFocusNodeEnum ==
                CurrentFocusNodeEnum.detailContent) {
              // _detailContentFocusNode.requestFocus();
              FocusScope.of(context).requestFocus(_detailContentFocusNode);
            } else {
              FocusScope.of(context).requestFocus(_detailContentFocusNode);
            }
          });
        },
        coreButtonStyle: CoreButtonStyle.options(
            coreStyle: CoreStyle.outlined,
            coreColor: CoreColor.dark,
            coreRadius: CoreRadius.radius_6,
            kitForegroundColorOption: Colors.black,
            coreFixedSizeButton: CoreFixedSizeButton.medium_40),
      );
    }
    return Container();
  }

  _buildCloseButtonSetLabelOnToolbar() {
    if (isShowDialogSetLabel) {
      return CoreElevatedButton.iconOnly(
        icon: const FaIcon(FontAwesomeIcons.check, size: 18.0),
        onPressed: () {
          setState(() {
            isShowDialogSetLabel = false;
          });
        },
        coreButtonStyle: CoreButtonStyle.options(
            coreStyle: CoreStyle.outlined,
            coreColor: CoreColor.dark,
            coreRadius: CoreRadius.radius_6,
            kitForegroundColorOption: Colors.black,
            coreFixedSizeButton: CoreFixedSizeButton.medium_40),
      );
    }
    return Container();
  }

  _onBack() {
    if (_titleFocusNode.hasFocus) {
      _titleFocusNode.unfocus();
    } else if (_detailContentFocusNode.hasFocus) {
      _detailContentFocusNode.unfocus();
    }
  }

  _setSelectedLabels() async {
    if (labelList != null &&
        labelList!.isNotEmpty &&
        !selectedLabelDataLoaded) {
      if (widget.note != null) {
        List<dynamic> labelIds = jsonDecode(widget.note!.labels!);
        selectedLabelIds = labelIds;
        setState(() {
          selectedNoteLabels =
              labelList!.where((model) => labelIds.contains(model.id)).toList();
          selectedLabelDataLoaded = true;
        });
      }
    }
  }

  _setSelectedSubject() {
    /*
    Update note
     */
    if (widget.note?.subjectId != null) {
      List<SubjectModel>? subjects;

      if (subjectList != null &&
          subjectList!.isNotEmpty &&
          !selectedSubjectDataLoaded) {
        subjects = subjectList!
            .where((model) => widget.note!.subjectId == model.id)
            .toList();

        if (subjects.isNotEmpty) {
          selectedSubject = subjects.first;

          selectedSubjectDataLoaded = true;
        }
      }
    }

    /*
    Create note for subject
     */
    if (widget.subject != null && subjectList!.isNotEmpty) {
      selectedSubject = subjectList!.first;
    }
  }

  Widget _buildLabels() {
    List<Widget> labelWidgets = [];

    if (selectedNoteLabels!.isNotEmpty) {
      for (var element in selectedNoteLabels!) {
        labelWidgets.add(
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: DottedBorder(
                borderType: BorderType.RRect,
                radius: const Radius.circular(12),
                color: element.color.toColor(),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  child: Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.label_important_rounded,
                              color: element.color.toColor(),
                            ),
                            Flexible(
                              child: Text(element.title,
                                  maxLines: 1, overflow: TextOverflow.ellipsis),
                            ),
                          ],
                        ),
                      )),
                )),
          ),
        );
      }
    }
    return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: labelWidgets,
        ));
  }

  Future<bool> _onCreateNote(BuildContext context, NoteModel note) async {
    return await NoteDatabaseManager.create(note);
  }

  Future<bool> _onUpdateNote(BuildContext context, NoteModel note) async {
    return await NoteDatabaseManager.update(note);
  }

  Future<NoteModel?> _onGetUpdatedNote(
      BuildContext context, NoteModel note) async {
    return await NoteDatabaseManager.getById(note.id!);
  }

  @override
  Widget build(BuildContext context) {
    final noteNotifier = Provider.of<NoteNotifier>(context);

    return CoreFullScreenDialog(
      isShowOptionActionButton: true,
      title: widget.note == null ? 'Create' : 'Update',
      isConfirmToClose: true,
      actions: AppBarActionButtonEnum.save,
      isShowBottomActionButton: true,
      isShowGeneralActionButton: false,
      optionActionContent: buildOptionActionContent(context),
      onGoHome: () {},
      onSubmit: () async {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();

          final title =
              jsonEncode(_titleQuillController.document.toDelta().toJson());

          final description = jsonEncode(
              _detailContentQuillController.document.toDelta().toJson());

          if (_detailContentQuillController.document.isEmpty()) {
            CoreNotification.showMessage(context,
                CoreNotificationStatus.warning, 'Please enter your content!');
            return;
          }

          final labels = jsonEncode(selectedLabelIds);

          if (widget.note == null &&
              widget.actionMode == ActionModeEnum.create) {
            final NoteModel model = NoteModel(
                title: title,
                description: description,
                labels: labels,
                subjectId: selectedSubject?.id,
                createdAt: DateTime.now().millisecondsSinceEpoch,
                id: widget.note?.id);

            _onCreateNote(context, model).then((result) {
              if (result) {
                noteNotifier.onCountAll();

                CoreNotification.show(context, CoreNotificationStatus.success,
                    CoreNotificationAction.create, 'Note');

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const NoteListScreen(noteConditionModel: null)),
                  (route) => false,
                );
              } else {
                CoreNotification.show(context, CoreNotificationStatus.error,
                    CoreNotificationAction.create, 'Note');
              }
            });
          } else if (widget.note != null &&
              widget.actionMode == ActionModeEnum.update) {
            final NoteModel model = NoteModel(
                title: title,
                description: description,
                labels: labels,
                subjectId: selectedSubject?.id,
                isFavourite: widget.note?.isFavourite,
                createdAt: widget.note?.createdAt,
                updatedAt: DateTime.now().millisecondsSinceEpoch,
                id: widget.note?.id);

            _onUpdateNote(context, model).then((result) {
              if (result) {
                CoreNotification.show(context, CoreNotificationStatus.success,
                    CoreNotificationAction.update, 'Note');

                // Navigator.pushAndRemoveUntil(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) =>
                //           const NoteListScreen(noteConditionModel: null)),
                //   (route) => false,
                // );

                _onGetUpdatedNote(context, model).then((result) {
                  if (result != null) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NoteDetailScreen(
                                  note: result,
                                  labels: selectedNoteLabels,
                                  subject: selectedSubject,
                                )),
                        (route) => false);
                  }
                });
              } else {
                CoreNotification.show(context, CoreNotificationStatus.error,
                    CoreNotificationAction.update, 'Note');
              }
            });
          }
        }
      },
      onRedo: null,
      onUndo: null,
      onBack: null,
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
                _buildCloseButtonSetLabelOnToolbar()
              ],
            ),
          ],
        ),
      ],
      bottomActionBarScrollable: [
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
        _buildNumberListOnToolbar(),
      ],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          onWillPop: () async {
            _onBack();
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
                          fontStyle: FontStyle.italic,
                          fontSize: 16,
                          color: Colors.white54),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFF404040),
                        width: 1.0,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(12.0))),
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Color(0xFFF7F7F7),
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
                      placeholder: 'Tap to enter your title',
                      customStyles: flutter_quill.DefaultStyles(
                          placeHolder: flutter_quill.DefaultTextBlockStyle(
                              const TextStyle(
                                  fontSize: 16.0, color: Colors.grey),
                              const flutter_quill.VerticalSpacing(1.0, 1.0),
                              const flutter_quill.VerticalSpacing(1.0, 1.0),
                              null)),
                    ),
                  ),
                ),
                const SizedBox(height: 5.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      key: _detailContentKeyForScroll,
                      'Content:',
                      style: GoogleFonts.montserrat(
                          fontStyle: FontStyle.italic,
                          fontSize: 16,
                          color: Colors.white54),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFF404040),
                        width: 1.0,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(12.0))),
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Color(0xFFF7F7F7),
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    constraints: BoxConstraints(
                        minHeight: 150.0,
                        maxHeight: _detailContentContainerHeight),
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
                      placeholder: 'Tap to enter your content',
                      customStyles: flutter_quill.DefaultStyles(
                          placeHolder: flutter_quill.DefaultTextBlockStyle(
                              const TextStyle(
                                  fontSize: 16.0, color: Colors.grey),
                              const flutter_quill.VerticalSpacing(1.0, 1.0),
                              const flutter_quill.VerticalSpacing(1.0, 1.0),
                              null)),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Subject:',
                      style: GoogleFonts.montserrat(
                          fontStyle: FontStyle.italic,
                          fontSize: 16,
                          color: Colors.white54),
                    ),
                  ],
                ),
                StreamBuilder<List<SubjectModel>?>(
                    stream: _subjectStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData &&
                          snapshot.data != null &&
                          snapshot.data!.isNotEmpty) {
                        _setSelectedSubject();

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField(
                                    isExpanded: true,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Color(0xff343a40), width: 2),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Color(0xff343a40), width: 2),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                    dropdownColor: Colors.white,
                                    value: selectedSubject,
                                    onChanged: (SubjectModel? newValue) {
                                      setState(() {
                                        selectedSubject = newValue;
                                      });
                                    },
                                    items: snapshot.data!.map((item) {
                                      return DropdownMenuItem(
                                        value: item,
                                        child: Text(item.title,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1),
                                      );
                                    }).toList()),
                              ),
                            ],
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return const Text('No subjects found',
                            style: TextStyle(color: Colors.white54));
                      }
                    }),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Labels:',
                      style: GoogleFonts.montserrat(
                          fontStyle: FontStyle.italic,
                          fontSize: 16,
                          color: Colors.white54),
                    ),
                  ],
                ),
                CoreElevatedButton.icon(
                  icon: const FaIcon(FontAwesomeIcons.tag, size: 18.0),
                  label: Text('Choose labels',
                      style: CommonStyles.buttonTextStyle),
                  onPressed: () {
                    if (_titleFocusNode.hasFocus) {
                      _titleFocusNode.unfocus();
                    }
                    if (_detailContentFocusNode.hasFocus) {
                      _detailContentFocusNode.unfocus();
                    }

                    setState(() {
                      isShowDialogSetLabel = true;
                    });
                  },
                  coreButtonStyle: CoreButtonStyle.options(
                      coreStyle: CoreStyle.outlined,
                      coreColor: CoreColor.dark,
                      coreRadius: CoreRadius.radius_6,
                      kitForegroundColorOption: Colors.black,
                      coreFixedSizeButton: CoreFixedSizeButton.medium_40),
                ),
                _buildLabels(),
                const SizedBox(
                  height: 500,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}