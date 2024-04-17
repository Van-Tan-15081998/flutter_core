import 'package:flutter_core_v3/app/services/database/database_provider.dart';

import '../../../../../core/common/pagination/models/CorePaginationModel.dart';
import '../models/label_condition_model.dart';
import '../models/label_model.dart';

class LabelDatabaseManager {
  static Future<List<LabelModel>?> all() async {
    List<LabelModel>? labels = await DatabaseProvider.getAllLabels();

    return labels;
  }

  static Future<List<LabelModel>?> onGetLabelPagination(CorePaginationModel corePaginationModel, LabelConditionModel labelConditionModel) async {
    List<LabelModel>? labels = await DatabaseProvider.getLabelPagination(corePaginationModel, labelConditionModel);

    return labels;
  }

  static Future<int> onCountAll() async {
    try {
      int countAll = await DatabaseProvider.countAllLabels();

      return countAll;
    } catch (e){
      return 0;
    }
  }

  static Future<bool> create(LabelModel label) async {
    try {
      LabelModel? createdModel;
      createdModel = await _onCreate(label);

      if (createdModel != null) {
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  static Future<LabelModel?> _onCreate(LabelModel label) async {
    try {
      int resultId = await DatabaseProvider.createLabel(label);

      if (resultId != 0) {
        LabelModel? createdModel = await getById(resultId);

        return createdModel;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<bool> update(LabelModel label) async {
    try {
      LabelModel? updatedModel;
      updatedModel = await _onUpdate(label);

      if (updatedModel != null) {
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  static  Future<LabelModel?> _onUpdate(LabelModel label) async {
    try {
      int result = await DatabaseProvider.updateLabel(label);

      if (result != 0) {
        LabelModel? updatedModel = await getById(label.id!);

        return updatedModel;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<bool> delete(LabelModel label, int deleteTime) async {
    try {
      LabelModel? deletedModel;
      deletedModel = await _onDelete(label, deleteTime);

      if (deletedModel != null) {
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  static  Future<LabelModel?> _onDelete(LabelModel label, int deleteTime) async {
    try {
      int result = await DatabaseProvider.deleteLabel(label, deleteTime);

      if (result != 0) {
        LabelModel? deletedModel = await getById(label.id!);

        return deletedModel;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<bool> deleteForever(LabelModel label) async {
    try {
      LabelModel? deletedModel;
      deletedModel = await _onDeleteForever(label);

      if (deletedModel == null) {
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  static  Future<LabelModel?> _onDeleteForever(LabelModel label) async {
    try {
      int result = await DatabaseProvider.deleteForeverLabel(label);

      if (result != 0) {
        LabelModel? deletedModel = await getById(label.id!);

        return deletedModel;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<bool> restoreFromTrash(LabelModel label, int restoreTime) async {
    try {
      LabelModel? restoredModel;
      restoredModel = await _restoreFromTrash(label, restoreTime);

      if (restoredModel != null) {
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  static  Future<LabelModel?> _restoreFromTrash(LabelModel label, int restoreTime) async {
    try {
      int result = await DatabaseProvider.restoreLabel(label, restoreTime);

      if (result != 0) {
        LabelModel? restoredModel = await getById(label.id!);

        return restoredModel;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static  Future<LabelModel?> getById(int id) async {
    try {
      LabelModel? result = await DatabaseProvider.getLabelById(id);

      return result;
    } catch (e) {
      return null;
    }
  }
}
