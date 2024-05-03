import 'package:flutter/material.dart';
import '../databases/template_db_manager.dart';

class TemplateNotifier with ChangeNotifier {
  int _countAllTemplates = 0;
  int get countAllTemplates => _countAllTemplates;
  TemplateNotifier() {
    onCountAll();
  }

  Future onCountAll() async {
    _countAllTemplates = await TemplateDatabaseManager.onCountAll();
    notifyListeners();
  }
}
