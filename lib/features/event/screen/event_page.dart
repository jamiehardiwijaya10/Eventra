import 'package:flutter/material.dart';
import '../../../core/services/event_service.dart';
import '../../../core/theme/app_color.dart';
import '../../../shared/widgets/navbar_costumer.dart';
import '../widgets/page/activity_summary.dart';
import '../widgets/page/current_event.dart';
import '../widgets/page/event_header.dart';
import '../widgets/page/event_horizontal_card.dart';
import '../widgets/page/history_card.dart';
import '../widgets/page/history_section.dart';
import '../widgets/page/quick_access.dart';
import '../widgets/page/recommendation.dart';
import '../widgets/page/search_event.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'event_screen.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  final EventService _eventService = EventService();
  final SupabaseClient _client = Supabase.instance.client;

  final PageController _currentEventController = PageController(
    viewportFraction: 0.92,
  );

  List<Map<String, dynamic>> events = [];

  bool isLoading = true;
  String? errorMessage;

  int currentEventIndex = 0;
  int approvedBoothCount = 0;

  @override
  void initState() {
    super.initState();
    loadEvents();
  }

  @override
  void dispose() {
    _currentEventController.dispose();
    super.dispose();
  }

  Future<void> loadEvents() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final result =
        await _eventService.getMyPurchasedEvents();

      int boothCount = 0;

      final eventIds = result
          .map((event) => event['id']?.toString())
          .whereType<String>()
          .toList();

      if (eventIds.isNotEmpty) {
        final boothResponse = await _client
            .from('booths')
            .select('id')
            .inFilter('event_id', eventIds)
            .eq('status', 'approved');

        boothCount = boothResponse.length;
      }

      if (!mounted) return;

      setState(() {
        events = result;
        approvedBoothCount = boothCount;
        currentEventIndex = 0;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('LOAD CUSTOMER PURCHASED EVENTS ERROR: $e');

      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  String _formatDate(dynamic value) {
    if (value == null) {
      return '-';
    }

    final date = DateTime.tryParse(value.toString());

    if (date == null) {
      return value.toString();
    }

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

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _eventImage(Map<String, dynamic> event) {
    final banner = event['banner']?.toString();

    if (banner != null && banner.isNotEmpty) {
      return banner;
    }

    return 'assets/images/konser.png';
  }

  String _eventLocation(Map<String, dynamic> event) {
    final location = event['location']?.toString();

    if (location != null && location.isNotEmpty) {
      return location;
    }

    final venue = event['venue_name']?.toString();

    if (venue != null && venue.isNotEmpty) {
      return venue;
    }

    return '-';
  }

  int _visitorCount(Map<String, dynamic> event) {
    final value = event['visitor_count'];

    if (value is int) {
      return value;
    }

    return int.tryParse(value?.toString() ?? '0') ?? 0;
  }

  List<Map<String, dynamic>> _getRecommendedEvents() {
    if (events.length <= 1) {
      return [];
    }

    return events
        .asMap()
        .entries
        .where((entry) => entry.key != currentEventIndex)
        .map((entry) => entry.value)
        .toList();
  }

  List<Map<String, dynamic>> _getHistoryEvents() {
    final now = DateTime.now();

    return events.where((event) {
      final endDate = DateTime.tryParse(event['end_date']?.toString() ?? '');

      if (endDate == null) {
        return false;
      }

      return endDate.isBefore(now);
    }).toList();
  }

  List<Map<String, dynamic>> _getActiveEvents() {
    final now = DateTime.now();

    return events.where((event) {
      final startDate = DateTime.tryParse(
        event['start_date']?.toString() ?? '',
      );

      final endDate = DateTime.tryParse(event['end_date']?.toString() ?? '');

      if (startDate == null || endDate == null) {
        return true;
      }

      return !endDate.isBefore(now);
    }).toList();
  }

  double _getRating(Map<String, dynamic> event) {
    final value = event['rating'];

    if (value is num) {
      return value.toDouble();
    }

    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,

      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: loadEvents,

          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),

            padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const EventHeader(),

                const SizedBox(height: 24),

                EventSearch(onChanged: (value) {}, onFilter: () {}),

                const SizedBox(height: 30),

                if (isLoading)
                  _buildLoading()
                else if (errorMessage != null)
                  _buildError()
                else if (events.isEmpty)
                  _buildEmpty()
                else ...[
                  _buildCurrentEvents(),

                  const SizedBox(height: 30),

                  _buildQuickAccess(),

                  const SizedBox(height: 30),

                  _buildRecommendations(),

                  const SizedBox(height: 30),

                  _buildActivitySummary(),

                  const SizedBox(height: 30),

                  _buildHistory(),
                ],
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: const NavBar(currentIndex: 1),
    );
  }

  Widget _buildLoading() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 80),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildError() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50),
      child: Column(
        children: [
          const Icon(Icons.error_outline, size: 50, color: Colors.red),

          const SizedBox(height: 12),

          const Text(
            'Gagal memuat event',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),

          const SizedBox(height: 8),

          Text(
            errorMessage ?? '',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),

          const SizedBox(height: 16),

          ElevatedButton(onPressed: loadEvents, child: const Text('Coba Lagi')),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 70),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.event_busy_outlined, size: 60, color: Colors.grey),

            SizedBox(height: 14),

            Text(
              'Belum ada event tersedia',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),

            SizedBox(height: 5),

            Text(
              'Event yang sudah dipublish akan muncul di sini.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentEvents() {
    final activeEvents = _getActiveEvents();

    if (activeEvents.isEmpty) {
      return _buildEmpty();
    }

    return Column(
      children: [
        SizedBox(
          height: 475,

          child: PageView.builder(
            controller: _currentEventController,

            itemCount: activeEvents.length,

            onPageChanged: (index) {
              setState(() {
                currentEventIndex = index;
              });
            },

            itemBuilder: (context, index) {
              final event = activeEvents[index];

              return Padding(
                padding: const EdgeInsets.only(right: 12),

                child: CurrentEventCard(
                  image: _eventImage(event),
                  title: event['title']?.toString() ?? '-',
                  location: _eventLocation(event),
                  date: _formatDate(event['start_date']),
                  joined: _visitorCount(event),

                  onOpenEvent: () {
                    _openEvent(event);
                  },

                  onOpenMap: () {
                    _openBoothMap(event);
                  },
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 12),

        if (activeEvents.length > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(activeEvents.length, (index) {
              final selected = index == currentEventIndex;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),

                margin: const EdgeInsets.symmetric(horizontal: 4),

                width: selected ? 20 : 7,
                height: 7,

                decoration: BoxDecoration(
                  color: selected ? AppColor.primary : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              );
            }),
          ),
      ],
    );
  }

  Widget _buildQuickAccess() {
    return QuickAccessSection(
      items: [
        QuickAccessItem(
          title: 'My Ticket',
          icon: Icons.confirmation_number_outlined,
          onTap: () {},
        ),

        QuickAccessItem(
          title: 'Booth Map',
          icon: Icons.map_outlined,
          onTap: () {
            final activeEvents = _getActiveEvents();

            if (activeEvents.isNotEmpty &&
                currentEventIndex < activeEvents.length) {
              _openBoothMap(activeEvents[currentEventIndex]);
            }
          },
        ),

        QuickAccessItem(
          title: 'Saved Booth',
          icon: Icons.favorite_outline,
          onTap: () {},
        ),

        QuickAccessItem(
          title: 'Schedule',
          icon: Icons.schedule_outlined,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildRecommendations() {
    final recommended = _getRecommendedEvents();

    if (recommended.isEmpty) {
      return const SizedBox.shrink();
    }

    return RecommendedSection(
      events: recommended.map((event) {
        return RecommendedEvent(
          image: _eventImage(event),
          title: event['title']?.toString() ?? '-',
          location: _eventLocation(event),
          date: _formatDate(event['start_date']),
          rating: _getRating(event),
        );
      }).toList(),
    );
  }

  Widget _buildActivitySummary() {
    final activeEvents = _getActiveEvents();

    return ActivitySummary(
      items: [
        ActivityItem(
          title: 'Events',
          value: activeEvents.length.toString(),
          icon: Icons.event_available,
          color: AppColor.primary,
        ),

        ActivityItem(
          title: 'Booths',
          value: approvedBoothCount.toString(),
          icon: Icons.storefront_outlined,
          color: Colors.blue,
        ),

        ActivityItem(
          title: 'Tickets',
          value: '-',
          icon: Icons.confirmation_number_outlined,
          color: Colors.green,
        ),

        ActivityItem(
          title: 'Favorites',
          value: '-',
          icon: Icons.favorite_outline,
          color: Colors.red,
        ),
      ],
    );
  }

  Widget _buildHistory() {
    final history = _getHistoryEvents();

    if (history.isEmpty) {
      return const SizedBox.shrink();
    }

    return HistorySection(
      events: history.map((event) {
        return HistoryEvent(
          image: _eventImage(event),
          title: event['title']?.toString() ?? '-',
          location: _eventLocation(event),
          date: _formatDate(event['start_date']),
          attended: false,
        );
      }).toList(),
    );
  }

void _openEvent(Map<String, dynamic> event) {
  final eventId = event['id']?.toString();

  if (eventId == null || eventId.isEmpty) {
    return;
  }

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => EventScreen(
        eventId: eventId,
      ),
    ),
  );
}
  }

  void _openBoothMap(Map<String, dynamic> event) {
    final eventId = event['id']?.toString();

    if (eventId == null) {
      return;
    }
  }
