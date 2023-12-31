import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as flutter_quill;
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
      _titleQuillController.document = flutter_quill.Document.fromDelta(delta);

      /// Set selection
    }

    if (widget.note.description.isNotEmpty) {
      /// Set data for input
      List<dynamic> deltaMap = jsonDecode(widget.note.description);

      flutter_quill.Delta delta = flutter_quill.Delta.fromJson(deltaMap);
      _descriptionQuillController.document =
          flutter_quill.Document.fromDelta(delta);

      if (_descriptionQuillController.document.toString().isNotEmpty) {
        List<dynamic> deltaMap = jsonDecode(widget.note.description);

        flutter_quill.Delta delta = flutter_quill.Delta.fromJson(deltaMap);
        _subDescriptionQuillController.document =
            flutter_quill.Document.fromDelta(delta);
      } else {
        // Xử lý khi Document rỗng
        print('Document rỗng.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: widget.onLongPress,
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 6),
        child: ExpandableNotifier(
            child: Padding(
          padding: const EdgeInsets.all(10),
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: <Widget>[
                SizedBox(
                  // height: 150,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.rectangle,
                    ),
                    child: flutter_quill.QuillEditor(
                      controller: _titleQuillController,
                      readOnly: true, // true for view only mode
                        autoFocus: false,
                        expands: false,
                        focusNode: _focusNode,
                        padding: const EdgeInsets.all(10.0),
                        scrollController: _scrollController,
                        scrollable: false,
                        showCursor: false
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
                                  showCursor: false
                              ),
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
        )),
        // child: NoteCard(note: widget.note),
      ),
    );
  }
}
