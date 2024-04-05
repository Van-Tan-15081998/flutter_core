import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../../core/common/pagination/models/CorePaginationModel.dart';
import '../../screens/features/label/models/label_model.dart';
import '../../screens/features/note/models/note_condition_model.dart';
import '../../screens/features/note/models/note_model.dart';
import '../../screens/features/subjects/models/subject_condition_model.dart';
import '../../screens/features/subjects/models/subject_model.dart';
import '../../screens/features/task/models/task_model.dart';

class DatabaseProvider {
  static const int _version = 1;
  static const String _dbName = "hi_notes.db";

  static Future<Database> _getDB() async {
    return openDatabase(join(await getDatabasesPath(), _dbName),
        onCreate: (db, version) async {
      await db.execute(
          "CREATE TABLE notes(id INTEGER PRIMARY KEY, title TEXT NOT NULL, description TEXT NOT NULL, subjectId INTEGER NULL, labels TEXT  NULL, isFavourite INTEGER NULL, createdAt INTEGER NOT NULL, updatedAt INTEGER NULL, deletedAt INTEGER NULL);");
      await db.execute(
          "CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT NOT NULL, description TEXT NOT NULL, subjectId INTEGER NULL, labels TEXT  NULL, statusId INTEGER NOT NULL, createdAt INTEGER NOT NULL, updatedAt INTEGER NULL, deletedAt INTEGER NULL);");
      await db.execute(
          "CREATE TABLE subjects(id INTEGER PRIMARY KEY, title TEXT NOT NULL, color TEXT NOT NULL, createdAt INTEGER NOT NULL, updatedAt INTEGER NULL, deletedAt INTEGER NULL);");
      await db.execute(
          "CREATE TABLE labels(id INTEGER PRIMARY KEY, title TEXT NOT NULL, color TEXT NOT NULL, createdAt INTEGER NOT NULL, updatedAt INTEGER NULL, deletedAt INTEGER NULL);");
    }, version: _version);
  }

  /// NOTES
  static Future<int> countAllNotes() async {
    final db = await _getDB();
    int? countAll = Sqflite.firstIntValue(await db
        .rawQuery('SELECT COUNT(*) FROM notes WHERE deletedAt IS NULL'));

    if (countAll == null) {
      return 0;
    }
    return countAll;
  }

