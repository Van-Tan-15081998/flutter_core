import 'package:dotted_border/dotted_border.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core_v3/app/library/extensions/extensions.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../../../../core/components/actions/common_buttons/CoreElevatedButton.dart';
import '../../../../../core/components/containment/dialogs/CoreFullScreenDialog.dart';
import '../../../../../core/components/helper_widgets/CoreHelperWidget.dart';
import '../../../../../core/components/notifications/CoreNotification.dart';
import '../../../../library/common/converters/CommonConverters.dart';
import '../../../../library/common/languages/CommonLanguages.dart';
import '../../../../library/common/styles/CommonStyles.dart';
import '../../../../library/common/themes/ThemeDataCenter.dart';
import '../../../../library/common/utils/CommonAudioOnPressButton.dart';
import '../../../../library/enums/CommonEnums.dart';
import '../../../setting/providers/setting_notifier.dart';
import '../databases/label_db_manager.dart';
import '../models/label_model.dart';
import '../providers/label_notifier.dart';
import 'label_create_screen.dart';
import 'label_list_screen.dart';

class LabelDetailScreen extends StatefulWidget {
  final LabelModel label;
  final RedirectFromEnum? redirectFrom;

  const LabelDetailScreen(
      {super.key, required this.label, required this.redirectFrom});

  @override
  State<LabelDetailScreen> createState() => _LabelDetailScreenState();
}

class _LabelDetailScreenState extends State<LabelDetailScreen> {
  CommonAudioOnPressButton commonAudioOnPressButton =
      CommonAudioOnPressButton();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    commonAudioOnPressButton.dispose();
    // TODO: implement dispose
    super.dispose();
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

