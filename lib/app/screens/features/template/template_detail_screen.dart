import 'dart:convert';
import 'package:dotted_border/dotted_border.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core_v3/app/library/extensions/extensions.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_quill/flutter_quill.dart' as flutter_quill;
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/components/actions/common_buttons/CoreButtonStyle.dart';
import '../../../../core/components/actions/common_buttons/CoreElevatedButton.dart';
import '../../../../core/components/containment/dialogs/CoreFullScreenDialog.dart';
import '../../../../core/components/helper_widgets/CoreHelperWidget.dart';
import '../../../../core/components/notifications/CoreNotification.dart';
import '../../../library/enums/CommonEnums.dart';
import '../../setting/providers/setting_notifier.dart';
import '../label/models/label_model.dart';
import '../subjects/models/subject_condition_model.dart';
import '../subjects/models/subject_model.dart';
import '../subjects/widgets/subject_list_screen.dart';
import 'databases/note_db_manager.dart';
import 'models/note_model.dart';
import 'note_create_screen.dart';
import 'note_list_screen.dart';
import 'providers/note_notifier.dart';

class NoteDetailScreen extends StatefulWidget {
  final NoteModel note;
  final List<LabelModel>? labels;
  final SubjectModel? subject;

  const NoteDetailScreen({
    super.key,
    required this.note,
    required this.subject,
    required this.labels,
  });

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  /*
  Editor parameters
   */
  final flutter_quill.QuillController _titleQuillController =
      flutter_quill.QuillController.basic();

  final flutter_quill.QuillController _descriptionQuillController =
      flutter_quill.QuillController.basic();

