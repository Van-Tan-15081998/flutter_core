import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_core_v3/app/library/common/themes/ThemeDataCenter.dart';
import 'package:flutter_core_v3/app/library/extensions/extensions.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../../../core/components/actions/common_buttons/CoreElevatedButton.dart';
import '../../../../../library/common/converters/CommonConverters.dart';
import '../../../../../library/common/styles/CommonStyles.dart';
import '../../../../../library/enums/CommonEnums.dart';
import '../../../../setting/providers/setting_notifier.dart';
import '../../../note/models/note_condition_model.dart';
import '../../../note/note_create_screen.dart';
import '../../../note/note_list_screen.dart';
import '../../databases/subject_db_manager.dart';
import '../../models/subject_model.dart';
import '../subject_create_screen.dart';
import '../subject_detail_folder_item.dart';
import '../subject_detail_screen.dart';

class SubjectWidgetFolderItem extends StatefulWidget {
  final int? index;
  final SubjectModel subject;
  final bool? isSubSubject;
  final VoidCallback? onUpdate;
  final VoidCallback? onDelete;
  final VoidCallback? onDeleteForever;
  final VoidCallback? onRestoreFromTrash;
  final VoidCallback? onFilterChildrenOnly;
  final VoidCallback? onFilterParent;
  const SubjectWidgetFolderItem(
      {Key? key,
      required this.index,
      required this.subject,
      required this.isSubSubject,
      required this.onUpdate,
      required this.onDelete,
      required this.onDeleteForever,
      required this.onRestoreFromTrash,
      required this.onFilterChildrenOnly,
      required this.onFilterParent})
      : super(key: key);

  @override
  State<SubjectWidgetFolderItem> createState() =>
      _SubjectWidgetFolderItemState();
}

class _SubjectWidgetFolderItemState extends State<SubjectWidgetFolderItem> {
  late int countChildren;
  late int countNotes;

  bool expandedActions = false;
  bool alreadySetExpandedActions = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<int> _onCountChildren() async {
    return await SubjectDatabaseManager.countChildren(widget.subject);
  }

  Future<int> _onCountNotes() async {
    return await SubjectDatabaseManager.countNotes(widget.subject);
  }

