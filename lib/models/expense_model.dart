import 'package:hm_tracker/models/category_expense_model.dart';
import 'package:hm_tracker/models/user_model.dart';

class Expense {
  String? id;
  String? userId;
  User? user;
  DateTime? date;
  int? amount;
  String? categoryExpenseid;
  CategoryExpense? category;
  String? desc;
  DateTime? createdAt;
  DateTime? updatedAt;

  Expense({
    required this.id,
    required this.userId,
    this.user,
    this.date,
    this.amount,
    this.categoryExpenseid,
    this.createdAt,
    this.updatedAt,
    this.category,
    this.desc,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
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

      categoryExpenseid: json['category_expense']?.toString(),
      desc: json['desc'],

      category: json['CategoryExpense'] != null
          ? CategoryExpense.fromJson(json['CategoryExpense'])
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
    data['category_expense'] = categoryExpenseid;
    data['desc'] = desc;
    return data;
  }

  static List<Expense> fromJsonList(List? list) {
    if (list == null || list.isEmpty) return [];
    return list.map((item) => Expense.fromJson(item)).toList();
  }
}
