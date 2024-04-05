import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as flutter_quill;

class TaskFunctions {
  static void addStringToQuillContent(
      {required flutter_quill.QuillController quillController,
        required TextSelection selection,
        required Object? object,
        required String insertString}) {

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
