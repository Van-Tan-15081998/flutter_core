import 'package:flutter/material.dart';
import 'package:flutter_core_v3/app/screens/features/note/models/note_model.dart';
import 'package:flutter_quill/flutter_quill.dart' as flutter_quill;

class NoteFunctions {
  static void addStringToQuillContent(
      {required flutter_quill.QuillController quillController,
      required TextSelection selection,
      required Object? object,
      required String insertString}) {
    // final currentSelection = quillController.selection;
    // if (currentSelection.isValid) {
    //
    //   final controller = quillController;
    //   final index = controller.selection.baseOffset;
    //   final length = controller.selection.extentOffset - index;
    //
    //   if (object != null) {
    //     /// Tạo một Delta mới chứa nội dung bạn muốn chèn
    //     final delta = flutter_quill.Delta()
    //       ..insert(insertString);
    //
    //     /// Khi edit thì sẽ add theo frame: {"insert:"}
    //     final offset = flutter_quill.getEmbedNode(controller, controller.selection.start).offset;
    //     controller.replaceText(
    //         offset, 1, delta, TextSelection.collapsed(offset: offset));
    //   } else {
    //
    //     /// Lấy vị trí cũ
    //     final oldPosition = controller.selection.baseOffset;
    //
    //     controller.replaceText(index, length, insertString, null, ignoreFocus: true);
    //
    //     /// Tính toán vị trí mới sau khi chèn
    //     final deltaLength = insertString.length; /// Độ dài của delta
    //     final newPosition = oldPosition + deltaLength;
    //
    //     /// Tạo TextSelection mới với vị trí mới
    //     final newSelection = TextSelection.collapsed(offset: newPosition);
    //
    //     controller.ignoreFocusOnTextChange = true;
    //
    //     controller.updateSelection(newSelection, flutter_quill.ChangeSource.LOCAL);
    //
    //   }
    // }

    final currentSelection = quillController.selection;
    if (currentSelection.isValid) {
      final index = quillController.selection.baseOffset;
      final length = quillController.selection.extentOffset - index;

      /// Lấy vị trí cũ
      final oldPosition = quillController.selection.baseOffset;

      quillController.replaceText(index, length, insertString, null,
          ignoreFocus: true);

      /// Tính toán vị trí mới sau khi chèn
      final deltaLength = insertString.length;

      /// Độ dài của delta
      final newPosition = oldPosition + deltaLength;

      /// Tạo TextSelection mới với vị trí mới
      selection = TextSelection.collapsed(offset: newPosition);

      quillController.ignoreFocusOnTextChange = true;

      quillController.updateSelection(
          selection, flutter_quill.ChangeSource.LOCAL);
    }
  }
}
