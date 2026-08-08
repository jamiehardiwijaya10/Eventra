import 'package:flutter/material.dart';
import '../widgets/my/management_menu_card.dart';

class ManageEventPage extends StatelessWidget {
  const ManageEventPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),

      appBar: AppBar(
        title: const Text("Manage Event"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          const Text(
            "Food Festival Bandung",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            "Manage every aspect of your event from one dashboard.",
            style: TextStyle(
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 25),

          ManagementMenuCard(
            icon: Icons.storefront,
            title: "Booth Management",
            subtitle: "Manage all registered booths",
            onTap: () {},
          ),

          const SizedBox(height: 15),

          ManagementMenuCard(
            icon: Icons.fact_check_outlined,
            title: "Registration Requests",
            subtitle: "Approve or reject booth registration",
            onTap: () {},
          ),

          const SizedBox(height: 15),

          ManagementMenuCard(
            icon: Icons.map_outlined,
            title: "Venue Map",
            subtitle: "Manage digital floor plan",
            onTap: () {},
          ),

          const SizedBox(height: 15),

          ManagementMenuCard(
            icon: Icons.bar_chart,
            title: "Statistics",
            subtitle: "View visitor and booth analytics",
            onTap: () {},
          ),

          const SizedBox(height: 15),

          ManagementMenuCard(
            icon: Icons.campaign_outlined,
            title: "Announcement",
            subtitle: "Send announcements to visitors",
            onTap: () {},
          ),

          const SizedBox(height: 15),

          ManagementMenuCard(
            icon: Icons.settings_outlined,
            title: "Settings",
            subtitle: "Configure event information",
            onTap: () {},
          ),
        ],
      ),
    );
  }
}