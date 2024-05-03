import 'package:flutter_core_v3/app/services/database/database_provider.dart';
import '../../../../../core/common/pagination/models/CorePaginationModel.dart';
import '../models/subject_condition_model.dart';
import '../models/subject_model.dart';

class SubjectDatabaseManager {
  static Future<List<SubjectModel>?> all() async {
    List<SubjectModel>? subjects = await DatabaseProvider.getAllSubjects();

    return subjects;
  }

  static Future<List<SubjectModel>?> onGetSubjectPagination(
      CorePaginationModel corePaginationModel,
      SubjectConditionModel subjectConditionModel) async {
    List<SubjectModel>? subjects = await DatabaseProvider.getSubjectPagination(
        corePaginationModel, subjectConditionModel);

    return subjects;
  }

  static Future<int> onCountAll() async {
    try {
      int countAll = await DatabaseProvider.countAllSubjects();

      return countAll;
    } catch (e) {
      return 0;
    }
  }

  static Future<bool> create(SubjectModel subject) async {
    try {
      SubjectModel? createdModel;
      createdModel = await _onCreate(subject);

      if (createdModel != null) {
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  static Future<SubjectModel?> _onCreate(SubjectModel subject) async {
    try {
      int resultId = await DatabaseProvider.createSubject(subject);

      if (resultId != 0) {
        SubjectModel? createdModel = await getById(resultId);

        return createdModel;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<bool> update(SubjectModel subject) async {
    try {
      SubjectModel? updatedModel;
      updatedModel = await _onUpdate(subject);

      if (updatedModel != null) {
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  static Future<SubjectModel?> _onUpdate(SubjectModel subject) async {
    try {
      int result = await DatabaseProvider.updateSubject(subject);

      if (result != 0) {
        SubjectModel? updatedModel = await getById(subject.id!);

        return updatedModel;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<bool> delete(SubjectModel subject, int deleteTime) async {
    try {
      SubjectModel? deletedModel;
      deletedModel = await _onDelete(subject, deleteTime);

      if (deletedModel != null) {
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  static Future<SubjectModel?> _onDelete(
      SubjectModel subject, int deleteTime) async {
    try {
      int result = await DatabaseProvider.deleteSubject(subject, deleteTime);

      if (result != 0) {
        SubjectModel? deletedModel = await getById(subject.id!);

        return deletedModel;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<bool> deleteForever(SubjectModel subject) async {
    try {
      SubjectModel? deletedModel;
      deletedModel = await _onDeleteForever(subject);

      if (deletedModel == null) {
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  static Future<SubjectModel?> _onDeleteForever(SubjectModel subject) async {
    try {
      int result = await DatabaseProvider.deleteForeverSubject(subject);

      if (result != 0) {
        SubjectModel? deletedModel = await getById(subject.id!);

        return deletedModel;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<bool> restoreFromTrash(
      SubjectModel subject, int restoreTime) async {
    try {
      SubjectModel? restoredModel;
      restoredModel = await _restoreFromTrash(subject, restoreTime);

      if (restoredModel != null) {
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  static Future<SubjectModel?> _restoreFromTrash(
      SubjectModel subject, int restoreTime) async {
    try {
      int result = await DatabaseProvider.restoreSubject(subject, restoreTime);

      if (result != 0) {
        SubjectModel? restoredModel = await getById(subject.id!);

        return restoredModel;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<SubjectModel?> getById(int id) async {
    try {
      SubjectModel? result = await DatabaseProvider.getSubjectById(id);

      return result;
    } catch (e) {
      return null;
    }
  }

  static Future<int> countChildren(SubjectModel subject) async {
    try {
      int? countChildren;
      countChildren = await DatabaseProvider.countChildren(subject);

      return countChildren;
    } catch (e) {
      return 0;
    }
  }

  static Future<int> countNotes(SubjectModel subject) async {
    try {
      int? countNotes;
      countNotes = await DatabaseProvider.countNotes(subject);

      return countNotes;
    } catch (e) {
      return 0;
    }
  }

  static Future<bool> checkCanDeleteSubject(SubjectModel subject) async {
    // Only can delete subject it has not sub subjects and notes
    try {
      int? countNotes;
      int? countChildren;

      countNotes = await DatabaseProvider.countNotes(subject);
      countChildren = await DatabaseProvider.countChildren(subject);

      if (countNotes == 0 && countChildren == 0) {
        return true;
      }

    }  catch (e) {
      return false;
    }

    return false;
  }
}
