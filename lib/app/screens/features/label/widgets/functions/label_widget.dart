import 'dart:convert';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_core_v3/app/library/extensions/extensions.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as flutter_quill;

import '../../../../../../core/components/actions/common_buttons/CoreButtonStyle.dart';
import '../../../../../../core/components/actions/common_buttons/CoreElevatedButton.dart';
import '../../../../../library/enums/CommonEnums.dart';
import '../../models/label_model.dart';
import '../label_add_screen.dart';

class LabelWidget extends StatefulWidget {
  final LabelModel label;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  const LabelWidget(
      {Key? key,
      required this.label,
      required this.onTap,
      required this.onLongPress})
      : super(key: key);

  @override
  State<LabelWidget> createState() => _LabelWidgetState();
}

class _LabelWidgetState extends State<LabelWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
        'You wrote at ${getTimeString(widget.label.createdAt!)}';
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text(defaultTitle),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: const ValueKey(0),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            flex: 1,
            onPressed: (context) {
              // Get.offAll(NoteDetailScreen(note: widget.note));
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
            widget.label.updatedAt == null
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 5.0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(getTimeString(widget.label.createdAt!),
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
                        Text(getTimeString(widget.label.updatedAt!),
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
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 6.0),
                                  child: DottedBorder(
                                      borderType: BorderType.RRect,
                                      radius: const Radius.circular(12),
                                      color: widget.label.color.toColor(),
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
                                                      Icons.label_important_rounded,
                                                      color: widget.label.color
                                                          .toColor()),
                                                  Flexible(
                                                    child: Text(widget.label.title,
                                                        maxLines:1,
                                                        overflow: TextOverflow.ellipsis),
                                                  ),
                                                ],
                                              ),
                                            )),
                                      )),
                                ),
                              ),
                              CoreElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LabelAddScreen(
                                                actionMode:
                                                    ActionModeEnum.update,
                                                label: widget.label,
                                              )));
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
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }
}
