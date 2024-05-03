import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_core_v3/app/library/extensions/extensions.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/components/actions/common_buttons/CoreElevatedButton.dart';
import '../../../../../library/common/converters/CommonConverters.dart';
import '../../../../../library/common/styles/CommonStyles.dart';
import '../../../../../library/common/themes/ThemeDataCenter.dart';
import '../../../../../library/enums/CommonEnums.dart';
import '../../../../setting/providers/setting_notifier.dart';
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

  @override
  Widget build(BuildContext context) {
    final settingNotifier = Provider.of<SettingNotifier>(context);

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
                      builder: (context) => LabelDetailScreen(
                            label: widget.label,
                            redirectFrom: null,
                          )));
            },
            backgroundColor: settingNotifier.isSetBackgroundImage == true
                ? settingNotifier.isSetBackgroundImage == true
                    ? Colors.white.withOpacity(0.30)
                    : Colors.transparent
                : ThemeDataCenter.getBackgroundColor(context),
            foregroundColor:
                ThemeDataCenter.getViewSlidableActionColorStyle(context),
            icon: Icons.remove_red_eye_rounded,
          ),
          widget.label.deletedAt == null
              ? SlidableAction(
                  flex: 1,
                  onPressed: (context) {
                    if (widget.onDelete != null) {
                      widget.onDelete!();
                    }
                  },
                  backgroundColor: settingNotifier.isSetBackgroundImage == true
                      ? settingNotifier.isSetBackgroundImage == true
                          ? Colors.white.withOpacity(0.30)
                          : Colors.transparent
                      : ThemeDataCenter.getBackgroundColor(context),
                  foregroundColor:
                      ThemeDataCenter.getDeleteSlidableActionColorStyle(
                          context),
                  icon: Icons.delete,
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
                    child: Tooltip(
                      message: 'Created time',
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding:
                                settingNotifier.isSetBackgroundImage == true
                                    ? const EdgeInsets.all(2.0)
                                    : const EdgeInsets.all(0),
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(6.0)),
                                color:
                                    settingNotifier.isSetBackgroundImage == true
                                        ? Colors.white.withOpacity(0.65)
                                        : Colors.transparent),
                            child: Row(
                              children: [
                                Icon(Icons.create_rounded,
                                    size: 13.0,
                                    color: ThemeDataCenter.getTopCardLabelStyle(
                                        context)),
                                const SizedBox(width: 5.0),
                                Text(
                                    CommonConverters.toTimeString(
                                        time: widget.label.createdAt!),
                                    style: CommonStyles.dateTimeTextStyle(
                                        color: ThemeDataCenter
                                            .getTopCardLabelStyle(context))),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : Container(),
            widget.label.updatedAt != null && widget.label.deletedAt == null
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 5.0, 0),
                    child: Tooltip(
                      message: 'Updated time',
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding:
                                settingNotifier.isSetBackgroundImage == true
                                    ? const EdgeInsets.all(2.0)
                                    : const EdgeInsets.all(0),
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(6.0)),
                                color:
                                    settingNotifier.isSetBackgroundImage == true
                                        ? Colors.white.withOpacity(0.65)
                                        : Colors.transparent),
                            child: Row(
                              children: [
                                Icon(Icons.update_rounded,
                                    size: 13.0,
                                    color: ThemeDataCenter.getTopCardLabelStyle(
                                        context)),
                                const SizedBox(width: 5.0),
                                Text(
                                    CommonConverters.toTimeString(
                                        time: widget.label.updatedAt!),
                                    style: CommonStyles.dateTimeTextStyle(
                                        color: ThemeDataCenter
                                            .getTopCardLabelStyle(context)))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : Container(),
            widget.label.deletedAt != null
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 5.0, 0),
                    child: Tooltip(
                      message: 'Deleted time',
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding:
                                settingNotifier.isSetBackgroundImage == true
                                    ? const EdgeInsets.all(2.0)
                                    : const EdgeInsets.all(0),
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(6.0)),
                                color:
                                    settingNotifier.isSetBackgroundImage == true
                                        ? Colors.white.withOpacity(0.65)
                                        : Colors.transparent),
                            child: Row(
                              children: [
                                Icon(Icons.delete_rounded,
                                    size: 13.0,
                                    color: ThemeDataCenter.getTopCardLabelStyle(
                                        context)),
                                const SizedBox(width: 5.0),
                                Text(
                                    CommonConverters.toTimeString(
                                        time: widget.label.deletedAt!),
                                    style: CommonStyles.dateTimeTextStyle(
                                        color: ThemeDataCenter
                                            .getTopCardLabelStyle(context)))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : Container(),
            Card(
              shadowColor: Colors.black,
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: ThemeDataCenter.getBorderCardColorStyle(context),
                    width: 1.0),
                borderRadius: BorderRadius.circular(5.0),
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
                                        coreButtonStyle: ThemeDataCenter
                                            .getUpdateButtonStyle(context),
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
                                          coreButtonStyle: ThemeDataCenter
                                              .getRestoreButtonStyle(context),
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
                                          coreButtonStyle: ThemeDataCenter
                                              .getDeleteForeverButtonStyle(
                                                  context),
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
