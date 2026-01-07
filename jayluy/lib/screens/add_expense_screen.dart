import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import '../models/transaction.dart'; 
import '../state/app_state.dart';

class CategoryOption {
  final String name;
  final IconData icon;
  final Color color;

  CategoryOption(this.name, this.icon, this.color);
}

class AddExpenseScreen extends StatefulWidget {
  final VoidCallback? onSave; 

  const AddExpenseScreen({super.key, this.onSave});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  // [UPDATED] We only need this controller for the top field now
  final TextEditingController _nameController = TextEditingController(); // Reused for the main input
  
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  
  // Track selected icon (Defaults to "Other")
  CategoryOption _selectedCategoryOption = CategoryOption(
    "Other", Icons.more_horiz, const Color(0xFFEEEEEE)
  );

  final List<CategoryOption> _categories = [
    CategoryOption("Food & Drinks", Icons.restaurant, const Color(0xFFE0F2F1)),
    CategoryOption("Shopping", Icons.shopping_bag, const Color(0xFFF3E5F5)),
    CategoryOption("Transport", Icons.directions_car, const Color(0xFFE1F5FE)),
    CategoryOption("Bills", Icons.receipt_long, const Color(0xFFFFF3E0)),
    CategoryOption("Entertainment", Icons.movie, const Color(0xFFFCE4EC)),
    CategoryOption("Health", Icons.local_hospital, const Color(0xFFFFEBEE)),
    CategoryOption("Other", Icons.more_horiz, const Color(0xFFEEEEEE)),
  ];

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('EEE, d MMM y').format(_selectedDate);
    
    // Default start
    _selectedCategoryOption = _categories[0];
    _nameController.text = _categories[0].name; // Pre-fill with first category
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
                      
                      // 1. NAME FIELD (Was Category)
                      // Now acts as the main Name input AND Category selector
                      _buildLabel("NAME"),
                      _buildInput(
                        controller: _nameController,
                        hint: "e.g. Starbucks",
                        
                        // Show selected icon on the left
                        prefixIcon: _selectedCategoryOption.icon,
                        prefixIconColor: _selectedCategoryOption.color,
                        
                        // Dropdown arrow on the right to change Icon/Category
                        suffixWidget: PopupMenuButton<CategoryOption>(
                          icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                          onSelected: (CategoryOption value) {
                            setState(() {
                              _selectedCategoryOption = value;
                              // Optional: If you want clicking "Food" to replace the text "Starbucks", keep this.
                              // If you want to keep "Starbucks" but change the icon, remove this line.
                              _nameController.text = value.name; 
                            });
                          },
                          itemBuilder: (BuildContext context) {
                            return _categories.map((CategoryOption choice) {
                              return PopupMenuItem<CategoryOption>(
                                value: choice,
                                child: Row(
                                  children: [
                                    Icon(choice.icon, color: const Color(0xFF00897B), size: 18),
                                    const SizedBox(width: 10),
                                    Text(choice.name),
                                  ],
                                ),
                              );
                            }).toList();
                          },
                        ),
                      ),
                      const SizedBox(height: 20),

                      // [REMOVED] Old Name Field (Deleted as requested)

                      // 2. AMOUNT FIELD
                      _buildLabel("AMOUNT"),
                      _buildInput(
                        controller: _amountController,
                        hint: "0.00",
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 20),

                      // 3. DATE FIELD
                      _buildLabel("DATE"),
                      _buildInput(
                        controller: _dateController,
                        hint: "Select Date",
                        readOnly: true, 
                        icon: Icons.calendar_today,
                        onTap: _presentDatePicker, 
                      ),
                      const SizedBox(height: 20),

                      // 4. DESCRIPTION FIELD
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
                            hintStyle: TextStyle(color: Colors.black26),
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // 5. SAVE BUTTON
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
                                title: _nameController.text, // Uses the top field text
                                amount: "-\$${_amountController.text}",
                                icon: _selectedCategoryOption.icon, // Uses selected icon
                                iconBgColor: _selectedCategoryOption.color,
                                date: _selectedDate, 
                              );

                              setState(() {
                                globalTransactions.insert(0, newTx);
                              });
                              
                              // Reset
                              _nameController.clear();
                              _amountController.clear();
                              _descController.clear();
                              
                              // Reset category default
                              setState(() {
                                _selectedCategoryOption = _categories[0];
                                _nameController.text = _categories[0].name;
                              });

                              if (widget.onSave != null) {
                                widget.onSave!();
                              }
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
                child: Icon(prefixIcon, size: 18, color: const Color(0xFF00897B)),
              ),
            )
          : null,

        suffixIcon: suffixWidget ?? (icon != null
            ? Icon(icon, color: Colors.grey, size: 20)
            : null),
            
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