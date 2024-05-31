import 'package:cloud_firestore/cloud_firestore.dart';

import '../modelexpense/model.dart';


class ExpenseService {
  static CollectionReference expenses = FirebaseFirestore.instance.collection('expenses');

  static Future<void> addOrUpdateExpense(String category, String description, double expense, Expense? currentExpense) async {
    if (currentExpense == null) {
      await expenses.add({
        'category': category,
        'description': description,
        'expense': expense,
        'date': DateTime.now(),
      });
    } else {
      await expenses.doc(currentExpense.id).update({
        'category': category,
        'description': description,
        'expense': expense,
        'date': DateTime.now(),
      });
    }
  }

  static Stream<List<Expense>> fetchExpenses() {
    return expenses.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Expense.fromFirestore(doc)).toList();
    });
  }

  static Future<void> deleteExpense(String id) async {
    await expenses.doc(id).delete();
  }

  static Future<Map<String, double>> calculateTotalExpenses() async {
    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day);
    DateTime startOfMonth = DateTime(now.year, now.month, 1);
    DateTime startOfYear = DateTime(now.year, 1, 1);

    QuerySnapshot dailySnapshot = await expenses.where('date', isGreaterThanOrEqualTo: startOfDay).get();
    QuerySnapshot monthlySnapshot = await expenses.where('date', isGreaterThanOrEqualTo: startOfMonth).get();
    QuerySnapshot yearlySnapshot = await expenses.where('date', isGreaterThanOrEqualTo: startOfYear).get();

    double dailyTotal = 0.0;
    double monthlyTotal = 0.0;
    double yearlyTotal = 0.0;

    dailySnapshot.docs.forEach((doc) {
      dailyTotal += (doc['expense'] as num).toDouble();
    });

    monthlySnapshot.docs.forEach((doc) {
      monthlyTotal += (doc['expense'] as num).toDouble();
    });

    yearlySnapshot.docs.forEach((doc) {
      yearlyTotal += (doc['expense'] as num).toDouble();
    });

    return {
      'daily': dailyTotal,
      'monthly': monthlyTotal,
      'yearly': yearlyTotal,
    };
  }
}
