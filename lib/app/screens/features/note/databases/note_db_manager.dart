import 'package:flutter_core_v3/app/services/database/database_provider.dart';

import '../../../../../core/common/pagination/models/CorePaginationModel.dart';
import '../models/note_condition_model.dart';
import '../models/note_model.dart';

class NoteDatabaseManager {
  static Future<List<NoteModel>?> initData() async {
    List<NoteModel>? notes = await DatabaseProvider.getAllNotes();

    return notes;
  }

  static Future<List<NoteModel>?> onGetNotePagination(CorePaginationModel corePaginationModel, NoteConditionModel noteConditionModel) async {
    List<NoteModel>? notes = await DatabaseProvider.getNotePagination(corePaginationModel, noteConditionModel);

    return notes;
  }

  static Future<int> onCountAll() async {
    try {
      int countAll = await DatabaseProvider.countAllNotes();

      return countAll;
    } catch (e){
      return 0;
    }
  }

  static Future<bool> create(NoteModel note) async {
    try {
      NoteModel? createdModel;
      createdModel = await _onCreate(note);

      if (createdModel != null) {
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  static Future<NoteModel?> _onCreate(NoteModel note) async {
    try {
      int resultId = await DatabaseProvider.createNote(note);

      if (resultId != 0) {
        NoteModel? createdModel = await onGetById(resultId);

        return createdModel;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<bool> update(NoteModel note) async {
    try {
      NoteModel? updatedModel;
      updatedModel = await _onUpdate(note);

      if (updatedModel != null) {
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  static  Future<NoteModel?> _onUpdate(NoteModel note) async {
    try {
      int result = await DatabaseProvider.updateNote(note);

      if (result != 0) {
        NoteModel? updatedModel = await onGetById(note.id!);

        return updatedModel;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<bool> delete(NoteModel note, int deleteTime) async {
    try {
      NoteModel? deletedModel;
      deletedModel = await _onDelete(note, deleteTime);

      if (deletedModel != null) {
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  static  Future<NoteModel?> _onDelete(NoteModel note, int deleteTime) async {
    try {
      int result = await DatabaseProvider.deleteNote(note, deleteTime);

      if (result != 0) {
        NoteModel? deletedModel = await onGetById(note.id!);

        return deletedModel;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<bool> deleteForever(NoteModel note) async {
    try {
      NoteModel? deletedModel;
      deletedModel = await _onDeleteForever(note);

      if (deletedModel == null) {
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  static  Future<NoteModel?> _onDeleteForever(NoteModel note) async {
    try {
      int result = await DatabaseProvider.deleteForeverNote(note);

      if (result != 0) {
        NoteModel? deletedModel = await onGetById(note.id!);

        return deletedModel;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<bool> restoreFromTrash(NoteModel note, int restoreTime) async {
    try {
      NoteModel? restoredModel;
      restoredModel = await _restoreFromTrash(note, restoreTime);

      if (restoredModel != null) {
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  static  Future<NoteModel?> _restoreFromTrash(NoteModel note, int restoreTime) async {
    try {
      int result = await DatabaseProvider.restoreNote(note, restoreTime);

      if (result != 0) {
        NoteModel? restoredModel = await onGetById(note.id!);

        return restoredModel;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static  Future<NoteModel?> onGetById(int id) async {
    try {
      NoteModel? result = await DatabaseProvider.getNoteById(id);

      return result;
    } catch (e) {
      return null;
    }
  }
}
