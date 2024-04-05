import 'package:flutter/material.dart';

import '../databases/label_db_manager.dart';
import '../models/label_model.dart';

class LabelNotifier with ChangeNotifier {
  List<LabelModel> _labels = [];

  List<LabelModel>? get labels => _labels;

  int _countAllLabels = 0;
  int get countAllLabels => _countAllLabels;

  LabelNotifier() {
    getAll();
    onCountAll();
  }

  refresh() {
    getAll();
  }

  Future onCountAll() async {
    _countAllLabels = await LabelDatabaseManager.onCountAll();
    notifyListeners();
  }

  // Future<bool> addLabel(LabelModel label) async {
  //   try {
  //     LabelModel? labelAddToDatabase;
  //     labelAddToDatabase = await addLabelToDatabase(label);
  //
  //     if (labelAddToDatabase != null) {
  //       _labels.insert(0, labelAddToDatabase);
  //       notifyListeners();
  //       return true;
  //     }
  //   } catch (e) {
  //     return false;
  //   }
  //   return false;
  // }

  // Future<LabelModel?> addLabelToDatabase(LabelModel label) async {
  //   LabelModel? labelAddToDatabase;
  //   labelAddToDatabase = await LabelDatabaseManager.onCreate(label);
  //   return labelAddToDatabase;
  // }

  // Future<bool> updateLabel(LabelModel label) async {
  //   try {
  //     LabelModel? labelUpdateToDatabase;
  //     labelUpdateToDatabase = await updateLabelToDatabase(label);
  //
  //     if (labelUpdateToDatabase != null) {
  //       int updateId = labelUpdateToDatabase.id!;
  //       bool isIdExists = _labels.any((item) => item.id == updateId);
  //       if (isIdExists) {
  //         for (int i = 0; i < _labels.length; i++) {
  //           if (_labels[i].id == updateId) {
  //             _labels[i] = labelUpdateToDatabase;
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

  // Future<LabelModel?> updateLabelToDatabase(LabelModel label) async {
  //   LabelModel? labelAddToDatabase;
  //   labelAddToDatabase = await LabelDatabaseManager.onUpdate(label);
  //   return labelAddToDatabase;
  // }

  bool deleteLabel(LabelModel label) {
    try {
      int deleteId = label.id!;
      bool isIdExists = _labels.any((item) => item.id == deleteId);

      if (isIdExists) {
        for (var l in _labels) {
          if (l.id == deleteId) {
            _labels.remove(l);
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

  Future<List<LabelModel>?> getAll() async {
    List<LabelModel>? result = [];
    result = await LabelDatabaseManager.initData();

    if (result != null) {
      _labels = result;
      notifyListeners();
    }
    return null;
  }
}
