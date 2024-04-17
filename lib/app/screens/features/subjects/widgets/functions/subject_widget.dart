import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_core_v3/app/library/extensions/extensions.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/components/actions/common_buttons/CoreButtonStyle.dart';
import '../../../../../../core/components/actions/common_buttons/CoreElevatedButton.dart';
import '../../../../../library/common/styles/CommonStyles.dart';
import '../../../../../library/enums/CommonEnums.dart';
import '../../../../setting/providers/setting_notifier.dart';
import '../../../note/models/note_condition_model.dart';
import '../../../note/note_create_screen.dart';
import '../../../note/note_list_screen.dart';
import '../../databases/subject_db_manager.dart';
import '../../models/subject_model.dart';
import '../subject_create_screen.dart';
import '../subject_detail_screen.dart';

class SubjectWidget extends StatefulWidget {
  final int? index;
  final SubjectModel subject;
  final bool? isSubSubject;
  final VoidCallback? onUpdate;
  final VoidCallback? onDelete;
  final VoidCallback? onDeleteForever;
  final VoidCallback? onRestoreFromTrash;
  final VoidCallback? onFilterChildren;
  final VoidCallback? onFilterParent;
  const SubjectWidget(
      {Key? key,
      required this.index,
      required this.subject,
      required this.isSubSubject,
      required this.onUpdate,
      required this.onDelete,
      required this.onDeleteForever,
      required this.onRestoreFromTrash,
      required this.onFilterChildren,
      required this.onFilterParent})
      : super(key: key);

  @override
  State<SubjectWidget> createState() => _SubjectWidgetState();
}

class _SubjectWidgetState extends State<SubjectWidget> {
  late int countChildren;
  late int countNotes;

  bool expandedActions = false;
  bool alreadySetExpandedActions = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    countChildren = 0;
    countNotes = 0;

    _onCountChildren().then((result) {
      setState(() {
        countChildren = result;
      });
    });

