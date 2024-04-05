import 'package:flutter_core_v3/app/services/database/database_provider.dart';

import '../../../../../core/common/pagination/models/CorePaginationModel.dart';
import '../models/subject_condition_model.dart';
import '../models/subject_model.dart';

class SubjectDatabaseManager {

  static Future<List<SubjectModel>?> initData() async {
    List<SubjectModel>? subjects = await DatabaseProvider.getAllSubjects();

    return subjects;
  }


  static Future<List<SubjectModel>?> onGetSubjectPagination(CorePaginationModel corePaginationModel, SubjectConditionModel subjectConditionModel) async {
    List<SubjectModel>? subjects = await DatabaseProvider.getSubjectPagination(corePaginationModel, subjectConditionModel);

    return subjects;
  }

  static Future<int> onCountAll() async {
    try {
      int countAll = await DatabaseProvider.countAllSubjects();

      return countAll;
    } catch (e){
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
        SubjectModel? createdModel = await onGetById(resultId);

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

  static  Future<SubjectModel?> _onUpdate(SubjectModel subject) async {
    try {
      int result = await DatabaseProvider.updateSubject(subject);

      if (result != 0) {
        SubjectModel? updatedModel = await onGetById(subject.id!);

        return updatedModel;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static  Future<SubjectModel?> onGetById(int id) async {
    try {
      SubjectModel? result = await DatabaseProvider.getSubjectById(id);

      return result;
    } catch (e) {
      return null;
    }
  }
}
