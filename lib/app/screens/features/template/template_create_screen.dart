import 'dart:async';
import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core_v3/app/library/extensions/extensions.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_quill/flutter_quill.dart' as flutter_quill;
import 'package:provider/provider.dart';
import '../../../../core/components/actions/common_buttons/CoreButtonStyle.dart';
import '../../../../core/components/actions/common_buttons/CoreElevatedButton.dart';
import '../../../../core/components/containment/dialogs/CoreBasicDialog.dart';
import '../../../../core/components/containment/dialogs/CoreFullScreenDialog.dart';
import '../../../../core/components/helper_widgets/CoreHelperWidget.dart';
import '../../../../core/components/notifications/CoreNotification.dart';
import '../../../library/common/dimensions/CommonDimensions.dart';
import '../../../library/common/languages/CommonLanguages.dart';
import '../../../library/common/styles/CommonStyles.dart';
import '../../../library/common/themes/ThemeDataCenter.dart';
import '../../../library/common/utils/CommonAudioOnPressButton.dart';
import '../../../library/enums/CommonEnums.dart';
import '../../setting/providers/setting_notifier.dart';
import '../label/databases/label_db_manager.dart';
import '../label/models/label_model.dart';
import '../label/widgets/label_create_screen.dart';
import '../subjects/databases/subject_db_manager.dart';
import '../subjects/models/subject_model.dart';
import '../subjects/widgets/subject_create_screen.dart';
import 'databases/template_db_manager.dart';
import 'models/template_model.dart';
import 'providers/template_notifier.dart';
import 'template_detail_screen.dart';
import 'template_list_screen.dart';

enum CurrentFocusNodeEnum { none, title, detailContent }

class TemplateCreateScreen extends StatefulWidget {
  final TemplateModel? template;
  final SubjectModel? subject;
  final ActionModeEnum actionMode;

  const TemplateCreateScreen(
      {super.key,
      this.template,
      required this.subject,
      required this.actionMode});

  @override
  State<TemplateCreateScreen> createState() => _TemplateCreateScreenState();
}

class _TemplateCreateScreenState extends State<TemplateCreateScreen> {
  CommonAudioOnPressButton commonAudioOnPressButton =
      CommonAudioOnPressButton();
  final ScrollController _controllerScrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();
  bool reloadMark = false;

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

  bool isQuillControllerSelectionUnchecked = false;

  double optionActionContent = 0.0;

  double _detailContentContainerHeight = 300.0;

  List<LabelModel>? labelList = [];
  List<SubjectModel>? subjectList = [];
  SubjectModel? selectedSubject;
  List<LabelModel> selectedLabels = [];

  // bien nay de danh dau sau khi du load data de update da thuc hien xong, khong load lai lan nao nua khi rebuild giao dien (co setState)
  bool selectedLabelDataLoaded = false;
  bool selectedSubjectDataLoaded = false;

  final _detailContentKeyForScroll = GlobalKey();

