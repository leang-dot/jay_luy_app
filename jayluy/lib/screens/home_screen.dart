import 'package:flutter/material.dart';
import '../state/app_state.dart'; // Make sure currentUser is defined here
import '../models/transaction.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Get first 3 items from global list
  List<Transaction> get transactions => globalTransactions.take(3).toList();

  @override
  Widget build(BuildContext context) {
    // 1. Get the current user safely
    final user = currentUser; 
    final displayName = user?.fullName ?? "User"; // Fallback if null

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 246, 246, 246),
      body: SafeArea(
        child: Column(
          children: [
            // 1. HEADER SECTION
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                      // 2. USE DYNAMIC NAME HERE
                      Text(
                        displayName, 
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/profile');
                    },
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'assets/images/jayluy_logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // 2. GRADIENT CARD
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                width: double.infinity,
                height: 200,
                padding: const EdgeInsets.all(30.0),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF00897B),
                      Color.fromARGB(255, 0, 255, 229),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00897B).withOpacity(0.25),
                      blurRadius: 25,
                      offset: const Offset(0, 10),
                      spreadRadius: -5,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
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
                      "\$${calculateTotalExpenses().toStringAsFixed(2)}",
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

            // 3. TRANSACTIONS TITLE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Transactions History",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/transactions'),
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
            const SizedBox(height: 10),

            // 4. DYNAMIC TRANSACTION ITEMS
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                physics: const BouncingScrollPhysics(),
                children: transactions.map((tx) => _buildTransactionItem(tx)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper for Transaction Items
  Widget _buildTransactionItem(Transaction tx) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: tx.iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(tx.icon, color: const Color(0xFF00897B), size: 20),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                Text(
                  tx.timeFormatted,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 11,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
          Text(
            tx.amount,
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}