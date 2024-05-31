import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../modelexpense/model.dart';
import 'expense_diloug.dart';
import 'expense_services.dart';


class ExpenseCard extends StatelessWidget {
  final Expense expense;
  final Function onDelete;

  ExpenseCard({required this.expense, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRow('Category:', expense.category),
              _buildRow('Expense:', '${expense.expense} Rs/-'),
              _buildRow('Date:', expense.date.toString().substring(0, 10)),
              const Text('Description:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              Row(
                children: [
                  Text(expense.description, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
                  const Spacer(),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert_sharp),
                    onSelected: (String result) async {
                      switch (result) {
                        case 'Edit':
                          showExpenseDialog(context, expense: expense, onAdd: onDelete);
                          break;
                        case 'Delete':
                          await ExpenseService.deleteExpense(expense.id);
                          onDelete();
                          break;
                      }
                    },
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'Edit',
                        child: Text('Edit'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Delete',
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
      ],
    );
  }
}
