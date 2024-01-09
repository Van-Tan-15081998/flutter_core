import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_core_v3/app/library/extensions/extensions.dart';

import '../../../../../core/components/actions/common_buttons/CoreButtonStyle.dart';
import '../../../../../core/components/actions/common_buttons/CoreElevatedButton.dart';
import '../../../../../core/components/containment/dialogs/CoreFullScreenDialog.dart';
import '../../../../../core/components/form/CoreTextFormField.dart';
import '../../../../../core/components/helper_widgets/CoreHelperWidget.dart';
import '../../../../../core/components/notifications/CoreNotification.dart';
import '../../../../library/enums/CommonEnums.dart';
import '../controllers/label_controller.dart';
import '../models/label_model.dart';
import 'package:google_fonts/google_fonts.dart';

class LabelAddScreen extends StatefulWidget {
  final LabelModel? label;
  final ActionModeEnum actionMode;
  const LabelAddScreen({super.key, this.label, required this.actionMode});

  @override
  State<LabelAddScreen> createState() => _LabelAddScreenState();
}

class _LabelAddScreenState extends State<LabelAddScreen> {
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

    // Update mode
    if(widget.label is LabelModel) {
      myController.text = widget.label!.title;
      _title = widget.label!.title;
      if (widget.label!.color.isNotEmpty) {
        defaultColor = widget.label!.color.toColor();
        _color = widget.label!.color;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    LabelController controller = LabelController(context: context);

    return CoreFullScreenDialog(
      title: widget.label == null ? 'Add a label' : 'Edit label',
      isConfirmToClose: true,
      focusNodes: null,
      actions: AppBarActionButtonEnum.save,
      isShowGeneralActionButton: false,
      optionActionContent: Container(),
      onSubmit: () async {
        if (_formKey.currentState!.validate()) {
          if (widget.label == null &&
              widget.actionMode == ActionModeEnum.create) {
            final LabelModel model = LabelModel(
                title: _title,
                color: _color,
                createdAt: DateTime.now().millisecondsSinceEpoch,
                id: widget.label?.id);
            if (await controller.onCreateLabel(model)) {

              CoreNotification.show(context, CoreNotificationStatus.success, CoreNotificationAction.create, 'Label');

              Navigator.pop(context);
            }
          } else if (widget.label != null &&
              widget.actionMode == ActionModeEnum.update) {
            final LabelModel model = LabelModel(
                title: _title,
                color: _color,
                createdAt: widget.label?.createdAt,
                updatedAt: DateTime.now().millisecondsSinceEpoch,
                id: widget.label?.id);
            if (await controller.onUpdateLabel(model)) {

              CoreNotification.show(context, CoreNotificationStatus.success, CoreNotificationAction.update, 'Label');
              Navigator.pop(context);
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
                                            Icon(Icons.label_important_rounded,
                                                color: _color.toColor()),
                                            Text(_title.isNotEmpty
                                                ? _title
                                                : 'Your label'),
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
                              return 'Please enter your title';
                            }
                            return null;
                          },
                          maxLength: 30,
                          icon: const Icon(Icons.edit),
                          label: 'Title',
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
                                    coreColor: CoreColor.success,
                                    coreRadius: CoreRadius.radius_6,
                                    kitForegroundColorOption: Colors.black,
                                    coreFixedSizeButton:
                                        CoreFixedSizeButton.medium_40),
                                child: const Text('Choose color'),
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
