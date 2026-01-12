import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:notoli/pages/edit_note.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../providers/note_provider.dart';
import '../providers/settings_provider.dart';
import '../providers/auth_provider.dart';
import '../models/folder.dart';
import '../widgets/note_card.dart';
import 'settings.dart';
import 'search.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer3<NoteProvider, SettingsProvider, AuthProvider>(
      builder: (context, noteProvider, settings, auth, _) {
        // ===== SAFETY: USER MUST LOGIN =====
        if (auth.userCurrent == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // ===== APP BAR TITLE =====
        String title = 'Notoli';

        if (noteProvider.selectedFolderId != null) {
          final folder = noteProvider.folders
              .where((f) => f.id == noteProvider.selectedFolderId)
              .toList();

          if (folder.isNotEmpty) title = folder.first.name;
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(title),
            leading: noteProvider.selectedFolderId != null
                ? IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      noteProvider.setSelectedFolderId(null);
                    },
                  )
                : null,
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SearchPage()),
                  );
                },
              ),

              IconButton(
                icon: Icon(
                  settings.isGridView ? Icons.view_list : Icons.grid_view,
                ),
                onPressed: () {
                  settings.setViewMode(!settings.isGridView);
                },
              ),

              IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const Settings()),
                  );
                },
              ),
            ],
          ),
          body: _buildBody(noteProvider, settings),
          floatingActionButton: _selectedIndex == 1 || _selectedIndex == 3
              ? null
              : FloatingActionButton(
                  onPressed: () {
                    if (_selectedIndex == 2) {
                      _showCreateFolderDialog();
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => EditNotePage()),
                      ).then((_) {
                        Provider.of<NoteProvider>(
                          context,
                          listen: false,
                        ).loadNotes();
                      });
                    }
                  },
                  elevation: 0,
                  backgroundColor:
                      Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black87,
                  foregroundColor:
                      Theme.of(context).brightness == Brightness.dark
                      ? Colors.black87
                      : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(Icons.add, size: 28),
                ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(
                      icon: Icons.note_rounded,
                      selectedIcon: Icons.note,
                      label: "Notes",
                      index: 0,
                    ),
                    _buildNavItem(
                      icon: Icons.favorite_border,
                      selectedIcon: Icons.favorite,
                      label: "Favorite",
                      index: 1,
                    ),
                    _buildNavItem(
                      icon: Icons.folder_outlined,
                      selectedIcon: Icons.folder,
                      label: "Folder",
                      index: 2,
                    ),
                    _buildNavItem(
                      icon: Icons.schedule_outlined,
                      selectedIcon: Icons.schedule,
                      label: "Recent",
                      index: 3,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required int index,
  }) {
    final isSelected = _selectedIndex == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        final noteProvider = Provider.of<NoteProvider>(context, listen: false);
        if (index == 0) {
          noteProvider.setSelectedFolderId(null);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: EdgeInsets.all(8),
            child: Icon(
              isSelected ? selectedIcon : icon,
              color: isSelected
                  ? (isDark ? Colors.white : Colors.black87)
                  : (isDark ? Colors.grey[600] : Colors.grey[400]),
              size: 26,
            ),
          ),
          SizedBox(height: 2),
          AnimatedDefaultTextStyle(
            duration: Duration(milliseconds: 300),
            style: TextStyle(
              color: isSelected
                  ? (isDark ? Colors.white : Colors.black87)
                  : (isDark ? Colors.grey[600] : Colors.grey[400]),
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              letterSpacing: 0.5,
            ),
            child: Text(label),
          ),
          SizedBox(height: 4),
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: 3,
            width: isSelected ? 24 : 0,
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[600] : Colors.grey[400],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================

  Widget _buildBody(NoteProvider noteProvider, SettingsProvider settings) {
    if (_selectedIndex == 2) {
      return _buildFolderList(noteProvider);
    }

    if (noteProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    List notes = noteProvider.notes;

    if (_selectedIndex == 1) {
      notes = notes.where((n) => n.isFavorite).toList();
    } else if (_selectedIndex == 3) {
      final sorted = [...notes]
        ..sort((a, b) => b.modifiedAt.compareTo(a.modifiedAt));
      notes = sorted.take(20).toList();
    }

    if (notes.isEmpty) {
      return _buildEmptyNotes();
    }

    return settings.isGridView ? _buildGridView(notes) : _buildListView(notes);
  }

  // =====================================================

  Widget _buildGridView(List notes) {
    return AnimationLimiter(
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notes.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.85,
        ),
        itemBuilder: (_, index) {
          return AnimationConfiguration.staggeredGrid(
            position: index,
            duration: const Duration(milliseconds: 375),
            columnCount: 2,
            child: ScaleAnimation(
              child: FadeInAnimation(child: NoteCard(note: notes[index])),
            ),
          );
        },
      ),
    );
  }

  Widget _buildListView(List notes) {
    return AnimationLimiter(
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notes.length,
        itemBuilder: (_, index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50,
              child: FadeInAnimation(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: NoteCard(note: notes[index]),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // =====================================================

  Widget _buildFolderList(NoteProvider noteProvider) {
    final folders = noteProvider.folders;

    if (folders.isEmpty) {
      return _buildEmptyFolders();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: folders.length,
      itemBuilder: (_, index) {
        final folder = folders[index];
        final noteCount = noteProvider.notes
            .where((n) => n.folderId == folder.id)
            .length;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: const Icon(Icons.folder, size: 32),
            title: Text(folder.name),
            subtitle: Text('$noteCount notes'),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'rename') {
                  _showRenameFolderDialog(noteProvider, folder);
                } else if (value == 'delete') {
                  _showDeleteFolderDialog(noteProvider, folder);
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'rename', child: Text('Rename')),
                PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
            ),
            onTap: () {
              noteProvider.setSelectedFolderId(folder.id);
              setState(() => _selectedIndex = 0);
            },
          ),
        );
      },
    );
  }

  // =====================================================

  Widget _buildEmptyNotes() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.note_add_outlined, size: 100, color: Colors.grey),
          SizedBox(height: 16),
          Text('No notes yet'),
        ],
      ),
    );
  }

  Widget _buildEmptyFolders() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.folder_outlined, size: 100, color: Colors.grey),
          SizedBox(height: 16),
          Text('No folders created yet'),
        ],
      ),
    );
  }

  // =====================================================

  void _showRenameFolderDialog(NoteProvider provider, Folder folder) {
    final controller = TextEditingController(text: folder.name);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Rename Folder'),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                provider.updateFolder(folder.copyWith(name: controller.text));
              }
              Navigator.pop(context);
            },
            child: const Text('Rename'),
          ),
        ],
      ),
    );
  }

  void _showDeleteFolderDialog(NoteProvider provider, Folder folder) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Folder'),
        content: const Text(
          "Are you sure? Notes inside this folder won't be deleted.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              provider.deleteFolder(folder.id!);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showCreateFolderDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("New Folder"),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: "Folder Name"),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                final folder = Folder(
                  id: Uuid().v4(),
                  name: controller.text,
                  username: '',
                );
                Provider.of<NoteProvider>(
                  context,
                  listen: false,
                ).createFolder(folder);
              }
              Navigator.pop(context);
            },
            child: Text("Create"),
          ),
        ],
      ),
    );
  }
}
