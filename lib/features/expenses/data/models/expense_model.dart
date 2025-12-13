class ExpenseModel {
  final int? id;
  final String title;
  final String category;
  final double amount;
  final DateTime date;
  final String? notes;

  ExpenseModel({
    this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
    this.notes,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'],
      title: json['title'],
      category: json['category'],
      amount: double.parse(json['amount'].toString()),
      date: DateTime.parse(json['date']),
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "category": category,
      "amount": amount,
      "date": date.toIso8601String(),
      "notes": notes,
    };
  }
}
