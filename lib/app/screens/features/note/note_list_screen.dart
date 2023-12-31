import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_core_v3/app/screens/features/note/models/note_model.dart';
import 'package:flutter_core_v3/app/screens/features/note/widgets/note_widget.dart';
import 'package:flutter_core_v3/core/state_management/view/CoreGetReactiveComponent.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/components/actions/common_buttons/CoreButtonStyle.dart';
import '../../../../core/components/actions/common_buttons/CoreElevatedButton.dart';
import '../../../../core/components/navigation/bottom_app_bar/CoreBottomNavigationBar.dart';
import '../../../../core/state_management/dispatch_events/dispatch_listener_event.dart';
import '../../../library/enums/CommonEnums.dart';
import '../../../services/database/database_provider.dart';
import '../../home/home_screen.dart';
import '../label/controllers/label_controller.dart';
import '../label/models/label_model.dart';
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
  List<LabelModel> labels = [];

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

    DispatchListenerEvent.listener(
        "DISPATCH_GET_RELOAD_NOTE_LIST", onGetReloadNoteList, "DISPATCH_GET_RELOAD_NOTE_LIST");

    DispatchListenerEvent.listener(
        "DISPATCH_RELOAD_NOTE_LIST", onReloadNoteList, "DISPATCH_RELOAD_NOTE_LIST");

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

  onReloadNoteList(List<NoteModel> allNotes) {
    setState(() {
      notes = allNotes;
    });
  }

  onGetReloadNoteList(data) {
    controller.initData();
  }

  getLabels(LabelController labelController) async {
    if(labels.isEmpty) {
      List<LabelModel>? labelList = await labelController.getAll();

      if (labelList!.isNotEmpty) {
        labels = labelList;
      }
    }
  }

  getNoteLabels(String jsonLabelIds) {
    List<LabelModel>? noteLabels = [];
    List<dynamic> labelIds = jsonDecode(jsonLabelIds);

    noteLabels = labels.where((model) => labelIds.contains(model.id)).toList();
    return noteLabels;
  }

  @override
  Widget build(BuildContext context) {
    LabelController labelController = LabelController(context: context);
    getLabels(labelController);

    return  Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
            child: CoreElevatedButton.icon(
              icon: const FaIcon(FontAwesomeIcons.house, size: 18.0),
              label: const Text('Home'),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HomeScreen(
                        title: 'Hi Task',
                      )),
                      (route) => false,
                );
              },
              coreButtonStyle: CoreButtonStyle.options(
                  coreStyle: CoreStyle.outlined,
                  coreColor: CoreColor.success,
                  coreRadius: CoreRadius.radius_6,
                  kitForegroundColorOption: Colors.black,
                  coreFixedSizeButton: CoreFixedSizeButton.medium_40),
            ),
          )
        ],
        backgroundColor: const Color(0xff28a745),
        title: Text(
          'Notes',
          style:
          GoogleFonts.montserrat(fontStyle: FontStyle.italic, fontSize: 30),
        ),
      ),
      body: ListView.builder(
          itemBuilder: (context, index) => NoteWidget(
                note: notes[index],
                labels: getNoteLabels(notes[index].labels!),
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
              ),
          itemCount: notes.length),
      bottomNavigationBar: CoreBottomNavigationBar(
        backgroundColor: Colors.white,
        child: IconTheme(
          data: const IconThemeData(color: Colors.white),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              CoreElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomeScreen(
                          title: 'Hi Task',
                        )),
                        (route) => false,
                  );
                },
                coreButtonStyle: CoreButtonStyle.options(
                    coreStyle: CoreStyle.outlined,
                    coreColor: CoreColor.success,
                    coreRadius: CoreRadius.radius_6,
                    kitForegroundColorOption: Colors.black),
                child: const Icon(
                  Icons.home,
                  size: 25.0,
                ),
              ),
              const SizedBox(width: 5),
              CoreElevatedButton(
                onPressed: () {},
                coreButtonStyle: CoreButtonStyle.options(
                    coreStyle: CoreStyle.outlined,
                    coreColor: CoreColor.success,
                    coreRadius: CoreRadius.radius_6,
                    kitForegroundColorOption: Colors.black),
                child: const Icon(
                  Icons.search,
                  size: 25.0,
                ),
              ),
              const SizedBox(width: 5),
              CoreElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NoteAddScreen(
                            actionMode: ActionModeEnum.create)),
                  );
                },
                coreButtonStyle: CoreButtonStyle.options(
                    coreStyle: CoreStyle.outlined,
                    coreColor: CoreColor.success,
                    coreRadius: CoreRadius.radius_6,
                    kitForegroundColorOption: Colors.black),
                child: const Icon(
                  Icons.add,
                  size: 25.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
