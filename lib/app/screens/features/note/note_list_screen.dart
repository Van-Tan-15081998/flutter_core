import 'package:flutter/material.dart';
import 'package:flutter_core_v3/app/screens/features/note/models/note_model.dart';
import 'package:flutter_core_v3/app/screens/features/note/widgets/note_widget.dart';
import 'package:flutter_core_v3/core/state_management/view/CoreGetReactiveComponent.dart';
import 'package:get/get.dart';

import '../../../../core/state_management/dispatch_events/dispatch_listener_event.dart';
import '../../../services/database/database_provider.dart';
import 'controllers/note_controller.dart';
import 'note_add_screen.dart';

class NoteListScreen extends StatefulWidget {
  const NoteListScreen({super.key});

  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {

  List<NoteModel> notes = [];
  NoteController controller = NoteController();

  @override
  void initState() {
    if(notes.isEmpty) {
      controller.initData();
    }
    // TODO: implement initState

    DispatchListenerEvent.listener(
        "DISPATCH_GET_ALL_NOTES_FROM_DB", onGetAllNotesFromDB, "DISPATCH_GET_ALL_NOTES_FROM_DB");

    DispatchListenerEvent.listener(
    "DISPATCH_ADD_NEW_NOTE_TO_LIST", onAddNewNoteToList, "DISPATCH_ADD_NEW_NOTE_TO_LIST");

    super.initState();
  }

  onGetAllNotesFromDB(List<NoteModel> allNotes) {
    setState(() {
      notes = allNotes;
    });
  }

  onAddNewNoteToList(NoteModel noteModel) {
   setState(() {
     notes.add(noteModel);
   });
  }

  @override
  Widget build(BuildContext context) {

    return  ListView.builder(
        itemBuilder: (context, index) => NoteWidget(
              note: notes[index],
              onTap: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NoteAddScreen(
                              note: notes[index],
                              actionMode: ActionModeEnum.update,
                            )));
                setState(() {});
              },
              onLongPress: () async {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text(
                            'Are you sure you want to delete this note?'),
                        actions: [
                          ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.red)),
                            onPressed: () async {},
                            child: const Text('Yes'),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('No'),
                          ),
                        ],
                      );
                    });
              },
            ),
        itemCount: notes.length);
  }
}
