import 'package:flutter/material.dart';
import 'package:flutter_core_v3/app/screens/features/note/models/note_model.dart';
import 'package:flutter_core_v3/app/screens/features/note/note_detail_screen.dart';
import 'package:flutter_core_v3/core/stores/icons/CoreStoreIcons.dart';
import 'package:get/get.dart';

import '../../../../core/components/actions/common_buttons/CoreButtonStyle.dart';
import '../../../../core/components/actions/common_buttons/CoreElevatedButton.dart';
import '../../../../core/components/containment/bottom_sheets/CoreStandardBottomSheet.dart';
import '../../../../core/components/containment/dialogs/CoreFullScreenDialog.dart';
import '../../../../core/components/form/CoreDisableFormField.dart';
import '../../../../core/components/form/CoreEmailFormField.dart';
import '../../../../core/components/form/CoreMultilineFormField.dart';
import '../../../../core/components/form/CoreNumberFormField.dart';
import '../../../../core/components/form/CorePasswordFormField.dart';
import '../../../../core/components/form/CoreTextFormField.dart';
import '../../../../core/components/form/CoreTextRowFormField.dart';
import '../../../../core/components/helper_widgets/CoreHelperWidget.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/stores/fonts/CoreStoreFonts.dart';
import '../../../services/database/database_provider.dart';
import 'controllers/note_controller.dart';
import 'note_list_screen.dart';

enum ActionModeEnum { create, update, delete }

class NoteAddScreen extends StatefulWidget {
  final NoteModel? note;

  final ActionModeEnum actionMode;

  const NoteAddScreen({super.key, this.note, required this.actionMode});

  @override
  State<NoteAddScreen> createState() => _NoteAddScreenState();
}

class _NoteAddScreenState extends State<NoteAddScreen> {
  final FocusNode _titleFocusNode = FocusNode();

  final FocusNode _detailContentFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();

  bool _titleFocusNodeHasFocus = false;
  bool _detailContentFocusNodeHasFocus = false;

  List<FocusNode> focusNodeInsidePage = [];

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    List<FocusNode> focusNodeInsidePage = [
      _titleFocusNode,
      _detailContentFocusNode
    ];

    _titleFocusNode.addListener(() {
      if (_titleFocusNode.hasFocus) {
        if (!_titleFocusNodeHasFocus) {
          _titleFocusNodeHasFocus = true;

          _detailContentFocusNodeHasFocus = false;
        }

        for (FocusNode focusNode in focusNodeInsidePage) {
          if (focusNode != _titleFocusNode) {
            focusNode.unfocus();
          }
        }
      }
    });

