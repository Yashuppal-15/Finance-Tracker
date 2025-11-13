import 'package:flutter/material.dart';
import '../data/models/transaction_model.dart';
import '../../../core/utils/hive_service.dart';

class TransactionProvider extends ChangeNotifier {
  List<Transaction> _transactions = [];

  List<Transaction> get transactions {
    // Always reload from storage to ensure fresh data
    _transactions = HiveService.getAllTransactions();
    return _transactions;
  }

  double get totalIncome {
    final trans = HiveService.getAllTransactions();
    return trans
        .where((t) => t.isIncome)
        .fold(0, (sum, t) => sum + t.amount);
  }

  double get totalExpense {
    final trans = HiveService.getAllTransactions();
    return trans
        .where((t) => !t.isIncome)
        .fold(0, (sum, t) => sum + t.amount);
  }

  double get balance => totalIncome - totalExpense;

  // Add new transaction
  Future<void> addTransaction(Transaction transaction) async {
    await HiveService.saveTransaction(transaction);
    _transactions = HiveService.getAllTransactions();
    notifyListeners();
  }

  // Load transactions from storage
  Future<void> loadTransactions() async {
    _transactions = HiveService.getAllTransactions();
    notifyListeners();
  }

  // Delete transaction
  Future<void> deleteTransaction(String id) async {
    await HiveService.deleteTransaction(id);
    _transactions = HiveService.getAllTransactions();
    notifyListeners();
  }

  // Update transaction
  Future<void> updateTransaction(Transaction transaction) async {
    await HiveService.updateTransaction(transaction);
    _transactions = HiveService.getAllTransactions();
    notifyListeners();
  }

  // Get transactions for current month
  List<Transaction> _getCurrentMonthTransactions() {
    final now = DateTime.now();
    final transactions = HiveService.getAllTransactions();
    return transactions.where((t) {
      return t.date.year == now.year && t.date.month == now.month;
    }).toList();
  }

  // Get current month income
  double get currentMonthIncome {
    final transactions = _getCurrentMonthTransactions();
    return transactions
        .where((t) => t.isIncome)
        .fold(0, (sum, t) => sum + t.amount);
  }

  // Get current month expense
  double get currentMonthExpense {
    final transactions = _getCurrentMonthTransactions();
    return transactions
        .where((t) => !t.isIncome)
        .fold(0, (sum, t) => sum + t.amount);
  }

  // Get current month balance
  double get currentMonthBalance => currentMonthIncome - currentMonthExpense;
}
