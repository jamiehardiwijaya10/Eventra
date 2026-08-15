import 'package:flutter/material.dart';
import '../widgets/statistics/statistics_header.dart';
import '../widgets/statistics/statistics_summary_card.dart';
import '../widgets/statistics/visitor_trend_card.dart';
import '../widgets/statistics/event_performance_card.dart';
import '../widgets/statistics/booth_performance_card.dart';
import '../widgets/statistics/event_status_card.dart';
import '../widgets/statistics/event_insight_card.dart';
import '../../../shared/widgets/navbar_eo.dart';
import '../../../core/services/event_service.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({
    super.key,
  });

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  final EventService _eventService = EventService();
  List<Map<String, dynamic>> events = [];
  String? selectedEventId;
  Map<String, int> statistics = {};
  List<Map<String, dynamic>> eventBooths = [];
  bool isLoadingEvents = true;
  bool isLoadingStatistics = false;
  bool isLoadingBooths = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    try {
      final data = await _eventService.getMyEvents();

      if (!mounted) return;

      setState(() {
        events = data;
        isLoadingEvents = false;
        errorMessage = null;
      });

      if (events.isNotEmpty) {
        selectedEventId = events.first['id'].toString();

        await _loadStatistics(selectedEventId!);
        await _loadBooths(selectedEventId!);
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoadingEvents = false;
        errorMessage = e.toString();
      });
    }
  }

  Future<void> _loadStatistics(String eventId) async {
    setState(() {
      isLoadingStatistics = true;
    });

    try {
      final data = await _eventService.getEventStatistics(eventId);

      if (!mounted) return;

      setState(() {
        statistics = data;
        isLoadingStatistics = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoadingStatistics = false;
        errorMessage = e.toString();
      });
    }
  }

  Map<String, dynamic>? get _selectedEvent {
    if (selectedEventId == null) return null;

    try {
      return events.firstWhere(
        (event) => event['id'].toString() == selectedEventId,
      );
    } catch (_) {
      return null;
    }
  }

  String get _eventDuration {
    final event = _selectedEvent;

    if (event == null) return "-";

    final start = DateTime.tryParse(
      event['start_date']?.toString() ?? '',
    );

    final end = DateTime.tryParse(
      event['end_date']?.toString() ?? '',
    );

    if (start == null || end == null) {
      return "-";
    }

    final duration = end.difference(start).inDays + 1;

    return "$duration ${duration == 1 ? 'Day' : 'Days'}";
  }

  String get _eventDateRange {
    final event = _selectedEvent;

    if (event == null) return "-";

    final start = DateTime.tryParse(
      event['start_date']?.toString() ?? '',
    );

    final end = DateTime.tryParse(
      event['end_date']?.toString() ?? '',
    );

    if (start == null || end == null) {
      return "-";
    }

    return "${start.day.toString().padLeft(2, '0')} - "
        "${end.day.toString().padLeft(2, '0')} "
        "${_monthName(end.month)} ${end.year}";
  }

  Future<void> _loadBooths(String eventId) async {
    setState(() {
      isLoadingBooths = true;
    });

    try {
      final data = await _eventService.getEventBooths(eventId);

      if (!mounted) return;

      setState(() {
        eventBooths = data;
        isLoadingBooths = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoadingBooths = false;
        errorMessage = e.toString();
      });
    }
  }

  int get _upcomingEventCount {
  final now = DateTime.now();

  return events.where((event) {
    final start = DateTime.tryParse(
      event['start_date']?.toString() ?? '',
    );

    if (start == null) return false;

    return start.isAfter(now);
  }).length;
}

