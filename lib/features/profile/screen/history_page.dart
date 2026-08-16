import 'package:flutter/material.dart';
import '../../../core/theme/app_color.dart';
import '../../../core/services/auth_services.dart';
import '../../../core/services/profile_service.dart';
import '../../../core/services/event_service.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final AuthService _authService = AuthService();
  final ProfileService _profileService = ProfileService();
  final EventService _eventService = EventService();
  List<Map<String, dynamic>> _eventHistory = [];
  List<Map<String, dynamic>> _boothHistory = [];

  String? _role;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRole();
  }

  Future<void> _loadRole() async {
    try {
      final role = await _authService.getUserRole();

      if (role == "User") {
        final events =
            await _profileService.getCustomerEventHistory();

        final booths =
            await _profileService.getCustomerBoothHistory();

        _eventHistory = events;
        _boothHistory = booths;
      }

      if (role == "EO") {
        _eventHistory =
            await _profileService.getEoEventHistory();
      }

      if (role == "Booth Owner") {
        final events =
            await _eventService.getBoothOwnerEventHistory();

        _eventHistory = events;
      }

      if (!mounted) return;

      setState(() {
        _role = role;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("HISTORY ERROR: $e");

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    }
  }

  String get _title {
    switch (_role) {
      case "User":
        return "My History";
      case "Booth Owner":
        return "Event History";
      case "EO":
        return "Event History";
      default:
        return "History";
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          _title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: _buildHistoryContent(),
      ),
    );
  }

  Widget _buildHistoryContent() {
    switch (_role) {
      case "User":
        return _buildCustomerHistory();

      case "Booth Owner":
        return _buildBoothHistory();

      case "EO":
        return _buildEoHistory();

      default:
        return const Center(
          child: Text("History tidak tersedia."),
        );
    }
  }

  Widget _buildCustomerHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("Events Attended"),

        const SizedBox(height: 12),

        if (_boothHistory.isEmpty)
          _emptyHistoryCard(
            "Belum ada booth yang dikunjungi.",
          )
        else
          ..._boothHistory.map(
            (item) {
              final booth = item['booths'];
              final event = booth?['events'];

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _historyCard(
                  icon: Icons.storefront_outlined,
                  image: booth?['banner']?.toString(),
                  title: booth?['name']?.toString() ?? '-',
                  subtitle:
                      event?['title']?.toString() ?? '-',
                  venue:
                      event?['venue_name']?.toString(),
                ),
              );
            },
          ),
        const SizedBox(height: 28),

        _sectionTitle("Booths Visited"),

        const SizedBox(height: 12),

        _emptyHistoryCard(
          "Belum ada booth yang dikunjungi.",
        ),
      ],
    );
  }

  Widget _historyCard({
    required IconData icon,
    String? image,
    required String title,
    required String subtitle,
    String? venue,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: image != null && image.isNotEmpty
                ? Image.network(
                    image,
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 70,
                      height: 70,
                      color: AppColor.primary.withOpacity(.1),
                      child: Icon(
                        icon,
                        color: AppColor.primary,
                      ),
                    ),
                  )
                : Container(
                    width: 70,
                    height: 70,
                    color: AppColor.primary.withOpacity(.1),
                    child: Icon(
                      icon,
                      color: AppColor.primary,
                    ),
                  ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBoothHistory() {
    final Map<String, Map<String, dynamic>> groupedEvents = {};

    for (final item in _eventHistory) {
      final event = item['events'];

      if (event == null) continue;

      final eventId = event['id']?.toString();

      if (eventId == null) continue;

      if (!groupedEvents.containsKey(eventId)) {
        groupedEvents[eventId] = {
          'event': event,
          'booths': <String>[],
        };
      }

      final boothName = item['name']?.toString() ?? '-';

      (groupedEvents[eventId]!['booths'] as List<String>)
          .add(boothName);
    }

    final events = groupedEvents.values.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("Events Participated"),

        const SizedBox(height: 12),

        if (events.isEmpty)
          _emptyHistoryCard(
            "Belum ada event yang diikuti.",
          )
        else
          ...events.map((item) {
            final event =
                item['event'] as Map<String, dynamic>;

            final booths =
                item['booths'] as List<String>;

            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _boothEventHistoryCard(
                event: event,
                booths: booths,
              ),
            );
          }),
      ],
    );
  }

  Widget _boothEventHistoryCard({
    required Map<String, dynamic> event,
    required List<String> booths,
  }) {
    final startDate =
        event['start_date']?.toString().split('T').first ?? '-';

    final endDate =
        event['end_date']?.toString().split('T').first ?? '-';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (event['banner'] != null &&
              event['banner'].toString().isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                event['banner'].toString(),
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return Container(
                    height: 150,
                    color: Colors.grey.shade100,
                    child: const Icon(
                      Icons.event,
                      size: 50,
                    ),
                  );
                },
              ),
            ),

          const SizedBox(height: 14),

          Text(
            event['title']?.toString() ?? '-',
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            "$startDate - $endDate",
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),

          if (event['venue_name'] != null) ...[
            const SizedBox(height: 4),
            Text(
              event['venue_name'].toString(),
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
          ],

          const SizedBox(height: 14),

          const Text(
            "Booths",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 8),

          ...booths.map(
            (booth) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Icon(
                    Icons.storefront_outlined,
                    size: 18,
                    color: AppColor.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      booth,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEoHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("Events Created"),

        const SizedBox(height: 12),

        if (_eventHistory.isEmpty)
          _emptyHistoryCard(
            "Belum ada event yang dibuat.",
          )
        else
          ..._eventHistory.map(
            (event) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _historyCard(
                icon: Icons.event_outlined,
                image: event['banner']?.toString(),
                title: event['title']?.toString() ?? '-',
                subtitle:
                    "${event['start_date']?.toString().split('T').first ?? '-'} - "
                    "${event['end_date']?.toString().split('T').first ?? '-'}",
              ),
            ),
          ),
      ],
    );
}

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _emptyHistoryCard(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.history_rounded,
            size: 42,
            color: Colors.grey.shade400,
          ),

          const SizedBox(height: 12),

          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}