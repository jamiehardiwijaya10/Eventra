import 'package:flutter/material.dart';
import '../../../core/services/event_service.dart';
import '../widgets/my/management_menu_card.dart';
import 'booth_management_page.dart';
import 'event_settings_page.dart';
import 'booth_management_page.dart';
import 'registration_requests_page.dart';
import 'statistics_page.dart';

class ManageEventPage extends StatefulWidget {
  final String eventId;

  const ManageEventPage({
    super.key,
    required this.eventId,
  });

  @override
  State<ManageEventPage> createState() => _ManageEventPageState();
}

class _ManageEventPageState extends State<ManageEventPage> {
  final EventService _eventService = EventService();

  Map<String, dynamic>? event;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadEvent();
  }

  Future<void> loadEvent() async {
    try {
      final data = await _eventService.getEventById(
        widget.eventId,
      );

      if (!mounted) return;

      setState(() {
        event = data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Manage Event"),
        ),
        body: Center(
          child: Text(
            "Gagal mengambil event:\n$errorMessage",
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (event == null) {
      return const Scaffold(
        body: Center(
          child: Text("Event tidak ditemukan"),
        ),
      );
    }

    final eventTitle =
        event!['title']?.toString() ?? 'Untitled Event';

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

          Text(
            eventTitle,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            "Manage every aspect of your event from one dashboard.",
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 25),

          const SizedBox(height: 25),

          ManagementMenuCard(
            icon: Icons.storefront,
            title: "Booth Management",
            subtitle: "Manage all registered booths",
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BoothManagementPage(
                    eventId: widget.eventId,
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 15),

          ManagementMenuCard(
            icon: Icons.fact_check_outlined,
            title: "Registration Requests",
            subtitle: "Approve or reject booth registration",
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RegistrationRequestsPage(
                    eventId: widget.eventId,
                  ),
                ),
              );
            },
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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => StatisticsPage(
                    eventId: widget.eventId,
                  ),
                ),
              );
            },
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
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EventSettingsPage(
                    eventId: widget.eventId,
                  ),
                ),
              );

              if (result == true) {
                loadEvent();
              }
            },
          ),
        ],
      ),
    );
  }
}