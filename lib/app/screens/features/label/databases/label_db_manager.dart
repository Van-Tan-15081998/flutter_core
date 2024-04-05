import 'package:flutter_core_v3/app/services/database/database_provider.dart';

import '../models/label_model.dart';

class LabelDatabaseManager {
  static Future<List<LabelModel>?> initData() async {
    List<LabelModel>? labels = await DatabaseProvider.getAllLabels();

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
        LabelModel? createdModel = await onGetById(resultId);

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
        LabelModel? updatedModel = await onGetById(label.id!);

        return updatedModel;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static  Future<LabelModel?> onGetById(int id) async {
    try {
      LabelModel? result = await DatabaseProvider.getLabelById(id);

      return result;
    } catch (e) {
      return null;
    }
  }
}
