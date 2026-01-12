import 'package:flutter/material.dart';
import '../models/note.dart';
import '../models/folder.dart';
import '../models/tag.dart';
import '../repository/note_repo.dart';
import '../repository/folder_repo.dart';
import '../repository/tag_repo.dart';

class NoteProvider extends ChangeNotifier {
  final NoteRepo noteRepo;
  final FolderRepo folderRepo;
  final TagRepo tagRepo;
  final String? username;

  NoteProvider({
    required this.noteRepo,
    required this.folderRepo,
    required this.tagRepo,
    required this.username,
  }) {
    if (username != null) {
      loadAll();
    }
  }

  List<Note> _notes = [];
  List<Folder> _folders = [];
  List<Tag> _tags = [];

  bool _isLoading = false;
  String _searchQuery = '';
  String? _selectedFolderId;

  List<Note> get notes {
    var list = _notes;

    if (_selectedFolderId != null) {
      list = list.where((n) => n.folderId == _selectedFolderId).toList();
    }

    if (_searchQuery.isNotEmpty) {
      list = list
          .where(
            (n) =>
                n.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                n.content.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();
    }

    return list;
  }

  List<Folder> get folders => _folders;
  List<Tag> get tags => _tags;
  String get searchQuery => _searchQuery;
  String? get selectedFolderId => _selectedFolderId;
  bool get isLoading => _isLoading;

  Future<void> loadAll() async {
    if (username == null) return;

    _isLoading = true;
    notifyListeners();

    await Future.wait([_loadNotesRaw(), _loadFoldersRaw(), _loadTagsRaw()]);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadNotes() async {
    if (username == null) return;

    _isLoading = true;
    notifyListeners();

    await _loadNotesRaw();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadFolders() async {
    if (username == null) return;
    _folders = await folderRepo.getAllFolders(username!);
    notifyListeners();
  }

  Future<void> loadTags() async {
    if (username == null) return;
    _tags = await tagRepo.getAllTags(username!);
    notifyListeners();
  }

  Future<void> createNote(Note note) async {
    await noteRepo.createNote(note, username!);
    await loadNotes();
  }

  Future<void> updateNote(Note note) async {
    await noteRepo.updateNote(note, username!);
    await loadNotes();
  }

  Future<void> deleteNote(String id) async {
    await noteRepo.deleteNote(id, username!);
    await loadNotes();
  }

  Future<void> toggleFavorite(String id) async {
    await noteRepo.toggleFavorite(id, username!);
    await loadNotes();
  }

  Future<void> togglePin(String id) async {
    await noteRepo.togglePin(id, username!);
    await loadNotes();
  }

  Future<void> createFolder(Folder folder) async {
    await folderRepo.createFolder(folder, username!);
    await loadFolders();
  }

  Future<void> updateFolder(Folder folder) async {
    await folderRepo.updateFolder(folder, username!);
    await loadFolders();
  }

  Future<void> deleteFolder(String id) async {
    await folderRepo.deleteFolder(id, username!);
    await loadFolders();
    await loadNotes();
  }

  Future<void> createTag(Tag tag) async {
    await tagRepo.createTag(tag, username!);
    await loadTags();
  }

  Future<void> deleteTag(String id) async {
    await tagRepo.deleteTag(id, username!);
    await loadTags();
  }

  Future<void> _loadNotesRaw() async {
    if (username == null) return;
    _notes = await noteRepo.getAllNotes(username!);
  }

  Future<void> _loadFoldersRaw() async {
    if (username == null) return;
    _folders = await folderRepo.getAllFolders(username!);
  }

  Future<void> _loadTagsRaw() async {
    if (username == null) return;
    _tags = await tagRepo.getAllTags(username!);
  }

  Future<void> importNotes(List<Note> notes) async {
    if (username == null) return;

    for (final note in notes) {
      await noteRepo.createNote(note, username!);
    }

    await loadNotes();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedFolderId(String? folderId) {
    _selectedFolderId = folderId;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  void clear() {
    _notes = [];
    _folders = [];
    _tags = [];
    _searchQuery = '';
    _selectedFolderId = null;
    notifyListeners();
  }
}
