import 'dart:convert';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_core_v3/app/library/extensions/extensions.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as flutter_quill;
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:sticky_headers/sticky_headers.dart';
import '../../../../../core/components/actions/common_buttons/CoreButtonStyle.dart';
import '../../../../../core/components/actions/common_buttons/CoreElevatedButton.dart';
import '../../../../library/common/converters/CommonConverters.dart';
import '../../../../library/common/styles/CommonStyles.dart';
import '../../../../library/common/themes/ThemeDataCenter.dart';
import '../../../../library/common/utils/CommonAudioOnPressButton.dart';
import '../../../setting/providers/setting_notifier.dart';
import '../../label/models/label_model.dart';
import '../../subjects/models/subject_condition_model.dart';
import '../../subjects/models/subject_model.dart';
import '../../subjects/widgets/subject_list_screen.dart';
import 'package:intl/intl.dart';

import '../models/template_model.dart';
import '../template_detail_screen.dart';

class TemplateWidget extends StatefulWidget {
  final int? index;
  final TemplateModel template;
  final List<LabelModel>? labels;
  final SubjectModel? subject;
  final VoidCallback? onUpdate;
  final VoidCallback? onDelete;
  final VoidCallback? onDeleteForever;
  final VoidCallback? onRestoreFromTrash;
  final VoidCallback? onFavourite;
  final VoidCallback? onCreateNoteFromTemplate;
  const TemplateWidget(
      {Key? key,
      required this.index,
      required this.template,
      required this.subject,
      required this.labels,
      required this.onUpdate,
      required this.onDelete,
      required this.onDeleteForever,
      required this.onRestoreFromTrash,
      required this.onFavourite,
      required this.onCreateNoteFromTemplate})
      : super(key: key);

  @override
  State<TemplateWidget> createState() => _TemplateWidgetState();
}

class _TemplateWidgetState extends State<TemplateWidget> {
  CommonAudioOnPressButton commonAudioOnPressButton =
      CommonAudioOnPressButton();
  final flutter_quill.QuillController _titleQuillController =
      flutter_quill.QuillController.basic();

  final flutter_quill.QuillController _descriptionQuillController =
      flutter_quill.QuillController.basic();

  final flutter_quill.QuillController _subDescriptionQuillController =
      flutter_quill.QuillController.basic();

  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    if (widget.template.title.isNotEmpty) {
      /// Set data for input
      List<dynamic> deltaMap = jsonDecode(widget.template.title);

      flutter_quill.Delta delta = flutter_quill.Delta.fromJson(deltaMap);

      setState(() {
        _titleQuillController.document =
            flutter_quill.Document.fromDelta(delta);
      });
    }

