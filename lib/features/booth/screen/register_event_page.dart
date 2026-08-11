import 'package:flutter/material.dart';
import '../widgets/register_event/search_bar.dart';
import '../widgets/register_event/filter_chip.dart';
import '../widgets/register_event/register_card.dart';
import '../widgets/register_event/empty_state.dart';
import '../screen/registration_form_page.dart';
import '../../../core/services/event_service.dart';

class RegisterEventPage extends StatefulWidget {
  const RegisterEventPage({super.key});

  @override
  State<RegisterEventPage> createState() => _RegisterEventPageState();
}

class _RegisterEventPageState extends State<RegisterEventPage> {
  final TextEditingController _searchController = TextEditingController();
  final EventService _eventService = EventService();

  List<EventRegisterModel> events = [];
  bool isLoading = true;
  String? errorMessage;

  String _monthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return months[month - 1];
  }

  int selectedFilter = 0;

  final List<EventFilterModel> filters = const [
    EventFilterModel(title: "All"),
    EventFilterModel(title: "Open"),
    EventFilterModel(title: "Closing Soon"),
    EventFilterModel(title: "Festival"),
    EventFilterModel(title: "Market"),
    EventFilterModel(title: "Expo"),
  ];

  @override
  void initState() {
    super.initState();
    loadEvents();
  }

  Future<void> loadEvents() async {
    try {
      final data = await _eventService.getAvailableEvents();

      if (!mounted) return;

      setState(() {
        events = data.map((event) {
          final startDate = DateTime.tryParse(
            event['start_date']?.toString() ?? '',
          );

          final endDate = DateTime.tryParse(
            event['end_date']?.toString() ?? '',
          );

          String date = '-';

          if (startDate != null && endDate != null) {
            date =
                '${startDate.day} - ${endDate.day} '
                '${_monthName(endDate.month)} ${endDate.year}';
          }

          return EventRegisterModel(
            eventId: event['id'].toString(),
            image: event['banner']?.toString() ?? '',
            title: event['title']?.toString() ?? 'Untitled Event',
            date: date,
            location: event['location']?.toString() ?? '-',
            totalBooth:
                int.tryParse(
                  event['maximum_booth']?.toString() ?? '0',
                ) ??
                0,
            registrationOpen:
                event['status']?.toString() == 'published',
          );
        }).toList();

        isLoading = false;
        errorMessage = null;
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
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : errorMessage != null
                  ? Center(
                      child: Text(
                        errorMessage!,
                        textAlign: TextAlign.center,
                      ),
                    )
                  : events.isEmpty
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
                            final event = events[index];
                            return EventRegisterCard(
                              event: event,
                              onRegister: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => RegistrationFormPage(
                                      eventId: event.eventId,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
        )
        ],
      ),
    );
  }
}