import 'package:flutter/material.dart';

import '../databases/subject_db_manager.dart';
import '../models/subject_model.dart';

class SubjectNotifier with ChangeNotifier {
  List<SubjectModel> _subjects = [];

  List<SubjectModel>? get subjects => _subjects;

  int _countAllSubjects = 0;
  int get countAllSubjects => _countAllSubjects;

  SubjectNotifier() {
    getAll();
    onCountAll();
  }

  refresh() {
    getAll();
  }

  Future onCountAll() async {
    _countAllSubjects = await SubjectDatabaseManager.onCountAll();
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

  // bool deleteLabel(LabelModel label) {
  //   try {
  //     int deleteId = label.id!;
  //     bool isIdExists = _labels.any((item) => item.id == deleteId);
  //
  //     if (isIdExists) {
  //       for (var l in _labels) {
  //         if (l.id == deleteId) {
  //           _labels.remove(l);
  //           notifyListeners();
  //         }
  //       }
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } catch (e) {
  //     return false;
  //   }
  // }

  Future<List<SubjectModel>?> getAll() async {
    List<SubjectModel>? result = [];
    result = await SubjectDatabaseManager.initData();

    if (result != null) {
      _subjects = result;
      notifyListeners();
    }
    return null;
  }
}
