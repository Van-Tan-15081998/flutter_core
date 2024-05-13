import 'dart:convert';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core_v3/app/library/common/themes/ThemeDataCenter.dart';
import 'package:flutter_core_v3/app/library/extensions/extensions.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_quill/flutter_quill.dart' as flutter_quill;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/components/actions/common_buttons/CoreButtonStyle.dart';
import '../../../../core/components/actions/common_buttons/CoreElevatedButton.dart';
import '../../../../core/components/containment/dialogs/CoreBasicDialog.dart';
import '../../../../core/components/containment/dialogs/CoreFullScreenDialog.dart';
import '../../../../core/components/helper_widgets/CoreHelperWidget.dart';
import '../../../../core/components/notifications/CoreNotification.dart';
import '../../../library/common/converters/CommonConverters.dart';
import '../../../library/common/dimensions/CommonDimensions.dart';
import '../../../library/common/languages/CommonLanguages.dart';
import '../../../library/common/styles/CommonStyles.dart';
import '../../../library/common/utils/CommonAudioOnPressButton.dart';
import '../../../library/enums/CommonEnums.dart';
import '../../setting/providers/setting_notifier.dart';
import '../label/models/label_model.dart';
import '../subjects/models/subject_condition_model.dart';
import '../subjects/models/subject_model.dart';
import '../subjects/providers/subject_notifier.dart';
import '../subjects/widgets/subject_list_folder_mode_screen.dart';
import '../subjects/widgets/subject_list_screen.dart';
import 'databases/note_db_manager.dart';
import 'models/note_model.dart';
import 'note_create_screen.dart';
import 'note_list_screen.dart';
import 'providers/note_notifier.dart';

class NoteDetailScreen extends StatefulWidget {
  final NoteModel note;
  final List<LabelModel>? labels;
  final SubjectModel? subject;

  final RedirectFromEnum? redirectFrom;

  const NoteDetailScreen(
      {super.key,
      required this.note,
      required this.subject,
      required this.labels,
      required this.redirectFrom});

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  CommonAudioOnPressButton commonAudioOnPressButton =
      CommonAudioOnPressButton();
  /*
  Editor parameters
   */
  final flutter_quill.QuillController _titleQuillController =
      flutter_quill.QuillController.basic();

  final flutter_quill.QuillController _descriptionQuillController =
      flutter_quill.QuillController.basic();

  final flutter_quill.QuillController _subDescriptionQuillController =
      flutter_quill.QuillController.basic();

  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  List<String> _imageSourceStrings = [];

