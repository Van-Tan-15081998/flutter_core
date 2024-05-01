import 'package:flutter/material.dart';
import '../databases/subject_db_manager.dart';

class SubjectNotifier with ChangeNotifier {
  int _countAllSubjects = 0;
  int get countAllSubjects => _countAllSubjects;

  bool _reloadPage = false;
  bool get reloadPage => _reloadPage;

  SubjectNotifier() {
    onCountAll();
  }

  /*
  Reload Page for Subject List Folder View Mode
   */
  void onReloadPage() {
    _reloadPage = true;
    notifyListeners();
  }

  /*
  UnReload Page for Subject List Folder View Mode
   */
  void onResetReloadPage() {
    _reloadPage = false;
    notifyListeners();
  }

  Future onCountAll() async {
    _countAllSubjects = await SubjectDatabaseManager.onCountAll();
    notifyListeners();
  }
}
