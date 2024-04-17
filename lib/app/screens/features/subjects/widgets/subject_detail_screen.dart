import 'package:dotted_border/dotted_border.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core_v3/app/library/extensions/extensions.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import '../../../../../core/components/actions/common_buttons/CoreButtonStyle.dart';
import '../../../../../core/components/actions/common_buttons/CoreElevatedButton.dart';
import '../../../../../core/components/containment/dialogs/CoreFullScreenDialog.dart';
import '../../../../../core/components/helper_widgets/CoreHelperWidget.dart';
import '../../../../../core/components/notifications/CoreNotification.dart';
import '../../../../library/enums/CommonEnums.dart';
import '../../note/models/note_condition_model.dart';
import '../../note/note_create_screen.dart';
import '../../note/note_list_screen.dart';
import '../databases/subject_db_manager.dart';
import '../models/subject_condition_model.dart';
import '../models/subject_model.dart';
import '../providers/subject_notifier.dart';
import 'subject_create_screen.dart';
import 'subject_list_screen.dart';

class SubjectDetailScreen extends StatefulWidget {
  final SubjectModel subject;

  const SubjectDetailScreen({super.key, required this.subject});

  @override
  State<SubjectDetailScreen> createState() => _SubjectDetailScreenState();
}

class _SubjectDetailScreenState extends State<SubjectDetailScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  _onUpdateSubject() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SubjectCreateScreen(
                  subject: widget.subject,
                  parentSubject: null,
                  actionMode: ActionModeEnum.update,
                )));
  }

  Future<bool> _onDeleteSubject(BuildContext context) async {
    return await SubjectDatabaseManager.delete(
        widget.subject, DateTime.now().millisecondsSinceEpoch);
  }

  Future<bool> _onDeleteSubjectForever(BuildContext context) async {
    return await SubjectDatabaseManager.deleteForever(widget.subject);
  }

  Future<bool> _onRestoreSubjectFromTrash(BuildContext context) async {
    return await SubjectDatabaseManager.restoreFromTrash(
        widget.subject, DateTime.now().millisecondsSinceEpoch);
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

  Widget onGetTitle() {
    String defaultTitle =
        'You wrote at ${getTimeString(widget.subject.createdAt!)}';
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text(defaultTitle),
    );
  }

  @override
  Widget build(BuildContext context) {
    final subjectNotifier = Provider.of<SubjectNotifier>(context);

    return CoreFullScreenDialog(
        title: 'Detail',
        actions: AppBarActionButtonEnum.home,
        isConfirmToClose: false,
        homeLabel: 'Subjects',
        onGoHome: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => const SubjectListScreen(
                      subjectConditionModel: null,
                    )),
            (route) => false,
          );
        },
        onSubmit: null,
        onRedo: null,
        onUndo: null,
        onBack: null,
        isShowBottomActionButton: false,
        isShowGeneralActionButton: false,
        isShowOptionActionButton: true,
        optionActionContent: Container(),
        bottomActionBar: const [Row()],
        bottomActionBarScrollable: const [Row()],
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: ListView(children: <Widget>[
            Slidable(
              key: const ValueKey(0),
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  widget.subject.deletedAt == null
                      ? SlidableAction(
                          flex: 1,
                          onPressed: (context) {
                            _onDeleteSubject(context).then((result) {
                              if (result) {
                                subjectNotifier.onCountAll();

                                CoreNotification.show(
                                    context,
                                    CoreNotificationStatus.success,
                                    CoreNotificationAction.delete,
                                    'Subject');

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const SubjectListScreen(
                                      subjectConditionModel: null,
                                    ),
                                  ),
                                );
                              } else {
                                CoreNotification.show(
                                    context,
                                    CoreNotificationStatus.error,
                                    CoreNotificationAction.delete,
                                    'Subject');
                              }
                            });
                          },
                          backgroundColor: const Color(0xFF202124),
                          foregroundColor: const Color(0xffffb90f),
                          icon: Icons.delete,
                          label: 'Delete',
                        )
                      : Container()
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
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
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
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Icon(Icons.edit,
                                      size: 13.0, color: Colors.white54),
                                  const SizedBox(width: 5.0),
                                  Text(getTimeString(widget.subject.updatedAt!),
                                      style: const TextStyle(
                                          fontSize: 13.0,
                                          color: Colors.white54))
                                ],
                              ),
                            )
                          : Container(),
                      widget.subject.deletedAt != null
                          ? Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 9.0, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Icon(Icons.delete_rounded,
                                      size: 13.0, color: Colors.white54),
                                  const SizedBox(width: 5.0),
                                  Text(getTimeString(widget.subject.deletedAt!),
                                      style: const TextStyle(
                                          fontSize: 13.0,
                                          color: Colors.white54))
                                ],
                              ),
                            )
                          : Container(),
                      Card(
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              2.0, 0, 6.0, 0),
                                          child: DottedBorder(
                                              borderType: BorderType.RRect,
                                              radius: const Radius.circular(12),
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
                                                          const EdgeInsets.all(
                                                              6.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Icon(
                                                              Icons
                                                                  .palette_rounded,
                                                              color: widget
                                                                  .subject.color
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
                                      widget.subject.deletedAt == null
                                          ? Column(
                                              children: [
                                                Tooltip(
                                                  message: 'Update',
                                                  child: CoreElevatedButton
                                                      .iconOnly(
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
                                                    icon: const Icon(Icons
                                                        .edit_note_rounded),
                                                  ),
                                                ),
                                                Tooltip(
                                                  message: 'Create sub subject',
                                                  child: CoreElevatedButton
                                                      .iconOnly(
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) => SubjectCreateScreen(
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
                                                  child: CoreElevatedButton
                                                      .iconOnly(
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
                                                  child: CoreElevatedButton
                                                      .iconOnly(
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) => NoteCreateScreen(
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
                                                  child: CoreElevatedButton
                                                      .iconOnly(
                                                    onPressed: () {
                                                      SubjectConditionModel
                                                          subjectConditionModel =
                                                          SubjectConditionModel();
                                                      subjectConditionModel.id =
                                                          widget
                                                              .subject.parentId;
                                                      subjectConditionModel
                                                          .parentId = null;

                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              SubjectListScreen(
                                                            subjectConditionModel:
                                                                subjectConditionModel,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    coreButtonStyle:
                                                        CoreButtonStyle.dark(
                                                            kitRadius: 6.0),
                                                    icon: const Icon(Icons
                                                        .arrow_upward_rounded),
                                                  ),
                                                ),
                                                Tooltip(
                                                  message: 'Sub subjects',
                                                  child: CoreElevatedButton
                                                      .iconOnly(
                                                    onPressed: () {
                                                      SubjectConditionModel
                                                          subjectConditionModel =
                                                          SubjectConditionModel();
                                                      subjectConditionModel
                                                              .parentId =
                                                          widget
                                                              .subject.parentId;
                                                      subjectConditionModel.id =
                                                          null;

                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              SubjectListScreen(
                                                            subjectConditionModel:
                                                                subjectConditionModel,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    coreButtonStyle:
                                                        CoreButtonStyle.dark(
                                                            kitRadius: 6.0),
                                                    icon: const Icon(Icons
                                                        .arrow_downward_rounded),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Column(children: [
                                              CoreElevatedButton.iconOnly(
                                                onPressed: () {
                                                  _onRestoreSubjectFromTrash(
                                                          context)
                                                      .then((result) {
                                                    if (result) {
                                                      subjectNotifier
                                                          .onCountAll();

                                                      CoreNotification.show(
                                                          context,
                                                          CoreNotificationStatus
                                                              .success,
                                                          CoreNotificationAction
                                                              .restore,
                                                          'Subject');

                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              const SubjectListScreen(
                                                            subjectConditionModel:
                                                                null,
                                                          ),
                                                        ),
                                                      );
                                                    } else {
                                                      CoreNotification.show(
                                                          context,
                                                          CoreNotificationStatus
                                                              .error,
                                                          CoreNotificationAction
                                                              .restore,
                                                          'Subject');
                                                    }
                                                  });
                                                },
                                                coreButtonStyle:
                                                    CoreButtonStyle.info(
                                                        kitRadius: 6.0),
                                                icon: const Icon(
                                                    Icons
                                                        .restore_from_trash_rounded,
                                                    size: 26.0),
                                              ),
                                              const SizedBox(height: 2.0),
                                              CoreElevatedButton.iconOnly(
                                                onPressed: () async {
                                                  if (await CoreHelperWidget
                                                      .confirmFunction(
                                                          context)) {
                                                    _onDeleteSubjectForever(
                                                            context)
                                                        .then((result) {
                                                      if (result) {
                                                        subjectNotifier
                                                            .onCountAll();

                                                        CoreNotification.show(
                                                            context,
                                                            CoreNotificationStatus
                                                                .success,
                                                            CoreNotificationAction
                                                                .delete,
                                                            'Subject');

                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                const SubjectListScreen(
                                                              subjectConditionModel:
                                                                  null,
                                                            ),
                                                          ),
                                                        );
                                                      } else {
                                                        CoreNotification.show(
                                                            context,
                                                            CoreNotificationStatus
                                                                .error,
                                                            CoreNotificationAction
                                                                .delete,
                                                            'Subject');
                                                      }
                                                    });
                                                  }
                                                },
                                                coreButtonStyle:
                                                    CoreButtonStyle.danger(
                                                        kitRadius: 6.0),
                                                icon: const Icon(
                                                    Icons
                                                        .delete_forever_rounded,
                                                    size: 26.0),
                                              ),
                                            ])
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ]),
        ));
  }
}