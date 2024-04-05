import 'package:flutter/material.dart';
import '../databases/task_db_manager.dart';
import '../models/task_model.dart';

class TaskNotifier with ChangeNotifier {
  List<TaskModel> _tasks = [];

  List<TaskModel>? get tasks => _tasks;

  TaskNotifier() {
    getAll();
  }

  Future<bool> addTask(TaskModel task) async {
    try {
      TaskModel? taskAddToDatabase;
      taskAddToDatabase = await addTaskToDatabase(task);

      if (taskAddToDatabase != null) {
        _tasks.insert(0, taskAddToDatabase);
        notifyListeners();
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  Future<TaskModel?> addTaskToDatabase(TaskModel task) async {
    TaskModel? taskAddToDatabase;
    taskAddToDatabase = await TaskDatabaseManager.onCreate(task);
    return taskAddToDatabase;
  }

  Future<bool> updateTask(TaskModel task) async {
    try {
      TaskModel? taskUpdateToDatabase;
      taskUpdateToDatabase = await updateTaskToDatabase(task);

      if (taskUpdateToDatabase != null) {
        int updateId = taskUpdateToDatabase.id!;
        bool isIdExists = _tasks.any((item) => item.id == updateId);
        if (isIdExists) {
          for (int i = 0; i < _tasks.length; i++) {
            if (_tasks[i].id == updateId) {
              _tasks[i] = taskUpdateToDatabase;
              notifyListeners();
            }
          }
        }
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  Future<TaskModel?> updateTaskToDatabase(TaskModel task) async {
    TaskModel? taskAddToDatabase;
    taskAddToDatabase = await TaskDatabaseManager.onUpdate(task);
    return taskAddToDatabase;
  }

  bool deleteTask(TaskModel task) {
    try {
      int deleteId = task.id!;
      bool isIdExists = _tasks.any((item) => item.id == deleteId);

      if (isIdExists) {
        for (var t in _tasks) {
          if (task.id == deleteId) {
            _tasks.remove(t);
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

  Future<List<TaskModel>?> getAll() async {
    List<TaskModel>? result = [];
    result = await TaskDatabaseManager.initData();

    if (result != null) {
      _tasks = result;
      notifyListeners();
    }
    return null;
  }
}
