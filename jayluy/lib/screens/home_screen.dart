import 'package:flutter/material.dart';
import 'transaction_list_screen.dart';
import '../models/transaction.dart';
import '../models/user.dart';

class HomeScreen extends StatelessWidget {
  final User currentUser;
  final List<Transaction> transactions;

  const HomeScreen({
    super.key,
    required this.currentUser,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    double totalExpenses = transactions.fold(0.0, (sum, item) {
      String cleanAmount = item.amount.replaceAll(RegExp(r'[^\d.]'), '');
      return sum + (double.tryParse(cleanAmount) ?? 0.0);
    });

    final recentTransactions = transactions.take(3).toList();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 246, 246, 246),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Hello",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        currentUser.fullName,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const CircleAvatar(
                    backgroundColor: Colors.black,
                    radius: 24,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(30.0),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00897B), Color(0xFF00BFA5)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Total Expenses",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "\$${totalExpenses.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Recent Activity",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TransactionListScreen(transactions: transactions),
                        ),
                      );
                    },
                    child: const Text(
                      "See all",
                      style: TextStyle(
                        color: Colors.grey,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: recentTransactions.isEmpty
                  ? const Center(
                      child: Text(
                        "No activity yet",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      itemCount: recentTransactions.length,
                      itemBuilder: (context, index) {
                        final tx = recentTransactions[index];
                        return _buildTransactionItem(tx);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(Transaction tx) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: tx.iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(tx.icon, color: const Color(0xFF00897B)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx.title,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  tx.amount,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
