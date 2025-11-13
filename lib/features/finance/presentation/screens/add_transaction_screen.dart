import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import '../../data/models/transaction_model.dart';
import '../transaction_provider.dart';
import '../../../../core/constants/app_categories.dart';

class AddTransactionScreen extends StatefulWidget {
  final Transaction? initialTransaction;

  AddTransactionScreen({this.initialTransaction});

  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _descriptionController;
  late TextEditingController _amountController;

  DateTime _selectedDate = DateTime.now();
  String _selectedCategory = 'Food & Dining';
  bool _isIncome = false;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController();
    _amountController = TextEditingController();

    if (widget.initialTransaction != null) {
      _descriptionController.text = widget.initialTransaction!.description;
      _amountController.text = widget.initialTransaction!.amount.toString();
      _selectedDate = widget.initialTransaction!.date;
      _selectedCategory = widget.initialTransaction!.category;
      _isIncome = widget.initialTransaction!.isIncome;
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() == true) {
      final isEditing = widget.initialTransaction != null;

      final transaction = Transaction(
        id: isEditing ? widget.initialTransaction!.id : const Uuid().v4(),
        description: _descriptionController.text,
        amount: double.parse(_amountController.text),
        category: _selectedCategory,
        date: _selectedDate,
        isIncome: _isIncome,
      );

      final provider = Provider.of<TransactionProvider>(context, listen: false);

      if (isEditing) {
        provider.updateTransaction(transaction);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✓ Transaction updated!'),
            backgroundColor: Colors.blue,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        provider.addTransaction(transaction);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✓ Transaction added successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }

      // Optionally: Clear form or pop the screen, your preference
      // Remove navigation for web as we did before.
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryList = _isIncome ? incomeSources : categories;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initialTransaction != null ? 'Edit Transaction' : 'Add Transaction'),
        backgroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Income/Expense Tabs
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() {
                            _isIncome = true;
                            _selectedCategory = 'Salary';
                          }),
                          child: Container(
                            decoration: BoxDecoration(
                              color: _isIncome ? Colors.green : Colors.transparent,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(9),
                                bottomLeft: Radius.circular(9),
                              ),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Center(
                              child: Text(
                                'Income',
                                style: TextStyle(
                                  color: _isIncome ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 48,
                        color: Colors.grey.shade300,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() {
                            _isIncome = false;
                            _selectedCategory = 'Food & Dining';
                          }),
                          child: Container(
                            decoration: BoxDecoration(
                              color: !_isIncome ? Colors.red : Colors.transparent,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(9),
                                bottomRight: Radius.circular(9),
                              ),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Center(
                              child: Text(
                                'Expense',
                                style: TextStyle(
                                  color: !_isIncome ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),

                // Description Field
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    hintText: 'e.g., Grocery shopping',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(Icons.description),
                  ),
                  validator: (value) {
                    if (value?.isEmpty == true) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Amount Field
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    hintText: '0.00',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixText: '₹ ',
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                  validator: (value) {
                    if (value?.isEmpty == true) {
                      return 'Please enter an amount';
                    }
                    if (double.tryParse(value!) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Category Dropdown
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  items: categoryList
                      .map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _selectedCategory = value ?? 'Other');
                  },
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(Icons.category),
                  ),
                ),
                SizedBox(height: 16),

                // Date Picker
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Date',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    child: Text(
                      DateFormat('dd/MM/yyyy').format(_selectedDate),
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                SizedBox(height: 32),

                // Submit Button
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    widget.initialTransaction != null ? 'Update Transaction' : 'Add Transaction',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
