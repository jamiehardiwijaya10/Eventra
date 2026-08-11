import 'package:flutter/material.dart';
import '../widgets/statistics/statistics_header.dart';
import '../widgets/statistics/statistics_summary_card.dart';
import '../widgets/statistics/visitor_trend_card.dart';
import '../widgets/statistics/event_performance_card.dart';
import '../widgets/statistics/booth_performance_card.dart';
import '../widgets/statistics/event_status_card.dart';
import '../widgets/statistics/event_insight_card.dart';
import '../../../shared/widgets/navbar_eo.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({
    super.key,
  });

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  String selectedEvent = "Food Festival Bandung";

  final List<String> events = [
    "Food Festival Bandung",
    "Bandung Coffee Expo",
    "UMKM Fair 2026",
  ];

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
                selectedEvent: selectedEvent,
                events: events,
                onEventChanged: (value) {
                  if (value == null) return;

                  setState(() {
                    selectedEvent = value;
                  });
                },
              ),

              const SizedBox(height: 24),

              StatisticsSummaryCard(
                title: "Total Visitors",
                value: "1,250",
                icon: Icons.people_outline,
                subtitle: "Visitors during event",
              ),

              const SizedBox(height: 14),

              StatisticsSummaryCard(
                title: "Total Booths",
                value: "120",
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
                value: "3 Days",
                icon: Icons.calendar_today_outlined,
                subtitle: "12 - 14 August 2026",
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
                events: const [
                  EventPerformanceData(
                    eventName: "Food Festival Bandung",
                    visitors: 1250,
                    progress: 0.85,
                  ),
                  EventPerformanceData(
                    eventName: "Bandung Coffee Expo",
                    visitors: 850,
                    progress: 0.58,
                  ),
                  EventPerformanceData(
                    eventName: "UMKM Fair 2026",
                    visitors: 4320,
                    progress: 1.0,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              BoothPerformanceCard(
                booths: const [
                  BoothPerformanceData(
                    boothName: "Kopi Nusantara",
                    category: "Beverage",
                    activityCount: 485,
                  ),
                  BoothPerformanceData(
                    boothName: "Seblak Bandung",
                    category: "Food",
                    activityCount: 420,
                  ),
                  BoothPerformanceData(
                    boothName: "Crafty Corner",
                    category: "Craft",
                    activityCount: 315,
                  ),
                  BoothPerformanceData(
                    boothName: "Bandung Apparel",
                    category: "Fashion",
                    activityCount: 280,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              const EventStatusCard(
                upcoming: 3,
                ongoing: 1,
                finished: 5,
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