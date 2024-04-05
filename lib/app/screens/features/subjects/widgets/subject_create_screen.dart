import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_core_v3/app/library/extensions/extensions.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../../../../core/components/actions/common_buttons/CoreButtonStyle.dart';
import '../../../../../core/components/actions/common_buttons/CoreElevatedButton.dart';
import '../../../../../core/components/containment/dialogs/CoreFullScreenDialog.dart';
import '../../../../../core/components/form/CoreTextFormField.dart';
import '../../../../../core/components/helper_widgets/CoreHelperWidget.dart';
import '../../../../../core/components/notifications/CoreNotification.dart';
import '../../../../library/common/styles/CommonStyles.dart';
import '../../../../library/enums/CommonEnums.dart';
import '../databases/subject_db_manager.dart';
import '../models/subject_model.dart';
import '../providers/subject_notifier.dart';
import 'subject_list_screen.dart';

class SubjectCreateScreen extends StatefulWidget {
  final SubjectModel? subject;
  final ActionModeEnum actionMode;
  const SubjectCreateScreen({super.key, this.subject, required this.actionMode});

  @override
  State<SubjectCreateScreen> createState() => _SubjectCreateScreenState();
}

class _SubjectCreateScreenState extends State<SubjectCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _color = '';

  Color defaultColor = Colors.black;
  final ScrollController _controllerScrollController = ScrollController();

  final myController = TextEditingController();
  final myFocusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    myFocusNode.requestFocus();

    // Update mode
    if(widget.subject is SubjectModel) {
      myController.text = widget.subject!.title;
      _title = widget.subject!.title;
      if (widget.subject!.color.isNotEmpty) {
        defaultColor = widget.subject!.color.toColor();
        _color = widget.subject!.color;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final subjectNotifier = Provider.of<SubjectNotifier>(context);

    return CoreFullScreenDialog(
      title: widget.subject == null ? 'Create Subject' : 'Edit Subject',
      isConfirmToClose: true,
      actions: AppBarActionButtonEnum.save,
      isShowGeneralActionButton: false,
      optionActionContent: Container(),
      onSubmit: () async {
        if (_formKey.currentState!.validate()) {
          if (widget.subject == null &&
              widget.actionMode == ActionModeEnum.create) {
            final SubjectModel model = SubjectModel(
                title: _title,
                color: _color,
                createdAt: DateTime.now().millisecondsSinceEpoch,
                id: widget.subject?.id);
            if (await SubjectDatabaseManager.create(model)) {
              subjectNotifier.refresh();
              subjectNotifier.onCountAll();
              CoreNotification.show(context, CoreNotificationStatus.success, CoreNotificationAction.create, 'Subject');

              // Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const SubjectListScreen(subjectConditionModel: null,)),
                    (route) => false,
              );
            }
          } else if (widget.subject != null &&
              widget.actionMode == ActionModeEnum.update) {
            final SubjectModel model = SubjectModel(
                title: _title,
                color: _color,
                createdAt: widget.subject?.createdAt,
                updatedAt: DateTime.now().millisecondsSinceEpoch,
                id: widget.subject?.id);
            if (await SubjectDatabaseManager.update(model)) {
              subjectNotifier.refresh();
              CoreNotification.show(context, CoreNotificationStatus.success, CoreNotificationAction.update, 'Subject');
              // Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const SubjectListScreen(subjectConditionModel: null,)),
                    (route) => false,
              );
            }
          }
        }
      },
      onRedo: () {

      },
      onUndo: () {

      },
      onBack: () {},
      bottomActionBar: [Container()],
      bottomActionBarScrollable: [Container()],
      child: WillPopScope(
        onWillPop: () async {
          if (await CoreHelperWidget.confirmFunction(context)) {

            myFocusNode.unfocus();
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
                  Padding(
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
                                             Icon( Icons.palette_rounded, size: 26.0, color: _color.toColor()),
                                            const SizedBox(width: 6.0),
                                            Text(_title.isNotEmpty
                                                ? _title
                                                : 'Your subject'),
                                          ],
                                        ),
                                      )),
                                )),
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
                        CoreTextFormField(
                          onChanged: (value) {
                            setState(() {
                              _title = value;
                            });
                          },
                          controller: myController,
                          focusNode: myFocusNode,
                          onValidator: (value) {
                            if (value == null || value.isEmpty) {
                              return const Text('Please enter your title', style: TextStyle(color: Colors.redAccent));
                            }
                            return null;
                          },
                          maxLength: 30,
                          icon: const Icon(Icons.edit, color: Colors.white54),
                          label: 'Title',
                          labelColor: Colors.white54,
                          placeholder: 'Enter you title',
                          helper: 'Please enter your title',
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
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
                                      builder: (BuildContext context) => Form(
                                            onWillPop: () async {
                                              return true;
                                            },
                                            child: Dialog(
                                                shape: RoundedRectangleBorder(
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
                                                        pickerColor: defaultColor, //default color
                                                        onColorChanged:
                                                            (Color color) {
                                                          setState(() {
                                                            _color = color.value
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
                                    kitForegroundColorOption: Colors.black,
                                    coreFixedSizeButton:
                                        CoreFixedSizeButton.medium_40),
                                child: Text('Choose color', style: CommonStyles.buttonTextStyle),
                              ),
                            ],
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
      ),
    );
  }
}
