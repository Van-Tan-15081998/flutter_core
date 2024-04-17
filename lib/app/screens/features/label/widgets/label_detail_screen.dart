import 'package:dotted_border/dotted_border.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core_v3/app/library/extensions/extensions.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import '../../../../../core/components/actions/common_buttons/CoreButtonStyle.dart';
import '../../../../../core/components/actions/common_buttons/CoreElevatedButton.dart';
import '../../../../../core/components/containment/dialogs/CoreFullScreenDialog.dart';
import '../../../../../core/components/helper_widgets/CoreHelperWidget.dart';
import '../../../../../core/components/notifications/CoreNotification.dart';
import '../../../../library/enums/CommonEnums.dart';
import '../databases/label_db_manager.dart';
import '../models/label_model.dart';
import '../providers/label_notifier.dart';
import 'label_create_screen.dart';
import 'label_list_screen.dart';

class LabelDetailScreen extends StatefulWidget {
  final LabelModel label;

  const LabelDetailScreen({super.key, required this.label});

  @override
  State<LabelDetailScreen> createState() => _LabelDetailScreenState();
}

class _LabelDetailScreenState extends State<LabelDetailScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  _onUpdateLabel() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LabelCreateScreen(
                  label: widget.label,
                  actionMode: ActionModeEnum.update,
                )));
  }

  Future<bool> _onDeleteLabel(BuildContext context) async {
    return await LabelDatabaseManager.delete(
        widget.label, DateTime.now().millisecondsSinceEpoch);
  }

  Future<bool> _onDeleteLabelForever(BuildContext context) async {
    return await LabelDatabaseManager.deleteForever(widget.label);
  }

  Future<bool> _onRestoreLabelFromTrash(BuildContext context) async {
    return await LabelDatabaseManager.restoreFromTrash(
        widget.label, DateTime.now().millisecondsSinceEpoch);
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
    final labelNotifier = Provider.of<LabelNotifier>(context);

    return CoreFullScreenDialog(
      title: 'Detail',
      actions: AppBarActionButtonEnum.home,
      isConfirmToClose: false,
      homeLabel: 'Labels',
      onGoHome: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => const LabelListScreen(
                labelConditionModel: null,
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
            children: <Widget>[ Slidable(
            key: const ValueKey(0),
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                widget.label.deletedAt == null ?
                SlidableAction(
                  flex: 1,
                  onPressed: (context) {
                    _onDeleteLabel(context).then((result) {
                      if (result) {
                        labelNotifier.onCountAll();

                        CoreNotification.show(context, CoreNotificationStatus.success,
                            CoreNotificationAction.delete, 'Label');

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LabelListScreen(
                              labelConditionModel: null,
                            ),
                          ),
                        );
                      } else {
                        CoreNotification.show(context, CoreNotificationStatus.error,
                            CoreNotificationAction.delete, 'Label');
                      }
                    });
                  },
                  backgroundColor: const Color(0xFF202124),
                  foregroundColor: const Color(0xffffb90f),
                  icon: Icons.delete,
                  label: 'Delete',
                ) : Container()
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
                                        ? CoreElevatedButton.iconOnly(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          LabelCreateScreen(
                                                            actionMode:
                                                                ActionModeEnum.update,
                                                            label: widget.label,
                                                          )));
                                            },
                                            coreButtonStyle:
                                                CoreButtonStyle.dark(kitRadius: 6.0),
                                            icon: const Icon(Icons.edit_note_rounded),
                                          )
                                        : Column(children: [
                                            CoreElevatedButton.iconOnly(
                                              onPressed: () {
                                                _onRestoreLabelFromTrash(context)
                                                    .then((result) {
                                                  if (result) {
                                                    labelNotifier.onCountAll();

                                                    CoreNotification.show(
                                                        context,
                                                        CoreNotificationStatus
                                                            .success,
                                                        CoreNotificationAction
                                                            .restore,
                                                        'Label');

                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            const LabelListScreen(
                                                          labelConditionModel: null,
                                                        ),
                                                      ),
                                                    );
                                                  } else {
                                                    CoreNotification.show(
                                                        context,
                                                        CoreNotificationStatus.error,
                                                        CoreNotificationAction
                                                            .restore,
                                                        'Label');
                                                  }
                                                });
                                              },
                                              coreButtonStyle: CoreButtonStyle.info(
                                                  kitRadius: 6.0),
                                              icon: const Icon(
                                                  Icons.restore_from_trash_rounded,
                                                  size: 26.0),
                                            ),
                                            const SizedBox(height: 2.0),
                                            CoreElevatedButton.iconOnly(
                                              onPressed: () async {
                                                if (await CoreHelperWidget
                                                    .confirmFunction(context)) {
                                                  _onDeleteLabelForever(context)
                                                      .then((result) {
                                                    if (result) {
                                                      labelNotifier.onCountAll();

                                                      CoreNotification.show(
                                                          context,
                                                          CoreNotificationStatus
                                                              .success,
                                                          CoreNotificationAction
                                                              .delete,
                                                          'Label');

                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              const LabelListScreen(
                                                            labelConditionModel: null,
                                                          ),
                                                        ),
                                                      );
                                                    } else {
                                                      CoreNotification.show(
                                                          context,
                                                          CoreNotificationStatus
                                                              .error,
                                                          CoreNotificationAction
                                                              .delete,
                                                          'Label');
                                                    }
                                                  });
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
                      ],
                    ),
                  ),
                ],
              )),
            ),
          ),
        ]
        ),
      ),
    );
  }
}