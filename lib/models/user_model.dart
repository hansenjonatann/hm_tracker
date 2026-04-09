class User {
  String? id;
  String? name;
  String? username;
  String? email;
  String? role;

  User({this.id, this.name, this.username, this.email, this.role});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJSON() {
    const data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['username'] = username;
    data['role'] = role;
    return data;
  }

  static List<User> fromJsonList(List list) {
    if (list.length == 0) return List<User>.empty();
    return list.map((item) => User.fromJson(item)).toList();
  }
}
