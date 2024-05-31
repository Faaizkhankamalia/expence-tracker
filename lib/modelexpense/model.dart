import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  final String id;
  final String category;
  final String description;
  final double expense;
  final DateTime date;

  Expense({required this.id, required this.category, required this.description, required this.expense, required this.date});

  factory Expense.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Expense(
      id: doc.id,
      category: data['category'] ?? '',
      description: data['description'] ?? '',
      expense: data['expense'] ?? 0.0,
      date: (data['date'] as Timestamp).toDate(),
    );
  }
}
