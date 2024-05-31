import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../common/common_textfield.dart';
import '../modelexpense/model.dart';
import 'expense_services.dart';

void showExpenseDialog(BuildContext context, {Expense? expense, required Function onAdd}) {
  TextEditingController description = TextEditingController();
  TextEditingController expenseController = TextEditingController();
  TextEditingController date = TextEditingController();
  String _selectedCategory = 'Food';
  Expense? _currentExpense = expense;

  DateTime now = DateTime.now();

  if (expense != null) {
    _selectedCategory = expense.category;
    description.text = expense.description;
    expenseController.text = expense.expense.toString();
    date.text = expense.date.toString().substring(0, 10);
  } else {
    _selectedCategory = 'Food';
    description.clear();
    expenseController.clear();
    date.clear();
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Center(
            child: Text('Add Expense',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              child: DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: <String>[
                  'Food',
                  'Transportation',
                  'Entertainment',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: const TextStyle(fontSize: 14)),
                  );
                }).toList(),
                onChanged: (String? value) {
                  _selectedCategory = value!;
                },
                decoration: const InputDecoration(
                  labelText: 'Select Category',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Category is required';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 10),
            CommonTextFieldWithTitle(
              maxLine: 2,
              'Description',
              'Enter Description',
              description,
                  (val) {
                if (val!.isEmpty) {
                  return 'This is a required field';
                }
              },
            ),
            const SizedBox(height: 10),
            CommonTextFieldWithTitle(
              'Expense',
              'Enter your Expense',
              expenseController,
                  (val) {
                if (val!.isEmpty) {
                  return 'This is a required field';
                }
              },
            ),
            const SizedBox(height: 10),
            Container(
              height: 45,
              color: Colors.white,
              child: TextFormField(
                controller: date,
                decoration: InputDecoration(
                  labelText: 'Date',
                  hintText: now.toString().substring(0, 10),
                  border: const OutlineInputBorder(),
                ),
                readOnly: true,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _addExpenseToFirestore(
                  _selectedCategory, description.text, expenseController.text, _currentExpense);
              onAdd();
              Navigator.of(context).pop();
            },
            child: Text(expense != null ? 'Update' : 'Add'),
          ),
        ],
      );
    },
  );
}

Future<void> _addExpenseToFirestore(String category, String description, String expense, Expense? currentExpense) async {
  try {
    await ExpenseService.addOrUpdateExpense(category, description, double.parse(expense), currentExpense);
    Fluttertoast.showToast(
      msg: "Data successfully ${currentExpense == null ? 'added' : 'updated'}",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  } catch (e) {
    Fluttertoast.showToast(
      msg: "Error adding expense: $e",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
