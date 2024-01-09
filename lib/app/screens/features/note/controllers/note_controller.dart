import 'package:flutter_core_v3/app/screens/features/note/note_detail_screen.dart';
import 'package:flutter_core_v3/app/services/database/database_provider.dart';
import 'package:get/get.dart';
import '../../../../../core/state_management/dispatch_events/dispatch_listener_event.dart';
import '../models/note_model.dart';

class NoteController {
  List<NoteModel> notes = <NoteModel>[];

  Future<void> initData() async {
    List<NoteModel>? notesFromDB = await DatabaseProvider.getAllNotes();

    if (notesFromDB != null) {
      notes = notesFromDB;

      DispatchListenerEvent.dispatch('DISPATCH_GET_ALL_NOTES_FROM_DB', notes);
    }
  }

  Future<bool> onCreateNote(NoteModel note) async {
    try {
      int createdNoteId = await DatabaseProvider.addNote(note);

      NoteModel? createdNote =
          await DatabaseProvider.getNoteById(createdNoteId);

      if (createdNote is NoteModel) {
        notes.insert(0, createdNote);

        DispatchListenerEvent.dispatch(
            'DISPATCH_ADD_NEW_NOTE_TO_LIST', createdNote);
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

        if (updatedNote is NoteModel) {
          return true;
        }
      }
    } catch (e) {
      return false;
    }

    return true;
  }
}
