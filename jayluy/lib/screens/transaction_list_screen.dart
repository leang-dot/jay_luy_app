import 'package:flutter/material.dart';
import '../models/transaction.dart';

class TransactionListScreen extends StatelessWidget {
  final List<Transaction> transactions;

  const TransactionListScreen({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    final allTransactions = transactions;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 246, 246, 246),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Transaction History",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: allTransactions.isEmpty
          ? const Center(
              child: Text(
                "No transactions yet",
                style: TextStyle(fontFamily: 'Poppins', color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(24.0),
              itemCount: allTransactions.length,
              itemBuilder: (context, index) {
                final tx = allTransactions[index];
                return _buildHistoryItem(tx);
              },
            ),
    );
  }

  Widget _buildHistoryItem(Transaction tx) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: tx.iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(tx.icon, color: const Color(0xFF00897B), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    fontSize: 16,
                  ),
                ),
                Text(
                  tx.timeFormatted,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
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
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