  _onUpdate() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NoteCreateScreen(
                  note: widget.note,
                  copyNote: null,
                  subject: null,
                  actionMode: ActionModeEnum.update,
                  redirectFrom: RedirectFromEnum.noteDetail,
                )));
  }

  Future<bool> _onDeleteNote(BuildContext context) async {
    return await NoteDatabaseManager.delete(
        widget.note, DateTime.now().millisecondsSinceEpoch);
  }

  Future<bool> _onDeleteNoteForever(BuildContext context) async {
    return await NoteDatabaseManager.deleteForever(widget.note);
  }

  Future<bool> _onRestoreNoteFromTrash(BuildContext context) async {
    return await NoteDatabaseManager.restoreFromTrash(
        widget.note, DateTime.now().millisecondsSinceEpoch);
  }

  Future<bool> _onUnlockNote(BuildContext context, NoteModel note) async {
    return await NoteDatabaseManager.lock(note, null);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.note.title != null && widget.note.title!.isNotEmpty) {
      /// Set data for input
      List<dynamic> deltaMap = jsonDecode(widget.note.title!);

      flutter_quill.Delta delta = flutter_quill.Delta.fromJson(deltaMap);

      setState(() {
        _titleQuillController.document =
            flutter_quill.Document.fromDelta(delta);
      });

      /// Set selection
    }

    if (widget.note.description != null &&
        widget.note.description!.isNotEmpty) {
      /// Set data for input
      List<dynamic> deltaMap = jsonDecode(widget.note.description!);

      flutter_quill.Delta delta = flutter_quill.Delta.fromJson(deltaMap);

      setState(() {
        _descriptionQuillController.document =
            flutter_quill.Document.fromDelta(delta);
      });

      if (_descriptionQuillController.document.toString().isNotEmpty) {
        List<dynamic> deltaMap = jsonDecode(widget.note.description!);

        flutter_quill.Delta delta = flutter_quill.Delta.fromJson(deltaMap);
        setState(() {
          _subDescriptionQuillController.document =
              flutter_quill.Document.fromDelta(delta);
        });
      } else {
        // Xử lý khi Document empty
        print('Document empty.');
      }
    }

    if (widget.note.images != null && widget.note.images!.isNotEmpty) {
      /// Set data for input
      List<dynamic> imageSources = jsonDecode(widget.note.images!);

      if (imageSources.isNotEmpty) {
        setState(() {
          for (var element in imageSources) {
            _imageSourceStrings.add(element);
          }
        });
      }
    }
  }

  @override
  void dispose() {
    commonAudioOnPressButton.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  setDocuments() {
    if (widget.note.title != null && widget.note.title!.isNotEmpty) {
      /// Set data for input
      List<dynamic> deltaMap = jsonDecode(widget.note.title!);

      flutter_quill.Delta delta = flutter_quill.Delta.fromJson(deltaMap);

      setState(() {
        _titleQuillController.document =
            flutter_quill.Document.fromDelta(delta);
      });

      /// Set selection
    }

    if (widget.note.description != null &&
        widget.note.description!.isNotEmpty) {
      /// Set data for input
      List<dynamic> deltaMap = jsonDecode(widget.note.description!);

      flutter_quill.Delta delta = flutter_quill.Delta.fromJson(deltaMap);

      setState(() {
        _descriptionQuillController.document =
            flutter_quill.Document.fromDelta(delta);
      });

      if (_descriptionQuillController.document.toString().isNotEmpty) {
        List<dynamic> deltaMap = jsonDecode(widget.note.description!);

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

  Widget _onGetTitle(SettingNotifier settingNotifier) {
    String defaultTitle = CommonLanguages.convert(
        lang: settingNotifier.languageString ??
            CommonLanguages.languageStringDefault(),
        word: 'screen.title.titleNotSet');
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text(defaultTitle),
    );
  }

  bool checkTitleEmpty() {
    if (_titleQuillController.document.isEmpty()) {
      return false;
    }
    return true;
  }

  Widget _buildLabels() {
    List<Widget> labelWidgets = [];

    for (var element in widget.labels!) {
      labelWidgets.add(
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: DottedBorder(
            borderType: BorderType.RRect,
            radius: const Radius.circular(12),
            color: element.color.toColor(),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.label_important_rounded,
                        color: element.color.toColor(),
                      ),
                      Flexible(
                        child: Text(element.title,
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Flexible(
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: labelWidgets,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubject() {
    return widget.subject != null
        ? Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                child: InkWell(
                  borderRadius: BorderRadius.circular(12.0),
                  onLongPress: () {
                    // SubjectConditionModel subjectConditionModel =
                    //     SubjectConditionModel();
                    // subjectConditionModel.id = widget.subject!.id;
                    // Navigator.pushAndRemoveUntil(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => SubjectListScreen(
                    //               subjectConditionModel: subjectConditionModel,
                    //               redirectFrom: null,
                    //               breadcrumb: null,
                    //             )),
                    //     (route) => false);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SubjectListFolderModeScreen(
                          subjectConditionModel: null,
                          redirectFrom: RedirectFromEnum.notes,
                          breadcrumb: [widget.subject!],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.rectangle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: DottedBorder(
                                borderType: BorderType.RRect,
                                radius: const Radius.circular(12),
                                color: widget.subject?.color.toColor(),
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
                                            Icons.palette_rounded,
                                            color:
                                                widget.subject?.color.toColor(),
                                          ),
                                          const SizedBox(width: 6.0),
                                          Flexible(
                                            child: Text(widget.subject!.title,
                                                maxLines: 1,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        : Container();
  }

  void _onPopAction(BuildContext context) {
    if (widget.redirectFrom == RedirectFromEnum.noteUpdate) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => const NoteListScreen(
                  noteConditionModel: null,
                  isOpenSubjectsForFilter: null,
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
    final subjectNotifier = Provider.of<SubjectNotifier>(context);
    final settingNotifier = Provider.of<SettingNotifier>(context);

    setDocuments();
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
                                word: 'screen.title.detail.note'),
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
            word: 'screen.title.notes'),
        onGoHome: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => const NoteListScreen(
                      noteConditionModel: null,
                      isOpenSubjectsForFilter: null,
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
        child: _buildBody(context, settingNotifier, subjectNotifier),
      ),
    );
  }

  Widget _buildBody(BuildContext context, SettingNotifier settingNotifier,
      SubjectNotifier subjectNotifier) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Slidable(
              key: const ValueKey(0),
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  widget.note.deletedAt == null && widget.note.isLocked == null
                      ? SlidableAction(
                          flex: 1,
                          onPressed: (context) {
                            // _onDelete();
                            _onDeleteNote(context).then((result) {
                              if (result) {
                                Provider.of<NoteNotifier>(context,
                                        listen: false)
                                    .onCountAll();

                                CoreNotification.showMessage(
                                    context,
                                    settingNotifier,
                                    CoreNotificationStatus.success,
                                    CommonLanguages.convert(
                                        lang: settingNotifier.languageString ??
                                            CommonLanguages
                                                .languageStringDefault(),
                                        word: 'notification.action.deleted'));

                                if (widget.redirectFrom ==
                                    RedirectFromEnum.subjectsInFolderMode) {
                                  Navigator.pop(context, result);
                                } else {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const NoteListScreen(
                                              noteConditionModel: null,
                                              isOpenSubjectsForFilter: null,
                                              redirectFrom: null,
                                            )),
                                    (route) => false,
                                  );
                                }
                              } else {
                                CoreNotification.showMessage(
                                    context,
                                    settingNotifier,
                                    CoreNotificationStatus.error,
                                    CommonLanguages.convert(
                                        lang: settingNotifier.languageString ??
                                            CommonLanguages
                                                .languageStringDefault(),
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
                  initialExpanded: true,
                  child: Column(
                    children: [
                      widget.note.updatedAt == null &&
                              widget.note.deletedAt == null
                          ? Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 5.0, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  widget.note.isLocked != null
                                      ? Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              5.0, 0, 5.0, 0),
                                          child: Icon(Icons.lock,
                                              size: 22,
                                              color: ThemeDataCenter
                                                  .getLockSlidableActionColorStyle(
                                                      context)),
                                        )
                                      : Container(),
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
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        widget.note.createdForDay != null
                                            ? Tooltip(
                                                message: 'Created for',
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Icon(
                                                        Icons
                                                            .directions_run_rounded,
                                                        size: 14.0,
                                                        color: ThemeDataCenter
                                                            .getTopCardLabelStyle(
                                                                context)),
                                                    const SizedBox(width: 5.0),
                                                    Text(
                                                      CommonConverters
                                                          .toTimeString(
                                                              time: widget.note
                                                                  .createdForDay!,
                                                              format:
                                                                  'dd/MM/yyyy'),
                                                      style: TextStyle(
                                                          fontSize: 13.0,
                                                          color: ThemeDataCenter
                                                              .getTopCardLabelStyle(
                                                                  context)),
                                                    ),
                                                    const SizedBox(width: 5.0),
                                                  ],
                                                ),
                                              )
                                            : Container(),
                                        Tooltip(
                                          message: 'Created time',
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Icon(Icons.create_rounded,
                                                  size: 13.0,
                                                  color: ThemeDataCenter
                                                      .getTopCardLabelStyle(
                                                          context)),
                                              const SizedBox(width: 5.0),
                                              Text(
                                                CommonConverters.toTimeString(
                                                    time:
                                                        widget.note.createdAt!),
                                                style: CommonStyles
                                                    .dateTimeTextStyle(
                                                        color: ThemeDataCenter
                                                            .getTopCardLabelStyle(
                                                                context)),
                                              ),
                                              const SizedBox(width: 5.0),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  widget.note.isFavourite != null
                                      ? const Icon(Icons.favorite,
                                          color: Color(0xffdc3545), size: 26.0)
                                      : Container(),
                                ],
                              ),
                            )
                          : Container(),
                      widget.note.updatedAt != null &&
                              widget.note.deletedAt == null
                          ? Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 5.0, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  widget.note.isLocked != null
                                      ? Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              5.0, 0, 5.0, 0),
                                          child: Icon(Icons.lock,
                                              size: 22,
                                              color: ThemeDataCenter
                                                  .getLockSlidableActionColorStyle(
                                                      context)),
                                        )
                                      : Container(),
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
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        widget.note.createdForDay != null
                                            ? Tooltip(
                                                message: 'Created for',
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Icon(
                                                        Icons
                                                            .directions_run_rounded,
                                                        size: 14.0,
                                                        color: ThemeDataCenter
                                                            .getTopCardLabelStyle(
                                                                context)),
                                                    const SizedBox(width: 5.0),
                                                    Text(
                                                      CommonConverters
                                                          .toTimeString(
                                                              time: widget.note
                                                                  .createdForDay!,
                                                              format:
                                                                  'dd/MM/yyyy'),
                                                      style: TextStyle(
                                                          fontSize: 13.0,
                                                          color: ThemeDataCenter
                                                              .getTopCardLabelStyle(
                                                                  context)),
                                                    ),
                                                    const SizedBox(width: 5.0),
                                                  ],
                                                ),
                                              )
                                            : Container(),
                                        Tooltip(
                                          message: 'Updated time',
                                          child: Row(
                                            children: [
                                              Icon(Icons.update_rounded,
                                                  size: 13.0,
                                                  color: ThemeDataCenter
                                                      .getTopCardLabelStyle(
                                                          context)),
                                              const SizedBox(width: 5.0),
                                              Text(
                                                  CommonConverters.toTimeString(
                                                      time: widget
                                                          .note.updatedAt!),
                                                  style: CommonStyles
                                                      .dateTimeTextStyle(
                                                          color: ThemeDataCenter
                                                              .getTopCardLabelStyle(
                                                                  context))),
                                              const SizedBox(width: 5.0),
                                            ],
                                          ),
                                        ),
                                        Tooltip(
                                          message: 'Created time',
                                          child: Row(
                                            children: [
                                              Icon(Icons.create_rounded,
                                                  size: 13.0,
                                                  color: ThemeDataCenter
                                                      .getTopCardLabelStyle(
                                                          context)),
                                              const SizedBox(width: 5.0),
                                              Text(
                                                  CommonConverters.toTimeString(
                                                      time: widget
                                                          .note.createdAt!),
                                                  style: CommonStyles
                                                      .dateTimeTextStyle(
                                                          color: ThemeDataCenter
                                                              .getTopCardLabelStyle(
                                                                  context))),
                                              const SizedBox(width: 5.0),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  widget.note.isFavourite != null
                                      ? const Icon(Icons.favorite,
                                          color: Color(0xffdc3545), size: 26.0)
                                      : Container(),
                                ],
                              ),
                            )
                          : Container(),
                      widget.note.deletedAt != null
                          ? Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 5.0, 0),
                              child: Tooltip(
                                message: 'Deleted time',
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      padding: settingNotifier
                                                  .isSetBackgroundImage ==
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
                                                  .getTopCardLabelStyle(
                                                      context)),
                                          const SizedBox(width: 5.0),
                                          Text(
                                            CommonConverters.toTimeString(
                                                time: widget.note.deletedAt!),
                                            style:
                                                CommonStyles.dateTimeTextStyle(
                                              color: ThemeDataCenter
                                                  .getTopCardLabelStyle(
                                                      context),
                                            ),
                                          ),
                                          const SizedBox(width: 5.0),
                                        ],
                                      ),
                                    ),
                                    widget.note.isFavourite != null
                                        ? const Icon(Icons.favorite,
                                            color: Color(0xffdc3545),
                                            size: 26.0)
                                        : Container(),
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
                              color: ThemeDataCenter.getBorderCardColorStyle(
                                  context),
                              width: 1.0),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              // height: 150,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: widget.subject != null &&
                                          settingNotifier
                                              .isSetColorAccordingSubjectColor!
                                      ? widget.subject!.color.toColor()
                                      : ThemeDataCenter
                                          .getNoteTopBannerCardBackgroundColor(
                                              context),
                                  shape: BoxShape.rectangle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
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
                                              : _onGetTitle(settingNotifier)),
                                      widget.redirectFrom !=
                                              RedirectFromEnum
                                                  .subjectsInFolderMode
                                          ? Container(
                                              child:
                                                  widget.note.deletedAt == null
                                                      ? Row(
                                                          children: [
                                                            widget.note.isLocked ==
                                                                    null
                                                                ? Tooltip(
                                                                    message: CommonLanguages.convert(
                                                                        lang: settingNotifier.languageString ??
                                                                            CommonLanguages
                                                                                .languageStringDefault(),
                                                                        word:
                                                                            'tooltip.button.update'),
                                                                    child: CoreElevatedButton
                                                                        .iconOnly(
                                                                      buttonAudio:
                                                                          commonAudioOnPressButton,
                                                                      onPressed:
                                                                          () {
                                                                        _onUpdate();
                                                                      },
                                                                      coreButtonStyle:
                                                                          ThemeDataCenter.getUpdateButtonStyle(
                                                                              context),
                                                                      icon: const Icon(
                                                                          Icons
                                                                              .edit_note_rounded,
                                                                          size:
                                                                              26.0),
                                                                    ),
                                                                  )
                                                                : Tooltip(
                                                                    message: CommonLanguages.convert(
                                                                        lang: settingNotifier.languageString ??
                                                                            CommonLanguages
                                                                                .languageStringDefault(),
                                                                        word:
                                                                            'tooltip.button.unlock'),
                                                                    child: CoreElevatedButton
                                                                        .iconOnly(
                                                                      buttonAudio:
                                                                          commonAudioOnPressButton,
                                                                      onPressed:
                                                                          () async {
                                                                        if (await CoreHelperWidget.confirmFunction(
                                                                            context:
                                                                                context,
                                                                            settingNotifier:
                                                                                settingNotifier)) {
                                                                          _onUnlockNote(context, widget.note)
                                                                              .then((result) {
                                                                            if (result) {
                                                                              setState(() {
                                                                                widget.note.isLocked = widget.note.isLocked == null ? DateTime.now().millisecondsSinceEpoch : null;
                                                                              });

                                                                              CoreNotification.showMessage(context, settingNotifier, CoreNotificationStatus.success, CommonLanguages.convert(lang: settingNotifier.languageString ?? CommonLanguages.languageStringDefault(), word: 'notification.action.unlocked'));
                                                                            } else {
                                                                              CoreNotification.showMessage(context, settingNotifier, CoreNotificationStatus.error, CommonLanguages.convert(lang: settingNotifier.languageString ?? CommonLanguages.languageStringDefault(), word: 'notification.action.error'));
                                                                            }
                                                                          });
                                                                        }
                                                                      },
                                                                      coreButtonStyle:
                                                                          ThemeDataCenter.getUpdateButtonStyle(
                                                                              context),
                                                                      icon: const Icon(
                                                                          Icons
                                                                              .lock_open_rounded,
                                                                          size:
                                                                              26.0),
                                                                    ),
                                                                  )
                                                          ],
                                                        )
                                                      : Column(
                                                          children: [
                                                            Tooltip(
                                                              message: CommonLanguages.convert(
                                                                  lang: settingNotifier
                                                                          .languageString ??
                                                                      CommonLanguages
                                                                          .languageStringDefault(),
                                                                  word:
                                                                      'tooltip.button.restore'),
                                                              child:
                                                                  CoreElevatedButton
                                                                      .iconOnly(
                                                                buttonAudio:
                                                                    commonAudioOnPressButton,
                                                                onPressed: () {
                                                                  _onRestoreNoteFromTrash(
                                                                          context)
                                                                      .then(
                                                                          (result) {
                                                                    if (result) {
                                                                      Provider.of<NoteNotifier>(
                                                                              context,
                                                                              listen: false)
                                                                          .onCountAll();

                                                                      Navigator
                                                                          .pushAndRemoveUntil(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                const NoteListScreen(
                                                                                  noteConditionModel: null,
                                                                                  isOpenSubjectsForFilter: null,
                                                                                  redirectFrom: null,
                                                                                )),
                                                                        (route) =>
                                                                            false,
                                                                      );

                                                                      CoreNotification.showMessage(
                                                                          context,
                                                                          settingNotifier,
                                                                          CoreNotificationStatus
                                                                              .success,
                                                                          CommonLanguages.convert(
                                                                              lang: settingNotifier.languageString ?? CommonLanguages.languageStringDefault(),
                                                                              word: 'notification.action.restored'));
                                                                    } else {
                                                                      CoreNotification.showMessage(
                                                                          context,
                                                                          settingNotifier,
                                                                          CoreNotificationStatus
                                                                              .error,
                                                                          CommonLanguages.convert(
                                                                              lang: settingNotifier.languageString ?? CommonLanguages.languageStringDefault(),
                                                                              word: 'notification.action.error'));
                                                                    }
                                                                  });
                                                                },
                                                                coreButtonStyle:
                                                                    ThemeDataCenter
                                                                        .getRestoreButtonStyle(
                                                                            context),
                                                                icon: const Icon(
                                                                    Icons
                                                                        .restore_from_trash_rounded,
                                                                    size: 26.0),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                height: 2.0),
                                                            Tooltip(
                                                              message: CommonLanguages.convert(
                                                                  lang: settingNotifier
                                                                          .languageString ??
                                                                      CommonLanguages
                                                                          .languageStringDefault(),
                                                                  word:
                                                                      'tooltip.button.deleteForever'),
                                                              child:
                                                                  CoreElevatedButton
                                                                      .iconOnly(
                                                                buttonAudio:
                                                                    commonAudioOnPressButton,
                                                                onPressed:
                                                                    () async {
                                                                  if (await CoreHelperWidget.confirmFunction(
                                                                      context:
                                                                          context,
                                                                      settingNotifier:
                                                                          settingNotifier)) {
                                                                    _onDeleteNoteForever(
                                                                            context)
                                                                        .then(
                                                                            (result) {
                                                                      if (result) {
                                                                        Provider.of<NoteNotifier>(context,
                                                                                listen: false)
                                                                            .onCountAll();

                                                                        Navigator
                                                                            .pushAndRemoveUntil(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => const NoteListScreen(
                                                                                    noteConditionModel: null,
                                                                                    isOpenSubjectsForFilter: null,
                                                                                    redirectFrom: null,
                                                                                  )),
                                                                          (route) =>
                                                                              false,
                                                                        );

                                                                        CoreNotification.showMessage(
                                                                            context,
                                                                            settingNotifier,
                                                                            CoreNotificationStatus
                                                                                .success,
                                                                            CommonLanguages.convert(
                                                                                lang: settingNotifier.languageString ?? CommonLanguages.languageStringDefault(),
                                                                                word: 'notification.action.deleted'));
                                                                      } else {
                                                                        CoreNotification.showMessage(
                                                                            context,
                                                                            settingNotifier,
                                                                            CoreNotificationStatus
                                                                                .error,
                                                                            CommonLanguages.convert(
                                                                                lang: settingNotifier.languageString ?? CommonLanguages.languageStringDefault(),
                                                                                word: 'notification.action.error'));
                                                                      }
                                                                    });
                                                                  }
                                                                },
                                                                coreButtonStyle:
                                                                    ThemeDataCenter
                                                                        .getDeleteForeverButtonStyle(
                                                                            context),
                                                                icon: const Icon(
                                                                    Icons
                                                                        .delete_forever_rounded,
                                                                    size: 26.0),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            _buildSubject(),
                            _buildLabels(),
                            ScrollOnExpand(
                              scrollOnExpand: true,
                              scrollOnCollapse: false,
                              child: ExpandablePanel(
                                theme: const ExpandableThemeData(
                                  headerAlignment:
                                      ExpandablePanelHeaderAlignment.center,
                                  tapBodyToCollapse: true,
                                ),
                                header: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        CommonLanguages.convert(
                                            lang: settingNotifier
                                                    .languageString ??
                                                CommonLanguages
                                                    .languageStringDefault(),
                                            word: 'screen.title.content'),
                                        style: const TextStyle(
                                            fontSize: 13.0,
                                            color: Colors.black45),
                                      ),
                                    ],
                                  ),
                                ),
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
                                            controller:
                                                _subDescriptionQuillController,
                                            readOnly:
                                                true, // true for view only mode
                                            autoFocus: false,
                                            expands: false,
                                            focusNode: _focusNode,
                                            padding: const EdgeInsets.all(4.0),
                                            scrollController: _scrollController,
                                            scrollable: false,
                                            showCursor: false),
                                      ),
                                    ),
                                    Text(
                                      '...',
                                      style: GoogleFonts.montserrat(
                                          fontStyle: FontStyle.italic,
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                                expanded: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    flutter_quill.QuillEditor(
                                        controller: _descriptionQuillController,
                                        readOnly:
                                            true, // true for view only mode
                                        autoFocus: false,
                                        expands: false,
                                        focusNode: _focusNode,
                                        padding: const EdgeInsets.all(4.0),
                                        scrollController: _scrollController,
                                        scrollable: false,
                                        showCursor: false),
                                    GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                            color: Colors.transparent,
                                            child: _buildSelectedImages(
                                                context, settingNotifier)))
                                  ],
                                ),
                                builder: (_, collapsed, expanded) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10, bottom: 10),
                                    child: Expandable(
                                      collapsed: collapsed,
                                      expanded: expanded,
                                      theme: const ExpandableThemeData(
                                          crossFadePoint: 0),
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedImages(
      BuildContext context, SettingNotifier settingNotifier) {
    if (_imageSourceStrings.isNotEmpty) {
      if (_imageSourceStrings.length == 1) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _imageSourceStrings.length,
                (index) => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
                  child: GestureDetector(
                    onTap: () async {
                      await showDialog<bool>(
                          context: context,
                          barrierDismissible: true,
                          builder: (BuildContext context) {
                            return CoreBasicDialog(
                              insetPadding: const EdgeInsets.all(5.0),
                              backgroundColor: Colors.white.withOpacity(0.95),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: SizedBox(
                                height:
                                CommonDimensions.maxHeightScreen(context) *
                                    0.75,
                                child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        5.0, 20.0, 5.0, 10.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                CommonLanguages.convert(
                                                    lang: settingNotifier
                                                        .languageString ??
                                                        CommonLanguages
                                                            .languageStringDefault(),
                                                    word:
                                                    'screen.title.viewImage'),
                                                style: CommonStyles
                                                    .screenTitleTextStyle(
                                                    fontSize: 16.0,
                                                    color: const Color(
                                                        0xFF1f1f1f)),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10.0),
                                        Expanded(
                                          child: Container(
                                            constraints: BoxConstraints(
                                                maxWidth: CommonDimensions
                                                    .maxWidthScreen(
                                                    context) *
                                                    0.9),
                                            child: PhotoView(
                                              maxScale: 25.0,
                                              minScale: 0.1,
                                              backgroundDecoration:
                                              const BoxDecoration(
                                                  color:
                                                  Colors.transparent),
                                              imageProvider: FileImage(File(
                                                  _imageSourceStrings[index])),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10.0),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            CoreElevatedButton.icon(
                                              playSound: false,
                                              buttonAudio:
                                              commonAudioOnPressButton,
                                              icon: const FaIcon(
                                                  FontAwesomeIcons.xmark,
                                                  size: 18.0),
                                              label: Text(
                                                  CommonLanguages.convert(
                                                      lang: settingNotifier
                                                          .languageString ??
                                                          CommonLanguages
                                                              .languageStringDefault(),
                                                      word:
                                                      'button.title.close'),
                                                  style: CommonStyles
                                                      .labelTextStyle),
                                              onPressed: () {
                                                if (Navigator.canPop(context)) {
                                                  Navigator.pop(context, true);
                                                }
                                              },
                                              coreButtonStyle:
                                              CoreButtonStyle.options(
                                                  coreStyle:
                                                  CoreStyle.filled,
                                                  coreColor:
                                                  CoreColor.success,
                                                  coreRadius:
                                                  CoreRadius.radius_6,
                                                  kitBorderColorOption:
                                                  Colors.black,
                                                  kitForegroundColorOption:
                                                  Colors.black,
                                                  coreFixedSizeButton:
                                                  CoreFixedSizeButton
                                                      .medium_48),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )),
                              ),
                            );
                          });
                    },
                    child: Material(
                      elevation: 3,
                      borderRadius: BorderRadius.circular(5.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: Container(
                          constraints: BoxConstraints(
                              maxWidth:
                              CommonDimensions.maxWidthScreen(context) *
                                  0.7),
                          child: Image.file(
                            File(_imageSourceStrings[index]),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        int viewingIndex = 0;
        String? viewingImageSourceString;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              _imageSourceStrings.length,
                  (index) => Padding(
                padding: const EdgeInsets.all(5.0),
                child: GestureDetector(
                  onTap: () async {
                    viewingIndex = index;
                    viewingImageSourceString = _imageSourceStrings[index];
                    await showDialog<bool>(
                        context: context,
                        barrierDismissible: true,
                        builder: (BuildContext context) {
                          return CoreBasicDialog(
                              insetPadding: const EdgeInsets.all(5.0),
                              backgroundColor: Colors.white.withOpacity(0.95),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: StatefulBuilder(builder:
                                  (BuildContext context, StateSetter setState) {
                                return SizedBox(
                                  height: CommonDimensions.maxHeightScreen(
                                      context) *
                                      0.75,
                                  child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          5.0, 20.0, 5.0, 10.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  CommonLanguages.convert(
                                                      lang: settingNotifier
                                                          .languageString ??
                                                          CommonLanguages
                                                              .languageStringDefault(),
                                                      word:
                                                      'screen.title.viewImage'),
                                                  style: CommonStyles
                                                      .screenTitleTextStyle(
                                                      fontSize: 16.0,
                                                      color: const Color(
                                                          0xFF1f1f1f)),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10.0),
                                          Expanded(
                                            child: Container(
                                              constraints: BoxConstraints(
                                                  maxWidth: CommonDimensions
                                                      .maxWidthScreen(
                                                      context) *
                                                      0.9),
                                              child: PhotoView(
                                                maxScale: 25.0,
                                                minScale: 0.1,
                                                backgroundDecoration:
                                                const BoxDecoration(
                                                    color:
                                                    Colors.transparent),
                                                imageProvider: FileImage(File(
                                                    viewingImageSourceString ??
                                                        _imageSourceStrings[
                                                        index])),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10.0),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                4.0, 0, 4.0, 0),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                CoreElevatedButton.iconOnly(
                                                  playSound: false,
                                                  buttonAudio:
                                                  commonAudioOnPressButton,
                                                  onPressed: () {
                                                    if (viewingIndex > 0) {
                                                      setState(() {
                                                        viewingIndex--;
                                                        viewingImageSourceString =
                                                        _imageSourceStrings[
                                                        viewingIndex];
                                                      });
                                                    }
                                                  },
                                                  coreButtonStyle:
                                                  ThemeDataCenter
                                                      .getUpdateButtonStyle(
                                                      context),
                                                  icon: const Icon(
                                                      Icons
                                                          .arrow_back_ios_rounded,
                                                      size: 26.0),
                                                ),
                                                CoreElevatedButton.icon(
                                                  playSound: false,
                                                  buttonAudio:
                                                  commonAudioOnPressButton,
                                                  icon: const FaIcon(
                                                      FontAwesomeIcons.xmark,
                                                      size: 18.0),
                                                  label: Text(
                                                      CommonLanguages.convert(
                                                          lang: settingNotifier
                                                              .languageString ??
                                                              CommonLanguages
                                                                  .languageStringDefault(),
                                                          word:
                                                          'button.title.close'),
                                                      style: CommonStyles
                                                          .labelTextStyle),
                                                  onPressed: () {
                                                    if (Navigator.canPop(
                                                        context)) {
                                                      Navigator.pop(
                                                          context, true);
                                                    }
                                                  },
                                                  coreButtonStyle:
                                                  CoreButtonStyle.options(
                                                      coreStyle:
                                                      CoreStyle.filled,
                                                      coreColor:
                                                      CoreColor.success,
                                                      coreRadius: CoreRadius
                                                          .radius_6,
                                                      kitBorderColorOption:
                                                      Colors.black,
                                                      kitForegroundColorOption:
                                                      Colors.black,
                                                      coreFixedSizeButton:
                                                      CoreFixedSizeButton
                                                          .medium_48),
                                                ),
                                                CoreElevatedButton.iconOnly(
                                                  playSound: false,
                                                  buttonAudio:
                                                  commonAudioOnPressButton,
                                                  onPressed: () {
                                                    if (viewingIndex <
                                                        _imageSourceStrings
                                                            .length -
                                                            1) {
                                                      setState(() {
                                                        viewingIndex++;
                                                        viewingImageSourceString =
                                                        _imageSourceStrings[
                                                        viewingIndex];
                                                      });
                                                    }
                                                  },
                                                  coreButtonStyle:
                                                  ThemeDataCenter
                                                      .getUpdateButtonStyle(
                                                      context),
                                                  icon: const Icon(
                                                      Icons
                                                          .arrow_forward_ios_rounded,
                                                      size: 26.0),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )),
                                );
                              }));
                        });
                  },
                  child: Material(
                    elevation: 3,
                    borderRadius: BorderRadius.circular(5.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5.0),
                      child: SizedBox(
                        width: 100.0,
                        height: 100.0,
                        child: Image.file(
                          File(_imageSourceStrings[index]),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }
    }
    return Container();
  }
}