    if (widget.template.description.isNotEmpty) {
      /// Set data for input
      List<dynamic> deltaMap = jsonDecode(widget.template.description);

      flutter_quill.Delta delta = flutter_quill.Delta.fromJson(deltaMap);

      setState(() {
        _descriptionQuillController.document =
            flutter_quill.Document.fromDelta(delta);
      });

      if (_descriptionQuillController.document.toString().isNotEmpty) {
        List<dynamic> deltaMap = jsonDecode(widget.template.description);

        flutter_quill.Delta delta = flutter_quill.Delta.fromJson(deltaMap);
        setState(() {
          _subDescriptionQuillController.document =
              flutter_quill.Document.fromDelta(delta);
        });
      } else {
        // Xử lý khi Document rỗng
        print('Document rỗng.');
      }
    }
  }

  @override
  void dispose() {
    commonAudioOnPressButton.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  setDocuments() {
    if (widget.template.title.isNotEmpty) {
      /// Set data for input
      List<dynamic> deltaMap = jsonDecode(widget.template.title);

      flutter_quill.Delta delta = flutter_quill.Delta.fromJson(deltaMap);

      setState(() {
        _titleQuillController.document =
            flutter_quill.Document.fromDelta(delta);
      });

      /// Set selection
    }

    if (widget.template.description.isNotEmpty) {
      /// Set data for input
      List<dynamic> deltaMap = jsonDecode(widget.template.description);

      flutter_quill.Delta delta = flutter_quill.Delta.fromJson(deltaMap);

      setState(() {
        _descriptionQuillController.document =
            flutter_quill.Document.fromDelta(delta);
      });

      if (_descriptionQuillController.document.toString().isNotEmpty) {
        List<dynamic> deltaMap = jsonDecode(widget.template.description);

        flutter_quill.Delta delta = flutter_quill.Delta.fromJson(deltaMap);
        setState(() {
          _subDescriptionQuillController.document =
              flutter_quill.Document.fromDelta(delta);
        });
      } else {
        // Xử lý khi Document rỗng
        print('Document rỗng.');
      }
    }
  }

  Widget onGetTitle() {
    String defaultTitle =
        'You wrote at ${CommonConverters.toTimeString(time: widget.template.createdAt!)}';
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text(defaultTitle),
    );
  }

  bool checkTitleEmpty() {
    List<dynamic> deltaMap = jsonDecode(widget.template.title);

    flutter_quill.Delta delta = flutter_quill.Delta.fromJson(deltaMap);

    var list = delta.toList();
    if (list.length == 1) {
      if (list[0].key == 'insert' && list[0].data == '\n') {
        return false;
      }
    }
    return true;
  }

  Widget _buildLabels() {
    if (widget.labels != null && widget.labels!.isNotEmpty) {
      List<Widget> labelWidgets = [];

      for (var element in widget.labels!) {
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
      return Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.rectangle,
              ),
              child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: labelWidgets,
                    ),
                  )),
            ),
          ),
        ],
      );
    }
    return Container();
  }

  Widget _buildSubject() {
    return widget.subject != null
        ? Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                child: InkWell(
                  borderRadius: BorderRadius.circular(12.0),
                  onTap: () {},
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.rectangle,
                    ),
                    child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(mainAxisSize: MainAxisSize.max, children: [
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: DottedBorder(
                                  borderType: BorderType.RRect,
                                  radius: const Radius.circular(12),
                                  color: widget.subject?.color.toColor(),
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
                                                Icons.palette_rounded,
                                                color: widget.subject?.color
                                                    .toColor(),
                                              ),
                                              const SizedBox(width: 6.0),
                                              Flexible(
                                                child: Text(
                                                    widget.subject!.title,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                              ),
                                            ],
                                          ),
                                        )),
                                  )),
                            ),
                          ]),
                        )),
                  ),
                ),
              ),
            ],
          )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    final settingNotifier = Provider.of<SettingNotifier>(context);

    setDocuments();
    return Slidable(
      key: const ValueKey(0),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            flex: 1,
            onPressed: (context) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TemplateDetailScreen(
                            template: widget.template,
                            labels: widget.labels,
                            subject: widget.subject,
                            redirectFrom: null,
                          )));
            },
            backgroundColor: settingNotifier.isSetBackgroundImage == true
                ? settingNotifier.isSetBackgroundImage == true
                    ? Colors.white.withOpacity(0.30)
                    : Colors.transparent
                : ThemeDataCenter.getBackgroundColor(context),
            foregroundColor:
                ThemeDataCenter.getViewSlidableActionColorStyle(context),
            icon: Icons.remove_red_eye_rounded,
          ),
          widget.template.deletedAt == null
              ? SlidableAction(
                  flex: 1,
                  onPressed: (context) {
                    if (widget.onFavourite != null) {
                      widget.onFavourite!();
                    }
                  },
                  backgroundColor: settingNotifier.isSetBackgroundImage == true
                      ? settingNotifier.isSetBackgroundImage == true
                          ? Colors.white.withOpacity(0.30)
                          : Colors.transparent
                      : ThemeDataCenter.getBackgroundColor(context),
                  foregroundColor:
                      ThemeDataCenter.getFavouriteSlidableActionColorStyle(
                          context),
                  icon: Icons.favorite,
                )
              : Container(),
          widget.template.deletedAt == null
              ? SlidableAction(
                  flex: 1,
                  onPressed: (context) {
                    if (widget.onDelete != null) {
                      widget.onDelete!();
                    }
                  },
                  backgroundColor: settingNotifier.isSetBackgroundImage == true
                      ? settingNotifier.isSetBackgroundImage == true
                          ? Colors.white.withOpacity(0.30)
                          : Colors.transparent
                      : ThemeDataCenter.getBackgroundColor(context),
                  foregroundColor:
                      ThemeDataCenter.getDeleteSlidableActionColorStyle(
                          context),
                  icon: Icons.delete,
                )
              : Container()
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
        child: ExpandableNotifier(
            initialExpanded: settingNotifier.isExpandedTemplateContent ?? false,
            child: Column(
              children: [
                widget.template.updatedAt == null &&
                        widget.template.deletedAt == null
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(4.0, 0, 5.0, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(widget.index.toString(),
                                style: CommonStyles.labelTextStyle),
                            Tooltip(
                              message: 'Created time',
                              child: Container(
                                padding:
                                    settingNotifier.isSetBackgroundImage == true
                                        ? const EdgeInsets.all(2.0)
                                        : const EdgeInsets.all(0),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(6.0)),
                                    color:
                                        settingNotifier.isSetBackgroundImage ==
                                                true
                                            ? Colors.white.withOpacity(0.65)
                                            : Colors.transparent),
                                child: Row(
                                  children: [
                                    Icon(Icons.create_rounded,
                                        size: 13.0,
                                        color: ThemeDataCenter
                                            .getTopCardLabelStyle(context)),
                                    const SizedBox(width: 5.0),
                                    Text(
                                        CommonConverters.toTimeString(
                                            time: widget.template.createdAt!),
                                        style: CommonStyles.dateTimeTextStyle(
                                            color: ThemeDataCenter
                                                .getTopCardLabelStyle(
                                                    context))),
                                    const SizedBox(width: 5.0),
                                    widget.template.isFavourite != null
                                        ? BounceInDown(
                                            duration: const Duration(
                                                milliseconds: 500),
                                            child: const Icon(Icons.favorite,
                                                color: Color(0xffdc3545),
                                                size: 26.0),
                                          )
                                        : Container(),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    : Container(),
                widget.template.updatedAt != null &&
                        widget.template.deletedAt == null
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(4.0, 0, 5.0, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(widget.index.toString(),
                                style: CommonStyles.labelTextStyle),
                            Tooltip(
                              message: 'Updated time',
                              child: Container(
                                padding:
                                    settingNotifier.isSetBackgroundImage == true
                                        ? const EdgeInsets.all(2.0)
                                        : const EdgeInsets.all(0),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(6.0)),
                                    color:
                                        settingNotifier.isSetBackgroundImage ==
                                                true
                                            ? Colors.white.withOpacity(0.65)
                                            : Colors.transparent),
                                child: Row(
                                  children: [
                                    Icon(Icons.update_rounded,
                                        size: 13.0,
                                        color: ThemeDataCenter
                                            .getTopCardLabelStyle(context)),
                                    const SizedBox(width: 5.0),
                                    Text(
                                        CommonConverters.toTimeString(
                                            time: widget.template.updatedAt!),
                                        style: CommonStyles.dateTimeTextStyle(
                                            color: ThemeDataCenter
                                                .getTopCardLabelStyle(
                                                    context))),
                                    const SizedBox(width: 5.0),
                                    widget.template.isFavourite != null
                                        ? BounceInDown(
                                            duration: const Duration(
                                                milliseconds: 500),
                                            child: const Icon(Icons.favorite,
                                                color: Color(0xffdc3545),
                                                size: 26.0),
                                          )
                                        : Container(),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    : Container(),
                widget.template.deletedAt != null
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(4.0, 0, 5.0, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(widget.index.toString(),
                                style: CommonStyles.labelTextStyle),
                            Tooltip(
                              message: 'Deleted time',
                              child: Container(
                                padding:
                                    settingNotifier.isSetBackgroundImage == true
                                        ? const EdgeInsets.all(2.0)
                                        : const EdgeInsets.all(0),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(6.0)),
                                    color:
                                        settingNotifier.isSetBackgroundImage ==
                                                true
                                            ? Colors.white.withOpacity(0.65)
                                            : Colors.transparent),
                                child: Row(
                                  children: [
                                    Icon(Icons.delete_rounded,
                                        size: 13.0,
                                        color: ThemeDataCenter
                                            .getTopCardLabelStyle(context)),
                                    const SizedBox(width: 5.0),
                                    Text(
                                        CommonConverters.toTimeString(
                                            time: widget.template.deletedAt!),
                                        style: CommonStyles.dateTimeTextStyle(
                                            color: ThemeDataCenter
                                                .getTopCardLabelStyle(
                                                    context))),
                                    const SizedBox(width: 5.0),
                                    widget.template.isFavourite != null
                                        ? BounceInDown(
                                            duration: const Duration(
                                                milliseconds: 500),
                                            child: const Icon(Icons.favorite,
                                                color: Color(0xffdc3545),
                                                size: 26.0),
                                          )
                                        : Container(),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    : Container(),
                Card(
                  shadowColor: const Color(0xff1f1f1f),
                  elevation: 2.0,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: ThemeDataCenter.getBorderCardColorStyle(context),
                        width: 1.0),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: <Widget>[
                      StickyHeader(
                          header: SizedBox(
                            // height: 150,
                            child: Container(
                              decoration: BoxDecoration(
                                color: widget.subject != null &&
                                        settingNotifier
                                            .isSetColorAccordingSubjectColor!
                                    ? widget.subject!.color.toColor()
                                    : ThemeDataCenter
                                        .getNoteTopBannerCardBackgroundColor(
                                            context),
                                shape: BoxShape.rectangle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              115.0,
                                          child: checkTitleEmpty()
                                              ? SingleChildScrollView(
                                                  child:
                                                      flutter_quill.QuillEditor(
                                                          controller:
                                                              _titleQuillController,
                                                          readOnly:
                                                              true, // true for view only mode
                                                          autoFocus: false,
                                                          expands: false,
                                                          focusNode: _focusNode,
                                                          padding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  10.0,
                                                                  10.0,
                                                                  10.0,
                                                                  10.0),
                                                          scrollController:
                                                              _scrollController,
                                                          scrollable: false,
                                                          showCursor: false),
                                                )
                                              : onGetTitle()),
                                      widget.template.deletedAt == null
                                          ? Column(
                                              children: [
                                                Tooltip(
                                                  message: 'Update',
                                                  child: CoreElevatedButton
                                                      .iconOnly(
                                                    buttonAudio:
                                                        commonAudioOnPressButton,
                                                    onPressed: () {
                                                      if (widget.onUpdate !=
                                                          null) {
                                                        widget.onUpdate!();
                                                      }
                                                    },
                                                    coreButtonStyle:
                                                        ThemeDataCenter
                                                            .getUpdateButtonStyle(
                                                                context),
                                                    icon: const Icon(
                                                        Icons.edit_note_rounded,
                                                        size: 26.0),
                                                  ),
                                                ),
                                                Tooltip(
                                                  message: 'Create note',
                                                  child: CoreElevatedButton
                                                      .iconOnly(
                                                    buttonAudio:
                                                        commonAudioOnPressButton,
                                                    onPressed: () {
                                                      if (widget
                                                              .onCreateNoteFromTemplate !=
                                                          null) {
                                                        widget
                                                            .onCreateNoteFromTemplate!();
                                                      }
                                                    },
                                                    coreButtonStyle: ThemeDataCenter
                                                        .getCreateNoteButtonStyle(
                                                            context),
                                                    icon: const Icon(
                                                        Icons.add_card_rounded,
                                                        size: 26.0),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Column(children: [
                                              Tooltip(
                                                message: 'Restore',
                                                child:
                                                    CoreElevatedButton.iconOnly(
                                                  buttonAudio:
                                                      commonAudioOnPressButton,
                                                  onPressed: () {
                                                    if (widget
                                                            .onRestoreFromTrash !=
                                                        null) {
                                                      widget
                                                          .onRestoreFromTrash!();
                                                    }
                                                  },
                                                  coreButtonStyle:
                                                      ThemeDataCenter
                                                          .getRestoreButtonStyle(
                                                              context),
                                                  icon: const Icon(
                                                      Icons
                                                          .restore_from_trash_rounded,
                                                      size: 26.0),
                                                ),
                                              ),
                                              const SizedBox(height: 2.0),
                                              Tooltip(
                                                message: 'Delete forever',
                                                child:
                                                    CoreElevatedButton.iconOnly(
                                                  buttonAudio:
                                                      commonAudioOnPressButton,
                                                  onPressed: () {
                                                    if (widget
                                                            .onDeleteForever !=
                                                        null) {
                                                      widget.onDeleteForever!();
                                                    }
                                                  },
                                                  coreButtonStyle: ThemeDataCenter
                                                      .getDeleteForeverButtonStyle(
                                                          context),
                                                  icon: const Icon(
                                                      Icons
                                                          .delete_forever_rounded,
                                                      size: 26.0),
                                                ),
                                              ),
                                            ])
                                    ]),
                              ),
                            ),
                          ),
                          content: Column(
                            children: [
                              _buildSubject(),
                              _buildLabels(),
                              ScrollOnExpand(
                                scrollOnExpand: true,
                                scrollOnCollapse: false,
                                child: ExpandablePanel(
                                  theme: const ExpandableThemeData(
                                    headerAlignment:
                                        ExpandablePanelHeaderAlignment.center,
                                    tapBodyToCollapse: true,
                                  ),
                                  header: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Row(
                                        children: [
                                          Text("[id:${widget.template.id!}] ",
                                              style: const TextStyle(
                                                  fontSize: 13.0,
                                                  color: Colors.black45)),
                                          const Text("Content",
                                              style: TextStyle(
                                                  fontSize: 13.0,
                                                  color: Colors.black45)),
                                        ],
                                      )),
                                  collapsed: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 35,
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            boxShadow: [],
                                          ),
                                          child: flutter_quill.QuillEditor(
                                              controller:
                                                  _subDescriptionQuillController,
                                              readOnly:
                                                  true, // true for view only mode
                                              autoFocus: false,
                                              expands: false,
                                              focusNode: _focusNode,
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              scrollController:
                                                  _scrollController,
                                              scrollable: false,
                                              showCursor: false),
                                        ),
                                      ),
                                      Text(
                                        '...',
                                        style: GoogleFonts.montserrat(
                                            fontStyle: FontStyle.italic,
                                            fontSize: 14),
                                      ),
                                    ],
                                  ),
                                  expanded: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      flutter_quill.QuillEditor(
                                          controller:
                                              _descriptionQuillController,
                                          readOnly:
                                              true, // true for view only mode
                                          autoFocus: false,
                                          expands: false,
                                          focusNode: _focusNode,
                                          padding: const EdgeInsets.all(4.0),
                                          scrollController: _scrollController,
                                          scrollable: false,
                                          showCursor: false),
                                    ],
                                  ),
                                  builder: (_, collapsed, expanded) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10, bottom: 10),
                                      child: Expandable(
                                        collapsed: collapsed,
                                        expanded: expanded,
                                        theme: const ExpandableThemeData(
                                            crossFadePoint: 0),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
