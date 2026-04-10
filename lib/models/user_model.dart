class User {
  String? id;
  String? name;
  String? username;
  String? email;
  String? role;
  DateTime? createdAt;
  DateTime? updatedAt;

  User({
    this.id,
    this.name,
    this.username,
    this.email,
    this.role,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
      role: json['role'],
      createdAt: json['CreatedAt'] != null
          ? DateTime.tryParse(json['CreatedAt'])
          : null,
      updatedAt: json['UpdatedAt'] != null
          ? DateTime.tryParse(json['UpdatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJSON() {
    const data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['username'] = username;
    data['role'] = role;
    data['CreatedAt'] = createdAt!.toIso8601String();
    data['UpdatedAt'] = updatedAt!.toIso8601String();
    return data;
  }

  static List<User> fromJsonList(List list) {
    if (list.length == 0) return List<User>.empty();
    return list.map((item) => User.fromJson(item)).toList();
  }
}
