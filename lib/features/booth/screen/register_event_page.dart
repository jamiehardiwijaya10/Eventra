import 'package:flutter/material.dart';
import '../widgets/register_event/search_bar.dart';
import '../widgets/register_event/filter_chip.dart';
import '../widgets/register_event/register_card.dart';
import '../widgets/register_event/empty_state.dart';
import '../screen/registration_form_page.dart';

class RegisterEventPage extends StatefulWidget {
  const RegisterEventPage({super.key});

  @override
  State<RegisterEventPage> createState() => _RegisterEventPageState();
}

class _RegisterEventPageState extends State<RegisterEventPage> {
  final TextEditingController _searchController = TextEditingController();

  int selectedFilter = 0;

  final List<EventFilterModel> filters = const [
    EventFilterModel(title: "All"),
    EventFilterModel(title: "Open"),
    EventFilterModel(title: "Closing Soon"),
    EventFilterModel(title: "Festival"),
    EventFilterModel(title: "Market"),
    EventFilterModel(title: "Expo"),
  ];

  final List<EventRegisterModel> events = const [
    EventRegisterModel(
      image: "assets/images/burger.png",
      title: "Bandung Food Festival",
      date: "20 - 22 October 2026",
      location: "Braga City Walk, Bandung",
      totalBooth: 128,
      registrationOpen: true,
    ),

    EventRegisterModel(
      image: "assets/images/burger.png",
      title: "Coffee Expo Bandung",
      date: "5 - 7 November 2026",
      location: "Sasana Budaya Ganesha",
      totalBooth: 84,
      registrationOpen: true,
    ),

    EventRegisterModel(
      image: "assets/images/burger.png",
      title: "UMKM Fair",
      date: "15 - 17 December 2026",
      location: "Gedung Sate",
      totalBooth: 220,
      registrationOpen: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),

      appBar: AppBar(
        title: const Text("Register Booth"),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
      ),

      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              20,
              20,
              10,
            ),
            child: EventSearchBar(
              controller: _searchController,
              onChanged: (value) {},
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: EventFilterChip(
              filters: filters,
              selectedIndex: selectedFilter,
              onSelected: (index) {
                setState(() {
                  selectedFilter = index;
                });
              },
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: events.isEmpty
                ? const EmptyEventState(
              title: "No Event Found",
              subtitle:
              "There are currently no events available for registration.",
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              itemCount: events.length,
              itemBuilder: (_, index) {
                return EventRegisterCard(
                  event: events[index],
                  onRegister: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RegistrationFormPage(),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}