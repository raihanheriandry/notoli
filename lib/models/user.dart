class User {
  final String username;
  final String passwordHash;

  User({
    required this.username,
    required this.passwordHash,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password_hash': passwordHash,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      username: map['username'] ?? '',
      passwordHash: map['password_hash'] ?? '',
    );
  }

  User copyWith({
    String? username,
    String? passwordHash,
  }) {
    return User(
      username: username ?? this.username,
      passwordHash: passwordHash ?? this.passwordHash,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'passwordHash': passwordHash,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'] ?? '',
      passwordHash: json['passwordHash'] ?? '',
    );
  }
}