  Widget onGetTitle() {
    String defaultTitle =
        'You wrote at ${CommonConverters.toTimeString(time: widget.label.createdAt!)}';
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text(defaultTitle),
    );
  }

  void _onPopAction(BuildContext context) {
    if (widget.redirectFrom == RedirectFromEnum.labelUpdate) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => const LabelListScreen(
                  labelConditionModel: null,
                  redirectFrom: null,
                )),
        (route) => false,
      );
    } else {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    }
  }

  Widget? _buildAppbarLeading(
      BuildContext context, SettingNotifier settingNotifier) {
    return IconButton(
      style: CommonStyles.appbarLeadingBackButtonStyle(
          whiteBlur:
              settingNotifier.isSetBackgroundImage == true ? true : false),
      icon: const FaIcon(FontAwesomeIcons.chevronLeft),
      onPressed: () {
        _onPopAction(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final labelNotifier = Provider.of<LabelNotifier>(context);
    final settingNotifier = Provider.of<SettingNotifier>(context);

    return WillPopScope(
      onWillPop: () async {
        _onPopAction(context);
        return Navigator.canPop(context);
      },
      child: CoreFullScreenDialog(
        appbarLeading: _buildAppbarLeading(context, settingNotifier),
        title: Padding(
          padding: const EdgeInsets.only(right: 4.0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(5.0),
                  decoration: CommonStyles.titleScreenDecorationStyle(
                      settingNotifier.isSetBackgroundImage),
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                            CommonLanguages.convert(
                                lang: settingNotifier.languageString ??
                                    CommonLanguages.languageStringDefault(),
                                word: 'screen.title.detail.label'),
                            style: CommonStyles.screenTitleTextStyle(
                                fontSize: 16.0,
                                color: ThemeDataCenter.getScreenTitleTextColor(
                                    context))),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: AppBarActionButtonEnum.home,
        isConfirmToClose: false,
        homeLabel: CommonLanguages.convert(
            lang: settingNotifier.languageString ??
                CommonLanguages.languageStringDefault(),
            word: 'screen.title.labels'),
        onGoHome: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => const LabelListScreen(
                      labelConditionModel: null,
                      redirectFrom: null,
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
        child: _buildBody(context, labelNotifier, settingNotifier),
      ),
    );
  }

  Widget _buildBody(BuildContext context, LabelNotifier labelNotifier,
      SettingNotifier settingNotifier) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Column(children: <Widget>[
        Slidable(
          key: const ValueKey(0),
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              widget.label.deletedAt == null
                  ? SlidableAction(
                      flex: 1,
                      onPressed: (context) {
                        _onDeleteLabel(context).then((result) {
                          if (result) {
                            labelNotifier.onCountAll();

                            CoreNotification.showMessage(
                                context,
                                settingNotifier,
                                CoreNotificationStatus.success,
                                CommonLanguages.convert(
                                    lang: settingNotifier.languageString ??
                                        CommonLanguages.languageStringDefault(),
                                    word: 'notification.action.deleted'));

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LabelListScreen(
                                  labelConditionModel: null,
                                  redirectFrom: null,
                                ),
                              ),
                            );
                          } else {
                            CoreNotification.showMessage(
                                context,
                                settingNotifier,
                                CoreNotificationStatus.error,
                                CommonLanguages.convert(
                                    lang: settingNotifier.languageString ??
                                        CommonLanguages.languageStringDefault(),
                                    word: 'notification.action.error'));
                          }
                        });
                      },
                      backgroundColor:
                          settingNotifier.isSetBackgroundImage == true
                              ? settingNotifier.isSetBackgroundImage == true
                                  ? Colors.white.withOpacity(0.30)
                                  : Colors.transparent
                              : ThemeDataCenter.getBackgroundColor(context),
                      foregroundColor:
                          ThemeDataCenter.getDeleteSlidableActionColorStyle(
                              context),
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
                                        settingNotifier.isSetBackgroundImage ==
                                                true
                                            ? Colors.white.withOpacity(0.65)
                                            : Colors.transparent),
                                child: Row(
                                  children: [
                                    Icon(Icons.create_rounded,
                                        size: 13.0,
                                        color: ThemeDataCenter
                                            .getTopCardLabelStyle(context)),
                                    const SizedBox(width: 5.0),
                                    Text(
                                        CommonConverters.toTimeString(
                                            time: widget.label.createdAt!),
                                        style: CommonStyles.dateTimeTextStyle(
                                            color: ThemeDataCenter
                                                .getTopCardLabelStyle(
                                                    context))),
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
                                        settingNotifier.isSetBackgroundImage ==
                                                true
                                            ? Colors.white.withOpacity(0.65)
                                            : Colors.transparent),
                                child: Row(
                                  children: [
                                    Icon(Icons.update_rounded,
                                        size: 13.0,
                                        color: ThemeDataCenter
                                            .getTopCardLabelStyle(context)),
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
                                        settingNotifier.isSetBackgroundImage ==
                                                true
                                            ? Colors.white.withOpacity(0.65)
                                            : Colors.transparent),
                                child: Row(
                                  children: [
                                    Icon(Icons.delete_rounded,
                                        size: 13.0,
                                        color: ThemeDataCenter
                                            .getTopCardLabelStyle(context)),
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
                  color: Colors.white
                      .withOpacity(settingNotifier.opacityNumber ?? 1),
                  shadowColor: const Color(0xff1f1f1f),
                  elevation: 0,
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
                            // color: Colors.white,
                            shape: BoxShape.rectangle,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Flexible(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 6.0),
                                      child: DottedBorder(
                                          borderType: BorderType.RRect,
                                          radius: const Radius.circular(12),
                                          color: widget.label.color.toColor(),
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(12)),
                                            child: Container(
                                                color: Colors.white,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(6.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Icon(
                                                          Icons
                                                              .label_important_rounded,
                                                          color: widget
                                                              .label.color
                                                              .toColor()),
                                                      const SizedBox(
                                                          width: 6.0),
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
                                          message: CommonLanguages.convert(
                                              lang: settingNotifier
                                                      .languageString ??
                                                  CommonLanguages
                                                      .languageStringDefault(),
                                              word: 'tooltip.button.update'),
                                          child: CoreElevatedButton.iconOnly(
                                            buttonAudio:
                                                commonAudioOnPressButton,
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
                                                            redirectFrom: null,
                                                          )));
                                            },
                                            coreButtonStyle: ThemeDataCenter
                                                .getUpdateButtonStyle(context),
                                            icon: const Icon(
                                                Icons.edit_note_rounded),
                                          ),
                                        )
                                      : Column(children: [
                                          Tooltip(
                                            message: CommonLanguages.convert(
                                                lang: settingNotifier
                                                        .languageString ??
                                                    CommonLanguages
                                                        .languageStringDefault(),
                                                word: 'tooltip.button.restore'),
                                            child: CoreElevatedButton.iconOnly(
                                              buttonAudio:
                                                  commonAudioOnPressButton,
                                              onPressed: () {
                                                _onRestoreLabelFromTrash(
                                                        context)
                                                    .then((result) {
                                                  if (result) {
                                                    labelNotifier.onCountAll();

                                                    CoreNotification.showMessage(
                                                        context,
                                                        settingNotifier,
                                                        CoreNotificationStatus
                                                            .success,
                                                        CommonLanguages.convert(
                                                            lang: settingNotifier
                                                                    .languageString ??
                                                                CommonLanguages
                                                                    .languageStringDefault(),
                                                            word:
                                                                'notification.action.restored'));

                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            const LabelListScreen(
                                                          labelConditionModel:
                                                              null,
                                                          redirectFrom: null,
                                                        ),
                                                      ),
                                                    );
                                                  } else {
                                                    CoreNotification.showMessage(
                                                        context,
                                                        settingNotifier,
                                                        CoreNotificationStatus
                                                            .error,
                                                        CommonLanguages.convert(
                                                            lang: settingNotifier
                                                                    .languageString ??
                                                                CommonLanguages
                                                                    .languageStringDefault(),
                                                            word:
                                                                'notification.action.error'));
                                                  }
                                                });
                                              },
                                              coreButtonStyle: ThemeDataCenter
                                                  .getRestoreButtonStyle(
                                                      context),
                                              icon: const Icon(
                                                  Icons
                                                      .restore_from_trash_rounded,
                                                  size: 26.0),
                                            ),
                                          ),
                                          const SizedBox(height: 2.0),
                                          Tooltip(
                                            message: CommonLanguages.convert(
                                                lang: settingNotifier
                                                        .languageString ??
                                                    CommonLanguages
                                                        .languageStringDefault(),
                                                word:
                                                    'tooltip.button.deleteForever'),
                                            child: CoreElevatedButton.iconOnly(
                                              buttonAudio:
                                                  commonAudioOnPressButton,
                                              onPressed: () async {
                                                if (await CoreHelperWidget
                                                    .confirmFunction(
                                                        context: context,
                                                        settingNotifier:
                                                            settingNotifier)) {
                                                  _onDeleteLabelForever(context)
                                                      .then((result) {
                                                    if (result) {
                                                      labelNotifier
                                                          .onCountAll();

                                                      CoreNotification.showMessage(
                                                          context,
                                                          settingNotifier,
                                                          CoreNotificationStatus
                                                              .success,
                                                          CommonLanguages.convert(
                                                              lang: settingNotifier
                                                                      .languageString ??
                                                                  CommonLanguages
                                                                      .languageStringDefault(),
                                                              word:
                                                                  'notification.action.deleted'));

                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              const LabelListScreen(
                                                            labelConditionModel:
                                                                null,
                                                            redirectFrom: null,
                                                          ),
                                                        ),
                                                      );
                                                    } else {
                                                      CoreNotification.showMessage(
                                                          context,
                                                          settingNotifier,
                                                          CoreNotificationStatus
                                                              .error,
                                                          CommonLanguages.convert(
                                                              lang: settingNotifier
                                                                      .languageString ??
                                                                  CommonLanguages
                                                                      .languageStringDefault(),
                                                              word:
                                                                  'notification.action.error'));
                                                    }
                                                  });
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
        ),
      ]),
    );
  }
}
