import 'package:flutter/material.dart';
import '../models/user.dart';

class ProfileScreen extends StatelessWidget {
  final User currentUser;
  final VoidCallback onLogout;

  const ProfileScreen({
    super.key,
    required this.currentUser,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final displayName = currentUser.fullName;
    final displayEmail = currentUser.email;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 246, 246, 246),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading:
            false,
        title: const Text(
          "Profile",
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
        child: Column(
          children: [
            const SizedBox(height: 20),

            Center(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Icon(Icons.person, color: Colors.white, size: 50),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    displayName,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    displayEmail,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.grey[500],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    _buildProfileItem(Icons.person_outline, "Account Info"),
                    _buildProfileItem(
                      Icons.notifications_none,
                      "Notifications",
                    ),
                    _buildProfileItem(Icons.security, "Security"),
                    _buildProfileItem(Icons.help_outline, "Help & Support"),

                    const Spacer(),

                    GestureDetector(
                      onTap:
                          onLogout,
                      child: _buildProfileItem(
                        Icons.logout,
                        "Logout",
                        isLogout: true,
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(
    IconData icon,
    String title, {
    bool isLogout = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
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
          Icon(
            icon,
            color: isLogout ? Colors.red : const Color(0xFF00897B),
            size: 22,
          ),
          const SizedBox(width: 16),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: isLogout ? Colors.red : Colors.black,
            ),
          ),
          const Spacer(),
          if (!isLogout)
            const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 14),
        ],
      ),
    );
  }
}
