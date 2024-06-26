import 'dart:convert';
import 'package:dotted_border/dotted_border.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core_v3/app/library/extensions/extensions.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_quill/flutter_quill.dart' as flutter_quill;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/components/actions/common_buttons/CoreButtonStyle.dart';
import '../../../../core/components/actions/common_buttons/CoreElevatedButton.dart';
import '../../../../core/components/containment/dialogs/CoreFullScreenDialog.dart';
import '../../../../core/components/helper_widgets/CoreHelperWidget.dart';
import '../../../../core/components/notifications/CoreNotification.dart';
import '../../../library/common/converters/CommonConverters.dart';
import '../../../library/common/languages/CommonLanguages.dart';
import '../../../library/common/styles/CommonStyles.dart';
import '../../../library/common/themes/ThemeDataCenter.dart';
import '../../../library/common/utils/CommonAudioOnPressButton.dart';
import '../../../library/enums/CommonEnums.dart';
import '../../setting/providers/setting_notifier.dart';
import '../label/models/label_model.dart';
import '../subjects/models/subject_condition_model.dart';
import '../subjects/models/subject_model.dart';
import '../subjects/widgets/subject_list_screen.dart';
import 'databases/template_db_manager.dart';
import 'models/template_model.dart';
import 'providers/template_notifier.dart';
import 'template_create_screen.dart';
import 'template_list_screen.dart';

class TemplateDetailScreen extends StatefulWidget {
  final TemplateModel template;
  final List<LabelModel>? labels;
  final SubjectModel? subject;

  final RedirectFromEnum? redirectFrom;

  const TemplateDetailScreen(
      {super.key,
      required this.template,
      required this.subject,
      required this.labels,
      required this.redirectFrom});

  @override
  State<TemplateDetailScreen> createState() => _TemplateDetailScreenState();
}

class _TemplateDetailScreenState extends State<TemplateDetailScreen> {
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

