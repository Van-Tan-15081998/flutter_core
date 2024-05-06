import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_core_v3/app/library/extensions/extensions.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/components/actions/common_buttons/CoreButtonStyle.dart';
import '../../../../../core/components/actions/common_buttons/CoreElevatedButton.dart';
import '../../../../../core/components/containment/dialogs/CoreFullScreenDialog.dart';
import '../../../../../core/components/form/CoreTextFormField.dart';
import '../../../../../core/components/helper_widgets/CoreHelperWidget.dart';
import '../../../../../core/components/notifications/CoreNotification.dart';
import '../../../../library/common/languages/CommonLanguages.dart';
import '../../../../library/common/styles/CommonStyles.dart';
import '../../../../library/common/themes/ThemeDataCenter.dart';
import '../../../../library/common/utils/CommonAudioOnPressButton.dart';
import '../../../../library/enums/CommonEnums.dart';
import '../../../setting/providers/setting_notifier.dart';
import '../databases/label_db_manager.dart';
import '../models/label_model.dart';
import '../providers/label_notifier.dart';
import 'label_detail_screen.dart';
import 'label_list_screen.dart';

class LabelCreateScreen extends StatefulWidget {
  final LabelModel? label;
  final ActionModeEnum actionMode;
  const LabelCreateScreen({super.key, this.label, required this.actionMode});

  @override
  State<LabelCreateScreen> createState() => _LabelCreateScreenState();
}

class _LabelCreateScreenState extends State<LabelCreateScreen> {
  CommonAudioOnPressButton commonAudioOnPressButton =
      CommonAudioOnPressButton();
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _color =
      Colors.blueGrey.withOpacity(0.85).value.toRadixString(16).substring(2);

  Color defaultColor = Colors.blueGrey;
  final ScrollController _controllerScrollController = ScrollController();

  final myController = TextEditingController();
  final myFocusNode = FocusNode();

  Future<bool> _onCreateLabel(BuildContext context, LabelModel label) async {
    return await LabelDatabaseManager.create(label);
  }

  Future<bool> _onUpdateLabel(BuildContext context, LabelModel label) async {
    return await LabelDatabaseManager.update(label);
  }

  Future<LabelModel?> _onGetUpdatedLabel(
      BuildContext context, LabelModel label) async {
    return await LabelDatabaseManager.getById(label.id!);
  }

