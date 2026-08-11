import 'package:flutter/material.dart';
import '../../../core/services/event_service.dart';

class StatisticsPage extends StatefulWidget {
  final String eventId;

  const StatisticsPage({
    super.key,
    required this.eventId,
  });

  @override
  State<StatisticsPage> createState() =>
      _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  final EventService _eventService = EventService();

  Map<String, int>? statistics;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadStatistics();
  }

  Future<void> loadStatistics() async {
    try {
      final data =
          await _eventService.getEventStatistics(
        widget.eventId,
      );

      if (!mounted) return;

      setState(() {
        statistics = data;
        isLoading = false;
      });
    } catch (e) {
      debugPrint(
        'GET EVENT STATISTICS ERROR: $e',
      );

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
        title: const Text("Statistics"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : errorMessage != null
              ? Center(
                  child: Text(
                    "Gagal mengambil statistik:\n$errorMessage",
                    textAlign: TextAlign.center,
                  ),
                )
              : statistics == null
                  ? const Center(
                      child: Text(
                        "Data statistik tidak ditemukan.",
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: loadStatistics,
                      child: ListView(
                        padding: const EdgeInsets.all(20),
                        children: [
                          _buildStatCard(
                            "Total Booth",
                            statistics!['totalBooth']!,
                            Icons.storefront_outlined,
                          ),
                          _buildStatCard(
                            "Approved Booth",
                            statistics!['approvedBooth']!,
                            Icons.check_circle_outline,
                          ),
                          _buildStatCard(
                            "Pending Booth",
                            statistics!['pendingBooth']!,
                            Icons.pending_outlined,
                          ),
                          _buildStatCard(
                            "Rejected Booth",
                            statistics!['rejectedBooth']!,
                            Icons.cancel_outlined,
                          ),
                          _buildStatCard(
                            "Total Visitors",
                            statistics!['visitorCount']!,
                            Icons.people_outline,
                          ),
                        ],
                      ),
                    ),
    );
  }

  Widget _buildStatCard(
    String title,
    int value,
    IconData icon,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        leading: Icon(
          icon,
          size: 32,
        ),
        title: Text(title),
        trailing: Text(
          value.toString(),
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}