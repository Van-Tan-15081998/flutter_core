import 'dart:convert';
import 'dart:io';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_core_v3/app/library/common/dimensions/CommonDimensions.dart';
import 'package:flutter_core_v3/app/library/common/themes/ThemeDataCenter.dart';
import 'package:flutter_core_v3/app/library/extensions/extensions.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as flutter_quill;
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:sticky_headers/sticky_headers.dart';
import '../../../../../core/components/actions/common_buttons/CoreButtonStyle.dart';
import '../../../../../core/components/actions/common_buttons/CoreElevatedButton.dart';
import '../../../../../core/components/containment/dialogs/CoreBasicDialog.dart';
import '../../../../library/common/converters/CommonConverters.dart';
import '../../../../library/common/languages/CommonLanguages.dart';
import '../../../../library/common/styles/CommonStyles.dart';
import '../../../../library/common/utils/CommonAudioOnPressButton.dart';
import '../../../../library/enums/CommonEnums.dart';
import '../../../setting/providers/setting_notifier.dart';
import '../../label/models/label_model.dart';
import '../../subjects/models/subject_condition_model.dart';
import '../../subjects/models/subject_model.dart';
import '../../subjects/widgets/subject_list_folder_mode_screen.dart';
import '../../subjects/widgets/subject_list_screen.dart';
import '../models/note_model.dart';
import '../note_detail_screen.dart';

typedef OnFilterByLabelCallback = void Function(int? labelId);

class NoteWidget extends StatefulWidget {
  final int? index;
  final NoteModel note;
  final List<LabelModel>? labels;
  final SubjectModel? subject;
  final VoidCallback? onUpdate;
  final VoidCallback? onDelete;
  final VoidCallback? onDeleteForever;
  final VoidCallback? onRestoreFromTrash;
  final VoidCallback? onFavourite;
  final VoidCallback? onPin;
  final VoidCallback? onUnlock;
  final VoidCallback? onFilterBySubject;
  final OnFilterByLabelCallback? onFilterByLabel;
  const NoteWidget({
    Key? key,
    required this.index,
    required this.note,
    required this.subject,
    required this.labels,
    required this.onUpdate,
    required this.onDelete,
    required this.onDeleteForever,
    required this.onRestoreFromTrash,
    required this.onFavourite,
    required this.onPin,
    required this.onUnlock,
    required this.onFilterBySubject,
    required this.onFilterByLabel,
  }) : super(key: key);

  @override
  State<NoteWidget> createState() => _NoteWidgetState();
}

class _NoteWidgetState extends State<NoteWidget> {
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

  List<String> _imageSourceStrings = [];

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    if (widget.note.title != null && widget.note.title!.isNotEmpty) {
      /// Set data for input
      List<dynamic> deltaMap = jsonDecode(widget.note.title!);

      flutter_quill.Delta delta = flutter_quill.Delta.fromJson(deltaMap);

      setState(() {
        _titleQuillController.document =
            flutter_quill.Document.fromDelta(delta);
      });
    }