  onBack() {
    if (myFocusNode.hasFocus) {
      myFocusNode.unfocus();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Update mode
    if (widget.label is LabelModel) {
      myController.text = widget.label!.title;
      _title = widget.label!.title;
      if (widget.label!.color.isNotEmpty) {
        defaultColor = widget.label!.color.toColor();
        _color = widget.label!.color;
      }
    }

    myFocusNode.requestFocus();
  }

  @override
  void dispose() {
    commonAudioOnPressButton.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final labelNotifier = Provider.of<LabelNotifier>(context);
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
                          widget.label == null
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
      isShowOptionActionButton: false,
      isConfirmToClose: true,
      actions: AppBarActionButtonEnum.save,
      isShowBottomActionButton: false,
      isShowGeneralActionButton: false,
      optionActionContent: Container(),
      onGoHome: () {},
      onSubmit: () async {
        if (_formKey.currentState!.validate()) {
          if (widget.label == null &&
              widget.actionMode == ActionModeEnum.create) {
            final LabelModel model = LabelModel(
                title: _title,
                color: _color,
                createdAt: DateTime.now().millisecondsSinceEpoch,
                id: widget.label?.id);

            _onCreateLabel(context, model).then((result) {
              if (result) {
                labelNotifier.onCountAll();

                CoreNotification.show(context, CoreNotificationStatus.success,
                    CoreNotificationAction.create, 'Label');

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
                CoreNotification.show(context, CoreNotificationStatus.error,
                    CoreNotificationAction.create, 'Label');
              }
            });
          } else if (widget.label != null &&
              widget.actionMode == ActionModeEnum.update) {
            final LabelModel model = LabelModel(
                title: _title,
                color: _color,
                createdAt: widget.label?.createdAt,
                updatedAt: DateTime.now().millisecondsSinceEpoch,
                id: widget.label?.id);

            _onUpdateLabel(context, model).then((result) {
              if (result) {
                CoreNotification.show(context, CoreNotificationStatus.success,
                    CoreNotificationAction.update, 'Label');

                _onGetUpdatedLabel(context, model).then((result) {
                  if (result != null) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LabelDetailScreen(
                                  label: result,
                                  redirectFrom: RedirectFromEnum.labelUpdate,
                                )),
                        (route) => false);
                  }
                });
              } else {
                CoreNotification.show(context, CoreNotificationStatus.error,
                    CoreNotificationAction.update, 'Label');
              }
            });
          }
        }
      },
      onRedo: null,
      onUndo: null,
      onBack: null,
      bottomActionBar: [Container()],
      bottomActionBarScrollable: [Container()],
      child: settingNotifier.isSetBackgroundImage == true
          ? DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                        settingNotifier.backgroundImageSourceString ??
                            CommonStyles.backgroundImageSourceStringDefault()),
                    fit: BoxFit.cover),
              ),
              child: _buildBody(context, settingNotifier),
            )
          : _buildBody(context, settingNotifier),
    );
  }

  WillPopScope _buildBody(
      BuildContext context, SettingNotifier settingNotifier) {
    return WillPopScope(
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
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      color: settingNotifier.isSetBackgroundImage == true
                          ? Colors.white.withOpacity(0.65)
                          : Colors.transparent),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DottedBorder(
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
                                            Icon(Icons.label_important_rounded,
                                                color: _color.toColor()),
                                            Flexible(
                                              child: Text(_title.isNotEmpty
                                                  ? _title
                                                  : 'Your label'),
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
                            margin: settingNotifier.isSetBackgroundImage == true
                                ? const EdgeInsets.fromLTRB(0, 5.0, 0, 2.0)
                                : const EdgeInsets.all(0),
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12)),
                                color:
                                    settingNotifier.isSetBackgroundImage == true
                                        ? Colors.white.withOpacity(0.65)
                                        : Colors.transparent),
                            child: Padding(
                              padding: settingNotifier.isSetBackgroundImage ==
                                      true
                                  ? const EdgeInsets.all(5.0)
                                  : const EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
                              child: Text(
                                CommonLanguages.convert(
                                        lang: settingNotifier.languageString ??
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
                                        .getFormFieldLabelColorStyle(context)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                            color: settingNotifier.isSetBackgroundImage == true
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
                          maxLength: 30,
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
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: settingNotifier.isSetBackgroundImage == true
                                ? const EdgeInsets.fromLTRB(0, 5.0, 0, 2.0)
                                : const EdgeInsets.all(0),
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12)),
                                color:
                                    settingNotifier.isSetBackgroundImage == true
                                        ? Colors.white.withOpacity(0.65)
                                        : Colors.transparent),
                            child: Padding(
                              padding: settingNotifier.isSetBackgroundImage ==
                                      true
                                  ? const EdgeInsets.all(5.0)
                                  : const EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
                              child: Text(
                                CommonLanguages.convert(
                                        lang: settingNotifier.languageString ??
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
                                        .getFormFieldLabelColorStyle(context)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                            color: settingNotifier.isSetBackgroundImage == true
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
                                                          : Colors.transparent,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        const BorderRadius.all(
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
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                                border:
                                                                    Border.all(
                                                                  color: Colors
                                                                      .black54,
                                                                  width: 1.0,
                                                                ),
                                                                borderRadius:
                                                                    const BorderRadius
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
                                                          BorderRadius.circular(
                                                              10.0),
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
                                                                (Color color) {
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
