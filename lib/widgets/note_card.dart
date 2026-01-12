import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notoli/pages/edit_note.dart';
import 'package:notoli/providers/note_provider.dart';
import 'package:notoli/theme/app_colors.dart';
import 'package:notoli/models/note.dart';
import 'package:provider/provider.dart';

class NoteCard extends StatelessWidget {
  final Note note;

  const NoteCard({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final noteColor = isDark
        ? AppColors.noteColorsDark[note.colorIndex]
        : AppColors.noteColors[note.colorIndex];

    return Card(
      color: noteColor,
      child: InkWell(
        onTap: () {
          final noteProvider = context.read<NoteProvider>();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => EditNotePage(note: note)),
          ).then((_) {
            noteProvider.loadNotes();
          });
        },
        onLongPress: () {
          _showBottomSheet(context);
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      note.title.isEmpty ? "Untitled" : note.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (note.isPinned)
                    Icon(Icons.push_pin, size: 20, color: Colors.grey),
                  if (note.isFavorite)
                    Icon(Icons.favorite, size: 20, color: Colors.red),
                ],
              ),
              if (note.content.isNotEmpty) ...[
                SizedBox(height: 8),
                Text(
                  note.content,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (note.tags.isNotEmpty) ...[
                SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: note.tags
                      .take(3)
                      .map(
                        (tag) => Chip(
                          label: Text(tag, style: TextStyle(fontSize: 11)),
                          visualDensity: VisualDensity.compact,
                        ),
                      )
                      .toList(),
                ),
              ],
              SizedBox(height: 12),
              Text(
                DateFormat('MMM dd, yyyy " hh:mm a').format(note.modifiedAt),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: _getTextColorForBackground(noteColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getTextColorForBackground(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black54 : Colors.white70;
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(
                  note.isPinned ? Icons.push_pin_outlined : Icons.push_pin,
                ),
                title: Text(note.isPinned ? "Unpinned" : "Pin"),
                onTap: () {
                  Provider.of<NoteProvider>(
                    context,
                    listen: false,
                  ).togglePin(note.id!);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(
                  note.isFavorite ? Icons.favorite : Icons.favorite_border,
                ),
                title: Text(
                  note.isFavorite ? "Remove from favorite" : "Add to favorite",
                ),
                onTap: () {
                  Provider.of<NoteProvider>(
                    context,
                    listen: false,
                  ).toggleFavorite(note.id!);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text("Delete", style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteDialog(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Note?"),
        content: Text("Are you sure to delete this note?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Provider.of<NoteProvider>(
                context,
                listen: false,
              ).deleteNote(note.id!);
              Navigator.pop(context);
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
