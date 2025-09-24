import 'package:crpto_wallet/Botton%20Navigation%20Bar/profile/profile%20screen.dart';
import 'package:crpto_wallet/Botton%20Navigation%20Bar/transaction%20screen.dart';
import 'package:crpto_wallet/Token/Home/Token%20Home%20Screen.dart';
import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Notifications",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Today Section
          const Text(
            "Today",
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          _buildNotificationTile(
            title: "Lorem Ipsum Dolor Sit Amet",
            description: "Lorem Ipsum Dolor Sit Amet. Et Architecto Sequi Sed Aperiam Autem Ea Consequuntur",
            time: "05:57 Pm",
          ),
          const SizedBox(height: 12),

          _buildNotificationTile(
            title: "Lorem Ipsum",
            description: "Lorem Ipsum Dolor Sit Amet. Et Architecto Seq Sed Aperiam Autem Ea Consequuntur Vero",
            time: "05:57 Pm",
          ),

          const Divider(color: Colors.white24, height: 32),

          // Yesterday Section
          const Text(
            "Yesterday",
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          _buildNotificationTile(
            title: "Lorem Ipsum",
            description: "Lorem Ipsum Dolor Sit Amet. Et Architecto Seq Sed Aperiam Autem Ea Consequuntur",
            time: "05:57 Pm",
          ),
          const SizedBox(height: 12),

          _buildNotificationTile(
            title: "Lorem Ipsum Dolor Sit",
            description: "Lorem Ipsum Dolor Sit Amet. Et Architecto Seq Sed Aperiam Autem Ea Consequuntur Vero",
            time: "05:57 Pm",
          ),
          const SizedBox(height: 12),

          _buildNotificationTile(
            title: "Lorem Ipsum Dolor Sit",
            description: "Lorem Ipsum Dolor Sit Amet. Et Architecto Seq Sed Aperiam Autem Ea Consequuntur Vero",
            time: "05:57 Pm",
          ),
          const SizedBox(height: 12),

          _buildNotificationTile(
            title: "Lorem Ipsum",
            description: "Lorem Ipsum Dolor Sit Amet. Et Architecto Seq Sed Aperiam Autem Ea Consequuntur",
            time: "05:57 Pm",
          ),
        ],
      ),

      // ✅ Bottom Navigation Bar
      bottomNavigationBar: ClipRRect(
  borderRadius: const BorderRadius.only(
    topLeft: Radius.circular(20),
    topRight: Radius.circular(20),
  ),
  child: BottomNavigationBar(
        backgroundColor: Colors.grey[900],
        selectedItemColor: const Color(0xFFBFFF08),
        unselectedItemColor: Colors.white70,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "Transactions"),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: "Notifications"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        currentIndex: 2, // Notifications active
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TransactionsScreen()),
            );
          } else if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TokenHomeScreen()),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            );
          }
        },
      ),)
    );
  }

  // 🔹 Notification Tile Widget
  Widget _buildNotificationTile({
    required String title,
    required String description,
    required String time,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Circle Icon
        Container(
          padding: const EdgeInsets.all(6),
          decoration: const BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.notifications, color: Color(0xFFBFFF08)),
        ),
        const SizedBox(width: 12),

        // Title & Description
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    "At $time",
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(color: Colors.grey, fontSize: 13),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
