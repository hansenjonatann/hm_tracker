import 'package:hm_tracker/models/category_income_model.dart';
import 'package:hm_tracker/models/user_model.dart';

class Income {
  String? id;
  String? userId;
  User? user;
  DateTime? date;
  int? amount;
  String? categoryIncomeId;
  CategoryIncome? category;
  String? desc;
  DateTime? createdAt;
  DateTime? updatedAt;

  Income({
    required this.id,
    required this.userId,
    this.user,
    this.date,
    this.amount,
    this.categoryIncomeId,
    this.createdAt,
    this.updatedAt,
    this.category,
    this.desc,
  });

  factory Income.fromJson(Map<String, dynamic> json) {
    return Income(
      id: json['id']?.toString(), // Pastikan ID jadi String
      userId: json['user_id']?.toString(),

      // Parsing Date yang Aman
      date: json['date'] != null
          ? DateTime.tryParse(json['date'].toString())
          : null,

      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,

      // Parsing Amount yang Aman (Menangani jika API kirim String atau Int)
      amount: json['amount'] is int
          ? json['amount']
          : int.tryParse(json['amount']?.toString() ?? '0'),

      categoryIncomeId: json['category_income']?.toString(),
      desc: json['desc'],

      category: json['CategoryIncome'] != null
          ? CategoryIncome.fromJson(json['CategoryIncome'])
          : null,
    );
  }

  Map<String, dynamic> toJSON() {
    // JANGAN gunakan const di sini
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;

    // Kirim tanggal kembali ke API dalam format String (ISO8601)
    data['date'] = date?.toIso8601String();
    data['created_at'] = createdAt?.toIso8601String();
    data['updated_at'] = updatedAt?.toIso8601String();

    data['amount'] = amount;
    data['category_income'] = categoryIncomeId;
    data['desc'] = desc;
    return data;
  }

  static List<Income> fromJsonList(List? list) {
    if (list == null || list.isEmpty) return [];
    return list.map((item) => Income.fromJson(item)).toList();
  }
}
