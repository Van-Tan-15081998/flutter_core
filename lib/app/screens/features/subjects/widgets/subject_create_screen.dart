import 'dart:async';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_core_v3/app/library/extensions/extensions.dart';
import 'package:provider/provider.dart';
import '../../../../../core/components/actions/common_buttons/CoreButtonStyle.dart';
import '../../../../../core/components/actions/common_buttons/CoreElevatedButton.dart';
import '../../../../../core/components/containment/dialogs/CoreFullScreenDialog.dart';
import '../../../../../core/components/form/CoreTextFormField.dart';
import '../../../../../core/components/helper_widgets/CoreHelperWidget.dart';
import '../../../../../core/components/notifications/CoreNotification.dart';
import '../../../../library/common/languages/CommonLanguages.dart';
import '../../../../library/common/styles/CommonStyles.dart';
import '../../../../library/common/themes/ThemeDataCenter.dart';
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
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _color =
      Colors.blueGrey.withOpacity(0.85).value.toRadixString(16).substring(2);

  bool selectedSubjectDataLoaded = false;

  Color defaultColor = Colors.blueGrey;
  final ScrollController _controllerScrollController = ScrollController();

  final myController = TextEditingController();
  final myFocusNode = FocusNode();

  late StreamController<List<SubjectModel>?> _subjectStreamController;
  late Stream<List<SubjectModel>?> _subjectStream;
  List<SubjectModel>? subjectList = [];
  SubjectModel? selectedSubject;

  /*
  Get Subjects From DB
   */
  Future<List<SubjectModel>?> _fetchSubjects() async {
    List<SubjectModel>? subjects = await SubjectDatabaseManager.all();

    return subjects;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _subjectStreamController = StreamController<List<SubjectModel>?>();
    _subjectStream = _subjectStreamController.stream;
    _subjectStreamController.add(subjectList);

    _fetchSubjects().then((subjects) {
      if (subjects != null && subjects.isNotEmpty) {
        setState(() {
          /*
          Limit the subject list for choose
           */
          if (widget.parentSubject != null && subjects.isNotEmpty) {
            List<SubjectModel>? mySubjects = subjects
                .where((element) => element.id == widget.parentSubject!.id)
                .toList();
            if (mySubjects.isNotEmpty) {
              subjectList!.add(mySubjects.first);
            }
          } else if (widget.parentSubject == null) {
            subjectList = subjects;
          }
        });

        _subjectStreamController.add(subjectList);
      }
    });

    myFocusNode.requestFocus();

    // Update mode
    if (widget.subject is SubjectModel) {
      myController.text = widget.subject!.title;
      _title = widget.subject!.title;
      if (widget.subject!.color.isNotEmpty) {
        defaultColor = widget.subject!.color.toColor();
        _color = widget.subject!.color;
      }
    }
  }

  onBack() {
    if (myFocusNode.hasFocus) {
      myFocusNode.unfocus();
    }
  }

  @override
  void dispose() {
    _subjectStreamController.close();
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
                decoration: CommonStyles.titleScreenDecorationStyle(settingNotifier.isSetBackgroundImage),
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                          widget.subject == null
                              ? CommonLanguages.convert(
                                  lang: settingNotifier.languageString ??
                                      CommonLanguages.languageStringDefault(),
                                  word: 'screen.title.create')
                              : CommonLanguages.convert(
                                  lang: settingNotifier.languageString ??
                                      CommonLanguages.languageStringDefault(),
                                  word: 'screen.title.update'),
                          style: CommonStyles.screenTitleTextStyle(
                              fontSize: 22.0,
                              color: ThemeDataCenter.getScreenTitleTextColor(context)),
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
        if (_formKey.currentState!.validate()) {
          if (widget.subject == null &&
              widget.actionMode == ActionModeEnum.create) {
            final SubjectModel model = SubjectModel(
                title: _title,
                color: _color,
                parentId: selectedSubject?.id,
                createdAt: DateTime.now().millisecondsSinceEpoch,
                id: widget.subject?.id);

            _onCreateSubject(context, model).then((result) {
              if (result) {
                subjectNotifier.onCountAll();

                CoreNotification.show(context, CoreNotificationStatus.success,
                    CoreNotificationAction.create, 'Subject');

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
                CoreNotification.show(context, CoreNotificationStatus.error,
                    CoreNotificationAction.create, 'Subject');
              }
            });
          } else if (widget.subject != null &&
              widget.actionMode == ActionModeEnum.update) {
            final SubjectModel model = SubjectModel(
                title: _title,
                color: _color,
                parentId: selectedSubject?.id,
                createdAt: widget.subject?.createdAt,
                updatedAt: DateTime.now().millisecondsSinceEpoch,
                id: widget.subject?.id);

            _onUpdateSubject(context, model).then((result) {
              if (result) {
                CoreNotification.show(context, CoreNotificationStatus.success,
                    CoreNotificationAction.update, 'Subject');

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
                CoreNotification.show(context, CoreNotificationStatus.error,
                    CoreNotificationAction.update, 'Subject');
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
          if (await CoreHelperWidget.confirmFunction(context: context)) {
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
                          ],
                        ),
                        StreamBuilder<List<SubjectModel>?>(
                            stream: _subjectStream,
                            builder: (context, snapshot) {
                              if (snapshot.hasData &&
                                  snapshot.data != null &&
                                  snapshot.data!.isNotEmpty) {
                                _setSelectedSubject();

                                return Container(
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(12)),
                                      color: settingNotifier
                                                  .isSetBackgroundImage ==
                                              true
                                          ? Colors.white.withOpacity(0.65)
                                          : Colors.transparent),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: DropdownButtonFormField(
                                              isExpanded: true,
                                              decoration: InputDecoration(
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Color(0xff343a40),
                                                      width: 2),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Color(0xff343a40),
                                                      width: 2),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                filled: true,
                                                fillColor: Colors.white,
                                              ),
                                              dropdownColor: Colors.white,
                                              value: selectedSubject,
                                              onChanged:
                                                  (SubjectModel? newValue) {
                                                setState(() {
                                                  selectedSubject = newValue;
                                                });
                                              },
                                              items: snapshot.data!.map((item) {
                                                return DropdownMenuItem(
                                                  value: item,
                                                  child: Text(item.title,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1),
                                                );
                                              }).toList()),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return Text(
                                  'No subjects found',
                                  style: TextStyle(
                                      color: ThemeDataCenter
                                          .getFormFieldLabelColorStyle(
                                              context)),
                                );
                              }
                            }),
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
