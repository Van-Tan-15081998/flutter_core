import 'package:flutter/material.dart';
import '../databases/subject_db_manager.dart';

class SubjectNotifier with ChangeNotifier {
  int _countAllSubjects = 0;
  int get countAllSubjects => _countAllSubjects;

  SubjectNotifier() {
    onCountAll();
  }

  Future onCountAll() async {
    _countAllSubjects = await SubjectDatabaseManager.onCountAll();
    notifyListeners();
  }
}