    if (widget.note.description != null &&
        widget.note.description!.isNotEmpty) {
      /// Set data for input
      List<dynamic> deltaMap = jsonDecode(widget.note.description!);

      flutter_quill.Delta delta = flutter_quill.Delta.fromJson(deltaMap);

      setState(() {
        _descriptionQuillController.document =
            flutter_quill.Document.fromDelta(delta);
      });

      if (_descriptionQuillController.document.toString().isNotEmpty) {
        List<dynamic> deltaMap = jsonDecode(widget.note.description!);

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

    if (widget.note.images != null && widget.note.images!.isNotEmpty) {
      /// Set data for input
      List<dynamic> imageSources = jsonDecode(widget.note.images!);

      if (imageSources.isNotEmpty) {
        setState(() {
          for (var element in imageSources) {
            _imageSourceStrings.add(element);
          }
        });
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
    if (widget.note.title != null && widget.note.title!.isNotEmpty) {
      /// Set data for input
      List<dynamic> deltaMap = jsonDecode(widget.note.title!);

      flutter_quill.Delta delta = flutter_quill.Delta.fromJson(deltaMap);

      setState(() {
        _titleQuillController.document =
            flutter_quill.Document.fromDelta(delta);
      });

      /// Set selection
    }

    if (widget.note.description != null &&
        widget.note.description!.isNotEmpty) {
      /// Set data for input
      List<dynamic> deltaMap = jsonDecode(widget.note.description!);

      flutter_quill.Delta delta = flutter_quill.Delta.fromJson(deltaMap);

      setState(() {
        _descriptionQuillController.document =
            flutter_quill.Document.fromDelta(delta);
      });

      if (_descriptionQuillController.document.toString().isNotEmpty) {
        List<dynamic> deltaMap = jsonDecode(widget.note.description!);

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

  Widget onGetTitle(SettingNotifier settingNotifier) {
    String defaultTitle = CommonLanguages.convert(
        lang: settingNotifier.languageString ??
            CommonLanguages.languageStringDefault(),
        word: 'screen.title.titleNotSet');
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text(defaultTitle,
          style: const TextStyle(fontSize: 16.0, color: Color(0xFF1f1f1f))),
    );
  }

  bool checkTitleEmpty() {
    if (_titleQuillController.document.isEmpty()) {
      return false;
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
            child: InkWell(
              borderRadius: BorderRadius.circular(12.0),
              onTap: () {
                if (widget.onFilterByLabel != null) {
                  widget.onFilterByLabel!(element.id);
                }
              },
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
                                  child: Text(element.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ],
                            ),
                          )),
                    )),
              ),
            ),
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
                  onLongPress: () {
                    // SubjectConditionModel subjectConditionModel =
                    //     SubjectConditionModel();
                    // subjectConditionModel.id = widget.subject!.id;
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => SubjectListScreen(
                    //             subjectConditionModel: subjectConditionModel,
                    //             redirectFrom: RedirectFromEnum.notes,
                    //             breadcrumb: null,
                    //           )),
                    // );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SubjectListFolderModeScreen(
                          subjectConditionModel: null,
                          redirectFrom: RedirectFromEnum.notes,
                          breadcrumb: [widget.subject!],
                        ),
                      ),
                    );
                  },
                  onTap: () {
                    if (widget.onFilterBySubject != null) {
                      widget.onFilterBySubject!();
                    }
                  },
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
          widget.note.deletedAt == null
              ? SlidableAction(
                  flex: 1,
                  onPressed: (context) {
                    if (widget.onPin != null) {
                      widget.onPin!();
                    }
                  },
                  backgroundColor: settingNotifier.isSetBackgroundImage == true
                      ? settingNotifier.isSetBackgroundImage == true
                          ? Colors.white.withOpacity(0.30)
                          : Colors.transparent
                      : ThemeDataCenter.getBackgroundColor(context),
                  foregroundColor:
                      ThemeDataCenter.getPinSlidableActionColorStyle(context),
                  icon: Icons.push_pin,
                )
              : Container(),
          SlidableAction(
            flex: 1,
            onPressed: (context) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NoteDetailScreen(
                            note: widget.note,
                            labels: widget.labels,
                            subject: widget.subject,
                            redirectFrom: RedirectFromEnum.noteDetail,
                          )));
            },
            backgroundColor: settingNotifier.isSetBackgroundImage == true
                ? settingNotifier.isSetBackgroundImage == true
                    ? Colors.white.withOpacity(0.30)
                    : Colors.transparent
                : ThemeDataCenter.getBackgroundColor(context),
            foregroundColor:
                ThemeDataCenter.getViewSlidableActionColorStyle(context),
            icon: Icons.search_rounded,
          ),
          widget.note.deletedAt == null && widget.note.isLocked == null
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
          widget.note.deletedAt == null && widget.note.isLocked == null
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
          initialExpanded: settingNotifier.isExpandedNoteContent ?? false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              widget.note.updatedAt == null && widget.note.deletedAt == null
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(4.0, 0, 5.0, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(widget.index.toString(),
                              style: CommonStyles.labelTextStyle),
                          widget.note.isPinned != null
                              ? Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(5.0, 0, 5.0, 0),
                                  child: Icon(Icons.push_pin,
                                      size: 22,
                                      color: ThemeDataCenter
                                          .getPinSlidableActionColorStyle(
                                              context)),
                                )
                              : Container(),
                          widget.note.isLocked != null
                              ? Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(5.0, 0, 5.0, 0),
                                  child: Icon(Icons.lock,
                                      size: 22,
                                      color: ThemeDataCenter
                                          .getLockSlidableActionColorStyle(
                                              context)),
                                )
                              : Container(),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      widget.note.createdForDay != null
                                          ? Tooltip(
                                              message: 'Created for',
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Icon(
                                                      Icons
                                                          .directions_run_rounded,
                                                      size: 14.0,
                                                      color: ThemeDataCenter
                                                          .getTopCardLabelStyle(
                                                              context)),
                                                  const SizedBox(width: 5.0),
                                                  Text(
                                                      CommonConverters
                                                          .toTimeString(
                                                              time: widget.note
                                                                  .createdForDay!,
                                                              format:
                                                                  'dd/MM/yyyy'),
                                                      style: CommonStyles
                                                          .dateTimeTextStyle(
                                                              color: ThemeDataCenter
                                                                  .getTopCardLabelStyle(
                                                                      context))),
                                                  const SizedBox(width: 5.0),
                                                ],
                                              ),
                                            )
                                          : Container(),
                                      Tooltip(
                                        message: 'Created time',
                                        child: Row(
                                          children: [
                                            Icon(Icons.create_rounded,
                                                size: 13.0,
                                                color: ThemeDataCenter
                                                    .getTopCardLabelStyle(
                                                        context)),
                                            const SizedBox(width: 5.0),
                                            Text(
                                                CommonConverters.toTimeString(
                                                    time:
                                                        widget.note.createdAt!),
                                                style: CommonStyles
                                                    .dateTimeTextStyle(
                                                        color: ThemeDataCenter
                                                            .getTopCardLabelStyle(
                                                                context))),
                                            const SizedBox(width: 5.0),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                widget.note.isFavourite != null
                                    ? Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10.0, 0, 0, 0),
                                        child: BounceInDown(
                                          duration:
                                              const Duration(milliseconds: 500),
                                          child: AvatarGlow(
                                            glowRadiusFactor: 0.5,
                                            curve: Curves.linearToEaseOut,
                                            child: const Icon(Icons.favorite,
                                                color: Color(0xffdc3545),
                                                size: 26.0),
                                          ),
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  : Container(),
              widget.note.updatedAt != null && widget.note.deletedAt == null
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(4.0, 0, 5.0, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(widget.index.toString(),
                              style: CommonStyles.labelTextStyle),
                          widget.note.isPinned != null
                              ? Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(5.0, 0, 5.0, 0),
                                  child: Icon(Icons.push_pin,
                                      size: 22,
                                      color: ThemeDataCenter
                                          .getPinSlidableActionColorStyle(
                                              context)),
                                )
                              : Container(),
                          widget.note.isLocked != null
                              ? Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(5.0, 0, 5.0, 0),
                                  child: Icon(Icons.lock,
                                      size: 22,
                                      color: ThemeDataCenter
                                          .getLockSlidableActionColorStyle(
                                              context)),
                                )
                              : Container(),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      widget.note.createdForDay != null
                                          ? Tooltip(
                                              message: 'Created for',
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Icon(
                                                      Icons
                                                          .directions_run_rounded,
                                                      size: 14.0,
                                                      color: ThemeDataCenter
                                                          .getTopCardLabelStyle(
                                                              context)),
                                                  const SizedBox(width: 5.0),
                                                  Text(
                                                      CommonConverters
                                                          .toTimeString(
                                                              time: widget.note
                                                                  .createdForDay!,
                                                              format:
                                                                  'dd/MM/yyyy'),
                                                      style: CommonStyles
                                                          .dateTimeTextStyle(
                                                              color: ThemeDataCenter
                                                                  .getTopCardLabelStyle(
                                                                      context))),
                                                  const SizedBox(width: 5.0),
                                                ],
                                              ),
                                            )
                                          : Container(),
                                      Tooltip(
                                        message: 'Updated time',
                                        child: Row(
                                          children: [
                                            Icon(Icons.update_rounded,
                                                size: 13.0,
                                                color: ThemeDataCenter
                                                    .getTopCardLabelStyle(
                                                        context)),
                                            const SizedBox(width: 5.0),
                                            Text(
                                                CommonConverters.toTimeString(
                                                    time:
                                                        widget.note.updatedAt!),
                                                style: CommonStyles
                                                    .dateTimeTextStyle(
                                                        color: ThemeDataCenter
                                                            .getTopCardLabelStyle(
                                                                context))),
                                            const SizedBox(width: 5.0),
                                          ],
                                        ),
                                      ),
                                      Tooltip(
                                        message: 'Created time',
                                        child: Row(
                                          children: [
                                            Icon(Icons.create_rounded,
                                                size: 13.0,
                                                color: ThemeDataCenter
                                                    .getTopCardLabelStyle(
                                                        context)),
                                            const SizedBox(width: 5.0),
                                            Text(
                                                CommonConverters.toTimeString(
                                                    time:
                                                        widget.note.createdAt!),
                                                style: CommonStyles
                                                    .dateTimeTextStyle(
                                                        color: ThemeDataCenter
                                                            .getTopCardLabelStyle(
                                                                context))),
                                            const SizedBox(width: 5.0),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                widget.note.isFavourite != null
                                    ? Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10.0, 0, 0, 0),
                                        child: BounceInDown(
                                          duration:
                                              const Duration(milliseconds: 500),
                                          child: AvatarGlow(
                                            glowRadiusFactor: 0.5,
                                            curve: Curves.linearToEaseOut,
                                            child: const Icon(Icons.favorite,
                                                color: Color(0xffdc3545),
                                                size: 26.0),
                                          ),
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  : Container(),
              widget.note.deletedAt != null
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(4.0, 0, 5.0, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(widget.index.toString(),
                              style: CommonStyles.labelTextStyle),
                          widget.note.isPinned != null
                              ? Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(5.0, 0, 5.0, 0),
                                  child: Icon(Icons.push_pin,
                                      size: 22,
                                      color: ThemeDataCenter
                                          .getPinSlidableActionColorStyle(
                                              context)),
                                )
                              : Container(),
                          widget.note.isLocked != null
                              ? Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(5.0, 0, 5.0, 0),
                                  child: Icon(Icons.lock,
                                      size: 22,
                                      color: ThemeDataCenter
                                          .getLockSlidableActionColorStyle(
                                              context)),
                                )
                              : Container(),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      widget.note.createdForDay != null
                                          ? Tooltip(
                                              message: 'Created for',
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Icon(
                                                      Icons
                                                          .directions_run_rounded,
                                                      size: 14.0,
                                                      color: ThemeDataCenter
                                                          .getTopCardLabelStyle(
                                                              context)),
                                                  const SizedBox(width: 5.0),
                                                  Text(
                                                      CommonConverters
                                                          .toTimeString(
                                                              time: widget.note
                                                                  .createdForDay!,
                                                              format:
                                                                  'dd/MM/yyyy'),
                                                      style: CommonStyles
                                                          .dateTimeTextStyle(
                                                              color: ThemeDataCenter
                                                                  .getTopCardLabelStyle(
                                                                      context))),
                                                  const SizedBox(width: 5.0),
                                                ],
                                              ),
                                            )
                                          : Container(),
                                      Tooltip(
                                        message: 'Deleted time',
                                        child: Row(
                                          children: [
                                            Icon(Icons.delete_rounded,
                                                size: 13.0,
                                                color: ThemeDataCenter
                                                    .getTopCardLabelStyle(
                                                        context)),
                                            const SizedBox(width: 5.0),
                                            Text(
                                                CommonConverters.toTimeString(
                                                    time:
                                                        widget.note.deletedAt!),
                                                style: CommonStyles
                                                    .dateTimeTextStyle(
                                                        color: ThemeDataCenter
                                                            .getTopCardLabelStyle(
                                                                context))),
                                            const SizedBox(width: 5.0),
                                          ],
                                        ),
                                      ),
                                      Tooltip(
                                        message: 'Created time',
                                        child: Row(
                                          children: [
                                            Icon(Icons.create_rounded,
                                                size: 13.0,
                                                color: ThemeDataCenter
                                                    .getTopCardLabelStyle(
                                                        context)),
                                            const SizedBox(width: 5.0),
                                            Text(
                                                CommonConverters.toTimeString(
                                                    time:
                                                        widget.note.createdAt!),
                                                style: CommonStyles
                                                    .dateTimeTextStyle(
                                                        color: ThemeDataCenter
                                                            .getTopCardLabelStyle(
                                                                context))),
                                            const SizedBox(width: 5.0),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                widget.note.isFavourite != null
                                    ? Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10.0, 0, 0, 10.0),
                                        child: BounceInDown(
                                          duration:
                                              const Duration(milliseconds: 500),
                                          child: AvatarGlow(
                                            glowRadiusFactor: 0.5,
                                            curve: Curves.linearToEaseOut,
                                            child: const Icon(Icons.favorite,
                                                color: Color(0xffdc3545),
                                                size: 26.0),
                                          ),
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  : Container(),
              Card(
                  color: Colors.white
                      .withOpacity(settingNotifier.opacityNumber ?? 1),
                  shadowColor: const Color(0xff1f1f1f),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: ThemeDataCenter.getBorderCardColorStyle(context),
                        width: 1.0),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: settingNotifier.isStickTitleOfNote == true
                      ? Column(
                          children: <Widget>[
                            StickyHeader(
                              header: _buildHeader(context, settingNotifier),
                              content: _buildContent(settingNotifier),
                            )
                          ],
                        )
                      : Column(
                          children: [
                            _buildHeader(context, settingNotifier),
                            _buildContent(settingNotifier),
                          ],
                        )),
              Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    widget.note.deletedAt == null
                        ? InkWell(
                            onTap: () {
                              if (widget.onPin != null) {
                                widget.onPin!();
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
                                  color: settingNotifier.isSetBackgroundImage ==
                                          true
                                      ? Colors.white.withOpacity(0.65)
                                      : Colors.transparent),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Icon(Icons.push_pin,
                                    size: 22,
                                    color: ThemeDataCenter
                                        .getPinSlidableActionColorStyle(
                                            context)),
                              ),
                            ),
                          )
                        : Container(),
                    const SizedBox(width: 5.0),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NoteDetailScreen(
                                      note: widget.note,
                                      labels: widget.labels,
                                      subject: widget.subject,
                                      redirectFrom: RedirectFromEnum.noteDetail,
                                    )));
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
                          child: Icon(Icons.search_rounded,
                              size: 22,
                              color: ThemeDataCenter
                                  .getViewSlidableActionColorStyle(context)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5.0),
                    widget.note.deletedAt == null &&
                            widget.note.isLocked == null
                        ? InkWell(
                            onTap: () {
                              if (widget.onFavourite != null) {
                                widget.onFavourite!();
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
                                  color: settingNotifier.isSetBackgroundImage ==
                                          true
                                      ? Colors.white.withOpacity(0.65)
                                      : Colors.transparent),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Icon(
                                  Icons.favorite,
                                  size: 22,
                                  color: ThemeDataCenter
                                      .getFavouriteSlidableActionColorStyle(
                                          context),
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    const SizedBox(width: 5.0),
                    widget.note.isLocked == null &&
                            widget.note.deletedAt == null
                        ? InkWell(
                            onLongPress: () {
                              if (widget.onDelete != null) {
                                widget.onDelete!();
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
                                  color: settingNotifier.isSetBackgroundImage ==
                                          true
                                      ? Colors.white.withOpacity(0.65)
                                      : Colors.transparent),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Icon(
                                  Icons.delete,
                                  size: 22,
                                  color: ThemeDataCenter
                                      .getDeleteSlidableActionColorStyle(
                                          context),
                                ),
                              ),
                            ),
                          )
                        : Container()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column _buildContent(SettingNotifier settingNotifier) {
    return Column(
      children: [
        _buildSubject(),
        _buildLabels(),
        ScrollOnExpand(
          scrollOnExpand: false,
          scrollOnCollapse: false,
          child: ExpandablePanel(
            theme: const ExpandableThemeData(
              headerAlignment: ExpandablePanelHeaderAlignment.center,
              tapBodyToCollapse: false,
            ),
            header: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Row(
                  children: [
                    Text(
                        CommonLanguages.convert(
                            lang: settingNotifier.languageString ??
                                CommonLanguages.languageStringDefault(),
                            word: 'screen.title.content'),
                        style: const TextStyle(
                            fontSize: 13.0, color: Colors.black45)),
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
                    ),
                    child: flutter_quill.QuillEditor(
                        controller: _subDescriptionQuillController,
                        readOnly: true, // true for view only mode
                        autoFocus: false,
                        expands: false,
                        focusNode: _focusNode,
                        padding: const EdgeInsets.all(4.0),
                        scrollController: _scrollController,
                        scrollable: false,
                        showCursor: false),
                  ),
                ),
                Text(
                  '...',
                  style: GoogleFonts.montserrat(
                      fontStyle: FontStyle.italic, fontSize: 14),
                ),
              ],
            ),
            expanded: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                flutter_quill.QuillEditor(
                    controller: _descriptionQuillController,
                    readOnly: true, // true for view only mode
                    autoFocus: false,
                    expands: false,
                    focusNode: _focusNode,
                    padding: const EdgeInsets.all(4.0),
                    scrollController: _scrollController,
                    scrollable: false,
                    showCursor: false),
                _buildSelectedImages(context, settingNotifier)
              ],
            ),
            builder: (_, collapsed, expanded) {
              return Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: Expandable(
                  collapsed: collapsed,
                  expanded: expanded,
                  theme: const ExpandableThemeData(crossFadePoint: 0),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedImages(
      BuildContext context, SettingNotifier settingNotifier) {
    if (_imageSourceStrings.isNotEmpty) {
      if (_imageSourceStrings.length == 1) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _imageSourceStrings.length,
            (index) => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
                  child: GestureDetector(
                    onTap: () async {
                      await showDialog<bool>(
                          context: context,
                          barrierDismissible: true,
                          builder: (BuildContext context) {
                            return CoreBasicDialog(
                              insetPadding: const EdgeInsets.all(5.0),
                              backgroundColor: Colors.white.withOpacity(0.95),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: SizedBox(
                                height:
                                    CommonDimensions.maxHeightScreen(context) *
                                        0.75,
                                child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        5.0, 20.0, 5.0, 10.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                CommonLanguages.convert(
                                                    lang: settingNotifier
                                                            .languageString ??
                                                        CommonLanguages
                                                            .languageStringDefault(),
                                                    word:
                                                        'screen.title.viewImage'),
                                                style: CommonStyles
                                                    .screenTitleTextStyle(
                                                        fontSize: 16.0,
                                                        color: const Color(
                                                            0xFF1f1f1f)),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10.0),
                                        Expanded(
                                          child: Container(
                                            constraints: BoxConstraints(
                                                maxWidth: CommonDimensions
                                                        .maxWidthScreen(
                                                            context) *
                                                    0.9),
                                            child: PhotoView(
                                              maxScale: 25.0,
                                              minScale: 0.1,
                                              backgroundDecoration:
                                                  const BoxDecoration(
                                                      color:
                                                          Colors.transparent),
                                              imageProvider: FileImage(File(
                                                  _imageSourceStrings[index])),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10.0),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            CoreElevatedButton.icon(
                                              playSound: false,
                                              buttonAudio:
                                                  commonAudioOnPressButton,
                                              icon: const FaIcon(
                                                  FontAwesomeIcons.xmark,
                                                  size: 18.0),
                                              label: Text(
                                                  CommonLanguages.convert(
                                                      lang: settingNotifier
                                                              .languageString ??
                                                          CommonLanguages
                                                              .languageStringDefault(),
                                                      word:
                                                          'button.title.close'),
                                                  style: CommonStyles
                                                      .labelTextStyle),
                                              onPressed: () {
                                                if (Navigator.canPop(context)) {
                                                  Navigator.pop(context, true);
                                                }
                                              },
                                              coreButtonStyle:
                                                  CoreButtonStyle.options(
                                                      coreStyle:
                                                          CoreStyle.filled,
                                                      coreColor:
                                                          CoreColor.success,
                                                      coreRadius:
                                                          CoreRadius.radius_6,
                                                      kitBorderColorOption:
                                                          Colors.black,
                                                      kitForegroundColorOption:
                                                          Colors.black,
                                                      coreFixedSizeButton:
                                                          CoreFixedSizeButton
                                                              .medium_48),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )),
                              ),
                            );
                          });
                    },
                    child: Material(
                      elevation: 3,
                      borderRadius: BorderRadius.circular(5.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: Container(
                          constraints: BoxConstraints(
                              maxWidth:
                                  CommonDimensions.maxWidthScreen(context) *
                                      0.7,
                              maxHeight: CommonDimensions
                                  .maxHeightScreen(
                                  context) *
                                  0.35),
                          child: Image.file(
                            File(_imageSourceStrings[index]),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        int viewingIndex = 0;
        String? viewingImageSourceString;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              _imageSourceStrings.length,
              (index) => Padding(
                padding: const EdgeInsets.all(5.0),
                child: GestureDetector(
                  onTap: () async {
                    viewingIndex = index;
                    viewingImageSourceString = _imageSourceStrings[index];
                    await showDialog<bool>(
                        context: context,
                        barrierDismissible: true,
                        builder: (BuildContext context) {
                          return CoreBasicDialog(
                              insetPadding: const EdgeInsets.all(5.0),
                              backgroundColor: Colors.white.withOpacity(0.95),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: StatefulBuilder(builder:
                                  (BuildContext context, StateSetter setState) {
                                return SizedBox(
                                  height: CommonDimensions.maxHeightScreen(
                                          context) *
                                      0.75,
                                  child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          5.0, 20.0, 5.0, 10.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  CommonLanguages.convert(
                                                      lang: settingNotifier
                                                              .languageString ??
                                                          CommonLanguages
                                                              .languageStringDefault(),
                                                      word:
                                                          'screen.title.viewImage'),
                                                  style: CommonStyles
                                                      .screenTitleTextStyle(
                                                          fontSize: 16.0,
                                                          color: const Color(
                                                              0xFF1f1f1f)),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10.0),
                                          Expanded(
                                            child: Container(
                                              constraints: BoxConstraints(
                                                  maxWidth: CommonDimensions
                                                          .maxWidthScreen(
                                                              context) *
                                                      0.9),
                                              child: PhotoView(
                                                maxScale: 25.0,
                                                minScale: 0.1,
                                                backgroundDecoration:
                                                    const BoxDecoration(
                                                        color:
                                                            Colors.transparent),
                                                imageProvider: FileImage(File(
                                                    viewingImageSourceString ??
                                                        _imageSourceStrings[
                                                            index])),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10.0),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                4.0, 0, 4.0, 0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                CoreElevatedButton.iconOnly(
                                                  playSound: false,
                                                  buttonAudio:
                                                      commonAudioOnPressButton,
                                                  onPressed: () {
                                                    if (viewingIndex > 0) {
                                                      setState(() {
                                                        viewingIndex--;
                                                        viewingImageSourceString =
                                                            _imageSourceStrings[
                                                                viewingIndex];
                                                      });
                                                    }
                                                  },
                                                  coreButtonStyle:
                                                      ThemeDataCenter
                                                          .getUpdateButtonStyle(
                                                              context),
                                                  icon: const Icon(
                                                      Icons
                                                          .arrow_back_ios_rounded,
                                                      size: 26.0),
                                                ),
                                                CoreElevatedButton.icon(
                                                  playSound: false,
                                                  buttonAudio:
                                                      commonAudioOnPressButton,
                                                  icon: const FaIcon(
                                                      FontAwesomeIcons.xmark,
                                                      size: 18.0),
                                                  label: Text(
                                                      CommonLanguages.convert(
                                                          lang: settingNotifier
                                                                  .languageString ??
                                                              CommonLanguages
                                                                  .languageStringDefault(),
                                                          word:
                                                              'button.title.close'),
                                                      style: CommonStyles
                                                          .labelTextStyle),
                                                  onPressed: () {
                                                    if (Navigator.canPop(
                                                        context)) {
                                                      Navigator.pop(
                                                          context, true);
                                                    }
                                                  },
                                                  coreButtonStyle:
                                                      CoreButtonStyle.options(
                                                          coreStyle:
                                                              CoreStyle.filled,
                                                          coreColor:
                                                              CoreColor.success,
                                                          coreRadius: CoreRadius
                                                              .radius_6,
                                                          kitBorderColorOption:
                                                              Colors.black,
                                                          kitForegroundColorOption:
                                                              Colors.black,
                                                          coreFixedSizeButton:
                                                              CoreFixedSizeButton
                                                                  .medium_48),
                                                ),
                                                CoreElevatedButton.iconOnly(
                                                  playSound: false,
                                                  buttonAudio:
                                                      commonAudioOnPressButton,
                                                  onPressed: () {
                                                    if (viewingIndex <
                                                        _imageSourceStrings
                                                                .length -
                                                            1) {
                                                      setState(() {
                                                        viewingIndex++;
                                                        viewingImageSourceString =
                                                            _imageSourceStrings[
                                                                viewingIndex];
                                                      });
                                                    }
                                                  },
                                                  coreButtonStyle:
                                                      ThemeDataCenter
                                                          .getUpdateButtonStyle(
                                                              context),
                                                  icon: const Icon(
                                                      Icons
                                                          .arrow_forward_ios_rounded,
                                                      size: 26.0),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )),
                                );
                              }));
                        });
                  },
                  child: Material(
                    elevation: 3,
                    borderRadius: BorderRadius.circular(5.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5.0),
                      child: SizedBox(
                        width: 100.0,
                        height: 100.0,
                        child: Image.file(
                          File(_imageSourceStrings[index]),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }
    }
    return Container();
  }

  SizedBox _buildHeader(BuildContext context, SettingNotifier settingNotifier) {
    return SizedBox(
      // height: 150,
      child: Container(
        decoration: BoxDecoration(
          color: widget.subject != null &&
                  settingNotifier.isSetColorAccordingSubjectColor!
              ? widget.subject!.color
                  .toColor()
                  .withOpacity(settingNotifier.opacityNumber ?? 1)
              : ThemeDataCenter.getNoteTopBannerCardBackgroundColor(context),
          shape: BoxShape.rectangle,
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                    child: checkTitleEmpty()
                        ? SingleChildScrollView(
                            child: flutter_quill.QuillEditor(
                                controller: _titleQuillController,
                                readOnly: true, // true for view only mode
                                autoFocus: false,
                                expands: false,
                                focusNode: _focusNode,
                                padding: const EdgeInsets.fromLTRB(
                                    10.0, 10.0, 10.0, 10.0),
                                scrollController: _scrollController,
                                scrollable: false,
                                showCursor: false),
                          )
                        : onGetTitle(settingNotifier)),
                widget.note.deletedAt == null && widget.note.isLocked == null
                    ? Tooltip(
                        message: CommonLanguages.convert(
                            lang: settingNotifier.languageString ??
                                CommonLanguages.languageStringDefault(),
                            word: 'tooltip.button.update'),
                        child: CoreElevatedButton.iconOnly(
                          buttonAudio: commonAudioOnPressButton,
                          onPressed: () {
                            if (widget.onUpdate != null) {
                              widget.onUpdate!();
                            }
                          },
                          coreButtonStyle:
                              ThemeDataCenter.getUpdateButtonStyle(context),
                          icon: const Icon(Icons.edit_note_rounded, size: 26.0),
                        ),
                      )
                    : Container(),
                widget.note.deletedAt == null && widget.note.isLocked != null
                    ? Tooltip(
                        message: CommonLanguages.convert(
                            lang: settingNotifier.languageString ??
                                CommonLanguages.languageStringDefault(),
                            word: 'tooltip.button.unlock'),
                        child: CoreElevatedButton.iconOnly(
                          buttonAudio: commonAudioOnPressButton,
                          onPressed: () {
                            if (widget.onUnlock != null) {
                              widget.onUnlock!();
                            }
                          },
                          coreButtonStyle:
                              ThemeDataCenter.getUpdateButtonStyle(context),
                          icon: const Icon(Icons.lock_open_rounded, size: 26.0),
                        ),
                      )
                    : Container(),
                widget.note.deletedAt != null
                    ? Column(children: [
                        Tooltip(
                          message: CommonLanguages.convert(
                              lang: settingNotifier.languageString ??
                                  CommonLanguages.languageStringDefault(),
                              word: 'tooltip.button.restore'),
                          child: CoreElevatedButton.iconOnly(
                            buttonAudio: commonAudioOnPressButton,
                            onPressed: () {
                              if (widget.onRestoreFromTrash != null) {
                                widget.onRestoreFromTrash!();
                              }
                            },
                            coreButtonStyle:
                                ThemeDataCenter.getRestoreButtonStyle(context),
                            icon: const Icon(Icons.restore_from_trash_rounded,
                                size: 26.0),
                          ),
                        ),
                        const SizedBox(height: 2.0),
                        Tooltip(
                          message: CommonLanguages.convert(
                              lang: settingNotifier.languageString ??
                                  CommonLanguages.languageStringDefault(),
                              word: 'tooltip.button.deleteForever'),
                          child: CoreElevatedButton.iconOnly(
                            buttonAudio: commonAudioOnPressButton,
                            onPressed: () {
                              if (widget.onDeleteForever != null) {
                                widget.onDeleteForever!();
                              }
                            },
                            coreButtonStyle:
                                ThemeDataCenter.getDeleteForeverButtonStyle(
                                    context),
                            icon: const Icon(Icons.delete_forever_rounded,
                                size: 26.0),
                          ),
                        ),
                      ])
                    : Container()
              ]),
        ),
      ),
    );
  }
}
