import 'package:flutter_core_v3/app/library/extensions/extensions.dart';
import 'package:flutter/material.dart';
import '../../models/subject_model.dart';

class SubjectShortcutWidget extends StatefulWidget {
  final int? index;
  final SubjectModel subject;
  final VoidCallback? onGoToDestination;
  final VoidCallback? onDeleteShortcut;

  const SubjectShortcutWidget(
      {Key? key,
      required this.index,
      required this.subject,
      required this.onGoToDestination,
      required this.onDeleteShortcut})
      : super(key: key);

  @override
  State<SubjectShortcutWidget> createState() => _SubjectShortcutWidgetState();
}

class _SubjectShortcutWidgetState extends State<SubjectShortcutWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Row(
            children: [
              Icon(Icons.folder_rounded,
                  size: 30.0, color: widget.subject.color.toColor()),
              const SizedBox(width: 5.0),
              Expanded(
                  child: Row(
                children: [
                  Flexible(
                    child: Text(
                      widget.subject.title,
                      style: const TextStyle(
                          color: Color(0xFF1f1f1f),
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              )),
              Row(
                children: [
                  InkWell(
                    highlightColor: Colors.black45,
                    onLongPress: () {
                      if (widget.onDeleteShortcut != null) {
                        widget.onDeleteShortcut!();
                      }
                    },
                    borderRadius: BorderRadius.circular(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black45,
                            width: 1.0,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10.0)),
                          color: Colors.white.withOpacity(0.65)),
                      child: const Padding(
                        padding: EdgeInsets.all(6.0),
                        child: Icon(
                          Icons.delete,
                          size: 22,
                          color: Colors.orangeAccent,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5.0),
                  InkWell(
                    highlightColor: Colors.black45,
                    onTap: () {
                      if (widget.onGoToDestination != null) {
                        widget.onGoToDestination!();
                      }
                    },
                    borderRadius: BorderRadius.circular(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black45,
                            width: 1.0,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10.0)),
                          color: Colors.white.withOpacity(0.65)),
                      child: const Padding(
                        padding: EdgeInsets.fromLTRB(15.0, 6.0, 15.0, 6.0),
                        child: Icon(
                          Icons.shortcut_rounded,
                          size: 22,
                          color: Colors.lightBlue,
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
