import 'package:flutter/material.dart';
import 'package:flutter_core_v3/app/screens/features/note/note_detail_screen.dart';
import 'package:flutter_core_v3/app/services/database/database_provider.dart';
import 'package:flutter_core_v3/core/state_management/controller/CoreGetController.dart';
import 'package:get/get.dart';

import '../../../../../core/state_management/dispatch_events/dispatch_listener_event.dart';
import '../../../../../main.dart';
import '../../../home/home_screen.dart';
import '../models/note_model.dart';
import '../note_add_screen.dart';
import '../note_list_screen.dart';

class NoteController  {
  List<NoteModel> notes = <NoteModel>[];

  Future<void> initData() async {

    List<NoteModel>? notesFromDB = await DatabaseProvider.getAllNotes();

    if(notesFromDB != null) {
      notes = notesFromDB;

      DispatchListenerEvent.dispatch('DISPATCH_GET_ALL_NOTES_FROM_DB', notes);
    }
  }

  Future<bool> onCreateNote(NoteModel note) async {

    try {
      int createdNoteId = await DatabaseProvider.addNote(note);

      NoteModel? createdNote = await DatabaseProvider.getNoteById(createdNoteId);

      if(createdNote is NoteModel) {
        notes.insert(0, createdNote);

        DispatchListenerEvent.dispatch('DISPATCH_ADD_NEW_NOTE_TO_LIST', createdNote);

        Get.back();
      }

    } catch (e) {

      return false;
    }

    return true;
  }

  Future<dynamic> onUpdateNote(NoteModel note) async {

    try {
      int isUpdatedSuccess = await DatabaseProvider.updateNote(note);

      if (isUpdatedSuccess.isEqual(1)) {
        NoteModel? updatedNote = await DatabaseProvider.getNoteById(note.id!);

        if(updatedNote is NoteModel) {
          // Get.to(NoteAddScreen(note: updatedNote, actionMode: ActionModeEnum.update));

          // return updatedNote;
          Get.to(NoteDetailScreen(note: updatedNote));
        }
      }
    } catch (e) {

      return false;
    }

    return true;
  }
}
