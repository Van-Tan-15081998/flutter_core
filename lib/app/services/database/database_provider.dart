import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../screens/features/note/models/note_model.dart';

class DatabaseProvider {

  static const int _version = 1;
  static const String _dbName = "hi_tasks.db";

  static Future<Database> _getDB() async {
    return openDatabase(join(await getDatabasesPath(), _dbName),
        onCreate: (db, version) async => await db.execute(
            "CREATE TABLE notes(id INTEGER PRIMARY KEY, title TEXT NOT NULL, description TEXT NOT NULL);"),
        version: _version);
  }

  static Future<int> addNote(NoteModel note) async {
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

  static Future<int> deleteNote(NoteModel note) async {
    final db = await _getDB();
    return await db.delete(
      "notes",
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  static Future<List<NoteModel>?> getAllNotes() async {
    final db = await _getDB();

    // final List<Map<String, dynamic>> maps = await db.query("notes");
    final List<Map<String, dynamic>> maps = await db.query("notes", orderBy: "id DESC");

    if (maps.isEmpty) {
      return null;
    }

    return List.generate(maps.length, (index) => NoteModel.fromJson(maps[index]));
  }

  static Future<NoteModel?> getNoteById(int id) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      "notes",
      where: 'id = ?', // Điều kiện WHERE để lấy ghi chú theo ID
      whereArgs: [id],  // Giá trị ID
    );

    if (maps.isEmpty) {
      return null; // Trả về null nếu không tìm thấy ghi chú với ID tương ứng
    }

    return NoteModel.fromJson(maps.first); // Trả về ghi chú đầu tiên (nếu có)
  }

}