    _onCountNotes().then((result) {
      setState(() {
        countNotes = result;
      });
    });
  }

  Future<int> _onCountChildren() async {
    return await SubjectDatabaseManager.countChildren(widget.subject);
  }

  Future<int> _onCountNotes() async {
    return await SubjectDatabaseManager.countNotes(widget.subject);
  }

  String getTimeString(int time) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(time);

    int year = dateTime.year;
    int month = dateTime.month;
    int day = dateTime.day;
    int hour = dateTime.hour;
    int minute = dateTime.minute;

    return '$hour:$minute $day/$month/$year';
  }

  @override
  Widget build(BuildContext context) {
    final settingNotifier = Provider.of<SettingNotifier>(context);
    if (settingNotifier.isExpandedSubjectActions != null &&
        !alreadySetExpandedActions) {
      expandedActions = settingNotifier.isExpandedSubjectActions!;
      alreadySetExpandedActions = true;
    }

    return Padding(
      padding: EdgeInsets.only(
          left: widget.isSubSubject != null && widget.isSubSubject! ? 25.0 : 0),
      child: Slidable(
        key: const ValueKey(0),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            widget.subject.deletedAt == null ?
            SlidableAction(
              flex: 1,
              onPressed: (context) {
                setState(() {
                  expandedActions = !expandedActions;
                });
              },
              backgroundColor: const Color(0xFF202124),
              foregroundColor: const Color(0xff8fc49b),
              icon: Icons.keyboard_control_rounded,
            ) : Container(),
            SlidableAction(
              flex: 1,
              onPressed: (context) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SubjectDetailScreen(subject: widget.subject)));
              },
              backgroundColor: const Color(0xFF202124),
              foregroundColor: const Color(0xff17a2b8),
              icon: Icons.remove_red_eye_rounded,
            ),
            widget.subject.deletedAt == null ?
            SlidableAction(
              flex: 1,
              onPressed: (context) {
                if (widget.onDelete != null) {
                  widget.onDelete!();
                }
              },
              backgroundColor: const Color(0xFF202124),
              foregroundColor: const Color(0xffffb90f),
              icon: Icons.delete,
            ) : Container()
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
          child: ExpandableNotifier(
            child: Column(
              children: [
                widget.subject.updatedAt == null &&
                        widget.subject.deletedAt == null
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 9.0, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(widget.index.toString(),
                                style: CommonStyles.labelTextStyle),
                            Text(getTimeString(widget.subject.createdAt!),
                                style: const TextStyle(
                                  fontSize: 13.0,
                                  color: Colors.white54,
                                )),
                          ],
                        ),
                      )
                    : Container(),
                widget.subject.updatedAt != null &&
                        widget.subject.deletedAt == null
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 9.0, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(widget.index.toString(),
                                style: CommonStyles.labelTextStyle),
                            Row(
                              children: [
                                const Icon(Icons.edit,
                                    size: 13.0, color: Colors.white54),
                                const SizedBox(width: 5.0),
                                Text(getTimeString(widget.subject.updatedAt!),
                                    style: const TextStyle(
                                        fontSize: 13.0, color: Colors.white54))
                              ],
                            )
                          ],
                        ),
                      )
                    : Container(),
                widget.subject.deletedAt != null
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 9.0, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(widget.index.toString(),
                                style: CommonStyles.labelTextStyle),
                            Row(
                              children: [
                                const Icon(Icons.delete_rounded,
                                    size: 13.0, color: Colors.white54),
                                const SizedBox(width: 5.0),
                                Text(getTimeString(widget.subject.deletedAt!),
                                    style: const TextStyle(
                                        fontSize: 13.0, color: Colors.white54))
                              ],
                            )
                          ],
                        ),
                      )
                    : Container(),
                GestureDetector(
                  onDoubleTap: () {
                    setState(() {
                      expandedActions = !expandedActions;
                    });
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          5.0), // Đây là giá trị bo góc ở đây
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          // height: 150,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.rectangle,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                2.0, 2.0, 2.0, 2.0),
                                            child: DottedBorder(
                                                borderType: BorderType.RRect,
                                                radius:
                                                    const Radius.circular(12),
                                                color: widget.subject.color
                                                    .toColor(),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(12)),
                                                  child: Container(
                                                      color: Colors.white,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(6.0),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Icon(
                                                                Icons
                                                                    .palette_rounded,
                                                                color: widget
                                                                    .subject
                                                                    .color
                                                                    .toColor()),
                                                            const SizedBox(
                                                                width: 6.0),
                                                            Flexible(
                                                              child: Text(
                                                                  widget.subject
                                                                      .title,
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          16.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400)),
                                                            ),
                                                          ],
                                                        ),
                                                      )),
                                                )),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  widget.subject.deletedAt == null &&
                                          expandedActions
                                      ? FadeInRight(
                                          duration:
                                              const Duration(milliseconds: 200),
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                4.0, 0, 0, 0),
                                            child: Column(
                                              children: [
                                                Tooltip(
                                                  message: 'Update',
                                                  child: CoreElevatedButton.iconOnly(
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  SubjectCreateScreen(
                                                                    parentSubject:
                                                                        null,
                                                                    actionMode:
                                                                        ActionModeEnum
                                                                            .update,
                                                                    subject: widget
                                                                        .subject,
                                                                  )));
                                                    },
                                                    coreButtonStyle:
                                                        CoreButtonStyle.dark(
                                                            kitRadius: 6.0),
                                                    icon: const Icon(
                                                        Icons.edit_note_rounded),
                                                  ),
                                                ),
                                                Tooltip(
                                                  message: 'Create sub subject',
                                                  child: CoreElevatedButton.iconOnly(
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  SubjectCreateScreen(
                                                                      parentSubject:
                                                                          widget
                                                                              .subject,
                                                                      actionMode:
                                                                          ActionModeEnum
                                                                              .create)));
                                                    },
                                                    coreButtonStyle:
                                                        CoreButtonStyle.dark(
                                                            kitRadius: 6.0),
                                                    icon: const Icon(Icons
                                                        .create_new_folder_rounded),
                                                  ),
                                                ),
                                                Tooltip(
                                                  message: 'Notes',
                                                  child: CoreElevatedButton.iconOnly(
                                                    onPressed: () {
                                                      NoteConditionModel
                                                          noteConditionModel =
                                                          NoteConditionModel();
                                                      noteConditionModel
                                                              .subjectId =
                                                          widget.subject.id;
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  NoteListScreen(
                                                                      noteConditionModel:
                                                                          noteConditionModel)));
                                                    },
                                                    coreButtonStyle:
                                                        CoreButtonStyle.dark(
                                                            kitRadius: 6.0),
                                                    icon: const Icon(Icons
                                                        .playlist_play_rounded),
                                                  ),
                                                ),
                                                Tooltip(
                                                  message: 'Create note',
                                                  child: CoreElevatedButton.iconOnly(
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  NoteCreateScreen(
                                                                      subject: widget
                                                                          .subject,
                                                                      actionMode:
                                                                          ActionModeEnum
                                                                              .create)));
                                                    },
                                                    coreButtonStyle:
                                                        CoreButtonStyle.dark(
                                                            kitRadius: 6.0),
                                                    icon: const Icon(
                                                        Icons.add_card_rounded),
                                                  ),
                                                ),
                                                Tooltip(
                                                  message: 'Parent subject',
                                                  child: CoreElevatedButton.iconOnly(
                                                    onPressed: () {
                                                      if (widget.onFilterParent !=
                                                          null) {
                                                        widget.onFilterParent!();
                                                      }
                                                    },
                                                    coreButtonStyle:
                                                        CoreButtonStyle.dark(
                                                            kitRadius: 6.0),
                                                    icon: const Icon(
                                                        Icons.arrow_upward_rounded),
                                                  ),
                                                ),
                                                Tooltip(
                                                  message: 'Sub subjects',
                                                  child: CoreElevatedButton.iconOnly(
                                                    onPressed: () {
                                                      if (widget
                                                              .onFilterChildren !=
                                                          null) {
                                                        widget
                                                            .onFilterChildren!();
                                                      }
                                                    },
                                                    coreButtonStyle:
                                                        CoreButtonStyle.dark(
                                                            kitRadius: 6.0),
                                                    icon: const Icon(
                                                        Icons.arrow_downward_rounded),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      : Container(),
                                  widget.subject.deletedAt != null
                                      ? Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              4.0, 0, 0, 0),
                                          child: Column(children: [
                                            Tooltip(
                                              message: 'Restore',
                                              child: CoreElevatedButton.iconOnly(
                                                onPressed: () {
                                                  if (widget.onRestoreFromTrash !=
                                                      null) {
                                                    widget.onRestoreFromTrash!();
                                                  }
                                                },
                                                coreButtonStyle:
                                                    CoreButtonStyle.info(
                                                        kitRadius: 6.0),
                                                icon: const Icon(
                                                    Icons
                                                        .restore_from_trash_rounded,
                                                    size: 26.0),
                                              ),
                                            ),
                                            const SizedBox(height: 2.0),
                                            Tooltip(
                                              message: 'Delete forever',
                                              child: CoreElevatedButton.iconOnly(
                                                onPressed: () {
                                                  if (widget.onDeleteForever !=
                                                      null) {
                                                    widget.onDeleteForever!();
                                                  }
                                                },
                                                coreButtonStyle:
                                                    CoreButtonStyle.danger(
                                                        kitRadius: 6.0),
                                                icon: const Icon(
                                                    Icons.delete_forever_rounded,
                                                    size: 26.0),
                                              ),
                                            ),
                                          ]),
                                        )
                                      : Container()
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text('Sub subjects: ',
                          style: TextStyle(color: Colors.white54)),
                      Text(
                        countChildren.toString(),
                        style: const TextStyle(
                            color: Colors.white70, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        width: 30.0,
                      ),
                      const Text('Notes: ',
                          style: TextStyle(color: Colors.white54)),
                      Text(
                        countNotes.toString(),
                        style: const TextStyle(
                            color: Colors.white70, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}