class Folder {
  final String? id;
  final String name;
  final String username;
  final int colorIndex;
  final DateTime createdAt;

  Folder({
    this.id,
    required this.name,
    required this.username,
    this.colorIndex = 0,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'color_index': colorIndex,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Folder.fromMap(Map<String, dynamic> map) {
    return Folder(
      id: map['id'],
      name: map['name'],
      username: map['username'],
      colorIndex: map['color_index'] ?? 0,
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Folder copyWith({
    String? id,
    String? name,
    String? username,
    int? colorIndex,
    DateTime? createdAt,
  }) {
    return Folder(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      colorIndex: colorIndex ?? this.colorIndex,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'colorIndex': colorIndex,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Folder.fromJson(Map<String, dynamic> json) {
    return Folder(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      colorIndex: json['colorIndex'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

}
