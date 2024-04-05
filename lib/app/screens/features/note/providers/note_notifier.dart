import 'package:flutter/material.dart';

import '../../../../../core/common/pagination/models/CorePaginationModel.dart';
import '../databases/note_db_manager.dart';
import '../models/note_condition_model.dart';
import '../models/note_model.dart';

class NoteNotifier with ChangeNotifier {
  List<NoteModel> _notes = [];
  List<NoteModel>? get notes => _notes;

  int _countAllNotes = 0;
  int get countAllNotes => _countAllNotes;
  NoteNotifier() {
    // getAll();
    onCountAll();
  }

   Future onCountAll() async {
      _countAllNotes = await NoteDatabaseManager.onCountAll();
      notifyListeners();
  }

  // Future<bool> addNote(NoteModel note) async {
  //   try {
  //     NoteModel? noteAddToDatabase;
  //     noteAddToDatabase = await addNoteToDatabase(note);
  //
  //     if (noteAddToDatabase != null) {
  //       _notes.insert(0, noteAddToDatabase);
  //       notifyListeners();
  //       return true;
  //     }
  //   } catch (e) {
  //     return false;
  //   }
  //   return false;
  // }
  //
  // Future<NoteModel?> addNoteToDatabase(NoteModel note) async {
  //   NoteModel? noteAddToDatabase;
  //   noteAddToDatabase = await NoteDatabaseManager.onCreate(note);
  //   return noteAddToDatabase;
  // }

  // Future<bool> updateNote(NoteModel note) async {
  //   try {
  //     NoteModel? noteUpdateToDatabase;
  //     noteUpdateToDatabase = await updateNoteToDatabase(note);
  //
  //     if (noteUpdateToDatabase != null) {
  //       int updateId = noteUpdateToDatabase.id!;
  //       bool isIdExists = _notes.any((item) => item.id == updateId);
  //       if (isIdExists) {
  //         for (int i = 0; i < _notes.length; i++) {
  //           if (_notes[i].id == updateId) {
  //             _notes[i] = noteUpdateToDatabase;
  //             notifyListeners();
  //           }
  //         }
  //       }
  //       return true;
  //     }
  //   } catch (e) {
  //     return false;
  //   }
  //   return false;
  // }
  //
  // Future<NoteModel?> updateNoteToDatabase(NoteModel note) async {
  //   NoteModel? noteAddToDatabase;
  //   noteAddToDatabase = await NoteDatabaseManager.onUpdate(note);
  //   return noteAddToDatabase;
  // }

  bool deleteNote(NoteModel note) {
    try {
      int deleteId = note.id!;
      bool isIdExists = _notes.any((item) => item.id == deleteId);

      if (isIdExists) {
        for (var n in _notes) {
          if (n.id == deleteId) {
            _notes.remove(n);
            notifyListeners();
          }
        }
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<List<NoteModel>?> getAll() async {
    List<NoteModel>? result = [];
    result = await NoteDatabaseManager.initData();

    if (result != null) {
      _notes = result;
      notifyListeners();
    }
    return null;
  }

  Future<List<NoteModel>?> getNotePagination(CorePaginationModel corePaginationModel, NoteConditionModel noteConditionModel) async {
    List<NoteModel>? result = [];
    result = await NoteDatabaseManager.onGetNotePagination(corePaginationModel, noteConditionModel);

    if (result != null) {
      _notes = result;
      return _notes;
      // notifyListeners();
    }
    return null;
  }
}
