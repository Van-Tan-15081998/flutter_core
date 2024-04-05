import 'dart:convert';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_core_v3/app/library/extensions/extensions.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as flutter_quill;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../../../core/components/actions/common_buttons/CoreButtonStyle.dart';
import '../../../../../core/components/actions/common_buttons/CoreElevatedButton.dart';
import '../../label/models/label_model.dart';
import '../../subjects/models/subject_condition_model.dart';
import '../../subjects/models/subject_model.dart';
import '../../subjects/widgets/subject_list_screen.dart';
import '../models/note_model.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

import '../note_detail_screen.dart';

class NoteWidget extends StatefulWidget {
  final NoteModel note;
  final List<LabelModel>? labels;
  final SubjectModel? subject;
  final VoidCallback onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onDeleteForever;
  final VoidCallback? onRestoreFromTrash;
  const NoteWidget(
      {Key? key,
      required this.note,
      required this.subject,
      required this.labels,
      required this.onTap,
      required this.onDelete,
      required this.onDeleteForever,
      required this.onRestoreFromTrash})
      : super(key: key);

  @override
  State<NoteWidget> createState() => _NoteWidgetState();
}

class _NoteWidgetState extends State<NoteWidget> {
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

    if (widget.note.title.isNotEmpty) {
      /// Set data for input
      List<dynamic> deltaMap = jsonDecode(widget.note.title);

      flutter_quill.Delta delta = flutter_quill.Delta.fromJson(deltaMap);

      setState(() {
        _titleQuillController.document =
            flutter_quill.Document.fromDelta(delta);
      });
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

    return DateFormat('HH:mm  dd/MM/yyyy').format(dateTime);
  }

  Widget onGetTitle() {
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
                      builder: (context) =>
                          NoteDetailScreen(
                              note: widget.note,
                              labels: widget.labels,
                              subject: widget.subject
                          )));
            },
            backgroundColor: const Color(0xFF202124),
            foregroundColor: const Color(0xFF7BC043),
            icon: Icons.remove_red_eye_rounded,
            label: 'View',
          ),
          widget.note.deletedAt == null
              ? SlidableAction(
                  flex: 1,
                  onPressed: (context) {
                    if (widget.onDelete != null) {
                      widget.onDelete!();
                    }
                  },
                  backgroundColor: const Color(0xFF202124),
                  foregroundColor: const Color(0xffdc3545),
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
            widget.note.updatedAt == null && widget.note.deletedAt == null
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 5.0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(getTimeString(widget.note.createdAt!),
                            style: const TextStyle(
                                fontSize: 13.0, color: Colors.white54)),
                      ],
                    ),
                  )
                : Container(),
            widget.note.updatedAt != null && widget.note.deletedAt == null
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
                                fontSize: 13.0, color: Colors.white54))
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
                                fontSize: 13.0, color: Colors.white54))
                      ],
                    ),
                  )
                : Container(),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(5.0), // Đây là giá trị bo góc ở đây
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    // height: 150,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.lightGreen,
                        shape: BoxShape.rectangle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width - 115.0,
                                  child: checkTitleEmpty()
                                      ? flutter_quill.QuillEditor(
                                          controller: _titleQuillController,
                                          readOnly:
                                              true, // true for view only mode
                                          autoFocus: false,
                                          expands: false,
                                          focusNode: _focusNode,
                                          padding: const EdgeInsets.fromLTRB(
                                              10.0, 10.0, 10.0, 10.0),
                                          scrollController: _scrollController,
                                          scrollable: false,
                                          showCursor: false)
                                      : onGetTitle()),
                              widget.note.deletedAt == null
                                  ? CoreElevatedButton.iconOnly(
                                      onPressed: () {
                                        widget.onTap();
                                      },
                                      coreButtonStyle:
                                          CoreButtonStyle.dark(kitRadius: 6.0),
                                      icon: const Icon(Icons.edit_note_rounded,
                                          size: 26.0),
                                    )
                                  : Column(children: [
                                      CoreElevatedButton.iconOnly(
                                        onPressed: () {
                                          if (widget.onRestoreFromTrash !=
                                              null) {
                                            widget.onRestoreFromTrash!();
                                          }
                                        },
                                        coreButtonStyle: CoreButtonStyle.info(
                                            kitRadius: 6.0),
                                        icon: const Icon(
                                            Icons.restore_from_trash_rounded,
                                            size: 26.0),
                                      ),
                                      const SizedBox(height: 2.0),
                                      CoreElevatedButton.iconOnly(
                                        onPressed: () {
                                          if (widget.onDeleteForever != null) {
                                            widget.onDeleteForever!();
                                          }
                                        },
                                        coreButtonStyle: CoreButtonStyle.danger(
                                            kitRadius: 6.0),
                                        icon: const Icon(
                                            Icons.delete_forever_rounded,
                                            size: 26.0),
                                      ),
                                    ])
                            ]),
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
                        headerAlignment: ExpandablePanelHeaderAlignment.center,
                        tapBodyToCollapse: true,
                      ),
                      header: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Text("[${widget.note.id!}] ",
                                  style: const TextStyle(
                                      fontSize: 13.0, color: Colors.black45)),
                              const Text("Content",
                                  style: TextStyle(
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
                                boxShadow: [],
                              ),
                              child: flutter_quill.QuillEditor(
                                  controller: _subDescriptionQuillController,
                                  readOnly: true, // true for view only mode
                                  autoFocus: false,
                                  expands: false,
                                  focusNode: _focusNode,
                                  padding: const EdgeInsets.all(10.0),
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
                              padding: const EdgeInsets.all(10.0),
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
                            theme: const ExpandableThemeData(crossFadePoint: 0),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }
}
