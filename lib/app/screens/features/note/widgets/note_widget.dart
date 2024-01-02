import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as flutter_quill;
import '../../../../../core/components/actions/common_buttons/CoreButtonStyle.dart';
import '../../../../../core/components/actions/common_buttons/CoreElevatedButton.dart';
import '../models/note_model.dart';

class NoteWidget extends StatefulWidget {
  final NoteModel note;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  const NoteWidget(
      {Key? key,
      required this.note,
      required this.onTap,
      required this.onLongPress})
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

  @override
  Widget build(BuildContext context) {
    setDocuments();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
      child: ExpandableNotifier(
          child: Padding(
        padding: const EdgeInsets.all(10),
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
                              ),
                              CoreElevatedButton(
                                onPressed: () {
                                  widget.onTap();
                                },
                                coreButtonStyle: CoreButtonStyle.options(
                                    coreStyle: CoreStyle.outlined,
                                    coreColor: CoreColor.success,
                                    coreRadius: CoreRadius.radius_6,
                                    kitForegroundColorOption: Colors.black,
                                    coreFixedSizeButton:
                                        CoreFixedSizeButton.medium_40),
                                child: const Text('Edit'),
                              ),
                            ]),
                      ),
                    ),
                  ),
                  ScrollOnExpand(
                    scrollOnExpand: true,
                    scrollOnCollapse: false,
                    child: ExpandablePanel(
                      theme: const ExpandableThemeData(
                        headerAlignment: ExpandablePanelHeaderAlignment.center,
                        tapBodyToCollapse: true,
                      ),
                      header: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "Content",
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
        ),
      )),
      // child: NoteCard(note: widget.note),
    );
  }
}
