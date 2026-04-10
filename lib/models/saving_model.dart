import 'package:hm_tracker/models/user_model.dart';

class Saving {
  String? id;
  String? userId;
  User? user;
  int? amount;
  DateTime? createdAt;
  DateTime? updatedAt;

  Saving({
    this.id,
    this.userId,
    this.amount,
    this.user,
    this.createdAt,
    this.updatedAt,
  });

  factory Saving.fromJson(Map<String, dynamic> json) {
    return Saving(
      id: json['id'],
      userId: json['user_id'],
      user: json['User'],
      amount: json['amount'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJSON() {
    // JANGAN gunakan const di sini
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;

    // Kirim tanggal kembali ke API dalam format String (ISO8601)
    data['created_at'] = createdAt?.toIso8601String();
    data['updated_at'] = updatedAt?.toIso8601String();

    data['amount'] = amount;
    return data;
  }

  static List<Saving> fromJsonList(List? list) {
    if (list == null || list.isEmpty) return [];
    return list.map((item) => Saving.fromJson(item)).toList();
  }
}
