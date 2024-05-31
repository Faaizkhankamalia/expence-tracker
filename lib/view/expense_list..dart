import 'package:flutter/material.dart';

import '../modelexpense/model.dart';
import 'expense_services.dart';
import 'expenses_card.dart';


class ExpenseList extends StatelessWidget {
  final Function onDelete;

  ExpenseList({required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Expense>>(
      stream: ExpenseService.fetchExpenses(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        List<Expense> expenses = snapshot.data!;
        return Expanded(
          child: ListView.builder(
            itemCount: expenses.length,
            itemBuilder: (context, index) {
              Expense expense = expenses[index];
              return ExpenseCard(
                expense: expense,
                onDelete: onDelete,
              );
            },
          ),
        );
      },
    );
  }
}
