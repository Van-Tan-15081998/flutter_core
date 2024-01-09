import 'dart:convert';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:flutter_quill/flutter_quill.dart' as flutter_quill;
import '../../../../core/components/actions/common_buttons/CoreButtonStyle.dart';
import '../../../../core/components/actions/common_buttons/CoreElevatedButton.dart';
import '../../../../core/components/containment/dialogs/CoreFullScreenDialog.dart';
import '../../../library/enums/CommonEnums.dart';
import 'models/note_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'note_add_screen.dart';
import 'note_list_screen.dart';
import 'widgets/note_widget.dart';

class NoteDetailScreen extends StatefulWidget {
  final NoteModel note;

  const NoteDetailScreen({
    super.key,
    required this.note,
  });

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
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

  @override
  Widget build(BuildContext context) {
    setDocuments();
    return CoreFullScreenDialog(
      title: 'Detail note',
      actions: AppBarActionButtonEnum.home,
      isConfirmToClose: false,
      onSubmit: () async {},
      onRedo: () {},
      onUndo: () {},
      onBack: () {},
      isShowGeneralActionButton: true,
      isShowOptionActionButton: true,
      optionActionContent: Container(),
      bottomActionBar: const [Row()],
      bottomActionBarScrollable: const [Row()],
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: ListView(
          // mainAxisSize: MainAxisSize.max,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Text(widget.note.title),
            // Text(widget.note.description),
            Slidable(
              key: const ValueKey(0),
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    flex: 1,
                    onPressed: (context) {
                      Get.offAll(NoteDetailScreen(note: widget.note));
                    },
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF7BC043),
                    icon: Icons.remove_red_eye_rounded,
                    label: 'View',
                  ),
                  SlidableAction(
                    flex: 1,
                    onPressed: (context) {},
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xffdc3545),
                    icon: Icons.delete,
                    label: 'Delete',
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
                child: ExpandableNotifier(
                    child: Column(
                  children: [
                    widget.note.updatedAt == null
                        ? Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 5.0, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(getTimeString(widget.note.createdAt!),
                                    style: const TextStyle(
                                        fontSize: 13.0, color: Colors.black45)),
                              ],
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 5.0, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Icon(Icons.edit,
                                    size: 13.0, color: Colors.black45),
                                Text(getTimeString(widget.note.updatedAt!),
                                    style: const TextStyle(
                                        fontSize: 13.0, color: Colors.black45))
                              ],
                            ),
                          ),
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
                                color: Colors.lightGreen,
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
                                              : onGetTitle()),
                                      CoreElevatedButton(
                                        onPressed: () async {
                                          await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => NoteAddScreen(
                                                    note: widget.note,
                                                    actionMode: ActionModeEnum.update,
                                                  )));
                                          setState(() {});
                                        },
                                        coreButtonStyle:
                                            CoreButtonStyle.options(
                                                coreStyle: CoreStyle.outlined,
                                                coreColor: CoreColor.success,
                                                coreRadius: CoreRadius.radius_6,
                                                kitForegroundColorOption:
                                                    Colors.black,
                                                coreFixedSizeButton:
                                                    CoreFixedSizeButton
                                                        .medium_40),
                                        child: const Text('Edit'),
                                      ),
                                    ]),
                              ),
                            ),
                          ),
                          Column(
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
                        ],
                      ),
                    ),
                  ],
                )),
                // child: NoteCard(note: widget.note),
              ),
            )
          ],
        ),
      ),
    );
  }
}
