import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../widgets/expense_card.dart';
import '../widgets/add_expense_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Expense> _expenses = [];
  Category? _filterCategory;

  // ✅ Function: Add expense
  void _addExpense(Expense expense) {
    setState(() => _expenses.add(expense));
  }

  // ✅ Function: Delete expense
  void _deleteExpense(String id) {
    setState(() => _expenses.removeWhere((e) => e.id == id));
  }

  // ✅ Function: Calculate total
  double get _totalAmount =>
      _filteredExpenses.fold(0, (sum, e) => sum + e.amount);

  // ✅ Function: Filter by category
  List<Expense> get _filteredExpenses {
    if (_filterCategory == null) return _expenses;
    return _expenses.where((e) => e.category == _filterCategory).toList();
  }

  // ✅ Function: Show add expense bottom sheet
  void _showAddSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => AddExpenseSheet(onAdd: _addExpense),
    );
  }

  // ✅ Function: Confirm & clear all expenses
  void _clearAll() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Clear All?'),
        content: const Text('This will delete all your expenses.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              setState(() => _expenses.clear());
              Navigator.pop(context);
            },
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('💰 Expense Tracker',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          if (_expenses.isNotEmpty)
            IconButton(
                onPressed: _clearAll,
                icon: const Icon(Icons.delete_sweep_outlined)),
        ],
      ),
      body: Column(
        children: [
          // Summary card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                    color: theme.colorScheme.primary.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4))
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total Spent',
                        style: TextStyle(color: Colors.white70, fontSize: 13)),
                    const SizedBox(height: 4),
                    Text('\$${_totalAmount.toStringAsFixed(2)}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Transactions',
                        style: TextStyle(color: Colors.white70, fontSize: 13)),
                    const SizedBox(height: 4),
                    Text('${_filteredExpenses.length}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),

          // Category filter chips
          SizedBox(
            height: 42,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                FilterChip(
                  label: const Text('All'),
                  selected: _filterCategory == null,
                  onSelected: (_) => setState(() => _filterCategory = null),
                  selectedColor: theme.colorScheme.primaryContainer,
                ),
                const SizedBox(width: 6),
                ...Category.values.map((cat) => Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: FilterChip(
                        label: Text('${categoryIcons[cat]} ${cat.name}'),
                        selected: _filterCategory == cat,
                        onSelected: (_) =>
                            setState(() => _filterCategory =
                                _filterCategory == cat ? null : cat),
                        selectedColor: theme.colorScheme.primaryContainer,
                      ),
                    )),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Expense list
          Expanded(
            child: _filteredExpenses.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('😶', style: TextStyle(fontSize: 48)),
                        const SizedBox(height: 12),
                        Text('No expenses yet',
                            style: TextStyle(
                                color: Colors.grey[500], fontSize: 16)),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredExpenses.length,
                    itemBuilder: (_, i) => ExpenseCard(
                      expense: _filteredExpenses[i],
                      onDelete: () =>
                          _deleteExpense(_filteredExpenses[i].id),
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddSheet,
        icon: const Icon(Icons.add),
        label: const Text('Add Expense'),
      ),
    );
  }
}