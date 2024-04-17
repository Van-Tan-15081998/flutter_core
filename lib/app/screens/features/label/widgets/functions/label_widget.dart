import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_core_v3/app/library/extensions/extensions.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/components/actions/common_buttons/CoreButtonStyle.dart';
import '../../../../../../core/components/actions/common_buttons/CoreElevatedButton.dart';
import '../../../../../library/enums/CommonEnums.dart';
import '../../models/label_model.dart';
import '../label_create_screen.dart';
import '../label_detail_screen.dart';

class LabelWidget extends StatefulWidget {
  final LabelModel label;
  final VoidCallback? onUpdate;
  final VoidCallback? onDelete;
  final VoidCallback? onDeleteForever;
  final VoidCallback? onRestoreFromTrash;
  const LabelWidget({
    Key? key,
    required this.label,
    required this.onUpdate,
    required this.onDelete,
    required this.onDeleteForever,
    required this.onRestoreFromTrash,
  }) : super(key: key);

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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          LabelDetailScreen(label: widget.label)));
            },
            backgroundColor: const Color(0xFF202124),
            foregroundColor: const Color(0xff17a2b8),
            icon: Icons.remove_red_eye_rounded,
            label: 'View',
          ),
          widget.label.deletedAt == null
              ? SlidableAction(
                  flex: 1,
                  onPressed: (context) {
                    if (widget.onDelete != null) {
                      widget.onDelete!();
                    }
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
            widget.label.updatedAt == null && widget.label.deletedAt == null
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 5.0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(getTimeString(widget.label.createdAt!),
                            style: const TextStyle(
                              fontSize: 13.0,
                              color: Colors.white54,
                            )),
                      ],
                    ),
                  )
                : Container(),
            widget.label.updatedAt != null && widget.label.deletedAt == null
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 5.0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Icon(Icons.edit,
                            size: 13.0, color: Colors.white54),
                        const SizedBox(width: 5.0),
                        Text(getTimeString(widget.label.updatedAt!),
                            style: const TextStyle(
                                fontSize: 13.0, color: Colors.white54))
                      ],
                    ),
                  )
                : Container(),
            widget.label.deletedAt != null
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 5.0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Icon(Icons.delete_rounded,
                            size: 13.0, color: Colors.white54),
                        const SizedBox(width: 5.0),
                        Text(getTimeString(widget.label.deletedAt!),
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
                        color: Colors.white,
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
                                              padding:
                                                  const EdgeInsets.all(6.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                      Icons
                                                          .label_important_rounded,
                                                      color: widget.label.color
                                                          .toColor()),
                                                  const SizedBox(width: 6.0),
                                                  Flexible(
                                                    child: Text(
                                                        widget.label.title),
                                                  ),
                                                ],
                                              ),
                                            )),
                                      )),
                                ),
                              ),
                              widget.label.deletedAt == null
                                  ? Tooltip(
                                      message: 'Update',
                                      child: CoreElevatedButton.iconOnly(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      LabelCreateScreen(
                                                        actionMode:
                                                            ActionModeEnum
                                                                .update,
                                                        label: widget.label,
                                                      )));
                                        },
                                        coreButtonStyle: CoreButtonStyle.dark(
                                            kitRadius: 6.0),
                                        icon:
                                            const Icon(Icons.edit_note_rounded),
                                      ),
                                    )
                                  : Column(children: [
                                      Tooltip(
                                        message: 'Restore',
                                        child: CoreElevatedButton.iconOnly(
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
                                      ),
                                      const SizedBox(height: 2.0),
                                      Tooltip(
                                        message: 'Delete forever',
                                        child: CoreElevatedButton.iconOnly(
                                          onPressed: () {
                                            if (widget.onDeleteForever !=
                                                null) {
                                              widget.onDeleteForever!();
                                            }
                                          },
                                          coreButtonStyle:
                                              CoreButtonStyle.danger(
                                                  kitRadius: 6.0),
                                          icon: const Icon(
                                              Icons.delete_forever_rounded,
                                              size: 26.0),
                                        ),
                                      ),
                                    ])
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
