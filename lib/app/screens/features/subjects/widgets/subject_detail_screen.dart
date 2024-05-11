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
import '../../note/models/note_condition_model.dart';
import '../../note/note_create_screen.dart';
import '../../note/note_list_screen.dart';
import '../databases/subject_db_manager.dart';
import '../models/subject_condition_model.dart';
import '../models/subject_model.dart';
import '../providers/subject_notifier.dart';
import 'subject_create_screen.dart';
import 'subject_list_screen.dart';

class SubjectDetailScreen extends StatefulWidget {
  final SubjectModel subject;
  final RedirectFromEnum? redirectFrom;

  const SubjectDetailScreen(
      {super.key, required this.subject, required this.redirectFrom});

  @override
  State<SubjectDetailScreen> createState() => _SubjectDetailScreenState();
}

class _SubjectDetailScreenState extends State<SubjectDetailScreen> {
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

  _onUpdateSubject() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SubjectCreateScreen(
                  subject: widget.subject,
                  parentSubject: null,
                  actionMode: ActionModeEnum.update,
                  redirectFrom: null,
                  breadcrumb: null,
                )));
  }

  Future<bool> _onDeleteSubject(BuildContext context) async {
    return await SubjectDatabaseManager.delete(
        widget.subject, DateTime.now().millisecondsSinceEpoch);
  }

  Future<bool> _onDeleteSubjectForever(BuildContext context) async {
    return await SubjectDatabaseManager.deleteForever(widget.subject);
  }

  Future<bool> _onRestoreSubjectFromTrash(BuildContext context) async {
    return await SubjectDatabaseManager.restoreFromTrash(
        widget.subject, DateTime.now().millisecondsSinceEpoch);
  }

  Widget onGetTitle() {
    String defaultTitle =
        'You wrote at ${CommonConverters.toTimeString(time: widget.subject.createdAt!)}';
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text(defaultTitle),
    );
  }

  void _onPopAction(BuildContext context) {
    if (widget.redirectFrom == RedirectFromEnum.subjectUpdate) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => const SubjectListScreen(
                  subjectConditionModel: null,
                  redirectFrom: null,
                  breadcrumb: null,
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
    final subjectNotifier = Provider.of<SubjectNotifier>(context);
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
                                  word: 'screen.title.detail.subject'),
                              style: CommonStyles.screenTitleTextStyle(
                                  fontSize: 16.0,
                                  color:
                                      ThemeDataCenter.getScreenTitleTextColor(
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
              word: 'screen.title.subjects'),
          onGoHome: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => const SubjectListScreen(
                        subjectConditionModel: null,
                        redirectFrom: null,
                        breadcrumb: null,
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
          child: _buildBody(context, subjectNotifier, settingNotifier)),
    );
  }

  Widget _buildBody(BuildContext context, SubjectNotifier subjectNotifier,
      SettingNotifier settingNotifier) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Column(children: <Widget>[
        Slidable(
          key: const ValueKey(0),
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              widget.subject.deletedAt == null
                  ? SlidableAction(
                      flex: 1,
                      onPressed: (context) {
                        _onDeleteSubject(context).then((result) {
                          if (result) {
                            subjectNotifier.onCountAll();

                            CoreNotification.showMessage(
                                context, settingNotifier,
                                CoreNotificationStatus.success,
                                CommonLanguages.convert(
                                    lang: settingNotifier.languageString ??
                                        CommonLanguages.languageStringDefault(),
                                    word: 'notification.action.deleted'));

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SubjectListScreen(
                                  subjectConditionModel: null,
                                  redirectFrom: null,
                                  breadcrumb: null,
                                ),
                              ),
                            );
                          } else {
                            CoreNotification.showMessage(
                                context, settingNotifier,
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
                    )
                  : Container()
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
            child: ExpandableNotifier(
              child: Column(
                children: [
                  widget.subject.updatedAt == null &&
                          widget.subject.deletedAt == null
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 9.0, 0),
                          child: Tooltip(
                            message: 'Created time',
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  padding:
                                      settingNotifier.isSetBackgroundImage ==
                                              true
                                          ? const EdgeInsets.all(2.0)
                                          : const EdgeInsets.all(0),
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(6.0)),
                                      color: settingNotifier
                                                  .isSetBackgroundImage ==
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
                                              time: widget.subject.createdAt!),
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
                  widget.subject.updatedAt != null &&
                          widget.subject.deletedAt == null
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 9.0, 0),
                          child: Tooltip(
                            message: 'Updated time',
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  padding:
                                      settingNotifier.isSetBackgroundImage ==
                                              true
                                          ? const EdgeInsets.all(2.0)
                                          : const EdgeInsets.all(0),
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(6.0)),
                                      color: settingNotifier
                                                  .isSetBackgroundImage ==
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
                                              time: widget.subject.updatedAt!),
                                          style: CommonStyles.dateTimeTextStyle(
                                              color: ThemeDataCenter
                                                  .getTopCardLabelStyle(
                                                      context)))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      : Container(),
                  widget.subject.deletedAt != null
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 9.0, 0),
                          child: Tooltip(
                            message: 'Deleted time',
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  padding:
                                      settingNotifier.isSetBackgroundImage ==
                                              true
                                          ? const EdgeInsets.all(2.0)
                                          : const EdgeInsets.all(0),
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(6.0)),
                                      color: settingNotifier
                                                  .isSetBackgroundImage ==
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
                                              time: widget.subject.deletedAt!),
                                          style: CommonStyles.dateTimeTextStyle(
                                              color: ThemeDataCenter
                                                  .getTopCardLabelStyle(
                                                      context)))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      : Container(),
                  Card(
                    color: Colors.white.withOpacity(settingNotifier.opacityNumber ?? 1),
                    shadowColor: const Color(0xff1f1f1f),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color:
                              ThemeDataCenter.getBorderCardColorStyle(context),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          2.0, 0, 6.0, 0),
                                      child: DottedBorder(
                                          borderType: BorderType.RRect,
                                          radius: const Radius.circular(12),
                                          color: widget.subject.color.toColor(),
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
                                                          Icons.palette_rounded,
                                                          color: widget
                                                              .subject.color
                                                              .toColor()),
                                                      const SizedBox(
                                                          width: 6.0),
                                                      Flexible(
                                                        child: Text(
                                                            widget
                                                                .subject.title,
                                                            style: const TextStyle(
                                                                fontSize: 16.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400)),
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                          )),
                                    ),
                                  ),
                                  widget.subject.deletedAt == null
                                      ? Column(
                                          children: [
                                            Tooltip(
                                              message: CommonLanguages.convert(
                                                  lang: settingNotifier.languageString ??
                                                      CommonLanguages.languageStringDefault(),
                                                  word: 'tooltip.button.update'),
                                              child:
                                                  CoreElevatedButton.iconOnly(
                                                buttonAudio:
                                                    commonAudioOnPressButton,
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              SubjectCreateScreen(
                                                                parentSubject:
                                                                    null,
                                                                actionMode:
                                                                    ActionModeEnum
                                                                        .update,
                                                                subject: widget
                                                                    .subject,
                                                                redirectFrom:
                                                                    null,
                                                                breadcrumb:
                                                                    null,
                                                              )));
                                                },
                                                coreButtonStyle: ThemeDataCenter
                                                    .getUpdateButtonStyle(
                                                        context),
                                                icon: const Icon(
                                                    Icons.edit_note_rounded),
                                              ),
                                            ),
                                            Tooltip(
                                              message: CommonLanguages.convert(
                                                  lang: settingNotifier.languageString ??
                                                      CommonLanguages.languageStringDefault(),
                                                  word: 'tooltip.button.createSubSubject'),
                                              child:
                                                  CoreElevatedButton.iconOnly(
                                                buttonAudio:
                                                    commonAudioOnPressButton,
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              SubjectCreateScreen(
                                                                parentSubject:
                                                                    widget
                                                                        .subject,
                                                                actionMode:
                                                                    ActionModeEnum
                                                                        .create,
                                                                redirectFrom:
                                                                    null,
                                                                breadcrumb:
                                                                    null,
                                                              )));
                                                },
                                                coreButtonStyle: ThemeDataCenter
                                                    .getCreateSubSubjectButtonStyle(
                                                        context),
                                                icon: const Icon(Icons
                                                    .create_new_folder_rounded),
                                              ),
                                            ),
                                            Tooltip(
                                              message: CommonLanguages.convert(
                                                  lang: settingNotifier.languageString ??
                                                      CommonLanguages.languageStringDefault(),
                                                  word: 'screen.title.notes'),
                                              child:
                                                  CoreElevatedButton.iconOnly(
                                                buttonAudio:
                                                    commonAudioOnPressButton,
                                                onPressed: () {
                                                  NoteConditionModel
                                                      noteConditionModel =
                                                      NoteConditionModel();
                                                  noteConditionModel.subjectId =
                                                      widget.subject.id;
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              NoteListScreen(
                                                                noteConditionModel:
                                                                    noteConditionModel,
                                                                isOpenSubjectsForFilter:
                                                                    true,
                                                                redirectFrom:
                                                                    RedirectFromEnum
                                                                        .subjectDetail,
                                                              )));
                                                },
                                                coreButtonStyle: ThemeDataCenter
                                                    .getViewNotesButtonStyle(
                                                        context),
                                                icon: const Icon(Icons
                                                    .playlist_play_rounded),
                                              ),
                                            ),
                                            Tooltip(
                                              message: CommonLanguages.convert(
                                                  lang: settingNotifier.languageString ??
                                                      CommonLanguages.languageStringDefault(),
                                                  word: 'screen.title.create.note'),
                                              child:
                                                  CoreElevatedButton.iconOnly(
                                                buttonAudio:
                                                    commonAudioOnPressButton,
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              NoteCreateScreen(
                                                                note: null,
                                                                copyNote: null,
                                                                subject: widget
                                                                    .subject,
                                                                actionMode:
                                                                    ActionModeEnum
                                                                        .create,
                                                                redirectFrom:
                                                                    RedirectFromEnum
                                                                        .subjectCreateNote,
                                                              )));
                                                },
                                                coreButtonStyle: ThemeDataCenter
                                                    .getCreateNoteButtonStyle(
                                                        context),
                                                icon: const Icon(
                                                    Icons.add_card_rounded),
                                              ),
                                            ),
                                            Tooltip(
                                              message: 'Parent subject',
                                              child:
                                                  CoreElevatedButton.iconOnly(
                                                buttonAudio:
                                                    commonAudioOnPressButton,
                                                onPressed: () {
                                                  SubjectConditionModel
                                                      subjectConditionModel =
                                                      SubjectConditionModel();
                                                  subjectConditionModel.id =
                                                      widget.subject.parentId;
                                                  subjectConditionModel
                                                      .parentId = null;

                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          SubjectListScreen(
                                                        subjectConditionModel:
                                                            subjectConditionModel,
                                                        redirectFrom: null,
                                                        breadcrumb: null,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                coreButtonStyle: ThemeDataCenter
                                                    .getFilterParentSubjectButtonStyle(
                                                        context),
                                                icon: const Icon(
                                                    Icons.arrow_upward_rounded),
                                              ),
                                            ),
                                            Tooltip(
                                              message: 'Sub subjects',
                                              child:
                                                  CoreElevatedButton.iconOnly(
                                                buttonAudio:
                                                    commonAudioOnPressButton,
                                                onPressed: () {
                                                  SubjectConditionModel
                                                      subjectConditionModel =
                                                      SubjectConditionModel();
                                                  subjectConditionModel
                                                          .parentId =
                                                      widget.subject.parentId;
                                                  subjectConditionModel.id =
                                                      null;

                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          SubjectListScreen(
                                                        subjectConditionModel:
                                                            subjectConditionModel,
                                                        redirectFrom: null,
                                                        breadcrumb: null,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                coreButtonStyle: ThemeDataCenter
                                                    .getFilterSubSubjectButtonStyle(
                                                        context),
                                                icon: const Icon(Icons
                                                    .arrow_downward_rounded),
                                              ),
                                            ),
                                          ],
                                        )
                                      : Column(children: [
                                          Tooltip(
                                            message: CommonLanguages.convert(
                                                lang: settingNotifier.languageString ??
                                                    CommonLanguages.languageStringDefault(),
                                                word: 'tooltip.button.restore'),
                                            child: CoreElevatedButton.iconOnly(
                                              buttonAudio:
                                                  commonAudioOnPressButton,
                                              onPressed: () {
                                                _onRestoreSubjectFromTrash(
                                                        context)
                                                    .then((result) {
                                                  if (result) {
                                                    subjectNotifier.onCountAll();

                                                    CoreNotification.showMessage(
                                                        context, settingNotifier,
                                                        CoreNotificationStatus
                                                            .success,
                                                        CommonLanguages.convert(
                                                            lang: settingNotifier.languageString ??
                                                                CommonLanguages.languageStringDefault(),
                                                            word: 'notification.action.restored'));

                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            const SubjectListScreen(
                                                          subjectConditionModel:
                                                              null,
                                                          redirectFrom: null,
                                                          breadcrumb: null,
                                                        ),
                                                      ),
                                                    );
                                                  } else {
                                                    CoreNotification.showMessage(
                                                        context, settingNotifier,
                                                        CoreNotificationStatus
                                                            .error,
                                                        CommonLanguages.convert(
                                                            lang: settingNotifier.languageString ??
                                                                CommonLanguages.languageStringDefault(),
                                                            word: 'notification.action.error'));
                                                  }
                                                });
                                              },
                                              coreButtonStyle: ThemeDataCenter
                                                  .getRestoreButtonStyle(context),
                                              icon: const Icon(
                                                  Icons
                                                      .restore_from_trash_rounded,
                                                  size: 26.0),
                                            ),
                                          ),
                                          const SizedBox(height: 2.0),
                                          Tooltip(
                                            message: CommonLanguages.convert(
                                                lang: settingNotifier.languageString ??
                                                    CommonLanguages.languageStringDefault(),
                                                word: 'tooltip.button.deleteForever'),
                                            child: CoreElevatedButton.iconOnly(
                                              buttonAudio:
                                                  commonAudioOnPressButton,
                                              onPressed: () async {
                                                if (await CoreHelperWidget
                                                    .confirmFunction(
                                                        context: context, settingNotifier: settingNotifier)) {
                                                  _onDeleteSubjectForever(context)
                                                      .then((result) {
                                                    if (result) {
                                                      subjectNotifier
                                                          .onCountAll();

                                                      CoreNotification.showMessage(
                                                          context, settingNotifier,
                                                          CoreNotificationStatus
                                                              .success,
                                                          CommonLanguages.convert(
                                                              lang: settingNotifier.languageString ??
                                                                  CommonLanguages.languageStringDefault(),
                                                              word: 'notification.action.deleted'));

                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              const SubjectListScreen(
                                                            subjectConditionModel:
                                                                null,
                                                            redirectFrom: null,
                                                            breadcrumb: null,
                                                          ),
                                                        ),
                                                      );
                                                    } else {
                                                      CoreNotification.showMessage(
                                                          context, settingNotifier,
                                                          CoreNotificationStatus
                                                              .error,
                                                          CommonLanguages.convert(
                                                              lang: settingNotifier.languageString ??
                                                                  CommonLanguages.languageStringDefault(),
                                                              word: 'notification.action.error'));
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
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
