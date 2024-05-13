import 'package:flutter_core_v3/app/services/database/database_provider.dart';
import '../../../../../core/common/pagination/models/CorePaginationModel.dart';
import '../models/template_condition_model.dart';
import '../models/template_model.dart';

class TemplateDatabaseManager {
  static Future<List<TemplateModel>?> all() async {
    List<TemplateModel>? templates = await DatabaseProvider.getAllTemplates();

    return templates;
  }

  static Future<List<TemplateModel>?> onGetTemplatePagination(
      CorePaginationModel corePaginationModel,
      TemplateConditionModel templateConditionModel) async {
    List<TemplateModel>? templates =
        await DatabaseProvider.getTemplatePagination(
            corePaginationModel, templateConditionModel);

    return templates;
  }

  static Future<int> onCountAll() async {
    try {
      int countAll = await DatabaseProvider.countAllTemplates();

      return countAll;
    } catch (e) {
      return 0;
    }
  }

  static Future<bool> create(TemplateModel template) async {
    try {
      TemplateModel? createdModel;
      createdModel = await _onCreate(template);

      if (createdModel != null) {
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  static Future<TemplateModel?> _onCreate(TemplateModel template) async {
    try {
      int resultId = await DatabaseProvider.createTemplate(template);

      if (resultId != 0) {
        TemplateModel? createdModel = await getById(resultId);

        return createdModel;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<bool> update(TemplateModel template) async {
    try {
      TemplateModel? updatedModel;
      updatedModel = await _onUpdate(template);

      if (updatedModel != null) {
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  static Future<TemplateModel?> _onUpdate(TemplateModel template) async {
    try {
      int result = await DatabaseProvider.updateTemplate(template);

      if (result != 0) {
        TemplateModel? updatedModel = await getById(template.id!);

        return updatedModel;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<bool> favourite(
      TemplateModel template, int? isFavourite) async {
    try {
      TemplateModel? favouriteModel;
      favouriteModel = await _onFavourite(template, isFavourite);

      if (favouriteModel != null) {
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  static Future<TemplateModel?> _onFavourite(
      TemplateModel template, int? isFavourite) async {
    try {
      int result =
          await DatabaseProvider.favouriteTemplate(template, isFavourite);

      if (result != 0) {
        TemplateModel? favouriteModel = await getById(template.id!);

        return favouriteModel;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<bool> delete(TemplateModel template, int deleteTime) async {
    try {
      TemplateModel? deletedModel;
      deletedModel = await _onDelete(template, deleteTime);

      if (deletedModel != null) {
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  static Future<TemplateModel?> _onDelete(
      TemplateModel template, int deleteTime) async {
    try {
      int result = await DatabaseProvider.deleteTemplate(template, deleteTime);

      if (result != 0) {
        TemplateModel? deletedModel = await getById(template.id!);

        return deletedModel;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<bool> deleteForever(TemplateModel template) async {
    try {
      TemplateModel? deletedModel;
      deletedModel = await _onDeleteForever(template);

      if (deletedModel == null) {
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  static Future<TemplateModel?> _onDeleteForever(TemplateModel template) async {
    try {
      int result = await DatabaseProvider.deleteForeverTemplate(template);

      if (result != 0) {
        TemplateModel? deletedModel = await getById(template.id!);

        return deletedModel;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<bool> restoreFromTrash(
      TemplateModel template, int restoreTime) async {
    try {
      TemplateModel? restoredModel;
      restoredModel = await _restoreFromTrash(template, restoreTime);

      if (restoredModel != null) {
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  static Future<TemplateModel?> _restoreFromTrash(
      TemplateModel template, int restoreTime) async {
    try {
      int result =
          await DatabaseProvider.restoreTemplate(template, restoreTime);

      if (result != 0) {
        TemplateModel? restoredModel = await getById(template.id!);

        return restoredModel;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<TemplateModel?> getById(int id) async {
    try {
      TemplateModel? result = await DatabaseProvider.getTemplateById(id);

      return result;
    } catch (e) {
      return null;
    }
  }
}
