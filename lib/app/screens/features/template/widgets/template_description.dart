import 'package:flutter/material.dart';
import 'package:flutter_core_v3/core/components/actions/common_buttons/CoreButtonStyle.dart';
import 'package:flutter_core_v3/core/components/actions/common_buttons/CoreElevatedButton.dart';
import 'package:flutter_quill/flutter_quill.dart' as flutter_quill;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NoteDescription extends StatefulWidget {
  const NoteDescription({
    super.key
  });

  @override
  State<NoteDescription> createState() => _NoteDescriptionState();
}

class _NoteDescriptionState extends State<NoteDescription> {

  final flutter_quill.QuillController _controller = flutter_quill.QuillController.basic();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Note Description'),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // flutter_quill.QuillToolbar.basic(controller: _controller),
                  Container(
                    color: Colors.yellow,
                    height: 200,
                    child: flutter_quill.QuillEditor.basic(
                      controller: _controller,
                      readOnly: false, // true for view only mode
                      keyboardAppearance: Brightness.dark,
                    ),
                  )
                ],
              ),
            ),
          ),

        ),
        floatingActionButton: Padding(
          padding: EdgeInsets.fromLTRB(4, 0, 4, 10),
          child: Container(

            padding: const EdgeInsets.fromLTRB(4, 1 ,4 , 0),
            width: MediaQuery.of(context).size.width, // Đặt chiều rộng của container bằng chiều ngang của màn hình
            decoration: BoxDecoration(
              // border: Border.all(
              //   color: Colors.black, // Màu viền
              //   width: 1.0, // Độ rộng của viền
              //   style: BorderStyle.solid,
              //
              // ),
              color: Colors.grey,
              borderRadius: BorderRadius.circular(8.0), // Bo góc
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CoreElevatedButton.iconOnly(
                  icon: const FaIcon(FontAwesomeIcons.font, size: 18.0),
                  onPressed: () {

                  },
                  coreButtonStyle: CoreButtonStyle.options(
                      coreFixedSizeButton: CoreFixedSizeButton.squareIcon4050,
                      coreStyle: CoreStyle.outlined,
                      coreColor: CoreColor.turtles,
                      coreRadius: CoreRadius.radius_6,
                      kitForegroundColorOption: Color(0xff1f1f1f)),
                ),
                CoreElevatedButton.iconOnly(
                  onPressed: () {

                  },
                  coreButtonStyle: CoreButtonStyle.options(
                      coreFixedSizeButton: CoreFixedSizeButton.squareIcon4050,
                      coreStyle: CoreStyle.outlined,
                      coreColor: CoreColor.turtles,
                      coreRadius: CoreRadius.radius_6,
                      kitForegroundColorOption: Color(0xff1f1f1f)),
                  icon: const FaIcon(FontAwesomeIcons.faceSmile, size: 18.0),
                ),
                CoreElevatedButton.iconOnly(
                  onPressed: () {
                    // _quillToolbarController.clear(); /// Xóa toàn bộ nội dung
                    FocusScope.of(context).unfocus();

                    /// Ẩn bàn phím trên toàn bộ ứng dụng
                  },
                  coreButtonStyle: CoreButtonStyle.options(
                      coreFixedSizeButton: CoreFixedSizeButton.squareIcon4050,
                      coreStyle: CoreStyle.outlined,
                      coreColor: CoreColor.turtles,
                      coreRadius: CoreRadius.radius_6,
                      kitForegroundColorOption: Color(0xff1f1f1f)),
                  icon: const FaIcon(FontAwesomeIcons.squareCheck, size: 18.0),
                ),
                CoreElevatedButton.iconOnly(
                  onPressed: () {

                  },
                  coreButtonStyle: CoreButtonStyle.options(
                      coreFixedSizeButton: CoreFixedSizeButton.squareIcon4050,
                      coreStyle: CoreStyle.outlined,
                      coreColor: CoreColor.turtles,
                      coreRadius: CoreRadius.radius_6,
                      kitForegroundColorOption: Color(0xff1f1f1f)),
                  icon: const FaIcon(FontAwesomeIcons.listUl, size: 18.0),
                ),
                CoreElevatedButton.iconOnly(
                  onPressed: () {

                  },
                  coreButtonStyle: CoreButtonStyle.options(
                      coreFixedSizeButton: CoreFixedSizeButton.squareIcon4050,
                      coreStyle: CoreStyle.outlined,
                      coreColor: CoreColor.turtles,
                      coreRadius: CoreRadius.radius_6,
                      kitForegroundColorOption: Color(0xff1f1f1f)),
                  icon: const FaIcon(FontAwesomeIcons.arrowLeft, size: 18.0),
                ),
                CoreElevatedButton.iconOnly(
                  onPressed: () {

                  },
                  coreButtonStyle: CoreButtonStyle.options(
                      coreFixedSizeButton: CoreFixedSizeButton.squareIcon4050,
                      coreStyle: CoreStyle.outlined,
                      coreColor: CoreColor.turtles,
                      coreRadius: CoreRadius.radius_6,
                      kitForegroundColorOption: Color(0xff1f1f1f)),
                  icon: const FaIcon(FontAwesomeIcons.arrowRight, size: 18.0),
                ),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
      ),
    );
  }
}
