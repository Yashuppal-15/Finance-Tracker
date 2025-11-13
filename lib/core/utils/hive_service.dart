import 'package:hive_flutter/hive_flutter.dart';
import '../../features/finance/data/models/transaction_model.dart';


class HiveService {
  static Future<void> initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TransactionAdapter());
    await Hive.openBox<Transaction>('transactions');
  }

  static Future<void> saveTransaction(Transaction transaction) async {
    final box = Hive.box<Transaction>('transactions');
    await box.put(transaction.id, transaction);
  }

  static Future<void> updateTransaction(Transaction transaction) async {
    final box = Hive.box<Transaction>('transactions');
    await box.put(transaction.id, transaction);
  }

  static Future<void> deleteTransaction(String id) async {
    final box = Hive.box<Transaction>('transactions');
    await box.delete(id);
  }

  static List<Transaction> getAllTransactions() {
    final box = Hive.box<Transaction>('transactions');
    return box.values.toList().reversed.toList(); // Most recent first
  }
}
