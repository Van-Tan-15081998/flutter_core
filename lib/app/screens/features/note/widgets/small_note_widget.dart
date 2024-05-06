import 'dart:convert';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_core_v3/app/library/common/themes/ThemeDataCenter.dart';
import 'package:flutter_core_v3/app/library/extensions/extensions.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as flutter_quill;
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:sticky_headers/sticky_headers.dart';
import '../../../../../core/components/actions/common_buttons/CoreElevatedButton.dart';
import '../../../../library/common/converters/CommonConverters.dart';
import '../../../../library/common/languages/CommonLanguages.dart';
import '../../../../library/common/styles/CommonStyles.dart';
import '../../../../library/common/utils/CommonAudioOnPressButton.dart';
import '../../../setting/providers/setting_notifier.dart';
import '../../label/models/label_model.dart';
import '../../subjects/models/subject_model.dart';
import '../models/note_model.dart';

class SmallNoteWidget extends StatefulWidget {
  final int? index;
  final NoteModel note;
  final List<LabelModel>? labels;
  final SubjectModel? subject;
  final VoidCallback? onView;
  final VoidCallback? onPin;
  final VoidCallback? onUpdate;
  final VoidCallback? onDelete;
  final VoidCallback? onFavourite;
  final VoidCallback? onUnlock;
  final bool? isLastItem;
  const SmallNoteWidget(
      {Key? key,
      required this.index,
      required this.note,
      required this.subject,
      required this.labels,
      required this.onView,
      required this.onUpdate,
      required this.onDelete,
      required this.onFavourite,
      required this.onUnlock,
      required this.onPin,
      required this.isLastItem})
      : super(key: key);

  @override
  State<SmallNoteWidget> createState() => _SmallNoteWidgetState();
}

class _SmallNoteWidgetState extends State<SmallNoteWidget> {
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
    String defaultTitle =
        '${CommonLanguages.convert(lang: settingNotifier.languageString ?? CommonLanguages.languageStringDefault(), word: 'card.title.youWroteAt')} ${CommonConverters.toTimeString(time: widget.note.createdAt!)}';
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text(defaultTitle),
    );
  }

  bool checkTitleEmpty() {
    if (widget.note.title != null && widget.note.title!.isNotEmpty) {
      List<dynamic> deltaMap = jsonDecode(widget.note.title!);

      flutter_quill.Delta delta = flutter_quill.Delta.fromJson(deltaMap);

      var list = delta.toList();
      if (list.length == 1) {
        if (list[0].key == 'insert' && list[0].data == '\n') {
          return false;
        }
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

  @override
  Widget build(BuildContext context) {
    final settingNotifier = Provider.of<SettingNotifier>(context);

    setDocuments();
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
      child: ExpandableNotifier(
        initialExpanded: settingNotifier.isExpandedNoteContent ?? false,
        child: Column(
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
                                                  time: widget.note.createdAt!),
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
                                                  time: widget.note.updatedAt!),
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
                                                  time: widget.note.createdAt!),
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
                                        .getLockSlidableActionColorStyle(
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
                                        .getViewSlidableActionColorStyle(
                                            context)),
                              )
                            : Container(),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
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
                                                  time: widget.note.deletedAt!),
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
                                                  time: widget.note.createdAt!),
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
                shadowColor: const Color(0xff1f1f1f),
                elevation: 2.0,
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
                            content: _buildContent(),
                          )
                        ],
                      )
                    : Column(
                        children: <Widget>[
                          _buildHeader(context, settingNotifier),
                          _buildContent(),
                        ],
                      )),
            Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      if (widget.onPin != null) {
                        widget.onPin!();
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
                        child: Icon(Icons.push_pin,
                            size: 22,
                            color:
                                ThemeDataCenter.getPinSlidableActionColorStyle(
                                    context)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5.0),
                  InkWell(
                    onTap: () {
                      if (widget.onView != null) {
                        widget.onView!();
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
                        child: Icon(Icons.search_rounded,
                            size: 22,
                            color:
                                ThemeDataCenter.getViewSlidableActionColorStyle(
                                    context)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5.0),
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
                                color:
                                    settingNotifier.isSetBackgroundImage == true
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
                  widget.note.isLocked == null
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
                                color:
                                    settingNotifier.isSetBackgroundImage == true
                                        ? Colors.white.withOpacity(0.65)
                                        : Colors.transparent),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Icon(
                                Icons.delete,
                                size: 22,
                                color: ThemeDataCenter
                                    .getDeleteSlidableActionColorStyle(context),
                              ),
                            ),
                          ),
                        )
                      : Container()
                ],
              ),
            ),
            widget.isLastItem == true
                ? const SizedBox(height: 150.0)
                : Container()
          ],
        ),
      ),
    );
  }

  Column _buildContent() {
    return Column(
      children: [
        _buildLabels(),
        ScrollOnExpand(
          scrollOnExpand: true,
          scrollOnCollapse: false,
          child: ExpandablePanel(
            theme: const ExpandableThemeData(
              headerAlignment: ExpandablePanelHeaderAlignment.center,
              tapBodyToCollapse: true,
            ),
            header: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Row(
                  children: [
                    Text("[id:${widget.note.id!}] ",
                        style: const TextStyle(
                            fontSize: 13.0, color: Colors.black45)),
                    const Text("Content",
                        style:
                            TextStyle(fontSize: 13.0, color: Colors.black45)),
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

  SizedBox _buildHeader(BuildContext context, SettingNotifier settingNotifier) {
    return SizedBox(
      // height: 150,
      child: Container(
        decoration: BoxDecoration(
          color: widget.subject != null &&
                  settingNotifier.isSetColorAccordingSubjectColor!
              ? widget.subject!.color.toColor()
              : ThemeDataCenter.getNoteTopBannerCardBackgroundColor(context),
          shape: BoxShape.rectangle,
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                    width: MediaQuery.of(context).size.width - 115.0,
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
                        message: 'Update',
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
                        message: 'UnLock',
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
              ]),
        ),
      ),
    );
  }
}