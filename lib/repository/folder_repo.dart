import 'package:uuid/uuid.dart';
import '../db/db_helper.dart';
import '../models/folder.dart';

class FolderRepo {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final Uuid _uuid = const Uuid();

  Future<String> createFolder(Folder folder, String username) async {
    final folderWithId = folder.copyWith(
      id: folder.id ?? _uuid.v4(),
      username: username,
    );
    return await _dbHelper.insertFolder(folderWithId);
  }

  Future<List<Folder>> getAllFolders(String username) async {
    return await _dbHelper.getAllFolders(username);
  }

  Future<void> updateFolder(Folder folder, String username) async {
    await _dbHelper.updateFolder(folder, username);
  }

  Future<void> deleteFolder(String id, String username) async {
    await _dbHelper.deleteFolderById(id, username);
  }
}
