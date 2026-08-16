import 'package:flutter/material.dart';

import '../widgets/register_event/search_bar.dart';
import '../widgets/register_event/filter_chip.dart';
import '../widgets/register_event/register_card.dart';
import '../widgets/register_event/empty_state.dart';

import '../screen/registration_form_page.dart';

import '../../../core/services/event_service.dart';
import '../../../shared/widgets/navbar_booth.dart';

class RegisterEventPage extends StatefulWidget {
  const RegisterEventPage({
    super.key,
  });

  @override
  State<RegisterEventPage> createState() =>
      _RegisterEventPageState();
}

class _RegisterEventPageState
    extends State<RegisterEventPage> {

  final TextEditingController _searchController =
      TextEditingController();

  final EventService _eventService =
      EventService();

  List<EventRegisterModel> events = [];

  List<EventRegisterModel> filteredEvents = [];

  List<Map<String, dynamic>> categories = [];

  bool isLoading = true;

  String? errorMessage;

  int selectedFilter = 0;

  @override
  void initState() {
    super.initState();

    loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> loadData() async {
    try {
      final results = await Future.wait([
        _eventService.getAvailableEvents(),
        _eventService.getEventCategories(),
      ]);

      final eventData =
          results[0] as List<Map<String, dynamic>>;

      final categoryData =
          results[1] as List<Map<String, dynamic>>;

      final parsedEvents =
          eventData.map((event) {

        final startDate =
            DateTime.tryParse(
          event['start_date']?.toString() ?? '',
        );

        final endDate =
            DateTime.tryParse(
          event['end_date']?.toString() ?? '',
        );

        final deadline =
            DateTime.tryParse(
          event['registration_deadline']
                  ?.toString() ??
              '',
        );

        String date = '-';

        if (startDate != null &&
            endDate != null) {

          date =
              '${startDate.day} - '
              '${endDate.day} '
              '${_monthName(endDate.month)} '
              '${endDate.year}';
        }

        String? categoryName;

        final category =
            event['categories'];

        if (category is Map) {
          categoryName =
              category['name']?.toString();
        }

        return EventRegisterModel(
          eventId:
              event['id'].toString(),

          image:
              event['banner']?.toString() ??
                  '',

          title:
              event['title']?.toString() ??
                  'Untitled Event',

          date: date,

          location:
              event['location']?.toString() ??
                  '-',

          totalBooth:
              int.tryParse(
                    event['maximum_booth']
                            ?.toString() ??
                        '0',
                  ) ??
                  0,

          registrationOpen:
              event['status']?.toString() ==
                  'published',

          category:
              categoryName,

          registrationDeadline:
              deadline,

          startDate:
              startDate,
        );
      }).toList();

      if (!mounted) return;

      setState(() {
        events = parsedEvents;

        filteredEvents =
            List.from(parsedEvents);

        categories = categoryData;

        isLoading = false;

        errorMessage = null;
      });
    } catch (e) {
      debugPrint(
        "REGISTER EVENT ERROR: $e",
      );

      if (!mounted) return;

      setState(() {
        isLoading = false;

        errorMessage =
            e.toString();
      });
    }
  }

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

  List<EventFilterModel>
      get filters {

    return [
      const EventFilterModel(
        title: "All",
      ),

      const EventFilterModel(
        title: "Open",
      ),

      const EventFilterModel(
        title: "Upcoming",
      ),

      ...categories.map(
        (category) {
          return EventFilterModel(
            title:
                category['name']
                    ?.toString() ??
                '-',
          );
        },
      ),
    ];
  }

  void applyFilters() {

    final query =
        _searchController.text
            .trim()
            .toLowerCase();

    final selectedTitle =
        filters[selectedFilter].title;

    List<EventRegisterModel> result =
        List.from(events);

    if (query.isNotEmpty) {

      result = result.where(
        (event) {

          final title =
              event.title
                  .toLowerCase();

          final location =
              event.location
                  .toLowerCase();

          return title.contains(query) ||
              location.contains(query);
        },
      ).toList();
    }

    if (selectedTitle == "All") {

      _setFilteredEvents(result);

      return;
    }

    if (selectedTitle == "Open") {

      result = result.where(
        (event) {

          return event.registrationOpen &&
              !event.isUpcoming;
        },
      ).toList();

      _setFilteredEvents(result);

      return;
    }

    if (selectedTitle == "Upcoming") {

      result = result.where(
        (event) {

          return event.isUpcoming;
        },
      ).toList();

      _setFilteredEvents(result);

      return;
    }

    result = result.where(
      (event) {

        return event.category
                ?.toLowerCase() ==
            selectedTitle
                .toLowerCase();
      },
    ).toList();

    _setFilteredEvents(result);
  }

  void _setFilteredEvents(
    List<EventRegisterModel> result,
  ) {

    setState(() {
      filteredEvents = result;
    });
  }

  @override
  Widget build(
    BuildContext context,
  ) {

    return Scaffold(
      backgroundColor:
          const Color(0xffF7F8FA),

      appBar: AppBar(
        title:
            const Text(
          "Register Booth",
        ),

        elevation: 0,

        centerTitle: true,

        backgroundColor:
            Colors.white,
      ),

      body: Column(
        children: [

          Padding(
            padding:
                const EdgeInsets.fromLTRB(
              20,
              20,
              20,
              10,
            ),

            child: EventSearchBar(
              controller:
                  _searchController,

              onChanged: (_) {
                applyFilters();
              },
            ),
          ),

          if (!isLoading &&
              errorMessage == null &&
              filters.isNotEmpty)

            Padding(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 20,
              ),

              child:
                  EventFilterChip(
                filters:
                    filters,

                selectedIndex:
                    selectedFilter,

                onSelected:
                    (index) {

                  setState(() {
                    selectedFilter =
                        index;
                  });

                  applyFilters();
                },
              ),
            ),

          const SizedBox(
            height: 20,
          ),

          Expanded(
            child:
                _buildEventContent(),
          ),
        ],
      ),

      bottomNavigationBar: const NavBar(
        currentIndex: 1,
      ),
    );
  }

  Widget _buildEventContent() {

    if (isLoading) {
      return const Center(
        child:
            CircularProgressIndicator(),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding:
              const EdgeInsets.all(20),

          child: Text(
            errorMessage!,
            textAlign:
                TextAlign.center,
          ),
        ),
      );
    }

    if (filteredEvents.isEmpty) {
      return const EmptyEventState(
        title:
            "No Event Found",

        subtitle:
            "There are currently no events available for registration.",
      );
    }

    return ListView.builder(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 20,
      ),

      itemCount:
          filteredEvents.length,

      itemBuilder:
          (_, index) {

        final event =
            filteredEvents[index];

        return EventRegisterCard(
          event: event,

          onRegister: () {

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    RegistrationFormPage(
                  eventId:
                      event.eventId,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
