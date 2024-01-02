import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/components/containment/dialogs/CoreFullScreenDialog.dart';
import 'models/note_model.dart';
import 'note_list_screen.dart';
import 'widgets/note_widget.dart';

class NoteDetailScreen extends StatefulWidget {
  final NoteModel note;

  const NoteDetailScreen({
    super.key,
    required this.note,
  });

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return CoreFullScreenDialog(
      title: 'Detail note',
      actions: AppBarActionButtonEnum.home,
      isConfirmToClose: false,
      onSubmit: () async {},
      onRedo: () {},
      onUndo: () {},
      onBack: () {},
      isShowGeneralActionButton: true,
      isShowOptionActionButton: true,
      optionActionContent: Container(),
      bottomActionBar: const [
        Row()
      ],
      bottomActionBarScrollable: const [
        Row(
        )
      ],
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: ListView(
          // mainAxisSize: MainAxisSize.max,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Text(widget.note.title),
            // Text(widget.note.description),
            NoteWidget(
              note: widget.note,
              onLongPress: () {},
              onTap: () {},
            )
          ],
        ),
      ),
    );
  }
}
