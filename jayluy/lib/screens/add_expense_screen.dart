import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import '../models/category.dart';

class AddExpenseScreen extends StatefulWidget {
  final Function(Transaction) onSave;

  const AddExpenseScreen({super.key, required this.onSave});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  DateTime _selectedDate = DateTime.now();

  late Category _selectedCategory;

  final List<Category> _availableCategories = Category.categories;

  @override
  void initState() {
    super.initState();
    // Logic: Initialize UI state
    _dateController.text = DateFormat('EEE, d MMM y').format(_selectedDate);
    _selectedCategory = _availableCategories[0];
    _nameController.text = _availableCategories[0].name;
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF00897B),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    ).then((pickedDate) {
      if (pickedDate == null) return;
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text = DateFormat('EEE, d MMM y').format(pickedDate);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 246, 246, 246),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          "Add Expense",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("NAME"),
                      _buildInput(
                        controller: _nameController,
                        hint: "e.g. Starbucks",
                        prefixIcon: _selectedCategory.icon,
                        prefixIconColor: const Color(0xFFE0F2F1),
                        suffixWidget: PopupMenuButton<Category>(
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.grey,
                          ),
                          onSelected: (Category value) {
                            setState(() {
                              _selectedCategory = value;
                              _nameController.text = value.name;
                            });
                          },
                          itemBuilder: (BuildContext context) {
                            return _availableCategories.map((Category choice) {
                              return PopupMenuItem<Category>(
                                value: choice,
                                child: Row(
                                  children: [
                                    Icon(
                                      choice.icon,
                                      color: const Color(0xFF00897B),
                                      size: 18,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      choice.name,
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList();
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildLabel("AMOUNT"),
                      _buildInput(
                        controller: _amountController,
                        hint: "0.00",
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 20),
                      _buildLabel("DATE"),
                      _buildInput(
                        controller: _dateController,
                        hint: "Select Date",
                        readOnly: true,
                        icon: Icons.calendar_today,
                        onTap: _presentDatePicker,
                      ),
                      const SizedBox(height: 20),
                      _buildLabel("DESCRIPTION"),
                      Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFAFAFA),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: TextField(
                          controller: _descController,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(16),
                            hintText: "Optional details...",
                            hintStyle: TextStyle(
                              color: Colors.black26,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Center(
                        child: SizedBox(
                          width: 160,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_nameController.text.isEmpty ||
                                  _amountController.text.isEmpty) {
                                return;
                              }

                              final newTx = Transaction(
                                title: _nameController.text,
                                amount: "-\$${_amountController.text}",
                                icon: _selectedCategory.icon,
                                iconBgColor: const Color(0xFFE0F2F1),
                                date: _selectedDate,
                              );

                              widget.onSave(newTx);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00897B),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              'Add Expense',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.grey[400],
          fontFamily: 'Poppins',
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    String? hint,
    TextInputType? keyboardType,
    bool readOnly = false,
    IconData? icon,
    Widget? suffixWidget,
    IconData? prefixIcon,
    Color? prefixIconColor,
    VoidCallback? onTap,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
      style: const TextStyle(fontFamily: 'Poppins', fontSize: 14),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFFAFAFA),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black26),
        prefixIcon: prefixIcon != null
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: prefixIconColor ?? const Color(0xFFE0F2F1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    prefixIcon,
                    size: 18,
                    color: const Color(0xFF00897B),
                  ),
                ),
              )
            : null,
        suffixIcon:
            suffixWidget ??
            (icon != null ? Icon(icon, color: Colors.grey, size: 20) : null),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF00897B)),
        ),
      ),
    );
  }
}
