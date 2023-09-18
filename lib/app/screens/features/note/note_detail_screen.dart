import 'package:flutter/material.dart';

import '../../../../core/components/containment/dialogs/CoreFullScreenDialog.dart';
import 'models/note_model.dart';
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
      isConfirmToClose: false,
      focusNodes: [],
      onSubmit: () async {},
      onRedo: () {},
      onUndo: () {},
      isShowGeneralActionButton: true,
      isShowOptionActionButton: true,
      bottomActionBar: [
        Row(
            // children: [
            //   Flexible(
            //       flex: 1, child: Container(color: Colors.red.shade100)),
            //   Flexible(
            //       flex: 1,
            //       child: Container(
            //         color: Colors.red.shade200,
            //       )),
            // ],
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