  _onUpdate() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TemplateCreateScreen(
                  template: widget.template,
                  subject: null,
                  actionMode: ActionModeEnum.update,
                )));
  }

  Future<bool> _onDeleteTemplate(BuildContext context) async {
    return await TemplateDatabaseManager.delete(
        widget.template, DateTime.now().millisecondsSinceEpoch);
  }

  Future<bool> _onDeleteTemplateForever(BuildContext context) async {
    return await TemplateDatabaseManager.deleteForever(widget.template);
  }

  Future<bool> _onRestoreTemplateFromTrash(BuildContext context) async {
    return await TemplateDatabaseManager.restoreFromTrash(
        widget.template, DateTime.now().millisecondsSinceEpoch);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.template.title.isNotEmpty) {
      /// Set data for input
      List<dynamic> deltaMap = jsonDecode(widget.template.title);

      flutter_quill.Delta delta = flutter_quill.Delta.fromJson(deltaMap);

      setState(() {
        _titleQuillController.document =
            flutter_quill.Document.fromDelta(delta);
      });

      /// Set selection
    }

    if (widget.template.description.isNotEmpty) {
      /// Set data for input
      List<dynamic> deltaMap = jsonDecode(widget.template.description);

      flutter_quill.Delta delta = flutter_quill.Delta.fromJson(deltaMap);

      setState(() {
        _descriptionQuillController.document =
            flutter_quill.Document.fromDelta(delta);
      });

      if (_descriptionQuillController.document.toString().isNotEmpty) {
        List<dynamic> deltaMap = jsonDecode(widget.template.description);

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
  }

  @override
  void dispose() {
    commonAudioOnPressButton.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  setDocuments() {
    if (widget.template.title.isNotEmpty) {
      /// Set data for input
      List<dynamic> deltaMap = jsonDecode(widget.template.title);

      flutter_quill.Delta delta = flutter_quill.Delta.fromJson(deltaMap);

      setState(() {
        _titleQuillController.document =
            flutter_quill.Document.fromDelta(delta);
      });

      /// Set selection
    }

    if (widget.template.description.isNotEmpty) {
      /// Set data for input
      List<dynamic> deltaMap = jsonDecode(widget.template.description);

      flutter_quill.Delta delta = flutter_quill.Delta.fromJson(deltaMap);

      setState(() {
        _descriptionQuillController.document =
            flutter_quill.Document.fromDelta(delta);
      });

      if (_descriptionQuillController.document.toString().isNotEmpty) {
        List<dynamic> deltaMap = jsonDecode(widget.template.description);

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
    List<dynamic> deltaMap = jsonDecode(widget.template.title);

    flutter_quill.Delta delta = flutter_quill.Delta.fromJson(deltaMap);

    var list = delta.toList();
    if (list.length == 1) {
      if (list[0].key == 'insert' && list[0].data == '\n') {
        return false;
      }
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
                  onTap: () {
                    SubjectConditionModel subjectConditionModel =
                        SubjectConditionModel();
                    subjectConditionModel.id = widget.subject!.id;
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SubjectListScreen(
                                  subjectConditionModel: subjectConditionModel,
                                  redirectFrom: null,
                                  breadcrumb: null,
                                )),
                        (route) => false);
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
    if (widget.redirectFrom == RedirectFromEnum.templateUpdate) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => const TemplateListScreen(
                  templateConditionModel: null,
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
                                word: 'screen.title.detail.template'),
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
            word: 'screen.title.templates'),
        onGoHome: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => const TemplateListScreen(
                      templateConditionModel: null,
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
        child: _buildBody(context, settingNotifier),
      ),
    );
  }

  Widget _buildBody(BuildContext context, SettingNotifier settingNotifier) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Column(
        children: <Widget>[
          Slidable(
            key: const ValueKey(0),
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                widget.template.deletedAt == null
                    ? SlidableAction(
                        flex: 1,
                        onPressed: (context) {
                          // _onDelete();
                          _onDeleteTemplate(context).then((result) {
                            if (result) {
                              Provider.of<TemplateNotifier>(context,
                                      listen: false)
                                  .onCountAll();

                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const TemplateListScreen(
                                          templateConditionModel: null,
                                          redirectFrom: null,
                                        )),
                                (route) => false,
                              );

                              CoreNotification.showMessage(
                                  context,
                                  settingNotifier,
                                  CoreNotificationStatus.success,
                                  CommonLanguages.convert(
                                      lang: settingNotifier.languageString ??
                                          CommonLanguages
                                              .languageStringDefault(),
                                      word: 'notification.action.deleted'));
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
                    widget.template.updatedAt == null &&
                            widget.template.deletedAt == null
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
                                              time: widget.template.createdAt!),
                                          style: CommonStyles.dateTimeTextStyle(
                                              color: ThemeDataCenter
                                                  .getTopCardLabelStyle(
                                                      context)),
                                        ),
                                        const SizedBox(width: 5.0),
                                        widget.template.isFavourite != null
                                            ? const Icon(Icons.favorite,
                                                color: Color(0xffdc3545),
                                                size: 26.0)
                                            : Container(),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        : Container(),
                    widget.template.updatedAt != null &&
                            widget.template.deletedAt == null
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
                                                time:
                                                    widget.template.updatedAt!),
                                            style:
                                                CommonStyles.dateTimeTextStyle(
                                                    color: ThemeDataCenter
                                                        .getTopCardLabelStyle(
                                                            context))),
                                        const SizedBox(width: 5.0),
                                        widget.template.isFavourite != null
                                            ? const Icon(Icons.favorite,
                                                color: Color(0xffdc3545),
                                                size: 26.0)
                                            : Container(),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        : Container(),
                    widget.template.deletedAt != null
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
                                                time:
                                                    widget.template.deletedAt!),
                                            style:
                                                CommonStyles.dateTimeTextStyle(
                                                    color: ThemeDataCenter
                                                        .getTopCardLabelStyle(
                                                            context))),
                                        const SizedBox(width: 5.0),
                                        widget.template.isFavourite != null
                                            ? const Icon(Icons.favorite,
                                                color: Color(0xffdc3545),
                                                size: 26.0)
                                            : Container(),
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
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                115.0,
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
                                                        10.0, 10.0, 10.0, 10.0),
                                                scrollController:
                                                    _scrollController,
                                                scrollable: false,
                                                showCursor: false)
                                            : _onGetTitle(settingNotifier)),
                                    widget.template.deletedAt == null
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
                                                _onUpdate();
                                              },
                                              coreButtonStyle: ThemeDataCenter
                                                  .getUpdateButtonStyle(
                                                      context),
                                              icon: const Icon(
                                                  Icons.edit_note_rounded,
                                                  size: 26.0),
                                            ),
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
                                                    CoreElevatedButton.iconOnly(
                                                  buttonAudio:
                                                      commonAudioOnPressButton,
                                                  onPressed: () {
                                                    _onRestoreTemplateFromTrash(
                                                            context)
                                                        .then((result) {
                                                      if (result) {
                                                        Provider.of<TemplateNotifier>(
                                                                context,
                                                                listen: false)
                                                            .onCountAll();

                                                        Navigator
                                                            .pushAndRemoveUntil(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const TemplateListScreen(
                                                                    templateConditionModel:
                                                                        null,
                                                                    redirectFrom:
                                                                        null,
                                                                  )),
                                                          (route) => false,
                                                        );

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
                                                  coreButtonStyle:
                                                      CoreButtonStyle.info(
                                                          kitRadius: 6.0),
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
                                                child:
                                                    CoreElevatedButton.iconOnly(
                                                  buttonAudio:
                                                      commonAudioOnPressButton,
                                                  onPressed: () async {
                                                    if (await CoreHelperWidget
                                                        .confirmFunction(
                                                            context: context,
                                                            settingNotifier:
                                                                settingNotifier)) {
                                                      _onDeleteTemplateForever(
                                                              context)
                                                          .then((result) {
                                                        if (result) {
                                                          Provider.of<TemplateNotifier>(
                                                                  context,
                                                                  listen: false)
                                                              .onCountAll();

                                                          Navigator
                                                              .pushAndRemoveUntil(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const TemplateListScreen(
                                                                          templateConditionModel:
                                                                              null,
                                                                          redirectFrom:
                                                                              null,
                                                                        )),
                                                            (route) => false,
                                                          );

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
                                                  coreButtonStyle:
                                                      CoreButtonStyle.danger(
                                                          kitRadius: 6.0),
                                                  icon: const Icon(
                                                      Icons
                                                          .delete_forever_rounded,
                                                      size: 26.0),
                                                ),
                                              ),
                                            ],
                                          )
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
                                          lang:
                                              settingNotifier.languageString ??
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
                                      readOnly: true, // true for view only mode
                                      autoFocus: false,
                                      expands: false,
                                      focusNode: _focusNode,
                                      padding: const EdgeInsets.all(4.0),
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
    );
  }
}