int get _ongoingEventCount {
  final now = DateTime.now();

  return events.where((event) {
    final start = DateTime.tryParse(
      event['start_date']?.toString() ?? '',
    );

    final end = DateTime.tryParse(
      event['end_date']?.toString() ?? '',
    );

    if (start == null || end == null) return false;

    return !now.isBefore(start) && !now.isAfter(end);
  }).length;
}

  int get _finishedEventCount {
    final now = DateTime.now();

    return events.where((event) {
      final end = DateTime.tryParse(
        event['end_date']?.toString() ?? '',
      );

      if (end == null) return false;

      return now.isAfter(end);
    }).length;
  }

  String _monthName(int month) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];

    return months[month - 1];
  }

  List<EventPerformanceData> get _eventPerformanceData {
    if (events.isEmpty) {
      return [];
    }

    final visitorCounts = events.map((event) {
      return int.tryParse(
            event['visitor_count']?.toString() ?? '0',
          ) ??
          0;
    }).toList();

    final maxVisitors = visitorCounts.isEmpty
        ? 0
        : visitorCounts.reduce(
            (a, b) => a > b ? a : b,
          );

    return events.map((event) {
      final visitors =
          int.tryParse(
                event['visitor_count']?.toString() ?? '0',
              ) ??
              0;

      final progress = maxVisitors == 0
          ? 0.0
          : visitors / maxVisitors;

      return EventPerformanceData(
        eventName:
            event['title']?.toString() ?? 'Untitled Event',
        visitors: visitors,
        progress: progress,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Statistics",
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StatisticsHeader(
                selectedEventId: selectedEventId,
                events: events,
                onEventChanged: (value) {
                  if (value == null) return;

                  setState(() {
                    selectedEventId = value;
                  });

                  _loadStatistics(value);
                  _loadBooths(value);
                },
              ),

              const SizedBox(height: 24),

              StatisticsSummaryCard(
                title: "Total Visitors",
                value: isLoadingStatistics
                    ? "-"
                    : (statistics['visitorCount'] ?? 0).toString(),
                icon: Icons.people_outline,
                subtitle: "Visitors during event",
              ),

              const SizedBox(height: 14),

              StatisticsSummaryCard(
                title: "Total Booths",
                value: isLoadingStatistics
                    ? "-"
                    : (statistics['totalBooth'] ?? 0).toString(),
                icon: Icons.storefront_outlined,
                subtitle: "Registered booths",
              ),

              const SizedBox(height: 14),

              StatisticsSummaryCard(
                title: "Average Rating",
                value: "4.7",
                icon: Icons.star_outline,
                subtitle: "Based on visitor reviews",
              ),

              const SizedBox(height: 14),

              StatisticsSummaryCard(
                title: "Event Duration",
                value: _eventDuration,
                icon: Icons.calendar_today_outlined,
                subtitle: _eventDateRange,
              ),

              const SizedBox(height: 28),

              VisitorTrendCard(
                data: const [
                  VisitorData(
                    label: "10 AM",
                    visitors: 120,
                  ),
                  VisitorData(
                    label: "12 PM",
                    visitors: 280,
                  ),
                  VisitorData(
                    label: "2 PM",
                    visitors: 450,
                  ),
                  VisitorData(
                    label: "4 PM",
                    visitors: 380,
                  ),
                  VisitorData(
                    label: "6 PM",
                    visitors: 520,
                  ),
                  VisitorData(
                    label: "8 PM",
                    visitors: 430,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              EventPerformanceCard(
                events: _eventPerformanceData,
              ),

              const SizedBox(height: 20),

              if (isLoadingBooths)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  ),
                )
              else
                BoothPerformanceCard(
                  booths: eventBooths.map((booth) {
                    return BoothPerformanceData(
                      boothName: booth['name']?.toString() ?? '-',
                      category: booth['category']?.toString() ?? '-',
                      activityCount:
                          int.tryParse(
                            booth['activity_count']?.toString() ?? '0',
                          ) ??
                          0,
                    );
                  }).toList(),
                ),

              const SizedBox(height: 20),

              EventStatusCard(
                upcoming: _upcomingEventCount,
                ongoing: _ongoingEventCount,
                finished: _finishedEventCount,
              ),

              const SizedBox(height: 20),

              const EventInsightCard(
                title: "Event Insight",
                message:
                "UMKM Fair 2026 recorded the highest visitor activity among your events. Consider using a similar booth arrangement and event concept for future events.",
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const NavBar(
        currentIndex: 2,
      ),
    );
  }
}