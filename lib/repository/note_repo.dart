import 'package:uuid/uuid.dart';
import '../db/db_helper.dart';
import '../models/note.dart';

class NoteRepo {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final Uuid _uuid = const Uuid();

  Future<String> createNote(Note note, String username) async {
    final noteWithId = note.copyWith(
      id: note.id ?? _uuid.v4(),
      username: username,
      modifiedAt: DateTime.now(),
    );
    return await _dbHelper.insertNote(noteWithId);
  }

  Future<List<Note>> getAllNotes(String username) async {
    return await _dbHelper.getAllNotes(username);
  }

  Future<Note?> getNoteById(String id, String username) async {
    return await _dbHelper.getNoteById(id, username);
  }

  Future<void> updateNote(Note note, String username) async {
    await _dbHelper.updateNote(note.copyWith(modifiedAt: DateTime.now()), username);
  }

  Future<void> deleteNote(String id, String username) async {
    await _dbHelper.deleteNoteById(id, username);
  }

  Future<List<Note>> searchNotes(String query, String username) async {
    return await _dbHelper.searchNotes(query, username);
  }

  Future<List<Note>> getNotesByFolder(String folderId, String username) async {
    return await _dbHelper.getNotesByFolderId(folderId, username);
  }

  Future<List<Note>> getFavoriteNotes(String username) async {
    return await _dbHelper.getFavoriteNotes(username);
  }

  Future<void> togglePin(String id, String username) async {
    final note = await getNoteById(id, username);
    if (note != null) {
      await _dbHelper.updateNote(note.copyWith(isPinned: !note.isPinned), username);
    }
  }

  Future<void> toggleFavorite(String id, String username) async {
    final note = await getNoteById(id, username);
    if (note != null) {
      await _dbHelper.updateNote(note.copyWith(isFavorite: !note.isFavorite), username);
    }
  }
}
