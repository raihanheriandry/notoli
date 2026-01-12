class Tag {
  final String? id;
  final String name;
  final String username;
  final int colorIndex;

  Tag({
    this.id,
    required this.name,
    required this.username,
    required this.colorIndex,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'color_index': colorIndex,
    };
  }

  factory Tag.fromMap(Map<String, dynamic> map) {
    return Tag(
      id: map['id'],
      name: map['name'],
      username: map['username'],
      colorIndex: map['color_index'] ?? 0,
    );
  }

  Tag copyWith({String? id, String? name, String? username, int? colorIndex}) {
    return Tag(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      colorIndex: colorIndex ?? this.colorIndex,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'colorIndex': colorIndex,
    };
  }

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      colorIndex: json['colorIndex'] ?? 0,
    );
  }
}
