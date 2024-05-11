import 'dart:async';
import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_core_v3/app/library/extensions/extensions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../../../../../core/components/actions/common_buttons/CoreButtonStyle.dart';
import '../../../../../core/components/actions/common_buttons/CoreElevatedButton.dart';
import '../../../../../core/components/containment/dialogs/CoreBasicDialog.dart';
import '../../../../../core/components/containment/dialogs/CoreFullScreenDialog.dart';
import '../../../../../core/components/form/CoreTextFormField.dart';
import '../../../../../core/components/helper_widgets/CoreHelperWidget.dart';
import '../../../../../core/components/notifications/CoreNotification.dart';
import '../../../../library/common/dimensions/CommonDimensions.dart';
import '../../../../library/common/languages/CommonLanguages.dart';
import '../../../../library/common/styles/CommonStyles.dart';
import '../../../../library/common/themes/ThemeDataCenter.dart';
import '../../../../library/common/utils/CommonAudioOnPressButton.dart';
import '../../../../library/enums/CommonEnums.dart';
import '../../../setting/providers/setting_notifier.dart';
import '../../note/note_list_screen.dart';
import '../databases/subject_db_manager.dart';
import '../models/subject_model.dart';
import '../providers/subject_notifier.dart';
import 'subject_detail_screen.dart';
import 'subject_list_screen.dart';

class SubjectCreateScreen extends StatefulWidget {
  final SubjectModel? subject;
  final SubjectModel? parentSubject;
  final ActionModeEnum actionMode;
  final RedirectFromEnum? redirectFrom;
  final List<SubjectModel>? breadcrumb;
  const SubjectCreateScreen(
      {super.key,
      this.subject,
      required this.parentSubject,
      required this.actionMode,
      required this.redirectFrom,
      required this.breadcrumb});

  @override
  State<SubjectCreateScreen> createState() => _SubjectCreateScreenState();
}

class _SubjectCreateScreenState extends State<SubjectCreateScreen> {
  CommonAudioOnPressButton commonAudioOnPressButton =
      CommonAudioOnPressButton();
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _color =
      Colors.blueGrey.withOpacity(0.85).value.toRadixString(16).substring(2);
  String? _avatarSourceString;
  String _oldAvatarSourceString = '';

  bool selectedSubjectDataLoaded = false;
  bool reloadMark = false;

  Color defaultColor = Colors.blueGrey;
  final ScrollController _controllerScrollController = ScrollController();

  final myController = TextEditingController();
  final myFocusNode = FocusNode();

  List<SubjectModel>? subjectList = [];
  SubjectModel? selectedSubject;

  /*
  Get Subjects From DB
   */
  Future<List<SubjectModel>?> _fetchSubjects() async {
    List<SubjectModel>? subjects = await SubjectDatabaseManager.all();

    return subjects;
  }

