import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../transaction_provider.dart';

class AnalyticsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, provider, _) {
        final transactionCount = provider.transactions.length;
        final totalIncome = provider.totalIncome;
        final totalExpense = provider.totalExpense;
        final balance = provider.balance;

        return Scaffold(
          appBar: AppBar(
            title: Text('Analytics'),
            backgroundColor: Colors.white,
            elevation: 0,
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            iconTheme: IconThemeData(color: Colors.black),
          ),
          body: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  color: Colors.blue[50],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Summary',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.blueAccent,
                          ),
                        ),
                        SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Income:',
                              style: TextStyle(fontSize: 15, color: Colors.green[700]),
                            ),
                            Text('₹${totalIncome.toStringAsFixed(0)}',
                                style: TextStyle(fontSize: 15, color: Colors.green[700])),
                          ],
                        ),
                        SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Expense:',
                              style: TextStyle(fontSize: 15, color: Colors.red[700]),
                            ),
                            Text('₹${totalExpense.toStringAsFixed(0)}',
                                style: TextStyle(fontSize: 15, color: Colors.red[700])),
                          ],
                        ),
                        SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Overall Balance:',
                              style: TextStyle(fontSize: 15, color: Colors.blue[900]),
                            ),
                            Text('₹${balance.toStringAsFixed(0)}',
                                style: TextStyle(fontSize: 15, color: Colors.blueAccent)),
                          ],
                        ),
                        SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Transactions:',
                              style: TextStyle(fontSize: 15, color: Colors.grey[800]),
                            ),
                            Text(
                              '$transactionCount',
                              style: TextStyle(fontSize: 15, color: Colors.grey[800]),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 32),
                Expanded(
                  child: Center(
                    child: transactionCount == 0
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.pie_chart, size: 80, color: Colors.grey.shade300),
                              SizedBox(height: 20),
                              Text(
                                'Analytics Coming Soon',
                                style: TextStyle(fontSize: 18, color: Colors.grey),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Add transactions first to see analytics',
                                style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                              ),
                            ],
                          )
                        : Text(
                            'Pie & bar charts of your transactions will appear here!\n\nAdd, delete, and update transactions to see graphical analytics.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey[600], fontSize: 16),
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
