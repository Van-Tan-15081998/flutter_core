import 'dart:async';
import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core_v3/app/library/common/themes/ThemeDataCenter.dart';
import 'package:flutter_core_v3/app/library/extensions/extensions.dart';
import 'package:flutter_core_v3/app/screens/features/note/note_list_screen.dart';
import 'package:flutter_core_v3/app/screens/setting/providers/setting_notifier.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_quill/flutter_quill.dart' as flutter_quill;
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../../core/components/actions/common_buttons/CoreButtonStyle.dart';
import '../../../../core/components/actions/common_buttons/CoreElevatedButton.dart';
import '../../../../core/components/containment/dialogs/CoreFullScreenDialog.dart';
import '../../../../core/components/helper_widgets/CoreHelperWidget.dart';
import '../../../../core/components/notifications/CoreNotification.dart';
import '../../../library/common/languages/CommonLanguages.dart';
import '../../../library/common/styles/CommonStyles.dart';
import '../../../library/common/utils/CommonAudioOnPressButton.dart';
import '../../../library/enums/CommonEnums.dart';
import '../label/databases/label_db_manager.dart';
import '../label/models/label_model.dart';
import '../label/widgets/label_create_screen.dart';
import '../subjects/databases/subject_db_manager.dart';
import '../subjects/models/subject_model.dart';
import '../subjects/providers/subject_notifier.dart';
import '../subjects/widgets/subject_create_screen.dart';
import 'databases/note_db_manager.dart';
import 'models/note_model.dart';
import 'note_detail_screen.dart';
import 'providers/note_notifier.dart';

enum CurrentFocusNodeEnum { none, title, detailContent }

class NoteCreateScreen extends StatefulWidget {
  final NoteModel? note;

  /*
  Create note by copy note OR create from template
   */
  final NoteModel? copyNote;

  final SubjectModel? subject;
  final ActionModeEnum actionMode;
  final ActionCreateNoteEnum? actionCreateNoteEnum;
  final int? createdForDay;

  final RedirectFromEnum? redirectFrom;

  const NoteCreateScreen(
      {super.key,
      required this.note,
      required this.copyNote,
      required this.subject,
      required this.actionMode,
      this.actionCreateNoteEnum,
      this.createdForDay,
      required this.redirectFrom});

  @override
  State<NoteCreateScreen> createState() => _NoteCreateScreenState();
}

class _NoteCreateScreenState extends State<NoteCreateScreen> {
  CommonAudioOnPressButton commonAudioOnPressButton =
      CommonAudioOnPressButton();
  final ScrollController _controllerScrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();

  bool isShowDialogSetLabel = false;

  bool isLock = false;

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

  _onReloadLabel() {
    _fetchLabels().then((labels) {
      if (labels != null && labels.isNotEmpty) {
        setState(() {
          labelList = labels;
        });
        _setSelectedLabels();
      }
    });
  }

