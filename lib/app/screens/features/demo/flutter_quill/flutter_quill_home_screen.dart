import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class FlutterQuillHomeScreen extends StatefulWidget {
  const FlutterQuillHomeScreen({
    super.key
  });

  @override
  State<FlutterQuillHomeScreen> createState() => _FlutterQuillHomeScreenState();
}

class _FlutterQuillHomeScreenState extends State<FlutterQuillHomeScreen> {

  QuillController _controller = QuillController.basic();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        QuillToolbar.basic(controller: _controller),
        Expanded(
          child: Container(
            child: QuillEditor.basic(
              controller: _controller,
              readOnly: false, // true for view only mode
            ),
          ),
        )
      ],
    );
  }
}