    _detailContentFocusNode.addListener(() {
      if (_detailContentFocusNode.hasFocus) {
        if (!_detailContentFocusNodeHasFocus) {
          _detailContentFocusNodeHasFocus = true;

          _titleFocusNodeHasFocus = false;
        }

        for (FocusNode focusNode in focusNodeInsidePage) {
          if (focusNode != _detailContentFocusNode) {
            focusNode.unfocus();
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    NoteController controller = Get.find();

    if (widget.note != null) {
      titleController.text = widget.note!.title;
      descriptionController.text = widget.note!.description;
    }

    List listFontFamiliesParsed = CoreStoreFonts.listFontFamiliesParsed();

    return CoreFullScreenDialog(
      title: widget.note == null ? 'Add a note' : 'Edit note',
      isConfirmToClose: true,
      focusNodes: [_titleFocusNode, _detailContentFocusNode],
      onSubmit: () async {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();

          /// Gửi form hoặc thực hiện xử lý dữ liệu ở đây

          final title = titleController.value.text;
          final description = descriptionController.value.text;

          if (title.isEmpty || description.isEmpty) {
            return;
          }

          final NoteModel model = NoteModel(
              title: title, description: description, id: widget.note?.id);
          if (widget.note == null &&
              widget.actionMode == ActionModeEnum.create) {
            if (await controller.onCreateNote(model)) {}
          } else if (widget.note != null &&
              widget.actionMode == ActionModeEnum.update) {
            var result = await controller.onUpdateNote(model);

            // if(result is NoteModel) {
            //   showDialog<String>(
            //       context: context,
            //       builder: (BuildContext context) => NoteDetailScreen(note: result,)
            //   );
            // }
          }
        }
      },
      onRedo: () {},
      onUndo: () {},
      bottomActionBar: [
        CoreElevatedButton.iconOnly(
          icon: const FaIcon(FontAwesomeIcons.font, size: 18.0),
          onPressed: () => showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              builder: (BuildContext context) {
                return CoreStandardBottomSheet(
                  coreStandardBottomHeight: CoreStandardBottomHeight.half,
                  // child: ListView.builder(
                  //     // itemBuilder: (context, index) => Text(
                  //     //     CoreStoreIcons.trees[index]
                  //     // ),
                  //     itemBuilder: (context, index) =>
                  //         CoreElevatedButton.iconOnly(
                  //           onPressed: () {
                  //             if (_titleFocusNodeHasFocus) {
                  //               setState(() {
                  //                 titleController.text += CoreStoreIcons.activeIcons[index];
                  //
                  //                 // final updatedText = titleController.text + CoreStoreIcons.trees[index].toString();
                  //                 //
                  //                 // titleController.value = titleController.value.copyWith(
                  //                 //   text: updatedText,
                  //                 //   selection: TextSelection.collapsed(offset: updatedText.length),
                  //                 // );
                  //
                  //                 print(titleController.text);
                  //               });
                  //             }
                  //
                  //             else if (_detailContentFocusNodeHasFocus) {
                  //               setState(() {
                  //                 descriptionController.text +=
                  //                     CoreStoreIcons.activeIcons[index];
                  //               });
                  //             }
                  //           },
                  //           coreButtonStyle: CoreButtonStyle.options(
                  //             coreFixedSizeButton:
                  //                 CoreFixedSizeButton.squareIcon4060,
                  //             coreStyle: CoreStyle.outlined,
                  //             coreColor: CoreColor.turtles,
                  //             coreRadius: CoreRadius.radius_6,
                  //             kitForegroundColorOption: Colors.black,
                  //           ),
                  //           icon: Text(CoreStoreIcons.activeIcons[index]),
                  //         ),
                  //     itemCount: CoreStoreIcons.activeIcons.length)
                  child: DefaultTabController(
                    length: 3,
                    child: Scaffold(
                      appBar: PreferredSize(
                        preferredSize: Size.fromHeight(kToolbarHeight),

                        /// Đặt kích thước tùy chỉnh cho AppBar
                        child: AppBar(
                          automaticallyImplyLeading: false, // Ẩn nút back
                          title: null,

                          /// Ẩn tiêu đề
                          elevation: 0,

                          /// Loại bỏ độ đổ bóng
                          bottom: TabBar(
                            tabs: [
                              const Tab(icon: FaIcon(FontAwesomeIcons.font, size: 18.0)),
                              Tab(icon: Row(
                                children: [
                                  FaIcon(FontAwesomeIcons.bold, size: 18.0),
                                  FaIcon(FontAwesomeIcons.italic, size: 18.0),
                                  FaIcon(FontAwesomeIcons.underline, size: 18.0)
                                ],
                              )),
                              Tab(icon: FaIcon(FontAwesomeIcons.paintbrush, size: 18.0)),
                              Tab(icon: FaIcon(FontAwesomeIcons.textHeight, size: 18.0)),
                            ],
                          ),
                        ),
                      ),
                      body: TabBarView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: GridView.builder(
                              padding: const EdgeInsets.fromLTRB(
                                  4.0, 4.0, 4.0, 80.0),
                              gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 150.0,

                                /// Kích thước tối đa của một cột
                                crossAxisSpacing: 10.0,

                                /// Khoảng cách giữa các cột
                                mainAxisSpacing: 10.0,

                                /// Khoảng cách giữa các hàng
                              ),
                              itemCount: listFontFamiliesParsed.length,
                              itemBuilder: (context, index) {
                                return CoreElevatedButton.iconOnly(
                                  onPressed: () {

                                  },
                                  coreButtonStyle: CoreButtonStyle.options(
                                      coreFixedSizeButton:
                                      CoreFixedSizeButton.squareIcon4060,
                                      coreStyle: CoreStyle.outlined,
                                      coreColor: CoreColor.turtles,
                                      coreRadius: CoreRadius.radius_6,
                                      kitForegroundColorOption: Colors.black),
                                  icon: Center(
                                    child: Text(
                                      'Hi Task',
                                      style: listFontFamiliesParsed[index],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: GridView.builder(
                              padding: const EdgeInsets.fromLTRB(
                                  4.0, 4.0, 4.0, 80.0),
                              gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 150.0,

                                /// Kích thước tối đa của một cột
                                crossAxisSpacing: 10.0,

                                /// Khoảng cách giữa các cột
                                mainAxisSpacing: 10.0,

                                /// Khoảng cách giữa các hàng
                              ),
                              itemCount: CoreStoreFonts.fontStyles.length,
                              itemBuilder: (context, index) {
                                return CoreElevatedButton.iconOnly(
                                  onPressed: () {

                                  },
                                  coreButtonStyle: CoreButtonStyle.options(
                                      coreFixedSizeButton:
                                      CoreFixedSizeButton.squareIcon4060,
                                      coreStyle: CoreStyle.outlined,
                                      coreColor: CoreColor.turtles,
                                      coreRadius: CoreRadius.radius_6,
                                      kitForegroundColorOption: Colors.black),
                                  icon: Center(
                                    child: Text(
                                      CoreStoreFonts.fontStyles[index].name,
                                      style: CoreStoreFonts.parseTextStyleFromCoreFontStyle(coreFontStyle: CoreStoreFonts.fontStyles[index]),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: GridView.builder(
                              padding: const EdgeInsets.fromLTRB(
                                  4.0, 4.0, 4.0, 80.0),
                              gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 150.0,

                                /// Kích thước tối đa của một cột
                                crossAxisSpacing: 10.0,

                                /// Khoảng cách giữa các cột
                                mainAxisSpacing: 10.0,

                                /// Khoảng cách giữa các hàng
                              ),
                              itemCount: CoreStoreFonts.fontColors.length,
                              itemBuilder: (context, index) {
                                return CoreElevatedButton.iconOnly(
                                  onPressed: () {

                                  },
                                  coreButtonStyle: CoreButtonStyle.options(
                                      coreFixedSizeButton:
                                      CoreFixedSizeButton.squareIcon4060,
                                      coreStyle: CoreStyle.outlined,
                                      coreColor: CoreColor.turtles,
                                      coreRadius: CoreRadius.radius_6,
                                      kitForegroundColorOption: Colors.black,
                                    kitBackgroundColorOption: CoreStoreFonts.fontColors[index].color
                                  ),
                                  icon: Container(),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: GridView.builder(
                              padding: const EdgeInsets.fromLTRB(
                                  4.0, 4.0, 4.0, 80.0),
                              gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 150.0,

                                /// Kích thước tối đa của một cột
                                crossAxisSpacing: 10.0,

                                /// Khoảng cách giữa các cột
                                mainAxisSpacing: 10.0,

                                /// Khoảng cách giữa các hàng
                              ),
                              itemCount: CoreStoreFonts.fontSizes.length,
                              itemBuilder: (context, index) {
                                return CoreElevatedButton.iconOnly(
                                  onPressed: () {

                                  },
                                  coreButtonStyle: CoreButtonStyle.options(
                                      coreFixedSizeButton:
                                      CoreFixedSizeButton.squareIcon4060,
                                      coreStyle: CoreStyle.outlined,
                                      coreColor: CoreColor.turtles,
                                      coreRadius: CoreRadius.radius_6,
                                      kitForegroundColorOption: Colors.black),
                                  icon: Center(
                                    child: Text(
                                      CoreStoreFonts.fontSizes[index].name,
                                      style: TextStyle(fontSize: CoreStoreFonts.fontSizes[index].size),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }),
          coreButtonStyle: CoreButtonStyle.options(
              coreFixedSizeButton: CoreFixedSizeButton.squareIcon4060,
              coreStyle: CoreStyle.outlined,
              coreColor: CoreColor.turtles,
              coreRadius: CoreRadius.radius_6,
              kitForegroundColorOption: Colors.black),
        ),
        CoreElevatedButton.iconOnly(
          onPressed: () {},
          coreButtonStyle: CoreButtonStyle.options(
            coreFixedSizeButton: CoreFixedSizeButton.squareIcon4060,
            coreStyle: CoreStyle.outlined,
            coreColor: CoreColor.turtles,
            coreRadius: CoreRadius.radius_6,
            kitForegroundColorOption: Colors.black,
          ),
          icon: const FaIcon(FontAwesomeIcons.image, size: 18.0),
        ),
        CoreElevatedButton.iconOnly(
          onPressed: () => showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              builder: (BuildContext context) {
                return CoreStandardBottomSheet(
                  coreStandardBottomHeight: CoreStandardBottomHeight.half,

                  child: DefaultTabController(
                    length: 3,
                    child: Scaffold(
                      appBar: PreferredSize(
                        preferredSize: Size.fromHeight(kToolbarHeight),

                        /// Đặt kích thước tùy chỉnh cho AppBar
                        child: AppBar(
                          automaticallyImplyLeading: false, // Ẩn nút back
                          title: null,

                          /// Ẩn tiêu đề
                          elevation: 0,

                          /// Loại bỏ độ đổ bóng
                          bottom: TabBar(
                            tabs: [
                              Tab(icon: Text(CoreStoreIcons.emoji_001)),
                              Tab(icon: Text(CoreStoreIcons.emoji_260)),
                              Tab(icon: Icon(Icons.directions_car)),
                            ],
                          ),
                        ),
                      ),
                      body: TabBarView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: GridView.builder(
                              padding: const EdgeInsets.fromLTRB(
                                  4.0, 4.0, 4.0, 80.0),
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 60.0,

                                /// Kích thước tối đa của một cột
                                crossAxisSpacing: 10.0,

                                /// Khoảng cách giữa các cột
                                mainAxisSpacing: 10.0,

                                /// Khoảng cách giữa các hàng
                              ),
                              itemCount: CoreStoreIcons.emojis.length,
                              itemBuilder: (context, index) {
                                return CoreElevatedButton.iconOnly(
                                  onPressed: () {
                                    if (_titleFocusNodeHasFocus) {
                                      setState(() {
                                        final updatedText =
                                            titleController.text +
                                                CoreStoreIcons.emojis[index]
                                                    .toString();

                                        titleController.value =
                                            titleController.value.copyWith(
                                          text: updatedText,
                                          selection: TextSelection.collapsed(
                                              offset: updatedText.length),
                                        );
                                      });
                                    } else if (_detailContentFocusNodeHasFocus) {
                                      setState(() {
                                        final updatedText =
                                            descriptionController.text +
                                                CoreStoreIcons.emojis[index]
                                                    .toString();

                                        descriptionController.value =
                                            descriptionController.value
                                                .copyWith(
                                          text: updatedText,
                                          selection: TextSelection.collapsed(
                                              offset: updatedText.length),
                                        );
                                      });
                                    }
                                  },
                                  coreButtonStyle: CoreButtonStyle.options(
                                      coreFixedSizeButton:
                                          CoreFixedSizeButton.squareIcon4060,
                                      coreStyle: CoreStyle.outlined,
                                      coreColor: CoreColor.turtles,
                                      coreRadius: CoreRadius.radius_6,
                                      kitForegroundColorOption: Colors.black),
                                  icon: Center(
                                    child: Text(
                                      CoreStoreIcons.emojis[index],
                                      style: const TextStyle(fontSize: 18.0),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: GridView.builder(
                              padding: const EdgeInsets.fromLTRB(
                                  4.0, 4.0, 4.0, 80.0),
                              gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 60.0,

                                /// Kích thước tối đa của một cột
                                crossAxisSpacing: 10.0,

                                /// Khoảng cách giữa các cột
                                mainAxisSpacing: 10.0,

                                /// Khoảng cách giữa các hàng
                              ),
                              itemCount: CoreStoreIcons.natureAndAnimals.length,
                              itemBuilder: (context, index) {
                                return CoreElevatedButton.iconOnly(
                                  onPressed: () {
                                    if (_titleFocusNodeHasFocus) {
                                      setState(() {
                                        final updatedText =
                                            titleController.text +
                                                CoreStoreIcons.natureAndAnimals[index]
                                                    .toString();

                                        titleController.value =
                                            titleController.value.copyWith(
                                              text: updatedText,
                                              selection: TextSelection.collapsed(
                                                  offset: updatedText.length),
                                            );
                                      });
                                    } else if (_detailContentFocusNodeHasFocus) {
                                      setState(() {
                                        final updatedText =
                                            descriptionController.text +
                                                CoreStoreIcons.natureAndAnimals[index]
                                                    .toString();

                                        descriptionController.value =
                                            descriptionController.value
                                                .copyWith(
                                              text: updatedText,
                                              selection: TextSelection.collapsed(
                                                  offset: updatedText.length),
                                            );
                                      });
                                    }
                                  },
                                  coreButtonStyle: CoreButtonStyle.options(
                                      coreFixedSizeButton:
                                      CoreFixedSizeButton.squareIcon4060,
                                      coreStyle: CoreStyle.outlined,
                                      coreColor: CoreColor.turtles,
                                      coreRadius: CoreRadius.radius_6,
                                      kitForegroundColorOption: Colors.black),
                                  icon: Center(
                                    child: Text(
                                      CoreStoreIcons.natureAndAnimals[index],
                                      style: const TextStyle(fontSize: 18.0),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Icon(Icons.directions_car, size: 350),
                        ],
                      ),
                    ),
                  ),
                );
              }),
          coreButtonStyle: CoreButtonStyle.options(
              coreFixedSizeButton: CoreFixedSizeButton.squareIcon4060,
              coreStyle: CoreStyle.outlined,
              coreColor: CoreColor.turtles,
              coreRadius: CoreRadius.radius_6,
              kitForegroundColorOption: Colors.black),
          icon: const FaIcon(FontAwesomeIcons.faceSmile, size: 18.0),
        ),
        CoreElevatedButton.iconOnly(
          onPressed: () {},
          coreButtonStyle: CoreButtonStyle.options(
              coreFixedSizeButton: CoreFixedSizeButton.squareIcon4060,
              coreStyle: CoreStyle.outlined,
              coreColor: CoreColor.turtles,
              coreRadius: CoreRadius.radius_6,
              kitForegroundColorOption: Colors.black),
          icon: const FaIcon(FontAwesomeIcons.palette, size: 18.0),
        ),
        CoreElevatedButton.iconOnly(
          onPressed: () {},
          coreButtonStyle: CoreButtonStyle.options(
              coreFixedSizeButton: CoreFixedSizeButton.squareIcon4060,
              coreStyle: CoreStyle.outlined,
              coreColor: CoreColor.turtles,
              coreRadius: CoreRadius.radius_6,
              kitForegroundColorOption: Colors.black),
          icon: const FaIcon(FontAwesomeIcons.listUl, size: 18.0),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Form(
          key: _formKey,
          onWillPop: () async {
            if (await CoreHelperWidget.confirmFunction(context)) {
              return true;
            }
            return false;
          },
          child: ListView(
            // mainAxisSize: MainAxisSize.max,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CoreTextFormField(
                focusNode: _titleFocusNode,
                onChanged: (value) => {
                  // titleController.text = value
                },
                controller: titleController,
                onValidator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your title';
                  }
                  return null;
                },
              ),
              CoreMultilineFormField(
                focusNode: _detailContentFocusNode,
                onChanged: (value) => {
                  // descriptionController.text = value
                },
                controller: descriptionController,
                onValidator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your content';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              const SizedBox(
                height: 200,
              )
            ],
          ),
        ),
      ),
    );
  }
}