  _onReloadSubjects(SettingNotifier settingNotifier) {
    _fetchSubjects().then((subjects) {
      if (subjects != null && subjects.isNotEmpty) {
        setState(() {
          subjectList = subjects;
          if (subjectList != null && subjectList!.isNotEmpty) {
            SubjectModel emptySubject = SubjectModel(
              id: null,
              title: '[Not select]',
              color: 'ffffff',
              parentId: null,
              createdAt: null,
            );
            subjectList!.add(emptySubject);
            selectedSubject = subjectList!.first;
          }
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();

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
          Limit the subject list for choose (Create note for selected subject)
           */
          if (widget.subject != null && subjects.isNotEmpty) {
            List<SubjectModel>? mySubjects = subjects
                .where((element) => element.id == widget.subject!.id)
                .toList();
            if (mySubjects.isNotEmpty) {
              setState(() {
                subjectList!.add(mySubjects.first);
              });
            }
          } else if (widget.subject == null) {
            setState(() {
              subjectList = subjects;
              if (subjectList != null) {
                SubjectModel emptySubject = SubjectModel(
                  id: null,
                  title: '[Not select]',
                  color: 'ffffff',
                  parentId: null,
                  createdAt: null,
                );
                subjectList!.add(emptySubject);
              }
            });
          }
        });
        _setSelectedSubject();
      }
    });

    /// If update
    if (widget.note != null && widget.actionMode == ActionModeEnum.update) {
      if (widget.note!.title != null && widget.note!.title!.isNotEmpty) {
        /// Set data for input
        List<dynamic> deltaMap = jsonDecode(widget.note!.title!);
        flutter_quill.Delta delta = flutter_quill.Delta.fromJson(deltaMap);
        _titleDocument = flutter_quill.Document.fromDelta(delta);
      }

      if (widget.note!.description != null &&
          widget.note!.description!.isNotEmpty) {
        /// Set data for input
        List<dynamic> deltaMap = jsonDecode(widget.note!.description!);
        flutter_quill.Delta delta = flutter_quill.Delta.fromJson(deltaMap);
        _detailContentDocument = flutter_quill.Document.fromDelta(delta);
      }

      if (widget.note!.isLocked != null) {
        isLock = true;
      }
    } else if (widget.copyNote != null &&
        widget.actionMode == ActionModeEnum.copy) {
      if (widget.copyNote!.title != null &&
          widget.copyNote!.title!.isNotEmpty) {
        /// Set data for input
        List<dynamic> deltaMap = jsonDecode(widget.copyNote!.title!);
        flutter_quill.Delta delta = flutter_quill.Delta.fromJson(deltaMap);
        _titleDocument = flutter_quill.Document.fromDelta(delta);
      }

      if (widget.copyNote!.description != null &&
          widget.copyNote!.description!.isNotEmpty) {
        /// Set data for input
        List<dynamic> deltaMap = jsonDecode(widget.copyNote!.description!);
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

    // Listen Focus And Hide Dialog SetText
    _titleFocusNode.addListener(() {
      if (_titleFocusNode.hasFocus) {
        setState(() {
          _currentFocusNodeEnum = CurrentFocusNodeEnum.title;
          closeOptionActionContent();
          _titleQuillController.ignoreFocusOnTextChange = false;

          _titleFocusNodeHasFocus = true;
          _detailContentFocusNodeHasFocus = false;
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

  @override
  void dispose() {
    commonAudioOnPressButton.dispose();
    super.dispose();
  }

  Widget _buildOptionActionContent(
      BuildContext context, SettingNotifier settingNotifier) {
    if (isShowDialogSetLabel) {
      if (labelList != null && labelList!.isNotEmpty) {
        return Container(
          margin: const EdgeInsets.fromLTRB(0, 4.0, 0, 4.0),
          padding: const EdgeInsets.all(4.0),
          constraints: const BoxConstraints(maxHeight: 300.0),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: const Color(0xff1f1f1f), // Màu đường viền
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
      } else {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BounceInLeft(
                    child: const FaIcon(FontAwesomeIcons.waze,
                        size: 30.0, color: Colors.white54)),
                const SizedBox(width: 5),
                BounceInRight(
                  child: Text(
                      CommonLanguages.convert(
                          lang: settingNotifier.languageString ??
                              CommonLanguages.languageStringDefault(),
                          word: 'notification.noItem.label'),
                      style: GoogleFonts.montserrat(
                          fontStyle: FontStyle.italic,
                          fontSize: 16.0,
                          color: Colors.white54,
                          fontWeight: FontWeight.w500)),
                ),
              ],
            ),
          ),
        );
      }
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

  _buildCloseButtonSetLabelOnToolbar() {
    if (isShowDialogSetLabel) {
      return CoreElevatedButton.iconOnly(
        buttonAudio: commonAudioOnPressButton,
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
            kitForegroundColorOption: const Color(0xff1f1f1f),
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
      if (widget.note != null && widget.actionMode == ActionModeEnum.update) {
        List<dynamic> labelIds = jsonDecode(widget.note!.labels!);

        // Get only label not deleted
        List<int?> labelListIds =
            labelList!.map((element) => element.id).toList();
        for (var element in labelIds) {
          if (labelListIds.contains(element)) {
            selectedLabelIds.add(element);
          }
        }

        setState(() {
          selectedNoteLabels = labelList!
              .where((model) => selectedLabelIds.contains(model.id))
              .toList();
          selectedLabelDataLoaded = true;
        });
      } else if (widget.copyNote != null &&
          widget.actionMode == ActionModeEnum.copy) {
        List<dynamic> labelIds = jsonDecode(widget.copyNote!.labels!);

        // Get only label not deleted
        List<int?> labelListIds =
            labelList!.map((element) => element.id).toList();
        for (var element in labelIds) {
          if (labelListIds.contains(element)) {
            selectedLabelIds.add(element);
          }
        }

        setState(() {
          selectedNoteLabels = labelList!
              .where((model) => selectedLabelIds.contains(model.id))
              .toList();
          selectedLabelDataLoaded = true;
        });
      }
    }
  }

  _setSelectedSubject() {
    /*
    Update note
     */
    if (widget.note != null && widget.actionMode == ActionModeEnum.update) {
      if (widget.note!.subjectId != null) {
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
    }

    /*
    Copy note
     */
    else if (widget.copyNote != null &&
        widget.actionMode == ActionModeEnum.copy) {
      if (widget.copyNote!.subjectId != null) {
        List<SubjectModel>? subjects;

        if (subjectList != null &&
            subjectList!.isNotEmpty &&
            !selectedSubjectDataLoaded) {
          subjects = subjectList!
              .where((model) => widget.copyNote!.subjectId == model.id)
              .toList();

          if (subjects.isNotEmpty) {
            selectedSubject = subjects.first;

            selectedSubjectDataLoaded = true;
          }
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

  Widget? _buildAppbarLeading() {
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final noteNotifier = Provider.of<NoteNotifier>(context);
    final subjectNotifier = Provider.of<SubjectNotifier>(context);
    final settingNotifier = Provider.of<SettingNotifier>(context);

    return CoreFullScreenDialog(
      homeLabel: null,
      appbarLeading: _buildAppbarLeading(),
      isShowOptionActionButton: true,
      title: _buildTitle(context, settingNotifier),
      isConfirmToClose: true,
      actions: AppBarActionButtonEnum.save,
      isShowBottomActionButton: true,
      isShowGeneralActionButton: false,
      optionActionContent: _buildOptionActionContent(context, settingNotifier),
      onGoHome: () {},
      onSubmit: () async {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();

          final title =
              jsonEncode(_titleQuillController.document.toDelta().toJson());

          final description = jsonEncode(
              _detailContentQuillController.document.toDelta().toJson());

          if (_detailContentQuillController.document.isEmpty()) {
            CoreNotification.showMessage(context, settingNotifier,
                CoreNotificationStatus.warning, 'Please enter your content!');
            return;
          }

          final labels = jsonEncode(selectedLabelIds);

          if ((widget.note == null &&
                  widget.actionMode == ActionModeEnum.create) ||
              (widget.copyNote != null &&
                  widget.actionMode == ActionModeEnum.copy)) {
            final NoteModel model = NoteModel(
                title: title,
                description: description,
                labels: labels,
                subjectId: selectedSubject?.id,
                createdAt: DateTime.now().millisecondsSinceEpoch,
                createdAtDayFormat: DateTime(DateTime.now().year,
                        DateTime.now().month, DateTime.now().day)
                    .millisecondsSinceEpoch,
                createdForDay: (widget.actionCreateNoteEnum ==
                                ActionCreateNoteEnum.createForSelectedDay ||
                            widget.actionMode == ActionModeEnum.copy) &&
                        widget.createdForDay != null
                    ? widget.createdForDay
                    : null,
                isFavourite: null,
                isPinned: null,
                isLocked: isLock == false
                    ? null
                    : DateTime(DateTime.now().year, DateTime.now().month,
                            DateTime.now().day)
                        .millisecondsSinceEpoch,
                id: widget.note?.id);

            _onCreateNote(context, model).then((result) {
              if (result) {
                noteNotifier.onCountAll();

                CoreNotification.showMessage(context, settingNotifier, CoreNotificationStatus.success,
                    CommonLanguages.convert(
                        lang: settingNotifier.languageString ??
                            CommonLanguages.languageStringDefault(),
                        word: 'notification.action.created'));

                if (widget.redirectFrom ==
                    RedirectFromEnum.subjectsInFolderMode) {
                  Navigator.pop(context, result);
                } else {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NoteListScreen(
                              noteConditionModel: null,
                              isOpenSubjectsForFilter: null,
                              redirectFrom: null,
                            )),
                    (route) => false,
                  );
                }
              } else {
                CoreNotification.showMessage(context, settingNotifier, CoreNotificationStatus.error,
                    CommonLanguages.convert(
                        lang: settingNotifier.languageString ??
                            CommonLanguages.languageStringDefault(),
                        word: 'notification.action.error'));
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
                createdAtDayFormat: widget.note?.createdAtDayFormat,
                createdForDay: widget.note?.createdForDay,
                updatedAt: DateTime.now().millisecondsSinceEpoch,
                isPinned: widget.note?.isPinned,
                isLocked: isLock == false
                    ? null
                    : widget.note?.isLocked ??
                        DateTime(DateTime.now().year, DateTime.now().month,
                                DateTime.now().day)
                            .millisecondsSinceEpoch,
                id: widget.note?.id);

            _onUpdateNote(context, model).then((result) {
              if (result) {
                CoreNotification.showMessage(context, settingNotifier, CoreNotificationStatus.success,
                    CommonLanguages.convert(
                        lang: settingNotifier.languageString ??
                            CommonLanguages.languageStringDefault(),
                        word: 'notification.action.updated'));

                _onGetUpdatedNote(context, model).then((getResult) {
                  if (getResult != null) {
                    if (widget.redirectFrom ==
                        RedirectFromEnum.subjectsInFolderMode) {
                      Navigator.pop(context, result);
                    } else {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NoteDetailScreen(
                                    note: getResult,
                                    labels: selectedNoteLabels,
                                    subject: selectedSubject?.id == null
                                        ? null
                                        : selectedSubject,
                                    redirectFrom: RedirectFromEnum.noteUpdate,
                                  )),
                          (route) => false);
                    }
                  }
                });
              } else {
                CoreNotification.showMessage(context, settingNotifier, CoreNotificationStatus.error,
                    CommonLanguages.convert(
                        lang: settingNotifier.languageString ??
                            CommonLanguages.languageStringDefault(),
                        word: 'notification.action.error'));
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
                _buildCheckboxButtonOnToolbar(),
                _buildBoldTextOnToolbar(),
                _buildItalicTextOnToolbar(),
                _buildUnderlineTextOnToolbar(),
                _buildUndoOnToolbar(),
                _buildRedoOnToolbar(),
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
            if (await CoreHelperWidget.confirmFunction(context: context, settingNotifier: settingNotifier, confirmExitScreen: true)) {
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
                    Container(
                      margin: settingNotifier.isSetBackgroundImage == true
                          ? const EdgeInsets.fromLTRB(0, 5.0, 0, 2.0)
                          : const EdgeInsets.all(0),
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                          color: settingNotifier.isSetBackgroundImage == true
                              ? Colors.white.withOpacity(0.65)
                              : Colors.transparent),
                      child: Padding(
                        padding: settingNotifier.isSetBackgroundImage == true
                            ? const EdgeInsets.all(5.0)
                            : const EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
                        child: Text(
                          CommonLanguages.convert(
                                  lang: settingNotifier.languageString ??
                                      CommonLanguages.languageStringDefault(),
                                  word: 'form.field.title.title')
                              .addColon()
                              .toString(),
                          style: GoogleFonts.montserrat(
                              fontStyle: FontStyle.italic,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color:
                                  ThemeDataCenter.getFormFieldLabelColorStyle(
                                      context)),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                      color: settingNotifier.isSetBackgroundImage == true
                          ? Colors.white.withOpacity(0.65)
                          : Colors.transparent,
                      border: Border.all(
                        color: const Color(0xFF404040),
                        width: 1.0,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(12.0))),
                  child: Container(
                    decoration: BoxDecoration(
                        color: settingNotifier.isSetBackgroundImage == true
                            ? Colors.white.withOpacity(0.65)
                            : const Color(0xFFF7F7F7),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10.0))),
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
                    Container(
                      margin: settingNotifier.isSetBackgroundImage == true
                          ? const EdgeInsets.fromLTRB(0, 5.0, 0, 2.0)
                          : const EdgeInsets.all(0),
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                          color: settingNotifier.isSetBackgroundImage == true
                              ? Colors.white.withOpacity(0.65)
                              : Colors.transparent),
                      child: Padding(
                        padding: settingNotifier.isSetBackgroundImage == true
                            ? const EdgeInsets.all(5.0)
                            : const EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
                        child: Text(
                          key: _detailContentKeyForScroll,
                          CommonLanguages.convert(
                                  lang: settingNotifier.languageString ??
                                      CommonLanguages.languageStringDefault(),
                                  word: 'form.field.title.content')
                              .addColon()
                              .toString(),
                          style: GoogleFonts.montserrat(
                              fontStyle: FontStyle.italic,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color:
                                  ThemeDataCenter.getFormFieldLabelColorStyle(
                                      context)),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                      color: settingNotifier.isSetBackgroundImage == true
                          ? Colors.white.withOpacity(0.65)
                          : Colors.transparent,
                      border: Border.all(
                        color: const Color(0xFF404040),
                        width: 1.0,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(12.0))),
                  child: Container(
                    decoration: BoxDecoration(
                        color: settingNotifier.isSetBackgroundImage == true
                            ? Colors.white.withOpacity(0.65)
                            : const Color(0xFFF7F7F7),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10.0))),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: settingNotifier.isSetBackgroundImage == true
                          ? const EdgeInsets.fromLTRB(0, 5.0, 0, 2.0)
                          : const EdgeInsets.all(0),
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                          color: settingNotifier.isSetBackgroundImage == true
                              ? Colors.white.withOpacity(0.65)
                              : Colors.transparent),
                      child: Padding(
                        padding: settingNotifier.isSetBackgroundImage == true
                            ? const EdgeInsets.all(5.0)
                            : const EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
                        child: Text(
                          CommonLanguages.convert(
                                  lang: settingNotifier.languageString ??
                                      CommonLanguages.languageStringDefault(),
                                  word: 'form.field.title.subject')
                              .addColon()
                              .toString(),
                          style: GoogleFonts.montserrat(
                              fontStyle: FontStyle.italic,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color:
                                  ThemeDataCenter.getFormFieldLabelColorStyle(
                                      context)),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        bool? isCreatedSubject = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SubjectCreateScreen(
                                    parentSubject: null,
                                    actionMode: ActionModeEnum.create,
                                    redirectFrom: RedirectFromEnum.noteCreate,
                                    breadcrumb: null,
                                  )),
                        );

                        if (isCreatedSubject == true) {
                          _onReloadSubjects(settingNotifier);
                        }
                      },
                      borderRadius: BorderRadius.circular(10.0),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: ThemeDataCenter.getFilteringTextColorStyle(
                                  context),
                              width: 1.0,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10.0)),
                            color: settingNotifier.isSetBackgroundImage == true
                                ? Colors.white.withOpacity(0.65)
                                : Colors.transparent),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Icon(
                            Icons.add_rounded,
                            size: 22,
                            color: ThemeDataCenter
                                .getDeleteSlidableActionColorStyle(context),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                subjectList != null && subjectList!.isNotEmpty
                    ? Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                            color: settingNotifier.isSetBackgroundImage == true
                                ? Colors.white.withOpacity(0.65)
                                : Colors.transparent),
                        child: Padding(
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
                                    items: subjectList!.map((item) {
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
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding:
                                const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(24.0)),
                                color:
                                    settingNotifier.isSetBackgroundImage == true
                                        ? Colors.white.withOpacity(0.65)
                                        : Colors.transparent),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                BounceInLeft(
                                    child: FaIcon(FontAwesomeIcons.waze,
                                        size: 30.0,
                                        color: ThemeDataCenter
                                            .getAloneTextColorStyle(context))),
                                const SizedBox(width: 5),
                                BounceInRight(
                                  child: Text(
                                      CommonLanguages.convert(
                                          lang:
                                              settingNotifier.languageString ??
                                                  CommonLanguages
                                                      .languageStringDefault(),
                                          word: 'notification.noItem.subject'),
                                      style: GoogleFonts.montserrat(
                                          fontStyle: FontStyle.italic,
                                          fontSize: 16.0,
                                          color: ThemeDataCenter
                                              .getAloneTextColorStyle(context),
                                          fontWeight: FontWeight.w500)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: settingNotifier.isSetBackgroundImage == true
                          ? const EdgeInsets.fromLTRB(0, 5.0, 0, 2.0)
                          : const EdgeInsets.all(0),
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                          color: settingNotifier.isSetBackgroundImage == true
                              ? Colors.white.withOpacity(0.65)
                              : Colors.transparent),
                      child: Padding(
                        padding: settingNotifier.isSetBackgroundImage == true
                            ? const EdgeInsets.all(5.0)
                            : const EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
                        child: Text(
                          CommonLanguages.convert(
                              lang: settingNotifier.languageString ??
                                  CommonLanguages.languageStringDefault(),
                              word: 'form.field.title.lock')
                              .addColon(),
                          style: GoogleFonts.montserrat(
                              fontStyle: FontStyle.italic,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color:
                                  ThemeDataCenter.getFormFieldLabelColorStyle(
                                      context)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20.0),
                    Expanded(
                      child: SwitchListTile(
                          contentPadding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                          title: Container(),
                          value: isLock,
                          onChanged: (bool value) {
                            setState(() {
                              isLock = value;
                            });
                          }),
                    )
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: settingNotifier.isSetBackgroundImage == true
                          ? const EdgeInsets.fromLTRB(0, 5.0, 0, 2.0)
                          : const EdgeInsets.all(0),
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                          color: settingNotifier.isSetBackgroundImage == true
                              ? Colors.white.withOpacity(0.65)
                              : Colors.transparent),
                      child: Padding(
                        padding: settingNotifier.isSetBackgroundImage == true
                            ? const EdgeInsets.all(5.0)
                            : const EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
                        child: Text(
                          CommonLanguages.convert(
                                  lang: settingNotifier.languageString ??
                                      CommonLanguages.languageStringDefault(),
                                  word: 'form.field.title.label')
                              .addColon()
                              .toString(),
                          style: GoogleFonts.montserrat(
                              fontStyle: FontStyle.italic,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color:
                                  ThemeDataCenter.getFormFieldLabelColorStyle(
                                      context)),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        bool? isCreatedLabel = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LabelCreateScreen(
                                    actionMode: ActionModeEnum.create,
                                    redirectFrom: RedirectFromEnum.noteCreate,
                                  )),
                        );

                        if (isCreatedLabel == true) {
                          _onReloadLabel();
                        }
                      },
                      borderRadius: BorderRadius.circular(10.0),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: ThemeDataCenter.getFilteringTextColorStyle(
                                  context),
                              width: 1.0,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10.0)),
                            color: settingNotifier.isSetBackgroundImage == true
                                ? Colors.white.withOpacity(0.65)
                                : Colors.transparent),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Icon(
                            Icons.add_rounded,
                            size: 22,
                            color: ThemeDataCenter
                                .getDeleteSlidableActionColorStyle(context),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                labelList != null && labelList!.isNotEmpty
                    ? Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                            color: settingNotifier.isSetBackgroundImage == true
                                ? Colors.white.withOpacity(0.65)
                                : Colors.transparent),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              CoreElevatedButton.icon(
                                buttonAudio: commonAudioOnPressButton,
                                icon: const FaIcon(FontAwesomeIcons.tag,
                                    size: 18.0),
                                label: Text(CommonLanguages.convert(
                                    lang: settingNotifier.languageString ??
                                        CommonLanguages.languageStringDefault(),
                                    word: 'button.title.selectLabel'),
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
                                    coreFixedSizeButton:
                                        CoreFixedSizeButton.medium_40),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding:
                                const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(24.0)),
                                color:
                                    settingNotifier.isSetBackgroundImage == true
                                        ? Colors.white.withOpacity(0.65)
                                        : Colors.transparent),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                BounceInLeft(
                                    child: FaIcon(FontAwesomeIcons.waze,
                                        size: 30.0,
                                        color: ThemeDataCenter
                                            .getAloneTextColorStyle(context))),
                                const SizedBox(width: 5),
                                BounceInRight(
                                  child: Text(
                                      CommonLanguages.convert(
                                          lang:
                                              settingNotifier.languageString ??
                                                  CommonLanguages
                                                      .languageStringDefault(),
                                          word: 'notification.noItem.label'),
                                      style: GoogleFonts.montserrat(
                                          fontStyle: FontStyle.italic,
                                          fontSize: 16.0,
                                          color: ThemeDataCenter
                                              .getAloneTextColorStyle(context),
                                          fontWeight: FontWeight.w500)),
                                ),
                              ],
                            ),
                          ),
                        ],
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

  Widget _buildTitle(BuildContext context, SettingNotifier settingNotifier) {
    return Padding(
      padding: const EdgeInsets.only(right: 4.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(5.0),
              decoration: CommonStyles.titleScreenDecorationStyle(
                  settingNotifier.isSetBackgroundImage),
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      widget.note == null
                          ? CommonLanguages.convert(
                              lang: settingNotifier.languageString ??
                                  CommonLanguages.languageStringDefault(),
                              word: 'screen.title.create.note')
                          : CommonLanguages.convert(
                              lang: settingNotifier.languageString ??
                                  CommonLanguages.languageStringDefault(),
                              word: 'screen.title.update.note'),
                      style: CommonStyles.screenTitleTextStyle(
                          fontSize: 16.0,
                          color:
                              ThemeDataCenter.getScreenTitleTextColor(context)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 5),
          (widget.actionCreateNoteEnum ==
                          ActionCreateNoteEnum.createForSelectedDay ||
                      widget.actionMode == ActionModeEnum.copy) &&
                  widget.createdForDay != null
              ? Expanded(
                  child: Container(
                    padding:
                    settingNotifier.isSetBackgroundImage ==
                        true
                        ? const EdgeInsets.all(2.0)
                        : const EdgeInsets.all(0),
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                            Radius.circular(6.0)),
                        color: settingNotifier
                            .isSetBackgroundImage ==
                            true
                            ? Colors.white.withOpacity(0.65)
                            : Colors.transparent),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Flexible(
                              child: Text(
                                CommonLanguages.convert(
                                    lang: settingNotifier.languageString ??
                                        CommonLanguages.languageStringDefault(),
                                    word: 'screen.title.selectedDate').addColon(),
                                style: TextStyle(
                                    color:
                                        ThemeDataCenter.getAloneTextColorStyle(context),
                                    fontSize: 12),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Flexible(
                              child: Text(
                                DateFormat('dd/MM/yyyy')
                                    .format(DateTime.fromMillisecondsSinceEpoch(
                                        widget.createdForDay!))
                                    .toString(),
                                style: TextStyle(
                                    color: ThemeDataCenter.getAloneTextColorStyle(
                                        context),
                                    fontSize: 14),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
