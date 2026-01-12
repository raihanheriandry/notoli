import 'package:uuid/uuid.dart';
import '../db/db_helper.dart';
import '../models/tag.dart';

class TagRepo {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final Uuid _uuid = const Uuid();

  Future<String> createTag(Tag tag, String username) async {
    final tagWithId = tag.copyWith(
      id: tag.id ?? _uuid.v4(),
      username: username,
    );
    return await _dbHelper.insertTag(tagWithId);
  }

  Future<List<Tag>> getAllTags(String username) async {
    return await _dbHelper.getAllTags(username);
  }

  Future<void> deleteTag(String id, String username) async {
    await _dbHelper.deleteTagById(id, username);
  }
}
