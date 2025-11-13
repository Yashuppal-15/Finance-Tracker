import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/transaction_model.dart';
import '../transaction_provider.dart';
import '../screens/add_transaction_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<TransactionProvider>(context, listen: false).loadTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, provider, _) {
        final filteredTransactions = provider.transactions.where((transaction) {
          final desc = transaction.description.toLowerCase();
          final cat = transaction.category.toLowerCase();
          return desc.contains(_searchQuery) || cat.contains(_searchQuery);
        }).toList();

        return Scaffold(
          appBar: AppBar(
            title: Text('Finance Tracker'),
            backgroundColor: Colors.white,
            elevation: 0,
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            iconTheme: IconThemeData(color: Colors.black),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Monthly summary card
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 24, 16, 0),
                  child: Card(
                    color: Colors.blue[50],
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                "This Month",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[800],
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Income: ₹${provider.currentMonthIncome.toStringAsFixed(0)}",
                                style: TextStyle(
                                    color: Colors.green, fontSize: 13),
                              ),
                              Text(
                                "Expense: ₹${provider.currentMonthExpense.toStringAsFixed(0)}",
                                style:
                                    TextStyle(color: Colors.red, fontSize: 13),
                              ),
                            ],
                          ),
                          Text(
                            "Balance: ₹${provider.currentMonthBalance.toStringAsFixed(0)}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Balance Cards Section
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Main Balance Card
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.blue.shade700,
                                Colors.blueAccent
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Balance',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '₹ ${provider.balance.toStringAsFixed(0)}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      // Income & Expense Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildSmallCard(
                            'Income',
                            '₹${provider.totalIncome.toStringAsFixed(0)}',
                            Colors.green,
                            Icons.arrow_downward,
                          ),
                          _buildSmallCard(
                            'Expense',
                            '₹${provider.totalExpense.toStringAsFixed(0)}',
                            Colors.red,
                            Icons.arrow_upward,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Search Bar
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Search transactions...',
                      suffixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onChanged: (query) {
                      setState(() {
                        _searchQuery = query.trim().toLowerCase();
                      });
                    },
                  ),
                ),
                // Recent Transactions Section
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Recent Transactions',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                // Transactions List
                if (filteredTransactions.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Column(
                      children: [
                        Icon(Icons.inbox, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          _searchQuery.isEmpty
                              ? 'No transactions yet'
                              : 'No matching transactions found',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ],
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: filteredTransactions.length,
                    itemBuilder: (context, index) {
                      final transaction = filteredTransactions[index];
                      return Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          elevation: 2,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: transaction.isIncome
                                  ? Colors.green.shade100
                                  : Colors.red.shade100,
                              child: Icon(
                                transaction.isIncome
                                    ? Icons.arrow_downward
                                    : Icons.arrow_upward,
                                color: transaction.isIncome
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                            title: Text(
                              transaction.description,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 15),
                            ),
                            subtitle: Text(transaction.category,
                                style: TextStyle(fontSize: 13)),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '₹${transaction.amount.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        color: transaction.isIncome
                                            ? Colors.green
                                            : Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      '${transaction.date.day}/${transaction.date.month}',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 12),
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blueAccent),
                                  tooltip: 'Edit',
                                  onPressed: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => AddTransactionScreen(
                                          initialTransaction: transaction),
                                    ));
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete_outline, color: Colors.grey),
                                  tooltip: 'Delete',
                                  onPressed: () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text('Delete Transaction?'),
                                        content: Text(
                                            'Are you sure you want to delete this transaction?'),
                                        actions: [
                                          TextButton(
                                            child: Text('Cancel'),
                                            onPressed: () =>
                                                Navigator.of(context)
                                                    .pop(false),
                                          ),
                                          TextButton(
                                            child: Text('Delete',
                                                style: TextStyle(
                                                    color: Colors.red)),
                                            onPressed: () =>
                                                Navigator.of(context)
                                                    .pop(true),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (confirm ?? false) {
                                      Provider.of<TransactionProvider>(context,
                                              listen: false)
                                          .deleteTransaction(transaction.id);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content:
                                                Text('Transaction deleted')),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
          // floatingActionButton: FloatingActionButton(
          //   backgroundColor: Colors.blueAccent,
          //   child: Icon(Icons.add, color: Colors.white),
          //   onPressed: () {
          //     Navigator.of(context).push(
          //       MaterialPageRoute(builder: (_) => AddTransactionScreen()),
          //     );
          //   },
          // ),
        );
      },
    );
  }

  Widget _buildSmallCard(
    String title,
    String amount,
    Color color,
    IconData icon,
  ) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              Icon(icon, color: color, size: 28),
              SizedBox(height: 8),
              Text(title, style: TextStyle(fontSize: 12, color: Colors.grey)),
              SizedBox(height: 4),
              Text(
                amount,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
