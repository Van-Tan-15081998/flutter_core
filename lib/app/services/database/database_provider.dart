import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../../core/common/pagination/models/CorePaginationModel.dart';
import '../../screens/features/label/models/label_condition_model.dart';
import '../../screens/features/label/models/label_model.dart';
import '../../screens/features/note/models/note_condition_model.dart';
import '../../screens/features/note/models/note_model.dart';
import '../../screens/features/subjects/models/subject_condition_model.dart';
import '../../screens/features/subjects/models/subject_model.dart';
import '../../screens/features/template/models/template_condition_model.dart';
import '../../screens/features/template/models/template_model.dart';

class DatabaseProvider {
  static const int _version = 1;
  static const String _dbName = "hi_notes.db";

  static Future<Database> _getDB() async {
    return openDatabase(join(await getDatabasesPath(), _dbName),
        onCreate: (db, version) async {
      await db.execute(
          "CREATE TABLE notes(id INTEGER PRIMARY KEY, title TEXT NULL, description TEXT NULL, subjectId INTEGER NULL, labels TEXT  NULL, isFavourite INTEGER NULL, createdAt INTEGER NULL, createdAtDayFormat INTEGER NULL, createdForDay INTEGER NULL, planedAlertHour INTEGER NULL,  updatedAt INTEGER NULL, deletedAt INTEGER NULL);");
      await db.execute(
          "CREATE TABLE templates(id INTEGER PRIMARY KEY, title TEXT NULL, description TEXT NULL, subjectId INTEGER NULL, labels TEXT  NULL, isFavourite INTEGER NULL, createdAt INTEGER NULL, updatedAt INTEGER NULL, deletedAt INTEGER NULL);");
      await db.execute(
          "CREATE TABLE subjects(id INTEGER PRIMARY KEY, title TEXT NULL, color TEXT NULL, parentId INTEGER NULL, createdAt INTEGER NULL, updatedAt INTEGER NULL, deletedAt INTEGER NULL);");
      await db.execute(
          "CREATE TABLE labels(id INTEGER PRIMARY KEY, title TEXT NULL, color TEXT NULL, createdAt INTEGER NULL, updatedAt INTEGER NULL, deletedAt INTEGER NULL);");
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

  static Future<int> favouriteNote(NoteModel note, int? isFavourite) async {
    final db = await _getDB();
    return await db.update("notes", {'isFavourite': isFavourite},
        where: 'id = ?',
        whereArgs: [note.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> deleteNote(NoteModel note, int deleteTime) async {
    final db = await _getDB();
    return await db.update("notes", {'deletedAt': deleteTime},
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

  static Future<int> restoreNote(NoteModel note, int restoreTime) async {
    final db = await _getDB();
    return await db.update(
        "notes", {'deletedAt': null, 'updatedAt': restoreTime},
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

  static Future<List<NoteModel>?> getAllNotesDistinctCreatedAt() async {
    final db = await _getDB();

    List<NoteModel> mapsResult = [];

    final List<Map<String, dynamic>> distinctCreatedAtDayFormatMaps =
        await db.rawQuery(
      'SELECT DISTINCT notes.createdAtDayFormat FROM notes WHERE notes.deletedAt IS NULL',
    );

    final List<Map<String, dynamic>> distinctCreatedForDayMaps =
        await db.rawQuery(
      'SELECT DISTINCT notes.createdForDay FROM notes WHERE notes.deletedAt IS NULL',
    );

    if (distinctCreatedAtDayFormatMaps.isEmpty &&
        distinctCreatedForDayMaps.isEmpty) {
      return null;
    }

    if (distinctCreatedAtDayFormatMaps.isNotEmpty) {
      for (var element in distinctCreatedAtDayFormatMaps) {
        mapsResult.add(NoteModel.fromJson(element));
      }
    }

    if (distinctCreatedForDayMaps.isNotEmpty) {
      for (var element in distinctCreatedForDayMaps) {
        mapsResult.add(NoteModel.fromJson(element));
      }
    }

    return mapsResult;
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
            ' ${noteConditionModel.isDeleted == null || noteConditionModel.isDeleted == false ? "deletedAt IS NULL" : "deletedAt IS NOT NULL"}'
            ' ${noteConditionModel.createdAtStartOfDay != null && noteConditionModel.createdAtEndOfDay != null ? "AND ((createdAt >= ${noteConditionModel.createdAtStartOfDay} "
                "AND createdAt <= ${noteConditionModel.createdAtEndOfDay} ) OR (createdForDay >= ${noteConditionModel.createdAtStartOfDay} AND createdForDay <= ${noteConditionModel.createdAtEndOfDay}))" : ""}'
            ' ${noteConditionModel.subjectId != null ? " AND subjectID = ${noteConditionModel.subjectId}" : ""}'
            ' ${noteConditionModel.onlyNoneSubject == true ? " AND subjectID IS NULL" : ""}'
            ' ${noteConditionModel.favourite != null ? " AND isFavourite IS NOT NULL" : ""}'
            ' ${noteConditionModel.searchText != null && noteConditionModel.searchText!.isNotEmpty ? " AND (title LIKE \'%${noteConditionModel.searchText}%\' OR description LIKE \'%${noteConditionModel.searchText}%\')" : ""}',
        orderBy: noteConditionModel.recentlyUpdated != null
            ? "updatedAt DESC"
            : "id DESC");

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
  static Future<List<LabelModel>?> getLabelPagination(
      CorePaginationModel corePaginationModel,
      LabelConditionModel labelConditionModel) async {
    final db = await _getDB();

    final List<Map<String, dynamic>> maps = await db.query("labels",
        limit: corePaginationModel.itemPerPage,
        offset: corePaginationModel.currentPageIndex *
            corePaginationModel.itemPerPage,
        where:
            ' ${labelConditionModel.isDeleted == null || labelConditionModel.isDeleted == false ? "deletedAt IS NULL" : "deletedAt IS NOT NULL"}'
            ' ${labelConditionModel.id != null ? " AND id = ${labelConditionModel.id}" : ""}'
            ' ${labelConditionModel.searchText != null && labelConditionModel.searchText!.isNotEmpty ? " AND title LIKE \'%${labelConditionModel.searchText}%\'" : ""}',
        orderBy: "id DESC");

    if (maps.isEmpty) {
      return null;
    }

    return List.generate(
        maps.length, (index) => LabelModel.fromJson(maps[index]));
  }

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

  static Future<int> deleteLabel(LabelModel label, int deleteTime) async {
    final db = await _getDB();
    return await db.update("labels", {'deletedAt': deleteTime},
        where: 'id = ?',
        whereArgs: [label.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> deleteForeverLabel(LabelModel label) async {
    final db = await _getDB();

    return await db.delete(
      "labels",
      where: 'id = ?',
      whereArgs: [label.id],
    );
  }

  static Future<int> restoreLabel(LabelModel label, int restoreTime) async {
    final db = await _getDB();
    return await db.update(
        "labels", {'deletedAt': null, 'updatedAt': restoreTime},
        where: 'id = ?',
        whereArgs: [label.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<LabelModel>?> getAllLabels() async {
    final db = await _getDB();

    final List<Map<String, dynamic>> maps = await db.query("labels",
        where: 'deletedAt IS NULL', orderBy: "id DESC");

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

  /// SUBJECTS
  static Future<List<SubjectModel>?> getSubjectPagination(
      CorePaginationModel corePaginationModel,
      SubjectConditionModel subjectConditionModel) async {
    final db = await _getDB();

    final List<Map<String, dynamic>> maps = await db.query("subjects",
        limit: corePaginationModel.itemPerPage,
        offset: corePaginationModel.currentPageIndex *
            corePaginationModel.itemPerPage,
        where:
            ' ${subjectConditionModel.isDeleted == null || subjectConditionModel.isDeleted == false ? "deletedAt IS NULL" : "deletedAt IS NOT NULL"}'
            ' ${subjectConditionModel.id != null ? " AND id = ${subjectConditionModel.id}" : ""}'
            ' ${subjectConditionModel.isRootSubject == true ? " AND parentId IS NULL" : ""}'
            ' ${subjectConditionModel.onlyParentId != null ? " AND parentId = ${subjectConditionModel.onlyParentId}" : ""}'
            ' ${subjectConditionModel.parentId != null ? " AND (parentId = ${subjectConditionModel.parentId} OR id = ${subjectConditionModel.parentId})" : ""}'
            ' ${subjectConditionModel.searchText != null && subjectConditionModel.searchText!.isNotEmpty ? " AND title LIKE \'%${subjectConditionModel.searchText}%\'" : ""}',
        orderBy: subjectConditionModel.parentId != null ? "id ASC" : "id DESC");

    if (maps.isEmpty) {
      return null;
    }

    return List.generate(
        maps.length, (index) => SubjectModel.fromJson(maps[index]));
  }

  static Future<int> countAllSubjects() async {
    final db = await _getDB();
    int? countAll = Sqflite.firstIntValue(await db
        .rawQuery('SELECT COUNT(*) FROM subjects WHERE deletedAt IS NULL AND parentId IS NULL'));

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

    final List<Map<String, dynamic>> maps = await db.query("subjects",
        where: 'deletedAt IS NULL', orderBy: "id DESC");

    if (maps.isEmpty) {
      return null;
    }

    return List.generate(
        maps.length, (index) => SubjectModel.fromJson(maps[index]));
  }

  static Future<int> deleteSubject(SubjectModel subject, int deleteTime) async {
    final db = await _getDB();
    return await db.update("subjects", {'deletedAt': deleteTime},
        where: 'id = ?',
        whereArgs: [subject.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> deleteForeverSubject(SubjectModel subject) async {
    final db = await _getDB();

    return await db.delete(
      "subjects",
      where: 'id = ?',
      whereArgs: [subject.id],
    );
  }

  static Future<int> restoreSubject(
      SubjectModel subject, int restoreTime) async {
    final db = await _getDB();
    return await db.update(
        "subjects", {'deletedAt': null, 'updatedAt': restoreTime},
        where: 'id = ?',
        whereArgs: [subject.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> countChildren(SubjectModel subject) async {
    final db = await _getDB();
    int? countAll = Sqflite.firstIntValue(await db.rawQuery(
        'SELECT COUNT(*) FROM subjects WHERE deletedAt IS NULL AND parentId = ${subject.id}'));

    if (countAll == null) {
      return 0;
    }
    return countAll;
  }

  static Future<int> countNotes(SubjectModel subject) async {
    final db = await _getDB();
    int? countAll = Sqflite.firstIntValue(await db.rawQuery(
        'SELECT COUNT(*) FROM notes WHERE deletedAt IS NULL AND subjectId = ${subject.id}'));

    if (countAll == null) {
      return 0;
    }
    return countAll;
  }

  /// TEMPLATES
  static Future<int> countAllTemplates() async {
    final db = await _getDB();
    int? countAll = Sqflite.firstIntValue(await db
        .rawQuery('SELECT COUNT(*) FROM templates WHERE deletedAt IS NULL'));

    if (countAll == null) {
      return 0;
    }
    return countAll;
  }

  static Future<int> createTemplate(TemplateModel template) async {
    final db = await _getDB();
    return await db.insert("templates", template.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> updateTemplate(TemplateModel template) async {
    final db = await _getDB();
    return await db.update("templates", template.toJson(),
        where: 'id = ?',
        whereArgs: [template.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> favouriteTemplate(
      TemplateModel template, int? isFavourite) async {
    final db = await _getDB();
    return await db.update("templates", {'isFavourite': isFavourite},
        where: 'id = ?',
        whereArgs: [template.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> deleteTemplate(
      TemplateModel template, int deleteTime) async {
    final db = await _getDB();
    return await db.update("templates", {'deletedAt': deleteTime},
        where: 'id = ?',
        whereArgs: [template.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> deleteForeverTemplate(TemplateModel template) async {
    final db = await _getDB();

    return await db.delete(
      "templates",
      where: 'id = ?',
      whereArgs: [template.id],
    );
  }

  static Future<int> restoreTemplate(
      TemplateModel template, int restoreTime) async {
    final db = await _getDB();
    return await db.update(
        "templates", {'deletedAt': null, 'updatedAt': restoreTime},
        where: 'id = ?',
        whereArgs: [template.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<TemplateModel>?> getAllTemplates() async {
    final db = await _getDB();

    final List<Map<String, dynamic>> maps =
        await db.query("templates", orderBy: "id DESC");

    if (maps.isEmpty) {
      return null;
    }

    return List.generate(
        maps.length, (index) => TemplateModel.fromJson(maps[index]));
  }

  static Future<List<TemplateModel>?> getTemplatePagination(
      CorePaginationModel corePaginationModel,
      TemplateConditionModel templateConditionModel) async {
    final db = await _getDB();

    final List<Map<String, dynamic>> maps = await db.query("templates",
        limit: corePaginationModel.itemPerPage,
        offset: corePaginationModel.currentPageIndex *
            corePaginationModel.itemPerPage,
        where:
            ' ${templateConditionModel.isDeleted == null || templateConditionModel.isDeleted == false ? "deletedAt IS NULL" : "deletedAt IS NOT NULL"}'
            ' ${templateConditionModel.subjectId != null ? " AND subjectID = ${templateConditionModel.subjectId}" : ""}'
            ' ${templateConditionModel.favourite != null ? " AND isFavourite IS NOT NULL" : ""}'
            ' ${templateConditionModel.searchText != null && templateConditionModel.searchText!.isNotEmpty ? " AND (title LIKE \'%${templateConditionModel.searchText}%\' OR description LIKE \'%${templateConditionModel.searchText}%\')" : ""}',
        orderBy: templateConditionModel.recentlyUpdated != null
            ? "updatedAt DESC"
            : "id DESC");

    if (maps.isEmpty) {
      return null;
    }

    return List.generate(
        maps.length, (index) => TemplateModel.fromJson(maps[index]));
  }

  static Future<TemplateModel?> getTemplateById(int id) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      "templates",
      where: 'id = ?', // Điều kiện WHERE để lấy ghi chú theo ID
      whereArgs: [id], // Giá trị ID
    );

    if (maps.isEmpty) {
      return null; // Trả về null nếu không tìm thấy ghi chú với ID tương ứng
    }

    return TemplateModel.fromJson(
        maps.first); // Trả về ghi chú đầu tiên (nếu có)
  }
}
