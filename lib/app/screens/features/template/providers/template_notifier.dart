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
    onCountAll();
  }

   Future onCountAll() async {
      _countAllNotes = await NoteDatabaseManager.onCountAll();
      notifyListeners();
  }

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
    result = await NoteDatabaseManager.all();

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
    }
    return null;
  }
}