  static Future<int> createNote(NoteModel note) async {
    final db = await _getDB();
    return await db.insert("notes", note.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> updateNote(NoteModel note) async {
    final db = await _getDB();
    return await db.update("notes", note.toJson(),
        where: 'id = ?',
        whereArgs: [note.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> deleteNote(NoteModel note,  int deleteTime) async {
    final db = await _getDB();
    return await db.update("notes",
        {'deletedAt': deleteTime},
        where: 'id = ?',
        whereArgs: [note.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> deleteForeverNote(NoteModel note) async {
    final db = await _getDB();

    return await db.delete(
      "notes",
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  static Future<int> restoreNote(NoteModel note,  int restoreTime) async {
    final db = await _getDB();
    return await db.update("notes",
        {'deletedAt': null, 'updatedAt': restoreTime},
        where: 'id = ?',
        whereArgs: [note.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<NoteModel>?> getAllNotes() async {
    final db = await _getDB();

    final List<Map<String, dynamic>> maps =
        await db.query("notes", orderBy: "id DESC");

    if (maps.isEmpty) {
      return null;
    }

    return List.generate(
        maps.length, (index) => NoteModel.fromJson(maps[index]));
  }

  static Future<List<NoteModel>?> getNotePagination(
      CorePaginationModel corePaginationModel,
      NoteConditionModel noteConditionModel) async {
    final db = await _getDB();

    final List<Map<String, dynamic>> maps = await db.query("notes",
        limit: corePaginationModel.itemPerPage,
        offset: corePaginationModel.currentPageIndex *
            corePaginationModel.itemPerPage,
        where:
            ' ${noteConditionModel.isDeleted == null || noteConditionModel.isDeleted == false ?  "deletedAt IS NULL" : "deletedAt IS NOT NULL"}'
            ' ${noteConditionModel.createdAtStartOfDay != null && noteConditionModel.createdAtEndOfDay != null ? "AND createdAt >= ${noteConditionModel.createdAtStartOfDay} "
                "AND createdAt <= ${noteConditionModel.createdAtEndOfDay} " : ""}'
            ' ${noteConditionModel.subjectId != null ? " AND subjectID = ${noteConditionModel.subjectId}" : ""}'
            ' ${noteConditionModel.searchText != null && noteConditionModel.searchText!.isNotEmpty ? " AND (title LIKE \'%${noteConditionModel.searchText}%\' OR description LIKE \'%${noteConditionModel.searchText}%\')" : ""}',
        orderBy: noteConditionModel.recentlyUpdated != null ? "updatedAt DESC" : "id DESC");

    // raw query
    // final List<Map<String, dynamic>> maps = await db.rawQuery(
    //     'SELECT notes.*, json_each(labels) AS label FROM notes, json_each(notes.labels) WHERE deletedAt IS NULL'
    //     ' ${noteConditionModel.createdAtStartOfDay != null && noteConditionModel.createdAtEndOfDay != null ? "AND createdAt >= ${noteConditionModel.createdAtStartOfDay} AND createdAt <= ${noteConditionModel.createdAtEndOfDay}" : ""}'
    //     ' ${noteConditionModel.labelId != null ? " AND label.value = ${noteConditionModel.labelId}" : ""}'
    //     ' ORDER BY id DESC'
    //     ' LIMIT ${corePaginationModel.itemPerPage}'
    //     ' OFFSET ${corePaginationModel.currentPageIndex * corePaginationModel.itemPerPage}');

    if (maps.isEmpty) {
      return null;
    }

    return List.generate(
        maps.length, (index) => NoteModel.fromJson(maps[index]));
  }

  static Future<NoteModel?> getNoteById(int id) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      "notes",
      where: 'id = ?', // Điều kiện WHERE để lấy ghi chú theo ID
      whereArgs: [id], // Giá trị ID
    );

    if (maps.isEmpty) {
      return null; // Trả về null nếu không tìm thấy ghi chú với ID tương ứng
    }

    return NoteModel.fromJson(maps.first); // Trả về ghi chú đầu tiên (nếu có)
  }

  /// LABELS
  static Future<int> countAllLabels() async {
    final db = await _getDB();
    int? countAll = Sqflite.firstIntValue(await db
        .rawQuery('SELECT COUNT(*) FROM labels WHERE deletedAt IS NULL'));

    if (countAll == null) {
      return 0;
    }
    return countAll;
  }

  static Future<int> createLabel(LabelModel note) async {
    final db = await _getDB();
    return await db.insert("labels", note.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> updateLabel(LabelModel note) async {
    final db = await _getDB();
    return await db.update("labels", note.toJson(),
        where: 'id = ?',
        whereArgs: [note.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> deleteLabel(LabelModel note) async {
    final db = await _getDB();
    return await db.delete(
      "labels",
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  static Future<List<LabelModel>?> getAllLabels() async {
    final db = await _getDB();

    final List<Map<String, dynamic>> maps =
        await db.query("labels", orderBy: "id DESC");

    if (maps.isEmpty) {
      return null;
    }

    return List.generate(
        maps.length, (index) => LabelModel.fromJson(maps[index]));
  }

  static Future<LabelModel?> getLabelById(int id) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      "labels",
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) {
      return null;
    }

    return LabelModel.fromJson(maps.first);
  }

  /// TASKS
  static Future<int> createTask(TaskModel task) async {
    final db = await _getDB();
    return await db.insert("tasks", task.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> updateTask(TaskModel task) async {
    final db = await _getDB();
    return await db.update("tasks", task.toJson(),
        where: 'id = ?',
        whereArgs: [task.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> deleteTask(TaskModel task) async {
    final db = await _getDB();
    return await db.delete(
      "tasks",
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  static Future<List<TaskModel>?> getAllTasks() async {
    final db = await _getDB();

    final List<Map<String, dynamic>> maps =
        await db.query("tasks", orderBy: "id DESC");

    if (maps.isEmpty) {
      return null;
    }

    return List.generate(
        maps.length, (index) => TaskModel.fromJson(maps[index]));
  }

  static Future<TaskModel?> getTaskById(int id) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      "tasks",
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) {
      return null;
    }

    return TaskModel.fromJson(maps.first);
  }

  /// SUBJECTS
  static Future<List<SubjectModel>?> getSubjectPagination(
      CorePaginationModel corePaginationModel,
      SubjectConditionModel subjectConditionModel) async {
    final db = await _getDB();

    final List<Map<String, dynamic>> maps = await db.query("subjects",
        limit: corePaginationModel.itemPerPage,
        offset: corePaginationModel.currentPageIndex *
            corePaginationModel.itemPerPage,
        where: 'deletedAt IS NULL'
        ' ${subjectConditionModel.id != null ? " AND id = ${subjectConditionModel.id}" : ""}',
        orderBy: "id DESC");

    if (maps.isEmpty) {
      return null;
    }

    return List.generate(
        maps.length, (index) => SubjectModel.fromJson(maps[index]));
  }

  static Future<int> countAllSubjects() async {
    final db = await _getDB();
    int? countAll = Sqflite.firstIntValue(await db
        .rawQuery('SELECT COUNT(*) FROM subjects WHERE deletedAt IS NULL'));

    if (countAll == null) {
      return 0;
    }
    return countAll;
  }

  static Future<int> createSubject(SubjectModel subject) async {
    final db = await _getDB();
    return await db.insert("subjects", subject.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> updateSubject(SubjectModel subject) async {
    final db = await _getDB();
    return await db.update("subjects", subject.toJson(),
        where: 'id = ?',
        whereArgs: [subject.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> deleteSubject(SubjectModel subject) async {
    final db = await _getDB();
    return await db.delete(
      "subject",
      where: 'id = ?',
      whereArgs: [subject.id],
    );
  }

  static Future<SubjectModel?> getSubjectById(int id) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      "subjects",
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) {
      return null;
    }

    return SubjectModel.fromJson(maps.first);
  }

  static Future<List<SubjectModel>?> getAllSubjects() async {
    final db = await _getDB();

    final List<Map<String, dynamic>> maps =
        await db.query("subjects", orderBy: "id DESC");

    if (maps.isEmpty) {
      return null;
    }

    return List.generate(
        maps.length, (index) => SubjectModel.fromJson(maps[index]));
  }
}
