import 'package:flutter_core_v3/app/services/database/database_provider.dart';
import '../models/task_model.dart';

class TaskDatabaseManager {
  static Future<List<TaskModel>?> initData() async {
    List<TaskModel>? tasks = await DatabaseProvider.getAllTasks();

    return tasks;
  }

  static Future<TaskModel?> onCreate(TaskModel task) async {
    try {
      int resultId = await DatabaseProvider.createTask(task);

      if (resultId != 0) {
        TaskModel? createdModel = await onGetById(resultId);

        return createdModel;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static  Future<TaskModel?> onUpdate(TaskModel task) async {
    try {
      int result = await DatabaseProvider.updateTask(task);

      if (result != 0) {
        TaskModel? updatedModel = await onGetById(task.id!);

        return updatedModel;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static  Future<TaskModel?> onGetById(int id) async {
    try {
      TaskModel? result = await DatabaseProvider.getTaskById(id);

        return result;
    } catch (e) {
      return null;
    }
  }
}
