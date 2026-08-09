import 'package:flutter/material.dart';
import '../../../core/services/event_service.dart';
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
  final EventService _eventService = EventService();

  String selectedStatus = "All";

  List<Map<String, dynamic>> events = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadMyEvents();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadMyEvents() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final data = await _eventService.getMyEvents();

      if (!mounted) return;

      setState(() {
        events = data;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("GET MY EVENTS ERROR: $e");

      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  List<Map<String, dynamic>> get filteredEvents {
    final search = searchController.text.trim().toLowerCase();

    return events.where((event) {
      final title =
          (event['title'] ?? '').toString().toLowerCase();

      final location =
          (event['location'] ?? '').toString().toLowerCase();

      final matchesSearch =
          search.isEmpty ||
          title.contains(search) ||
          location.contains(search);

      final status =
          (event['status'] ?? '').toString().toLowerCase();

      final matchesStatus =
          selectedStatus == "All" ||
          status == selectedStatus.toLowerCase();

      return matchesSearch && matchesStatus;
    }).toList();
  }

  String formatDate(dynamic value) {
    if (value == null) return "-";

    final date = DateTime.tryParse(value.toString());

    if (date == null) return "-";

    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";
  }

  String calculateStatus(Map<String, dynamic> event) {
    final start = DateTime.tryParse(
      event['start_date']?.toString() ?? '',
    );

    final end = DateTime.tryParse(
      event['end_date']?.toString() ?? '',
    );

    if (start == null || end == null) {
      return "Unknown";
    }

    final now = DateTime.now();

    if (now.isBefore(start)) {
      return "Upcoming";
    }

    if (now.isAfter(end)) {
      return "Finished";
    }

    return "Ongoing";
  }

  @override
  Widget build(BuildContext context) {
    final displayedEvents = filteredEvents;

    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text("My Events"),
      ),

      body: RefreshIndicator(
        onRefresh: loadMyEvents,

        child: ListView(
          padding: const EdgeInsets.all(20),

          children: [
            const MyEventHeader(),

            const SizedBox(height: 24),

            CreateEventButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CreateEventPage(),
                  ),
                );
                loadMyEvents();
              },
            ),

            const SizedBox(height: 20),

            EventSearchBar(
              controller: searchController,
              onChanged: (_) {
                setState(() {});
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

            if (isLoading)
              const Padding(
                padding: EdgeInsets.all(40),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )

            else if (errorMessage != null)
              _buildError()

            else if (displayedEvents.isEmpty)
              _buildEmpty()

            else
              ...displayedEvents.map(
                (event) {
                  final eventId =
                      event['id'].toString();

                  final status =
                      calculateStatus(event);

                  return Padding(
                    padding:
                        const EdgeInsets.only(bottom: 20),

                    child: EventCard(
                      image:
                          event['banner']?.toString() ?? '',

                      title:
                          event['title']?.toString() ?? '-',

                      location:
                          event['location']?.toString() ?? '-',

                      date:
                          "${formatDate(event['start_date'])}"
                          " - "
                          "${formatDate(event['end_date'])}",

                      boothCount: 0,

                      visitorCount: 0,

                      status: status,

                      onManage: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ManageEventPage(
                              eventId: eventId,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),

            const SizedBox(height: 40),
          ],
        ),
      ),

      bottomNavigationBar: const NavBar(
        currentIndex: 1,
      ),
    );
  }

  Widget _buildEmpty() {
    return Container(
      padding: const EdgeInsets.all(30),
      child: const Column(
        children: [
          Icon(
            Icons.event_busy_outlined,
            size: 60,
            color: Colors.grey,
          ),

          SizedBox(height: 15),

          Text(
            "No events found",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 8),

          Text(
            "Create your first event to get started.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Icon(
            Icons.error_outline,
            size: 50,
            color: Colors.red,
          ),

          const SizedBox(height: 12),

          const Text(
            "Failed to load events",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            errorMessage ?? '',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 15),

          ElevatedButton(
            onPressed: loadMyEvents,
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }
}