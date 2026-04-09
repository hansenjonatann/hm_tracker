class CategoryIncome {
  String? id;
  String? name;
  DateTime? createdAt;
  DateTime? updatedAt;

  CategoryIncome({required this.id, this.name, this.createdAt, this.updatedAt});

  factory CategoryIncome.fromJson(Map<String, dynamic> json) {
    return CategoryIncome(
      id: json['id'],
      name: json['name'],
      // WAJIB PARSING JUGA DI SINI
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJSON() {
    const data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['created_at'] = createdAt!.toIso8601String();
    data['updated_at'] = updatedAt!.toIso8601String();
    return data;
  }

  static List<CategoryIncome> fromJsonList(List list) {
    if (list.length == 0) return List<CategoryIncome>.empty();
    return list.map((item) => CategoryIncome.fromJson(item)).toList();
  }
}
