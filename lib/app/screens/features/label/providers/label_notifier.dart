import 'package:flutter/material.dart';

import '../databases/label_db_manager.dart';
import '../models/label_model.dart';

class LabelNotifier with ChangeNotifier {

  int _countAllLabels = 0;
  int get countAllLabels => _countAllLabels;

  LabelNotifier() {
    onCountAll();
  }

  Future onCountAll() async {
    _countAllLabels = await LabelDatabaseManager.onCountAll();
    notifyListeners();
  }
}
