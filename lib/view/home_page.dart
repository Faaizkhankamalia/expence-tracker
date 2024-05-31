import 'package:flutter/material.dart';
import 'expense_diloug.dart';
import 'expense_list..dart';
import 'expense_services.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double totalDailyExpense   = 0.0;
  double totalMonthlyExpense = 0.0;
  double totalYearlyExpense  = 0.0;

  @override
  void initState() {
    super.initState();
    _calculateTotalExpenses();
  }

  void _calculateTotalExpenses() async {
    var totals = await ExpenseService.calculateTotalExpenses();
    setState(() {
      totalDailyExpense = totals['daily']!;
      totalMonthlyExpense = totals['monthly']!;
      totalYearlyExpense = totals['yearly']!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSummaryCard(),
              ExpenseList(onDelete: _calculateTotalExpenses),
            ],
          ),
        ),
      ),


      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showExpenseDialog(context, onAdd: _calculateTotalExpenses);
        },
        backgroundColor: Colors.blueGrey[100],
        child: const Center(
          child: Icon(
            Icons.add,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
  Widget _buildSummaryCard() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.blueGrey[100],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              const Center(
                child: Text(
                  "Total Daily Expense",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  "$totalDailyExpense Rs/-",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.red),
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSummaryItem("Monthly", totalMonthlyExpense),
                  _buildSummaryItem("Yearly", totalYearlyExpense),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String title, double amount) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 25,
          backgroundColor: Colors.white,
          child: Icon(
            Icons.arrow_downward_outlined,
            color: Colors.red,
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Text(
              "$amount Rs/-",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.red),
            ),
          ],
        ),
      ],
    );
  }
}
