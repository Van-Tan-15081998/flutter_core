import 'package:flutter_core_v3/app/library/common/themes/ThemeDataCenter.dart';
import 'package:flutter_core_v3/app/library/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../../../../library/common/converters/CommonConverters.dart';
import '../../../../../library/common/styles/CommonStyles.dart';
import '../../../../../library/enums/CommonEnums.dart';
import '../../../../setting/providers/setting_notifier.dart';
import '../../databases/subject_db_manager.dart';
import '../../models/subject_model.dart';
import '../subject_create_screen.dart';

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
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.folder_rounded,
                      size: 85, color: widget.subject.color.toColor()),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 2.0, 2.0, 0),
                    child: PopupMenuButton<ActionSubjectFolderItemEnum>(
                      icon: const Icon(
                        Icons.more_vert_rounded,
                        size: 20,
                      ),
                      onSelected: (ActionSubjectFolderItemEnum action) {
                        if (action == ActionSubjectFolderItemEnum.update) {
                          if (widget.onUpdate != null) {
                            widget.onUpdate!();
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SubjectCreateScreen(
                                          parentSubject: null,
                                          actionMode: ActionModeEnum.update,
                                          subject: widget.subject,
                                          redirectFrom: RedirectFromEnum
                                              .subjectsInFolderMode,
                                          breadcrumb: null,
                                        )));
                          }
                        } else if (action ==
                            ActionSubjectFolderItemEnum.delete) {
                          if (widget.onDelete != null) {
                            widget.onDelete!();
                          }
                        }
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<ActionSubjectFolderItemEnum>>[
                        const PopupMenuItem<ActionSubjectFolderItemEnum>(
                          value: ActionSubjectFolderItemEnum.update,
                          child: ListTile(
                            leading: FaIcon(FontAwesomeIcons.pen),
                            title:
                                Text('Update', style: TextStyle(fontSize: 14)),
                          ),
                        ),
                        const PopupMenuItem<ActionSubjectFolderItemEnum>(
                          value: ActionSubjectFolderItemEnum.delete,
                          child: ListTile(
                            leading: FaIcon(FontAwesomeIcons.trash),
                            title:
                                Text('Delete', style: TextStyle(fontSize: 14)),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(
                  Icons.snippet_folder_outlined,
                  size: 18.0,
                  color: Colors.black38,
                ),
                const SizedBox(
                  width: 2.0,
                ),
                Text(
                  countChildren.toString(),
                  style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.black45,
                      fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  width: 5.0,
                ),
                const Icon(
                  Icons.note_alt_outlined,
                  size: 16.0,
                  color: Colors.black38,
                ),
                const SizedBox(
                  width: 2.0,
                ),
                Text(
                  countNotes.toString(),
                  style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.black45,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 2.0, 8.0, 2.0),
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
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 2.0),
              child: Row(
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
                                    context)),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
