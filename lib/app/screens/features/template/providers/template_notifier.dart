import 'package:flutter/material.dart';

import '../../../../../core/common/pagination/models/CorePaginationModel.dart';
import '../databases/template_db_manager.dart';
import '../models/template_model.dart';

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