  @override
  Widget build(BuildContext context) {
    final settingNotifier = Provider.of<SettingNotifier>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IconButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
            ),
          ),
          backgroundColor:
              MaterialStateProperty.all<Color?>(Colors.white.withOpacity(0.65)),
        ),
        onPressed: () {
          if (widget.onFilterChildrenOnly != null) {
            widget.onFilterChildrenOnly!();
          }
        },
        icon: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.folder_rounded,
                    size: 90, color: widget.subject.color.toColor()),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 2.0, 2.0, 0),
                  child: PopupMenuButton<ActionSubjectFolderItemEnum>(
                    icon: const Icon(
                      Icons.more_vert_rounded,
                      size: 20,
                    ),
                    onSelected: (ActionSubjectFolderItemEnum action) {
                      if (action == ActionSubjectFolderItemEnum.update) {
                      } else if (action ==
                          ActionSubjectFolderItemEnum.delete) {}
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<ActionSubjectFolderItemEnum>>[
                      const PopupMenuItem<ActionSubjectFolderItemEnum>(
                        value: ActionSubjectFolderItemEnum.update,
                        child: ListTile(
                          leading: FaIcon(FontAwesomeIcons.pen),
                          title: Text('Update', style: TextStyle(fontSize: 14)),
                        ),
                      ),
                      const PopupMenuItem<ActionSubjectFolderItemEnum>(
                        value: ActionSubjectFolderItemEnum.delete,
                        child: ListTile(
                          leading: FaIcon(FontAwesomeIcons.trash),
                          title: Text('Delete', style: TextStyle(fontSize: 14)),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
              child: Row(
                children: [
                  Flexible(
                      child: Tooltip(
                          message: widget.subject.title,
                          child: Text(
                            widget.subject.title,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                                fontSize: 15.0, fontWeight: FontWeight.w500),
                          ))),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Tooltip(
                  message: 'Created time',
                  child: Container(
                    padding: settingNotifier.isSetBackgroundImage == true
                        ? const EdgeInsets.all(2.0)
                        : const EdgeInsets.all(0),
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(6.0)),
                        color: settingNotifier.isSetBackgroundImage == true
                            ? Colors.white.withOpacity(0.65)
                            : Colors.transparent),
                    child: Row(
                      children: [
                        Text(
                            CommonConverters.toTimeString(
                                time: widget.subject.createdAt!),
                            style: CommonStyles.dateTimeTextStyle(
                                fontSize: 9.0,
                                color: ThemeDataCenter.getTopCardLabelStyle(
                                    context)), overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// widget.subject.deletedAt == null &&
// expandedActions
// ? FadeInRight(
// duration:
// const Duration(milliseconds: 200),
// child: Padding(
// padding: const EdgeInsets.fromLTRB(
// 4.0, 0, 0, 0),
// child: Column(
// children: [
// Tooltip(
// message: 'Update',
// child: CoreElevatedButton
//     .iconOnly(
// onPressed: () {
// Navigator.push(
// context,
// MaterialPageRoute(
// builder: (context) =>
// SubjectCreateScreen(
// parentSubject:
// null,
// actionMode:
// ActionModeEnum
//     .update,
// subject: widget
//     .subject,
// redirectFromEnum:
// null,
// )));
// },
// coreButtonStyle:
// ThemeDataCenter
//     .getUpdateButtonStyle(
// context),
// icon: const Icon(Icons
//     .edit_note_rounded),
// ),
// ),
// Tooltip(
// message: 'Create sub subject',
// child: CoreElevatedButton
//     .iconOnly(
// onPressed: () {
// Navigator.push(
// context,
// MaterialPageRoute(
// builder: (context) =>
// SubjectCreateScreen(
// parentSubject:
// widget
//     .subject,
// actionMode:
// ActionModeEnum
//     .create,
// redirectFromEnum:
// null,
// )));
// },
// coreButtonStyle: ThemeDataCenter
//     .getCreateSubSubjectButtonStyle(
// context),
// icon: const Icon(Icons
//     .create_new_folder_rounded),
// ),
// ),
// Tooltip(
// message: 'Notes',
// child: CoreElevatedButton
//     .iconOnly(
// onPressed: () {
// NoteConditionModel
// noteConditionModel =
// NoteConditionModel();
// noteConditionModel
//     .subjectId =
// widget.subject.id;
// Navigator.push(
// context,
// MaterialPageRoute(
// builder: (context) =>
// NoteListScreen(
// noteConditionModel:
// noteConditionModel,
// isOpenSubjectsForFilter:
// true,
// redirectFrom:
// RedirectFromEnum
//     .subjects,
// )));
// },
// coreButtonStyle: ThemeDataCenter
//     .getViewNotesButtonStyle(
// context),
// icon: const Icon(Icons
//     .playlist_play_rounded),
// ),
// ),
// Tooltip(
// message: 'Create note',
// child: CoreElevatedButton
//     .iconOnly(
// onPressed: () {
// Navigator.push(
// context,
// MaterialPageRoute(
// builder: (context) =>
// NoteCreateScreen(
// note: null,
// copyNote:
// null,
// subject: widget
//     .subject,
// actionMode:
// ActionModeEnum
//     .create,
// redirectFrom:
// RedirectFromEnum
//     .subjectCreateNote,
// )));
// },
// coreButtonStyle: ThemeDataCenter
//     .getCreateNoteButtonStyle(
// context),
// icon: const Icon(
// Icons.add_card_rounded),
// ),
// ),
// Tooltip(
// message: 'Parent subject',
// child: CoreElevatedButton
//     .iconOnly(
// onPressed: () {
// if (widget
//     .onFilterParent !=
// null) {
// widget
//     .onFilterParent!();
// }
// },
// coreButtonStyle: ThemeDataCenter
//     .getFilterParentSubjectButtonStyle(
// context),
// icon: const Icon(Icons
//     .arrow_upward_rounded),
// ),
// ),
// Tooltip(
// message: 'Sub subjects',
// child: CoreElevatedButton
//     .iconOnly(
// onPressed: () {
// if (widget
//     .onFilterChildren !=
// null) {
// widget
//     .onFilterChildren!();
// }
// },
// coreButtonStyle: ThemeDataCenter
//     .getFilterSubSubjectButtonStyle(
// context),
// icon: const Icon(Icons
//     .arrow_downward_rounded),
// ),
// ),
// ],
// ),
// ),
// )
//     : Container(),
// widget.subject.deletedAt != null
// ? Padding(
// padding: const EdgeInsets.fromLTRB(
// 4.0, 0, 0, 0),
// child: Column(children: [
// Tooltip(
// message: 'Restore',
// child:
// CoreElevatedButton.iconOnly(
// onPressed: () {
// if (widget
//     .onRestoreFromTrash !=
// null) {
// widget
//     .onRestoreFromTrash!();
// }
// },
// coreButtonStyle: ThemeDataCenter
//     .getRestoreButtonStyle(
// context),
// icon: const Icon(
// Icons
//     .restore_from_trash_rounded,
// size: 26.0),
// ),
// ),
// const SizedBox(height: 2.0),
// Tooltip(
// message: 'Delete forever',
// child:
// CoreElevatedButton.iconOnly(
// onPressed: () {
// if (widget.onDeleteForever !=
// null) {
// widget.onDeleteForever!();
// }
// },
// coreButtonStyle: ThemeDataCenter
//     .getDeleteForeverButtonStyle(
// context),
// icon: const Icon(
// Icons
//     .delete_forever_rounded,
// size: 26.0),
// ),
// ),
// ]),
