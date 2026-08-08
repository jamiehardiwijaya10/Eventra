import 'package:flutter/material.dart';
import '../widgets/my/my_event_header.dart';
import '../widgets/my/create_event_button.dart';
import '../widgets/my/event_search_bar.dart';
import '../widgets/my/event_status_filter.dart';
import '../widgets/my/event_card.dart';
import 'manage_event_page.dart';
import 'create_event_page.dart';
import '../../../shared/widgets/navbar_eo.dart';

class MyEventPage extends StatefulWidget {
  const MyEventPage({super.key});

  @override
  State<MyEventPage> createState() => _MyEventPageState();
}

class _MyEventPageState extends State<MyEventPage> {
  final TextEditingController searchController = TextEditingController();

  String selectedStatus = "All";

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text("My Events"),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          const MyEventHeader(),

          const SizedBox(height: 24),

          CreateEventButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CreateEventPage(),
                ),
              );
            },
          ),

          const SizedBox(height: 20),

          EventSearchBar(
            controller: searchController,
            onChanged: (value) {
            },
          ),

          const SizedBox(height: 20),

          EventStatusFilter(
            selected: selectedStatus,
            onSelected: (value) {
              setState(() {
                selectedStatus = value;
              });
            },
          ),

          const SizedBox(height: 24),

          EventCard(
            image: "assets/images/burger.png",
            title: "Food Festival Bandung",
            location: "Sabuga Convention Hall",
            date: "12 - 14 August 2026",
            boothCount: 120,
            visitorCount: 1250,
            status: "Ongoing",
            onManage: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ManageEventPage(),
                ),
              );
            },
          ),

          const SizedBox(height: 20),

          EventCard(
            image: "assets/images/burger.png",
            title: "Bandung Coffee Expo",
            location: "Braga City Walk",
            date: "20 September 2026",
            boothCount: 65,
            visitorCount: 0,
            status: "Upcoming",
            onManage: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ManageEventPage(),
                ),
              );
            },
          ),

          const SizedBox(height: 20),

          EventCard(
            image: "assets/images/burger.png",
            title: "UMKM Fair 2026",
            location: "Gedung Sate",
            date: "5 - 7 July 2026",
            boothCount: 98,
            visitorCount: 4320,
            status: "Finished",
            onManage: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ManageEventPage(),
                ),
              );
            },
          ),
          const SizedBox(height: 40),
        ],
      ),
      bottomNavigationBar: const NavBar(
        currentIndex: 1,
      ),
    );
  }
}