  @override
  void initState() {
    super.initState();

    // Fetch Labels and Subjects
    _fetchLabels().then((labels) {
      if (labels != null && labels.isNotEmpty) {
        setState(() {
          labelList = labels;
        });
        _onSetSelectedLabels();
      }
    });
    _fetchSubjects().then((subjects) {
      if (subjects != null && subjects.isNotEmpty) {
        setState(() {
          /*
          Limit the subject list for choose (Create template for selected subject)
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
            });
          }
        });
        _onSetSelectedSubject();
      }
    });

    /// If edit
    if (widget.template != null && widget.actionMode == ActionModeEnum.update) {
      if (widget.template!.title.isNotEmpty) {
        /// Set data for input
        List<dynamic> deltaMap = jsonDecode(widget.template!.title);

        flutter_quill.Delta delta = flutter_quill.Delta.fromJson(deltaMap);
        _titleDocument = flutter_quill.Document.fromDelta(delta);

        /// Set selection
      }

      if (widget.template!.description.isNotEmpty) {
        /// Set data for input
        List<dynamic> deltaMap = jsonDecode(widget.template!.description);

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
          closeOptionActionContent();
          _titleQuillController.ignoreFocusOnTextChange = false;
          _titleFocusNodeHasFocus = true;
        });
      }
    });
    _detailContentFocusNode.addListener(() {
      if (_detailContentFocusNode.hasFocus) {
        setState(() {
          _detailContentContainerHeight = 200.0;
          closeOptionActionContent();
          _detailContentQuillController.ignoreFocusOnTextChange = false;
          _titleFocusNodeHasFocus = false;
        });

        _scrollToDetailContent();
      }
    });
  }

  @override
  void dispose() {
    commonAudioOnPressButton.dispose();
    super.dispose();
  }

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

  void _onReSetState() {
    setState(() {
      reloadMark = !reloadMark;
    });
  }

  void _onReloadLabel() {
    _fetchLabels().then((labels) {
      if (labels != null && labels.isNotEmpty) {
        setState(() {
          labelList = labels;
          if (labelList != null && labelList!.isNotEmpty) {
            selectedLabels.insert(0, labelList!.first);
          }
        });
        // _onSetSelectedLabels();
      }
    });
  }

  void _onReloadSubjects() {
    _fetchSubjects().then((subjects) {
      if (subjects != null && subjects.isNotEmpty) {
        setState(() {
          subjectList = subjects;
          if (subjectList != null && subjectList!.isNotEmpty) {
            selectedSubject = subjectList!.first;
          }
        });
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

  Widget _buildUndoOnToolbar() {
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

  Widget _buildRedoOnToolbar() {
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

  Widget _buildCheckboxButtonOnToolbar() {
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

  Widget _buildBoldTextOnToolbar() {
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

  Widget _buildItalicTextOnToolbar() {
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

  Widget _buildUnderlineTextOnToolbar() {
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

  Widget _buildTextColorOnToolbar() {
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

  Widget _buildTextBackgroundColorOnToolbar() {
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

  Widget _buildHeadingOnToolbar() {
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

  Widget _buildIndentIncreaseOnToolbar() {
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

  Widget _buildIndentDecreaseOnToolbar() {
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

  Widget _buildListOnToolbar() {
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

  Widget _buildNumberListOnToolbar() {
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

  Widget _buildLeftAlignmentSelectOnToolbar() {
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

  Widget _buildCenterAlignmentOnToolbar() {
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

  Widget _buildRightAlignmentOnToolbar() {
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

  Widget _buildJustifyAlignmentOnToolbar() {
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

  void _onBack() {
    if (_titleFocusNode.hasFocus) {
      _titleFocusNode.unfocus();
    } else if (_detailContentFocusNode.hasFocus) {
      _detailContentFocusNode.unfocus();
    }
  }

  List<int> _onGetTemplateLabelIds(TemplateModel template) {
    List<int> templateLabelIds = [];
    if (template.label01Id != null) {
      templateLabelIds.add(template.label01Id!);
    }
    if (template.label02Id != null) {
      templateLabelIds.add(template.label02Id!);
    }
    if (template.label03Id != null) {
      templateLabelIds.add(template.label03Id!);
    }
    if (template.label04Id != null) {
      templateLabelIds.add(template.label04Id!);
    }
    if (template.label05Id != null) {
      templateLabelIds.add(template.label05Id!);
    }

    return templateLabelIds;
  }

  void _onSetSelectedLabels() async {
    if (labelList != null &&
        labelList!.isNotEmpty &&
        !selectedLabelDataLoaded) {
      if (widget.template != null) {
        List<dynamic> labelIds = _onGetTemplateLabelIds(widget.template!);

        setState(() {
          selectedLabels =
              labelList!.where((model) => labelIds.contains(model.id)).toList();
          selectedLabelDataLoaded = true;
        });
      }
    }
  }

  bool _onCheckSelectedLabelsContainsById(int id) {
    if (selectedLabels.isNotEmpty) {
      List<int> selectedLabelIds = selectedLabels.map((e) => e.id!).toList();

      return selectedLabelIds.contains(id);
    }
    return false;
  }

  void _onSetSelectedSubject() {
    /*
    Update template
     */
    if (widget.template?.subjectId != null) {
      List<SubjectModel>? subjects;

      if (subjectList != null &&
          subjectList!.isNotEmpty &&
          !selectedSubjectDataLoaded) {
        subjects = subjectList!
            .where((model) => widget.template!.subjectId == model.id)
            .toList();

        if (subjects.isNotEmpty) {
          selectedSubject = subjects.first;

          selectedSubjectDataLoaded = true;
        }
      }
    }

    /*
    Create template for subject
     */
    if (widget.subject != null && subjectList!.isNotEmpty) {
      selectedSubject = subjectList!.first;
    }
  }

  Future<bool> _onCreateTemplate(
      BuildContext context, TemplateModel template) async {
    return await TemplateDatabaseManager.create(template);
  }

  Future<bool> _onUpdateTemplate(
      BuildContext context, TemplateModel template) async {
    return await TemplateDatabaseManager.update(template);
  }

  Future<TemplateModel?> _onGetUpdatedTemplate(
      BuildContext context, TemplateModel template) async {
    return await TemplateDatabaseManager.getById(template.id!);
  }

  int? _getSelectedLabelId(int index) {
    int? result;
    if (selectedLabels.length > index) {
      result = selectedLabels[index].id;
    } else {
      result = null;
    }
    return result;
  }

  void unFocusAll() {
    if (_titleFocusNode.hasFocus) {
      _titleFocusNode.unfocus();
    }
    if (_detailContentFocusNode.hasFocus) {
      _detailContentFocusNode.unfocus();
    }
  }

  void showPopupSelectLabels(
      BuildContext context, SettingNotifier settingNotifier) async {
    unFocusAll();
    if (labelList != null && labelList!.isNotEmpty) {
      bool? result = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: CoreBasicDialog(
            insetPadding: const EdgeInsets.all(5.0),
            backgroundColor: Colors.white.withOpacity(0.95),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: SizedBox(
              height: CommonDimensions.maxHeightScreen(context) * 0.75,
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(5.0, 20.0, 5.0, 10.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              CommonLanguages.convert(
                                  lang: settingNotifier.languageString ??
                                      CommonLanguages.languageStringDefault(),
                                  word: 'button.title.selectLabel'),
                              style: CommonStyles.screenTitleTextStyle(
                                  fontSize: 16.0,
                                  color: const Color(0xFF1f1f1f)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      Expanded(
                        child: ListView.builder(
                            itemCount: labelList!.length,
                            itemBuilder: (context, index) {
                              return StatefulBuilder(builder:
                                  (BuildContext context, StateSetter setState) {
                                return Container(
                                  color: _onCheckSelectedLabelsContainsById(labelList![index].id!)
                                      ? Colors.lightGreenAccent.withOpacity(0.3)
                                      : Colors.transparent,
                                  child: SwitchListTile(
                                      title: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Flexible(
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.rectangle,
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(2.0),
                                                          child: DottedBorder(
                                                            borderType:
                                                                BorderType
                                                                    .RRect,
                                                            radius: const Radius
                                                                .circular(12),
                                                            color: labelList![
                                                                    index]
                                                                .color
                                                                .toColor(),
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  const BorderRadius
                                                                          .all(
                                                                      Radius.circular(
                                                                          12)),
                                                              child: Container(
                                                                color: Colors
                                                                    .white,
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          6.0),
                                                                  child: Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .label_important_rounded,
                                                                        color: labelList![index]
                                                                            .color
                                                                            .toColor(),
                                                                      ),
                                                                      const SizedBox(
                                                                          width:
                                                                              6.0),
                                                                      Flexible(
                                                                        child: Text(
                                                                            labelList![index]
                                                                                .title,
                                                                            maxLines:
                                                                                1,
                                                                            overflow:
                                                                                TextOverflow.ellipsis),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      value: _onCheckSelectedLabelsContainsById(labelList![index].id!),
                                      onChanged: (bool value) {
                                        if (value) {
                                          if (selectedLabels.length < 5 && !_onCheckSelectedLabelsContainsById(labelList![index].id!)) {
                                            setState(() {
                                              selectedLabels
                                                  .add(labelList![index]);
                                            });
                                          }
                                        } else {
                                          setState(() {
                                            selectedLabels
                                                .removeWhere((element) => element.id == labelList![index].id!);
                                          });
                                        }
                                      }),
                                );
                              });
                            }),
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CoreElevatedButton.icon(
                            buttonAudio: commonAudioOnPressButton,
                            icon: const FaIcon(FontAwesomeIcons.check,
                                size: 18.0),
                            label: Text(
                                CommonLanguages.convert(
                                    lang: settingNotifier.languageString ??
                                        CommonLanguages.languageStringDefault(),
                                    word: 'button.title.accept'),
                                style: CommonStyles.labelTextStyle),
                            onPressed: () {
                              if (Navigator.canPop(context)) {
                                Navigator.pop(context, true);
                              }
                            },
                            coreButtonStyle: CoreButtonStyle.options(
                                coreStyle: CoreStyle.filled,
                                coreColor: CoreColor.success,
                                coreRadius: CoreRadius.radius_6,
                                kitBorderColorOption: Colors.black,
                                kitForegroundColorOption: Colors.black,
                                coreFixedSizeButton:
                                    CoreFixedSizeButton.medium_48),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5.0),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Maximum number that can be selected: 5',
                            style: TextStyle(
                                fontSize: 12.0, color: Colors.black45),
                          ),
                        ],
                      ),
                    ],
                  )),
            ),
          ),
        ),
      );

      if (result == true) {
        _onReSetState();
      }
    }
  }

  void showPopupSelectSubject(
      BuildContext context, SettingNotifier settingNotifier) async {
    unFocusAll();
    if (subjectList != null && subjectList!.isNotEmpty) {
      bool? result = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: CoreBasicDialog(
            insetPadding: const EdgeInsets.all(5.0),
            backgroundColor: Colors.white.withOpacity(0.95),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: SizedBox(
              height: CommonDimensions.maxHeightScreen(context) * 0.75,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(5.0, 20.0, 5.0, 10.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            CommonLanguages.convert(
                                lang: settingNotifier.languageString ??
                                    CommonLanguages.languageStringDefault(),
                                word: 'button.title.selectSubject'),
                            style: CommonStyles.screenTitleTextStyle(
                                fontSize: 16.0, color: const Color(0xFF1f1f1f)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Expanded(
                      child: StatefulBuilder(builder:
                          (BuildContext context, StateSetter setState) {
                        return ListView.builder(
                            itemCount: subjectList!.length,
                            itemBuilder: (context, index) {
                              return Container(
                                color: selectedSubject?.id ==
                                        subjectList![index].id
                                    ? Colors.lightGreenAccent.withOpacity(0.3)
                                    : Colors.transparent,
                                child: SwitchListTile(
                                    title: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Flexible(
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.rectangle,
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(2.0),
                                                        child: DottedBorder(
                                                          borderType:
                                                              BorderType.RRect,
                                                          radius: const Radius
                                                              .circular(12),
                                                          color: subjectList![
                                                                  index]
                                                              .color
                                                              .toColor(),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                const BorderRadius
                                                                        .all(
                                                                    Radius
                                                                        .circular(
                                                                            12)),
                                                            child: Container(
                                                              color:
                                                                  Colors.white,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        6.0),
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    Icon(
                                                                      Icons
                                                                          .palette_rounded,
                                                                      color: subjectList![
                                                                              index]
                                                                          .color
                                                                          .toColor(),
                                                                    ),
                                                                    const SizedBox(
                                                                        width:
                                                                            6.0),
                                                                    Flexible(
                                                                      child: Text(
                                                                          subjectList![index]
                                                                              .title,
                                                                          maxLines:
                                                                              1,
                                                                          overflow:
                                                                              TextOverflow.ellipsis),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    value:
                                        selectedSubject == subjectList![index],
                                    onChanged: (bool value) {
                                      if (value) {
                                        setState(() {
                                          selectedSubject = subjectList![index];
                                        });
                                      } else {
                                        setState(() {
                                          selectedSubject = null;
                                        });
                                      }
                                    }),
                              );
                            });
                      }),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CoreElevatedButton.icon(
                          buttonAudio: commonAudioOnPressButton,
                          icon:
                              const FaIcon(FontAwesomeIcons.check, size: 18.0),
                          label: Text(
                              CommonLanguages.convert(
                                  lang: settingNotifier.languageString ??
                                      CommonLanguages.languageStringDefault(),
                                  word: 'button.title.accept'),
                              style: CommonStyles.labelTextStyle),
                          onPressed: () {
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context, true);
                            }
                          },
                          coreButtonStyle: CoreButtonStyle.options(
                              coreStyle: CoreStyle.filled,
                              coreColor: CoreColor.success,
                              coreRadius: CoreRadius.radius_6,
                              kitBorderColorOption: Colors.black,
                              kitForegroundColorOption: Colors.black,
                              coreFixedSizeButton:
                                  CoreFixedSizeButton.medium_48),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      if (result == true) {
        _onReSetState();
      }
    }
  }

  Widget _buildSelectedLabels() {
    List<Widget> labelWidgets = [];

    if (selectedLabels.isNotEmpty) {
      for (var element in selectedLabels) {
        labelWidgets.add(
          Center(
            child: Padding(
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
                                child: Text(element.title, style: const TextStyle(
                                    fontSize: 16.0, fontWeight: FontWeight.w500),
                                    maxLines: 1, overflow: TextOverflow.ellipsis),
                              ),
                            ],
                          ),
                        )),
                  )),
            ),
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

  Widget _buildSelectedSubject() {
    if (selectedSubject != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: DottedBorder(
              borderType: BorderType.RRect,
              radius: const Radius.circular(12),
              color: selectedSubject!.color.toColor(),
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
                            color: selectedSubject!.color.toColor(),
                          ),
                          Flexible(
                            child: Text(selectedSubject!.title, style: const TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.w500),
                                maxLines: 1, overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                    )),
              )),
        ),
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    final templateNotifier = Provider.of<TemplateNotifier>(context);
    final settingNotifier = Provider.of<SettingNotifier>(context);

    return CoreFullScreenDialog(
      homeLabel: null,
      appbarLeading: null,
      isShowOptionActionButton: true,
      title: _buildTitle(settingNotifier, context),
      isConfirmToClose: true,
      actions: AppBarActionButtonEnum.save,
      isShowBottomActionButton: true,
      isShowGeneralActionButton: false,
      optionActionContent: null,
      onGoHome: () {},
      onSubmit: () async {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();

          final title =
              jsonEncode(_titleQuillController.document.toDelta().toJson());

          final description = jsonEncode(
              _detailContentQuillController.document.toDelta().toJson());

          if (_titleQuillController.document.isEmpty() &&
              _detailContentQuillController.document.isEmpty()) {
            CoreNotification.showMessage(
                context,
                settingNotifier,
                CoreNotificationStatus.warning,
                'Please enter your content or title!');
            return;
          }

          if (widget.template == null &&
              widget.actionMode == ActionModeEnum.create) {
            final TemplateModel model = TemplateModel(
                title: title,
                description: description,
                labels: '',
                subjectId: selectedSubject?.id,
                label01Id: _getSelectedLabelId(0),
                label02Id: _getSelectedLabelId(1),
                label03Id: _getSelectedLabelId(2),
                label04Id: _getSelectedLabelId(3),
                label05Id: _getSelectedLabelId(4),
                createdAt: DateTime.now().millisecondsSinceEpoch,
                id: widget.template?.id);

            _onCreateTemplate(context, model).then((result) {
              if (result) {
                templateNotifier.onCountAll();

                CoreNotification.showMessage(
                    context,
                    settingNotifier,
                    CoreNotificationStatus.success,
                    CommonLanguages.convert(
                        lang: settingNotifier.languageString ??
                            CommonLanguages.languageStringDefault(),
                        word: 'notification.action.created'));

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TemplateListScreen(
                          templateConditionModel: null, redirectFrom: null)),
                  (route) => false,
                );
              } else {
                CoreNotification.showMessage(
                    context,
                    settingNotifier,
                    CoreNotificationStatus.error,
                    CommonLanguages.convert(
                        lang: settingNotifier.languageString ??
                            CommonLanguages.languageStringDefault(),
                        word: 'notification.action.error'));
              }
            });
          } else if (widget.template != null &&
              widget.actionMode == ActionModeEnum.update) {
            final TemplateModel model = TemplateModel(
                title: title,
                description: description,
                labels: '',
                subjectId: selectedSubject?.id,
                label01Id: _getSelectedLabelId(0),
                label02Id: _getSelectedLabelId(1),
                label03Id: _getSelectedLabelId(2),
                label04Id: _getSelectedLabelId(3),
                label05Id: _getSelectedLabelId(4),
                isFavourite: widget.template?.isFavourite,
                createdAt: widget.template?.createdAt,
                updatedAt: DateTime.now().millisecondsSinceEpoch,
                id: widget.template?.id);

            _onUpdateTemplate(context, model).then((result) {
              if (result) {
                CoreNotification.showMessage(
                    context,
                    settingNotifier,
                    CoreNotificationStatus.success,
                    CommonLanguages.convert(
                        lang: settingNotifier.languageString ??
                            CommonLanguages.languageStringDefault(),
                        word: 'notification.action.updated'));

                _onGetUpdatedTemplate(context, model).then((result) {
                  if (result != null) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TemplateDetailScreen(
                                  template: result,
                                  labels: selectedLabels,
                                  subject: selectedSubject,
                                  redirectFrom: RedirectFromEnum.templateUpdate,
                                )),
                        (route) => false);
                  }
                });
              } else {
                CoreNotification.showMessage(
                    context,
                    settingNotifier,
                    CoreNotificationStatus.error,
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
      child: GestureDetector(
        onTap: () {
          if (_titleFocusNode.hasFocus) {
            _titleFocusNode.unfocus();
          }
          if (_detailContentFocusNode.hasFocus) {
            _detailContentFocusNode.unfocus();
          }
          _onReSetState();
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            onWillPop: () async {
              _onBack();
              if (await CoreHelperWidget.confirmFunction(
                  context: context,
                  settingNotifier: settingNotifier,
                  confirmExitScreen: true)) {
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
                      SizedBox(
                        child: Row(
                          children: [
                            subjectList != null && subjectList!.isNotEmpty
                                ? InkWell(
                                    onTap: () async {
                                      showPopupSelectSubject(
                                          context, settingNotifier);
                                    },
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: ThemeDataCenter
                                                .getFilteringTextColorStyle(
                                                    context),
                                            width: 1.0,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10.0)),
                                          color:
                                              Colors.white.withOpacity(0.65)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Row(
                                          children: [
                                            const FaIcon(
                                                FontAwesomeIcons.handPointRight,
                                                size: 20.0,
                                                color: Color(0xFF1f1f1f)),
                                            const SizedBox(width: 5.0),
                                            Text(
                                                CommonLanguages.convert(
                                                    lang: settingNotifier
                                                            .languageString ??
                                                        CommonLanguages
                                                            .languageStringDefault(),
                                                    word:
                                                        'button.title.selectSubject'),
                                                style: const TextStyle(
                                                    fontSize: 14.0,
                                                    color: Color(0xFF1f1f1f)))
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                            const SizedBox(width: 5.0),
                            InkWell(
                              onTap: () async {
                                bool? isCreatedSubject = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SubjectCreateScreen(
                                            parentSubject: null,
                                            actionMode: ActionModeEnum.create,
                                            redirectFrom:
                                                RedirectFromEnum.noteCreate,
                                            breadcrumb: null,
                                          )),
                                );

                                if (isCreatedSubject == true) {
                                  _onReloadSubjects();
                                }
                              },
                              borderRadius: BorderRadius.circular(10.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: ThemeDataCenter
                                          .getFilteringTextColorStyle(context),
                                      width: 1.0,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10.0)),
                                    color:
                                        settingNotifier.isSetBackgroundImage ==
                                                true
                                            ? Colors.white.withOpacity(0.65)
                                            : Colors.transparent),
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Icon(
                                    Icons.add_rounded,
                                    size: 22,
                                    color: ThemeDataCenter
                                        .getDeleteSlidableActionColorStyle(
                                            context),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  subjectList == null || subjectList!.isEmpty
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.fromLTRB(
                                  16.0, 8.0, 16.0, 8.0),
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(24.0)),
                                  color: settingNotifier.isSetBackgroundImage ==
                                          true
                                      ? Colors.white.withOpacity(0.65)
                                      : Colors.transparent),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  BounceInLeft(
                                      child: FaIcon(FontAwesomeIcons.waze,
                                          size: 30.0,
                                          color: ThemeDataCenter
                                              .getAloneTextColorStyle(
                                                  context))),
                                  const SizedBox(width: 5),
                                  BounceInRight(
                                    child: Text(
                                        CommonLanguages.convert(
                                            lang: settingNotifier
                                                    .languageString ??
                                                CommonLanguages
                                                    .languageStringDefault(),
                                            word:
                                                'notification.noItem.subject'),
                                        style: GoogleFonts.montserrat(
                                            fontStyle: FontStyle.italic,
                                            fontSize: 16.0,
                                            color: ThemeDataCenter
                                                .getAloneTextColorStyle(
                                                    context),
                                            fontWeight: FontWeight.w500)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Container(),
                  _buildSelectedSubject(),
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
                      SizedBox(
                        child: Row(
                          children: [
                            labelList != null && labelList!.isNotEmpty
                                ? InkWell(
                                    onTap: () async {
                                      showPopupSelectLabels(
                                          context, settingNotifier);
                                    },
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: ThemeDataCenter
                                                .getFilteringTextColorStyle(
                                                    context),
                                            width: 1.0,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10.0)),
                                          color:
                                              Colors.white.withOpacity(0.65)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Row(
                                          children: [
                                            const FaIcon(
                                                FontAwesomeIcons.handPointRight,
                                                size: 20.0,
                                                color: Color(0xFF1f1f1f)),
                                            const SizedBox(width: 5.0),
                                            Text(
                                                CommonLanguages.convert(
                                                    lang: settingNotifier
                                                            .languageString ??
                                                        CommonLanguages
                                                            .languageStringDefault(),
                                                    word:
                                                        'button.title.selectLabel'),
                                                style: const TextStyle(
                                                    fontSize: 14.0,
                                                    color: Color(0xFF1f1f1f)))
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                            const SizedBox(width: 5.0),
                            InkWell(
                              onTap: () async {
                                bool? isCreatedLabel = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LabelCreateScreen(
                                            actionMode: ActionModeEnum.create,
                                            redirectFrom:
                                                RedirectFromEnum.noteCreate,
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
                                      color: ThemeDataCenter
                                          .getFilteringTextColorStyle(context),
                                      width: 1.0,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10.0)),
                                    color:
                                        settingNotifier.isSetBackgroundImage ==
                                                true
                                            ? Colors.white.withOpacity(0.65)
                                            : Colors.transparent),
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Icon(
                                    Icons.add_rounded,
                                    size: 22,
                                    color: ThemeDataCenter
                                        .getDeleteSlidableActionColorStyle(
                                            context),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  labelList == null || labelList!.isEmpty
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.fromLTRB(
                                  16.0, 8.0, 16.0, 8.0),
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(24.0)),
                                  color: settingNotifier.isSetBackgroundImage ==
                                          true
                                      ? Colors.white.withOpacity(0.65)
                                      : Colors.transparent),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  BounceInLeft(
                                      child: FaIcon(FontAwesomeIcons.waze,
                                          size: 30.0,
                                          color: ThemeDataCenter
                                              .getAloneTextColorStyle(
                                                  context))),
                                  const SizedBox(width: 5),
                                  BounceInRight(
                                    child: Text(
                                        CommonLanguages.convert(
                                            lang: settingNotifier
                                                    .languageString ??
                                                CommonLanguages
                                                    .languageStringDefault(),
                                            word: 'notification.noItem.label'),
                                        style: GoogleFonts.montserrat(
                                            fontStyle: FontStyle.italic,
                                            fontSize: 16.0,
                                            color: ThemeDataCenter
                                                .getAloneTextColorStyle(
                                                    context),
                                            fontWeight: FontWeight.w500)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Container(),
                  _buildSelectedLabels(),
                  const SizedBox(
                    height: 500,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding _buildTitle(SettingNotifier settingNotifier, BuildContext context) {
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
                        widget.template == null
                            ? CommonLanguages.convert(
                                lang: settingNotifier.languageString ??
                                    CommonLanguages.languageStringDefault(),
                                word: 'screen.title.create.template')
                            : CommonLanguages.convert(
                                lang: settingNotifier.languageString ??
                                    CommonLanguages.languageStringDefault(),
                                word: 'screen.title.update.template'),
                        style: CommonStyles.screenTitleTextStyle(
                            fontSize: 16.0,
                            color: ThemeDataCenter.getScreenTitleTextColor(
                                context))),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