  Future<void> loadAvatarImageData() async {
    if (widget.subject!.avatarSourceString != null &&
        widget.subject!.avatarSourceString!.isNotEmpty) {
      bool isExist = await File(widget.subject!.avatarSourceString!).exists();

      if (isExist) {
        _avatarSourceString = widget.subject!.avatarSourceString.toString();
        _oldAvatarSourceString = _avatarSourceString!;
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _fetchSubjects().then((subjects) {
      if (subjects != null && subjects.isNotEmpty) {
        /*
          Limit the subject list for choose
           */
        if (widget.parentSubject != null && subjects.isNotEmpty) {
          List<SubjectModel>? mySubjects = subjects
              .where((element) => element.id == widget.parentSubject!.id)
              .toList();
          if (mySubjects.isNotEmpty) {
            setState(() {
              subjectList!.add(mySubjects.first);
            });
          }
        } else if (widget.parentSubject == null) {
          setState(() {
            subjectList = subjects;

            // Except it self
            if (subjectList != null &&
                subjectList!.isNotEmpty &&
                widget.subject != null &&
                widget.actionMode == ActionModeEnum.update) {
              subjectList!
                  .removeWhere((element) => element.id == widget.subject!.id);
            }
          });
        }
        _setSelectedSubject();
      }
    });

    myFocusNode.requestFocus();

    // Update mode
    if (widget.subject != null && widget.actionMode == ActionModeEnum.update) {
      myController.text = widget.subject!.title;
      _title = widget.subject!.title;
      if (widget.subject!.color.isNotEmpty) {
        defaultColor = widget.subject!.color.toColor();
        _color = widget.subject!.color;
      }
      loadAvatarImageData();
    }
  }

  onBack() {
    if (myFocusNode.hasFocus) {
      myFocusNode.unfocus();
    }
  }

  @override
  void dispose() {
    commonAudioOnPressButton.dispose();
    super.dispose();
  }

  Future<bool> _onCreateSubject(
      BuildContext context, SubjectModel subject) async {
    return await SubjectDatabaseManager.create(subject);
  }

  Future<bool> _onUpdateSubject(
      BuildContext context, SubjectModel subject) async {
    return await SubjectDatabaseManager.update(subject);
  }

  Future<SubjectModel?> _onGetUpdatedSubject(
      BuildContext context, SubjectModel subject) async {
    return await SubjectDatabaseManager.getById(subject.id!);
  }

  Future<void> _pickImage(
      ImageSource source, SettingNotifier settingNotifier) async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _avatarSourceString = pickedFile.path;
      });
    }
  }

  Future<String?> _saveImage(String? imagePath) async {
    if (imagePath != null && imagePath.isNotEmpty) {
      final imageFile = File(imagePath);
      final appDirectory = await getApplicationDocumentsDirectory();

      String fileName = imageFile.path.split('/').last;
      String fileExtension = fileName.split('.').last;

      final savedImageFile = await imageFile.copy(
          '${appDirectory.path}/image_${DateTime.now().millisecondsSinceEpoch}.$fileExtension');

      if (savedImageFile.path.isNotEmpty) {
        return savedImageFile.path;
      }
    }
    return null;
  }

  _deleteImage(String filePath) {
    File file = File(filePath);
    if (file.existsSync()) {
      file.deleteSync();
    }
  }

  _setSelectedSubject() {
    /*
    Update subject
     */
    if (widget.subject?.parentId != null) {
      List<SubjectModel>? subjects;

      if (subjectList != null &&
          subjectList!.isNotEmpty &&
          !selectedSubjectDataLoaded) {
        subjects = subjectList!
            .where((model) => widget.subject!.parentId == model.id)
            .toList();

        if (subjects.isNotEmpty) {
          selectedSubject = subjects.first;

          selectedSubjectDataLoaded = true;
        }
      }
    }

    /*
    Create sub subject
     */
    if (widget.parentSubject != null && subjectList!.isNotEmpty) {
      selectedSubject = subjectList!.first;
    }
  }

  void showPopupSelectSubject(
      BuildContext context, SettingNotifier settingNotifier) async {
    if (subjectList != null && subjectList!.isNotEmpty) {
      bool? result = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: CoreBasicDialog(
            insetPadding: const EdgeInsets.all(5.0),
            backgroundColor: Colors.white.withOpacity(0.95),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: SizedBox(
              height: CommonDimensions.maxHeightScreen(context) * 0.75,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(5.0, 20.0, 5.0, 10.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            CommonLanguages.convert(
                                lang: settingNotifier.languageString ??
                                    CommonLanguages.languageStringDefault(),
                                word: 'button.title.selectSubject'),
                            style: CommonStyles.screenTitleTextStyle(
                                fontSize: 16.0, color: const Color(0xFF1f1f1f)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Expanded(
                      child: StatefulBuilder(builder:
                          (BuildContext context, StateSetter setState) {
                        return ListView.builder(
                            itemCount: subjectList!.length,
                            itemBuilder: (context, index) {
                              return Container(
                                color: selectedSubject?.id ==
                                        subjectList![index].id
                                    ? Colors.lightGreenAccent.withOpacity(0.3)
                                    : Colors.transparent,
                                child: SwitchListTile(
                                    title: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Flexible(
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.rectangle,
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(2.0),
                                                        child: DottedBorder(
                                                          borderType:
                                                              BorderType.RRect,
                                                          radius: const Radius
                                                              .circular(12),
                                                          color: subjectList![
                                                                  index]
                                                              .color
                                                              .toColor(),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                const BorderRadius
                                                                        .all(
                                                                    Radius
                                                                        .circular(
                                                                            12)),
                                                            child: Container(
                                                              color:
                                                                  Colors.white,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        6.0),
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    Icon(
                                                                      Icons
                                                                          .palette_rounded,
                                                                      color: subjectList![
                                                                              index]
                                                                          .color
                                                                          .toColor(),
                                                                    ),
                                                                    const SizedBox(
                                                                        width:
                                                                            6.0),
                                                                    Flexible(
                                                                      child: Text(
                                                                          subjectList![index]
                                                                              .title,
                                                                          maxLines:
                                                                              1,
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
                                        ],
                                      ),
                                    ),
                                    value:
                                        selectedSubject == subjectList![index],
                                    onChanged: (bool value) {
                                      if (value) {
                                        setState(() {
                                          selectedSubject = subjectList![index];
                                        });
                                      } else {
                                        setState(() {
                                          selectedSubject = null;
                                        });
                                      }
                                    }),
                              );
                            });
                      }),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CoreElevatedButton.icon(
                          buttonAudio: commonAudioOnPressButton,
                          icon:
                              const FaIcon(FontAwesomeIcons.check, size: 18.0),
                          label: Text(
                              CommonLanguages.convert(
                                  lang: settingNotifier.languageString ??
                                      CommonLanguages.languageStringDefault(),
                                  word: 'button.title.accept'),
                              style: CommonStyles.labelTextStyle),
                          onPressed: () {
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context, true);
                            }
                          },
                          coreButtonStyle: CoreButtonStyle.options(
                              coreStyle: CoreStyle.filled,
                              coreColor: CoreColor.success,
                              coreRadius: CoreRadius.radius_6,
                              kitBorderColorOption: Colors.black,
                              kitForegroundColorOption: Colors.black,
                              coreFixedSizeButton:
                                  CoreFixedSizeButton.medium_48),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      if (result == true) {
        onReSetState();
      }
    }
  }

  onReSetState() {
    setState(() {
      reloadMark = !reloadMark;
    });
  }

  Widget _buildSelectedAvatarImage() {
    if (_avatarSourceString != null && _avatarSourceString!.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white54,
                    width: 1.0,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  image: DecorationImage(
                      image: FileImage(File(_avatarSourceString!)),
                      fit: BoxFit.cover),
                ),
                child: const SizedBox(
                  width: 125.0,
                  height: 125.0,
                )),
            const SizedBox(width: 10.0),
            InkWell(
              onTap: () {
                if (_avatarSourceString != null &&
                    _avatarSourceString!.isNotEmpty) {
                  setState(() {
                    _avatarSourceString = null;
                  });
                }
              },
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      color:
                          ThemeDataCenter.getFilteringTextColorStyle(context),
                      width: 1.0,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                    color: Colors.white.withOpacity(0.65)),
                child: const Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Icon(
                    Icons.close_rounded,
                    size: 22,
                    color: Colors.redAccent,
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }
    return Container();
  }

  Widget _buildSelectedSubject() {
    if (selectedSubject != null) {
      return Padding(
        padding: const EdgeInsets.all(6.0),
        child: DottedBorder(
            borderType: BorderType.RRect,
            radius: const Radius.circular(12),
            color: selectedSubject!.color.toColor(),
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
                          color: selectedSubject!.color.toColor(),
                        ),
                        Flexible(
                          child: Text(selectedSubject!.title,
                              style: const TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.w500),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                  )),
            )),
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    final subjectNotifier = Provider.of<SubjectNotifier>(context);
    final settingNotifier = Provider.of<SettingNotifier>(context);

    return CoreFullScreenDialog(
      homeLabel: null,
      appbarLeading: null,
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
                        widget.subject == null
                            ? CommonLanguages.convert(
                                lang: settingNotifier.languageString ??
                                    CommonLanguages.languageStringDefault(),
                                word: 'screen.title.create.subject')
                            : CommonLanguages.convert(
                                lang: settingNotifier.languageString ??
                                    CommonLanguages.languageStringDefault(),
                                word: 'screen.title.update.subject'),
                        style: CommonStyles.screenTitleTextStyle(
                            fontSize: 16.0,
                            color: ThemeDataCenter.getScreenTitleTextColor(
                                context)),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      isShowOptionActionButton: false,
      isConfirmToClose: true,
      actions: AppBarActionButtonEnum.save,
      isShowBottomActionButton: false,
      isShowGeneralActionButton: false,
      optionActionContent: Container(),
      onGoHome: () {},
      onSubmit: () async {

        String? avatarPath;
        if (_formKey.currentState!.validate()) {
          if (widget.subject == null &&
              widget.actionMode == ActionModeEnum.create) {
            try {
              avatarPath = await _saveImage(_avatarSourceString);
            } catch (e) {
              CoreNotification.showMessage(
                  context,
                  settingNotifier,
                  CoreNotificationStatus.error,
                  CommonLanguages.convert(
                      lang: settingNotifier.languageString ??
                          CommonLanguages.languageStringDefault(),
                      word: 'notification.action.error'));
              return;
            }

            final SubjectModel model = SubjectModel(
                title: _title,
                color: _color,
                parentId: selectedSubject?.id,
                isSetShortcut: null,
                avatarSourceString: avatarPath,
                createdAt: DateTime.now().millisecondsSinceEpoch,
                id: widget.subject?.id);

            _onCreateSubject(context, model).then((result) {
              if (result) {
                subjectNotifier.onCountAll();

                CoreNotification.showMessage(
                    context,
                    settingNotifier,
                    CoreNotificationStatus.success,
                    CommonLanguages.convert(
                        lang: settingNotifier.languageString ??
                            CommonLanguages.languageStringDefault(),
                        word: 'notification.action.created'));

                if (widget.redirectFrom == RedirectFromEnum.notes) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NoteListScreen(
                                noteConditionModel: null,
                                isOpenSubjectsForFilter: true,
                                redirectFrom: RedirectFromEnum.subjectCreate,
                              )));
                } else if (widget.redirectFrom ==
                    RedirectFromEnum.subjectsInFolderMode) {
                  Navigator.pop(context, result);
                } else if (widget.redirectFrom == RedirectFromEnum.noteCreate) {
                  Navigator.pop(context, result);
                } else {
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
                }
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
          } else if (widget.subject != null &&
              widget.actionMode == ActionModeEnum.update) {
            String? avatarPath;
            try {
              avatarPath = await _saveImage(_avatarSourceString);

              // Delete old avatar if select a new avatar
              if (_oldAvatarSourceString.isNotEmpty &&
                  _oldAvatarSourceString != _avatarSourceString) {
                _deleteImage(_oldAvatarSourceString);
              }
            } catch (e) {
              CoreNotification.showMessage(
                  context,
                  settingNotifier,
                  CoreNotificationStatus.error,
                  CommonLanguages.convert(
                      lang: settingNotifier.languageString ??
                          CommonLanguages.languageStringDefault(),
                      word: 'notification.action.error'));
              return;
            }

            final SubjectModel model = SubjectModel(
                title: _title,
                color: _color,
                parentId: selectedSubject?.id,
                isSetShortcut: widget.subject?.isSetShortcut,
                avatarSourceString: avatarPath,
                createdAt: widget.subject?.createdAt,
                updatedAt: DateTime.now().millisecondsSinceEpoch,
                id: widget.subject?.id);

            _onUpdateSubject(context, model).then((result) {
              if (result) {
                CoreNotification.showMessage(
                    context,
                    settingNotifier,
                    CoreNotificationStatus.success,
                    CommonLanguages.convert(
                        lang: settingNotifier.languageString ??
                            CommonLanguages.languageStringDefault(),
                        word: 'notification.action.updated'));

                _onGetUpdatedSubject(context, model).then((getResult) {
                  if (getResult != null) {
                    if (widget.redirectFrom ==
                        RedirectFromEnum.subjectsInFolderMode) {
                      Navigator.pop(context, result);
                    } else {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SubjectDetailScreen(
                                    subject: getResult,
                                    redirectFrom:
                                        RedirectFromEnum.subjectUpdate,
                                  )),
                          (route) => false);
                    }
                  }
                });
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
          }
        }
      },
      onRedo: () {},
      onUndo: () {},
      onBack: () {},
      bottomActionBar: [Container()],
      bottomActionBarScrollable: [Container()],
      child: WillPopScope(
        onWillPop: () async {
          onBack();
          if (await CoreHelperWidget.confirmFunction(
              context: context,
              settingNotifier: settingNotifier,
              confirmExitScreen: true)) {
            return true;
          }
          return false;
        },
        child: GestureDetector(
          onTap: () {
            if (myFocusNode.hasFocus) {
              myFocusNode.unfocus();
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              controller: _controllerScrollController,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        color: settingNotifier.isSetBackgroundImage == true
                            ? Colors.white.withOpacity(0.65)
                            : Colors.transparent),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DottedBorder(
                        color: const Color(0xFF404040),
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(12),
                        padding: const EdgeInsets.all(6),
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                          child: SizedBox(
                            height: 200,
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                              child: DottedBorder(
                                  borderType: BorderType.RRect,
                                  radius: const Radius.circular(12),
                                  color: _color.toColor(),
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
                                              Icon(Icons.palette_rounded,
                                                  size: 26.0,
                                                  color: _color.toColor()),
                                              const SizedBox(width: 6.0),
                                              Flexible(
                                                child: Text(
                                                    _title.isNotEmpty
                                                        ? _title
                                                        : 'Your subject',
                                                    style: const TextStyle(
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.w400)),
                                              ),
                                            ],
                                          ),
                                        )),
                                  )),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: settingNotifier.isSetBackgroundImage ==
                                      true
                                  ? const EdgeInsets.fromLTRB(0, 5.0, 0, 2.0)
                                  : const EdgeInsets.all(0),
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12)),
                                  color: settingNotifier.isSetBackgroundImage ==
                                          true
                                      ? Colors.white.withOpacity(0.65)
                                      : Colors.transparent),
                              child: Padding(
                                padding: settingNotifier.isSetBackgroundImage ==
                                        true
                                    ? const EdgeInsets.all(5.0)
                                    : const EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
                                child: Text(
                                  CommonLanguages.convert(
                                          lang:
                                              settingNotifier.languageString ??
                                                  CommonLanguages
                                                      .languageStringDefault(),
                                          word: 'form.field.title.title')
                                      .addColon()
                                      .toString(),
                                  style: GoogleFonts.montserrat(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: ThemeDataCenter
                                          .getFormFieldLabelColorStyle(
                                              context)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                              color:
                                  settingNotifier.isSetBackgroundImage == true
                                      ? Colors.white.withOpacity(0.65)
                                      : Colors.transparent),
                          child: CoreTextFormField(
                            style: TextStyle(
                                color: ThemeDataCenter.getAloneTextColorStyle(
                                    context)),
                            onChanged: (value) {
                              setState(() {
                                _title = value;
                              });
                            },
                            controller: myController,
                            focusNode: myFocusNode,
                            validateString: 'Please enter your title',
                            maxLength: 60,
                            icon: Icon(Icons.edit,
                                color:
                                    ThemeDataCenter.getFormFieldLabelColorStyle(
                                        context)),
                            label: 'Title',
                            labelColor:
                                ThemeDataCenter.getFormFieldLabelColorStyle(
                                    context),
                            placeholder: 'Enter you title',
                            helper: '',
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: settingNotifier.isSetBackgroundImage ==
                                      true
                                  ? const EdgeInsets.fromLTRB(0, 5.0, 0, 2.0)
                                  : const EdgeInsets.all(0),
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12)),
                                  color: settingNotifier.isSetBackgroundImage ==
                                          true
                                      ? Colors.white.withOpacity(0.65)
                                      : Colors.transparent),
                              child: Padding(
                                padding: settingNotifier.isSetBackgroundImage ==
                                        true
                                    ? const EdgeInsets.all(5.0)
                                    : const EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
                                child: Text(
                                  CommonLanguages.convert(
                                          lang:
                                              settingNotifier.languageString ??
                                                  CommonLanguages
                                                      .languageStringDefault(),
                                          word: 'form.field.title.color')
                                      .addColon()
                                      .toString(),
                                  style: GoogleFonts.montserrat(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: ThemeDataCenter
                                          .getFormFieldLabelColorStyle(
                                              context)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                              color:
                                  settingNotifier.isSetBackgroundImage == true
                                      ? Colors.white.withOpacity(0.65)
                                      : Colors.transparent),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                        child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                          children: List.generate(
                                              CommonStyles
                                                      .commonSubjectColorStringList()
                                                  .length,
                                              (index) => Container(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: _color ==
                                                                CommonStyles
                                                                        .commonSubjectColorStringList()[
                                                                    index]
                                                            ? Colors.blue
                                                            : Colors
                                                                .transparent,
                                                        width: 1.0,
                                                      ),
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  10.0)),
                                                    ),
                                                    child: InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          _color = CommonStyles
                                                                  .commonSubjectColorStringList()[
                                                              index];
                                                        });
                                                      },
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5.0),
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                                  border: Border
                                                                      .all(
                                                                    color: Colors
                                                                        .black87,
                                                                    width: 1.0,
                                                                  ),
                                                                  borderRadius: const BorderRadius
                                                                          .all(
                                                                      Radius.circular(
                                                                          15.0)),
                                                                  color: CommonStyles
                                                                              .commonSubjectColorStringList()[
                                                                          index]
                                                                      .toColor()),
                                                          child: const SizedBox(
                                                            height: 22.0,
                                                            width: 22.0,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ))),
                                    ))
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 40.0,
                                      height: 40.0,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(6.0)),
                                        color: _color.toColor(),
                                      ),
                                    ),
                                    const SizedBox(width: 10.0),
                                    CoreElevatedButton(
                                      buttonAudio: commonAudioOnPressButton,
                                      onPressed: () async {
                                        myFocusNode.unfocus();
                                        await showDialog<bool>(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                Form(
                                                  onWillPop: () async {
                                                    return true;
                                                  },
                                                  child: Dialog(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                      ),
                                                      child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            MaterialPicker(
                                                              pickerColor:
                                                                  defaultColor, //default color
                                                              onColorChanged:
                                                                  (Color
                                                                      color) {
                                                                setState(() {
                                                                  _color = color
                                                                      .value
                                                                      .toRadixString(
                                                                          16)
                                                                      .substring(
                                                                          2); // Lấy giá trị hex và bỏ qua byte alpha (Color(0xff29b6f6) => 29b6f6)
                                                                });
                                                                // Khi su dung: String colorHex = "29b6f6";
                                                                // Color parsedColor = Color(int.parse("0xFF$colorHex", radix: 16)); Color(0xff29b6f6)
                                                              },
                                                            )
                                                          ])),
                                                ));
                                      },
                                      coreButtonStyle: CoreButtonStyle.options(
                                          coreStyle: CoreStyle.outlined,
                                          coreColor: CoreColor.dark,
                                          coreRadius: CoreRadius.radius_6,
                                          kitForegroundColorOption:
                                              const Color(0xff1f1f1f),
                                          coreFixedSizeButton:
                                              CoreFixedSizeButton.medium_40),
                                      child: Text('Color palette',
                                          style: CommonStyles.buttonTextStyle),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: settingNotifier.isSetBackgroundImage ==
                                      true
                                  ? const EdgeInsets.fromLTRB(0, 5.0, 0, 2.0)
                                  : const EdgeInsets.all(0),
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12)),
                                  color: settingNotifier.isSetBackgroundImage ==
                                          true
                                      ? Colors.white.withOpacity(0.65)
                                      : Colors.transparent),
                              child: Padding(
                                padding: settingNotifier.isSetBackgroundImage ==
                                        true
                                    ? const EdgeInsets.all(5.0)
                                    : const EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
                                child: Text(
                                  CommonLanguages.convert(
                                          lang:
                                              settingNotifier.languageString ??
                                                  CommonLanguages
                                                      .languageStringDefault(),
                                          word:
                                              'form.field.title.parentSubject')
                                      .addColon()
                                      .toString(),
                                  style: GoogleFonts.montserrat(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: ThemeDataCenter
                                          .getFormFieldLabelColorStyle(
                                              context)),
                                ),
                              ),
                            ),
                            subjectList != null && subjectList!.isNotEmpty
                                ? InkWell(
                                    onTap: () async {
                                      showPopupSelectSubject(
                                          context, settingNotifier);
                                    },
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: ThemeDataCenter
                                                .getFilteringTextColorStyle(
                                                    context),
                                            width: 1.0,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10.0)),
                                          color:
                                              Colors.white.withOpacity(0.65)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Row(
                                          children: [
                                            const FaIcon(
                                                FontAwesomeIcons.handPointRight,
                                                size: 20.0,
                                                color: Color(0xFF1f1f1f)),
                                            const SizedBox(width: 5.0),
                                            Text(
                                                CommonLanguages.convert(
                                                    lang: settingNotifier
                                                            .languageString ??
                                                        CommonLanguages
                                                            .languageStringDefault(),
                                                    word:
                                                        'button.title.selectSubject'),
                                                style: const TextStyle(
                                                    fontSize: 14.0,
                                                    color: Color(0xFF1f1f1f)))
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                        subjectList == null || subjectList!.isEmpty
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        16.0, 8.0, 16.0, 8.0),
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(24.0)),
                                        color: settingNotifier
                                                    .isSetBackgroundImage ==
                                                true
                                            ? Colors.white.withOpacity(0.65)
                                            : Colors.transparent),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        BounceInLeft(
                                            child: FaIcon(FontAwesomeIcons.waze,
                                                size: 30.0,
                                                color: ThemeDataCenter
                                                    .getAloneTextColorStyle(
                                                        context))),
                                        const SizedBox(width: 5),
                                        BounceInRight(
                                          child: Text(
                                              CommonLanguages.convert(
                                                  lang: settingNotifier
                                                          .languageString ??
                                                      CommonLanguages
                                                          .languageStringDefault(),
                                                  word:
                                                      'notification.noItem.subject'),
                                              style: GoogleFonts.montserrat(
                                                  fontStyle: FontStyle.italic,
                                                  fontSize: 16.0,
                                                  color: ThemeDataCenter
                                                      .getAloneTextColorStyle(
                                                          context),
                                                  fontWeight: FontWeight.w500)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildSelectedSubject(),
                          ],
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: settingNotifier.isSetBackgroundImage ==
                                      true
                                  ? const EdgeInsets.fromLTRB(0, 5.0, 0, 2.0)
                                  : const EdgeInsets.all(0),
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12)),
                                  color: settingNotifier.isSetBackgroundImage ==
                                          true
                                      ? Colors.white.withOpacity(0.65)
                                      : Colors.transparent),
                              child: Padding(
                                padding: settingNotifier.isSetBackgroundImage ==
                                        true
                                    ? const EdgeInsets.all(5.0)
                                    : const EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
                                child: Text(
                                  CommonLanguages.convert(
                                          lang:
                                              settingNotifier.languageString ??
                                                  CommonLanguages
                                                      .languageStringDefault(),
                                          word: 'form.field.title.avatar')
                                      .addColon()
                                      .toString(),
                                  style: GoogleFonts.montserrat(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: ThemeDataCenter
                                          .getFormFieldLabelColorStyle(
                                              context)),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                _pickImage(
                                    ImageSource.gallery, settingNotifier);
                              },
                              borderRadius: BorderRadius.circular(10.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: ThemeDataCenter
                                          .getFilteringTextColorStyle(context),
                                      width: 1.0,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10.0)),
                                    color: Colors.white.withOpacity(0.65)),
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Row(
                                    children: [
                                      const Icon(
                                          Icons.add_photo_alternate_outlined,
                                          size: 20.0,
                                          color: Color(0xFF1f1f1f)),
                                      const SizedBox(width: 5.0),
                                      Text(
                                          CommonLanguages.convert(
                                              lang: settingNotifier
                                                      .languageString ??
                                                  CommonLanguages
                                                      .languageStringDefault(),
                                              word:
                                                  'button.title.selectPicture'),
                                          style: const TextStyle(
                                              fontSize: 14.0,
                                              color: Color(0xFF1f1f1f)))
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildSelectedAvatarImage(),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