  final flutter_quill.QuillController _subDescriptionQuillController =
      flutter_quill.QuillController.basic();

  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  _onUpdate() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NoteCreateScreen(
                  note: widget.note,
                  subject: null,
                  actionMode: ActionModeEnum.update,
                )));
  }

  Future<bool> _onDeleteNote(BuildContext context) async {
    return await NoteDatabaseManager.delete(
        widget.note, DateTime.now().millisecondsSinceEpoch);
  }

  Future<bool> _onDeleteNoteForever(BuildContext context) async {
    return await NoteDatabaseManager.deleteForever(widget.note);
  }

  Future<bool> _onRestoreNoteFromTrash(BuildContext context) async {
    return await NoteDatabaseManager.restoreFromTrash(
        widget.note, DateTime.now().millisecondsSinceEpoch);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.note.title.isNotEmpty) {
      /// Set data for input
      List<dynamic> deltaMap = jsonDecode(widget.note.title);

      flutter_quill.Delta delta = flutter_quill.Delta.fromJson(deltaMap);

      setState(() {
        _titleQuillController.document =
            flutter_quill.Document.fromDelta(delta);
      });

      /// Set selection
    }

    if (widget.note.description.isNotEmpty) {
      /// Set data for input
      List<dynamic> deltaMap = jsonDecode(widget.note.description);

      flutter_quill.Delta delta = flutter_quill.Delta.fromJson(deltaMap);

      setState(() {
        _descriptionQuillController.document =
            flutter_quill.Document.fromDelta(delta);
      });

      if (_descriptionQuillController.document.toString().isNotEmpty) {
        List<dynamic> deltaMap = jsonDecode(widget.note.description);

        flutter_quill.Delta delta = flutter_quill.Delta.fromJson(deltaMap);
        setState(() {
          _subDescriptionQuillController.document =
              flutter_quill.Document.fromDelta(delta);
        });
      } else {
        // Xử lý khi Document empty
        print('Document empty.');
      }
    }
  }

  setDocuments() {
    if (widget.note.title.isNotEmpty) {
      /// Set data for input
      List<dynamic> deltaMap = jsonDecode(widget.note.title);

      flutter_quill.Delta delta = flutter_quill.Delta.fromJson(deltaMap);

      setState(() {
        _titleQuillController.document =
            flutter_quill.Document.fromDelta(delta);
      });

      /// Set selection
    }

    if (widget.note.description.isNotEmpty) {
      /// Set data for input
      List<dynamic> deltaMap = jsonDecode(widget.note.description);

      flutter_quill.Delta delta = flutter_quill.Delta.fromJson(deltaMap);

      setState(() {
        _descriptionQuillController.document =
            flutter_quill.Document.fromDelta(delta);
      });

      if (_descriptionQuillController.document.toString().isNotEmpty) {
        List<dynamic> deltaMap = jsonDecode(widget.note.description);

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

  String getTimeString(int time) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(time);

    int year = dateTime.year;
    int month = dateTime.month;
    int day = dateTime.day;
    int hour = dateTime.hour;
    int minute = dateTime.minute;

    return '$hour:$minute $day/$month/$year';
  }

  Widget _onGetTitle() {
    String defaultTitle =
        'You wrote at ${getTimeString(widget.note.createdAt!)}';
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text(defaultTitle),
    );
  }

  bool checkTitleEmpty() {
    List<dynamic> deltaMap = jsonDecode(widget.note.title);

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
                ),
              ),
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
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubject() {
    return widget.subject != null
        ? Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                child: InkWell(
                  borderRadius: BorderRadius.circular(12.0),
                  onTap: () {
                    SubjectConditionModel subjectConditionModel =
                        SubjectConditionModel();
                    subjectConditionModel.id = widget.subject!.id;
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SubjectListScreen(
                                subjectConditionModel: subjectConditionModel)),
                        (route) => false);
                  },
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
                          children: [
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
                                            color:
                                                widget.subject?.color.toColor(),
                                          ),
                                          const SizedBox(width: 6.0),
                                          Flexible(
                                            child: Text(widget.subject!.title,
                                                maxLines: 1,
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
              ),
            ],
          )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    final settingNotifier = Provider.of<SettingNotifier>(context);

    setDocuments();
    return CoreFullScreenDialog(
      title: 'Detail',
      actions: AppBarActionButtonEnum.home,
      isConfirmToClose: false,
      homeLabel: 'Notes',
      onGoHome: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => const NoteListScreen(
                    noteConditionModel: null,
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
        child: ListView(
          children: <Widget>[
            Slidable(
              key: const ValueKey(0),
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  widget.note.deletedAt == null
                      ? SlidableAction(
                          flex: 1,
                          onPressed: (context) {
                            // _onDelete();
                            _onDeleteNote(context).then((result) {
                              if (result) {
                                Provider.of<NoteNotifier>(context,
                                        listen: false)
                                    .onCountAll();

                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const NoteListScreen(
                                              noteConditionModel: null)),
                                  (route) => false,
                                );

                                CoreNotification.show(
                                    context,
                                    CoreNotificationStatus.success,
                                    CoreNotificationAction.delete,
                                    'Note');
                              } else {
                                CoreNotification.show(
                                    context,
                                    CoreNotificationStatus.error,
                                    CoreNotificationAction.delete,
                                    'Note');
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
                  initialExpanded: true,
                  child: Column(
                    children: [
                      widget.note.updatedAt == null &&
                              widget.note.deletedAt == null
                          ? Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 5.0, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    getTimeString(widget.note.createdAt!),
                                    style: const TextStyle(
                                        fontSize: 13.0, color: Colors.white54),
                                  ),
                                  const SizedBox(width: 4.0),
                                  widget.note.isFavourite != null
                                      ? const Icon(Icons.favorite,
                                          color: Color(0xffdc3545), size: 26.0)
                                      : Container(),
                                ],
                              ),
                            )
                          : Container(),
                      widget.note.updatedAt != null &&
                              widget.note.deletedAt == null
                          ? Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 5.0, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Icon(Icons.edit,
                                      size: 13.0, color: Colors.white54),
                                  const SizedBox(width: 5.0),
                                  Text(getTimeString(widget.note.updatedAt!),
                                      style: const TextStyle(
                                          fontSize: 13.0,
                                          color: Colors.white54)),
                                  const SizedBox(width: 4.0),
                                  widget.note.isFavourite != null
                                      ? const Icon(Icons.favorite,
                                          color: Color(0xffdc3545), size: 26.0)
                                      : Container(),
                                ],
                              ),
                            )
                          : Container(),
                      widget.note.deletedAt != null
                          ? Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 5.0, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Icon(Icons.delete_rounded,
                                      size: 13.0, color: Colors.white54),
                                  const SizedBox(width: 5.0),
                                  Text(getTimeString(widget.note.deletedAt!),
                                      style: const TextStyle(
                                          fontSize: 13.0,
                                          color: Colors.white54)),
                                  const SizedBox(width: 4.0),
                                  widget.note.isFavourite != null
                                      ? const Icon(Icons.favorite,
                                          color: Color(0xffdc3545), size: 26.0)
                                      : Container(),
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
                                decoration: BoxDecoration(
                                  color: widget.subject != null &&
                                          settingNotifier
                                              .isSetColorAccordingSubjectColor!
                                      ? widget.subject!.color.toColor()
                                      : Colors.lightGreen,
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
                                              ? flutter_quill.QuillEditor(
                                                  controller:
                                                      _titleQuillController,
                                                  readOnly:
                                                      true, // true for view only mode
                                                  autoFocus: false,
                                                  expands: false,
                                                  focusNode: _focusNode,
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          10.0,
                                                          10.0,
                                                          10.0,
                                                          10.0),
                                                  scrollController:
                                                      _scrollController,
                                                  scrollable: false,
                                                  showCursor: false)
                                              : _onGetTitle()),
                                      widget.note.deletedAt == null
                                          ? Tooltip(
                                              message: 'Update',
                                              child:
                                                  CoreElevatedButton.iconOnly(
                                                onPressed: () {
                                                  _onUpdate();
                                                },
                                                coreButtonStyle:
                                                    CoreButtonStyle.dark(
                                                        kitRadius: 6.0),
                                                icon: const Icon(
                                                    Icons.edit_note_rounded,
                                                    size: 26.0),
                                              ),
                                            )
                                          : Column(
                                              children: [
                                                Tooltip(
                                                  message: 'Restore',
                                                  child: CoreElevatedButton
                                                      .iconOnly(
                                                    onPressed: () {
                                                      _onRestoreNoteFromTrash(
                                                              context)
                                                          .then((result) {
                                                        if (result) {
                                                          Provider.of<NoteNotifier>(
                                                                  context,
                                                                  listen: false)
                                                              .onCountAll();

                                                          Navigator
                                                              .pushAndRemoveUntil(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    const NoteListScreen(
                                                                        noteConditionModel:
                                                                            null)),
                                                            (route) => false,
                                                          );

                                                          CoreNotification.show(
                                                              context,
                                                              CoreNotificationStatus
                                                                  .success,
                                                              CoreNotificationAction
                                                                  .restore,
                                                              'Note');
                                                        } else {
                                                          CoreNotification.show(
                                                              context,
                                                              CoreNotificationStatus
                                                                  .error,
                                                              CoreNotificationAction
                                                                  .restore,
                                                              'Note');
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
                                                ),
                                                const SizedBox(height: 2.0),
                                                Tooltip(
                                                  message: 'Delete forever',
                                                  child: CoreElevatedButton
                                                      .iconOnly(
                                                    onPressed: () async {
                                                      if (await CoreHelperWidget
                                                          .confirmFunction(
                                                              context)) {
                                                        _onDeleteNoteForever(
                                                                context)
                                                            .then((result) {
                                                          if (result) {
                                                            Provider.of<NoteNotifier>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .onCountAll();

                                                            Navigator
                                                                .pushAndRemoveUntil(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      const NoteListScreen(
                                                                          noteConditionModel:
                                                                              null)),
                                                              (route) => false,
                                                            );

                                                            CoreNotification.show(
                                                                context,
                                                                CoreNotificationStatus
                                                                    .success,
                                                                CoreNotificationAction
                                                                    .delete,
                                                                'Note');
                                                          } else {
                                                            CoreNotification.show(
                                                                context,
                                                                CoreNotificationStatus
                                                                    .error,
                                                                CoreNotificationAction
                                                                    .delete,
                                                                'Note');
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
                                                ),
                                              ],
                                            )
                                    ],
                                  ),
                                ),
                              ),
                            ),
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
                                      Text(
                                        "[${widget.note.id!}] ",
                                        style: const TextStyle(
                                            fontSize: 13.0,
                                            color: Colors.black45),
                                      ),
                                      const Text(
                                        "Content",
                                        style: TextStyle(
                                            fontSize: 13.0,
                                            color: Colors.black45),
                                      ),
                                    ],
                                  ),
                                ),
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
                                            padding: const EdgeInsets.all(4.0),
                                            scrollController: _scrollController,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    flutter_quill.QuillEditor(
                                        controller: _descriptionQuillController,
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
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
