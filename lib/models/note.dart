import 'dart:convert';

class Note {
  final String? id;
  final String title;
  final String content;
  final String? folderId;
  final String username;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final List<String> tags;
  final int colorIndex;
  final bool isPinned;
  final bool isFavorite;
  final List<String> attachments;
  final String? contentJson;

  Note({
    this.id,
    required this.title,
    required this.content,
    this.folderId,
    required this.username,
    DateTime? createdAt,
    DateTime? modifiedAt,
    this.tags = const [],
    this.colorIndex = 0,
    this.isPinned = false,
    this.isFavorite = false,
    this.attachments = const [],
    this.contentJson,
  }) : createdAt = createdAt ?? DateTime.now(),
       modifiedAt = modifiedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'folder_id': folderId,
      'username': username,
      'created_at': createdAt.toIso8601String(),
      'modified_at': modifiedAt.toIso8601String(),
      'tags': jsonEncode(tags),
      'color_index': colorIndex,
      'is_pinned': isPinned ? 1 : 0,
      'is_favorite': isFavorite ? 1 : 0,
      'attachments': jsonEncode(attachments),
      'content_json': contentJson,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      folderId: map['folder_id'],
      username: map['username'] ?? '',
      createdAt: DateTime.parse(map['created_at']),
      modifiedAt: DateTime.parse(map['modified_at']),
      tags: map['tags'] != null ? List<String>.from(jsonDecode(map['tags'])) : [],
      colorIndex: map['color_index'] ?? 0,
      isPinned: map['is_pinned'] == 1,
      isFavorite: map['is_favorite'] == 1,
      attachments: map['attachments'] != null ? List<String>.from(jsonDecode(map['attachments'])) : [], 
      contentJson: map['content_json'],
    );
  }

  Note copyWith({
    String? id,
    String? title,
    String? content,
    String? folderId,
    String? username,
    DateTime? createdAt,
    DateTime? modifiedAt,
    List<String>? tags,
    int? colorIndex,
    bool? isPinned,
    bool? isFavorite,
    List<String>? attachments,
    String? contentJson,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      folderId: folderId ?? this.folderId,
      username: username ?? this.username,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      tags: tags ?? this.tags,
      colorIndex: colorIndex ?? this.colorIndex,
      isPinned: isPinned ?? this.isPinned,
      isFavorite: isFavorite ?? this.isFavorite,
      attachments: attachments ?? this.attachments,
      contentJson: contentJson ?? this.contentJson,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'folderId': folderId,
      'username': username,
      'createdAt': createdAt.toIso8601String(),
      'modifiedAt': modifiedAt.toIso8601String(),
      'tags': tags,
      'colorIndex': colorIndex,
      'isPinned': isPinned,
      'isFavorite': isFavorite,
      'attachments': attachments,
      'contentJson': contentJson,
    };
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      folderId: json['folderId'],
      username: json['username'],
      createdAt: DateTime.parse(json['createdAt']),
      modifiedAt: DateTime.parse(json['modifiedAt']),
      tags: List<String>.from(json['tags'] ?? []),
      colorIndex: json['colorIndex'] ?? 0,
      isPinned: json['isPinned'] ?? false,
      isFavorite: json['isFavorite'] ?? false,
      attachments: List<String>.from(json['attachments'] ?? []),
      contentJson: json['contentJson'],
    );
  }
}
