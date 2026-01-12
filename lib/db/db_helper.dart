import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../util/constants.dart';
import '../models/note.dart';
import '../models/folder.dart';
import '../models/tag.dart';
import '../models/user.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB(AppConstants.dbName);
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: AppConstants.dbVersion,
      onCreate: _createDB,
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE ${AppConstants.tbUsers} (
      username TEXT PRIMARY KEY,
      password_hash TEXT NOT NULL
    )
    ''');

    await db.execute('''
    CREATE TABLE ${AppConstants.tbNotes} (
      id TEXT PRIMARY KEY,
      title TEXT NOT NULL,
      content TEXT NOT NULL,
      folder_id TEXT,
      username TEXT NOT NULL,
      created_at TEXT NOT NULL,
      modified_at TEXT NOT NULL,
      tags TEXT,
      color_index INTEGER DEFAULT 0,
      is_pinned INTEGER DEFAULT 0,
      is_favorite INTEGER DEFAULT 0,
      attachments TEXT,
      content_json TEXT,
      FOREIGN KEY (username) REFERENCES ${AppConstants.tbUsers} (username) ON DELETE CASCADE,
      FOREIGN KEY (folder_id) REFERENCES ${AppConstants.tbFolders} (id) ON DELETE SET NULL
    )
    ''');

    await db.execute('''
    CREATE TABLE ${AppConstants.tbFolders} (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      username TEXT NOT NULL,
      color_index INTEGER DEFAULT 0,
      created_at TEXT NOT NULL,
      FOREIGN KEY (username) REFERENCES ${AppConstants.tbUsers} (username) ON DELETE CASCADE
    )
    ''');

    await db.execute('''
    CREATE TABLE ${AppConstants.tbTags} (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      username TEXT NOT NULL,
      color_index INTEGER DEFAULT 0,
      FOREIGN KEY (username) REFERENCES ${AppConstants.tbUsers} (username) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
    CREATE INDEX idx_notes_modified_at ON ${AppConstants.tbNotes} (modified_at DESC)
    ''');

    await db.execute('''
    CREATE INDEX idx_notes_folder_id ON ${AppConstants.tbNotes} (folder_id)
    ''');

    await db.execute('''
    CREATE INDEX idx_notes_is_pinned ON ${AppConstants.tbNotes} (is_pinned DESC)
    ''');
  }

  Future<int> registerUser(User user) async {
    final db = await database;
    return await db.insert(
      AppConstants.tbUsers,
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  Future<User?> getUser(String username) async {
    final db = await database;
    final maps = await db.query(
      AppConstants.tbUsers,
      where: 'username = ?',
      whereArgs: [username],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<String> insertNote(Note note) async {
    final db = await database;
    await db.insert(
      AppConstants.tbNotes,
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return note.id!;
  }

  Future<List<Note>> getAllNotes(String username) async {
    final db = await database;
    final result = await db.query(
      AppConstants.tbNotes,
      where: 'username = ?',
      whereArgs: [username],
      orderBy: 'is_pinned DESC, modified_at DESC',
    );
    return result.map((map) => Note.fromMap(map)).toList();
  }

  Future<Note?> getNoteById(String id, String username) async {
    final db = await database;
    final result = await db.query(
      AppConstants.tbNotes,
      where: 'id = ? AND username = ?',
      whereArgs: [id, username],
    );
    return result.isNotEmpty ? Note.fromMap(result.first) : null;
  }

  Future<int> updateNote(Note note, String username) async {
    final db = await database;
    return await db.update(
      AppConstants.tbNotes,
      note.toMap(),
      where: 'id = ? AND username = ?',
      whereArgs: [note.id, note.username],
    );
  }

  Future<int> deleteNoteById(String id, String username) async {
    final db = await database;
    return await db.delete(
      AppConstants.tbNotes,
      where: 'id = ? AND username = ?',
      whereArgs: [id, username],
    );
  }

  Future<List<Note>> searchNotes(String query, String username) async {
    final db = await database;
    final result = await db.query(
      AppConstants.tbNotes,
      where: 'username = ? AND (title LIKE ? OR content LIKE ?)',
      whereArgs: [username, '%$query%', '%$query%'],
      orderBy: 'is_pinned DESC, modified_at DESC',
    );
    return result.map((map) => Note.fromMap(map)).toList();
  }

  Future<List<Note>> getNotesByFolderId(String folderId, String username) async {
    final db = await database;
    final result = await db.query(
      AppConstants.tbNotes,
      where: 'folder_id = ? AND username = ?',
      whereArgs: [folderId, username],
      orderBy: 'is_pinned DESC, modified_at DESC',
    );
    return result.map((map) => Note.fromMap(map)).toList();
  }

  Future<List<Note>> getFavoriteNotes(String username) async {
    final db = await database;
    final result = await db.query(
      AppConstants.tbNotes,
      where: 'is_favorite = ? AND username = ?',
      whereArgs: [1, username],
      orderBy: 'is_pinned DESC, modified_at DESC',
    );
    return result.map((map) => Note.fromMap(map)).toList();
  }

  Future<String> insertFolder(Folder folder) async {
    final db = await database;
    await db.insert(
      AppConstants.tbFolders,
      folder.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return folder.id!;
  }

  Future<List<Folder>> getAllFolders(String username) async {
    final db = await database;
    final result = await db.query(
      AppConstants.tbFolders,
      where: 'username = ?',
      whereArgs: [username],
      orderBy: 'created_at DESC',
    );
    return result.map((map) => Folder.fromMap(map)).toList();
  }

  Future<int> updateFolder(Folder folder, String username) async {
    final db = await database;
    return await db.update(
      AppConstants.tbFolders,
      folder.toMap(),
      where: 'id = ? AND username = ?',
      whereArgs: [folder.id, username],
    );
  }

  Future<int> deleteFolderById(String id, String username) async {
    final db = await database;
    return await db.delete(
      AppConstants.tbFolders,
      where: 'id = ? AND username = ?',
      whereArgs: [id, username],
    );
  }

  Future<String> insertTag(Tag tag) async {
    final db = await database;
    await db.insert(
      AppConstants.tbTags,
      tag.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return tag.id!;
  }

  Future<List<Tag>> getAllTags(String username) async {
    final db = await database;
    final result = await db.query(
      AppConstants.tbTags,
      where: 'username = ?',
      whereArgs: [username],
    );
    return result.map((map) => Tag.fromMap(map)).toList();
  }

  Future<int> deleteTagById(String id, String username) async {
    final db = await database;
    return await db.delete(
      AppConstants.tbTags,
      where: 'id = ? AND username = ?',
      whereArgs: [id, username],
    );
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}
