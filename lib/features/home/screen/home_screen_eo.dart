import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_color.dart';
import '../../../shared/widgets/navbar_eo.dart';
import '../widgets/event_card_eo.dart';
import '../../../core/services/event_service.dart';
import '../../event/screen/create_event_page.dart';

class HomeScreenEo extends StatefulWidget {
  const HomeScreenEo({super.key});

  @override
  State<HomeScreenEo> createState() => _HomeScreenEoState();
}

class _HomeScreenEoState extends State<HomeScreenEo> {
  int selectedCategory = 0;
  final EventService _eventService = EventService();

  List<Map<String, dynamic>> _myEvents = [];
  bool _isLoadingEvents = true;
  String? _eventError;

    List<Map<String, dynamic>> get _currentEvents {
    final now = DateTime.now();

    return _myEvents.where((event) {
      final start = DateTime.tryParse(
        event['start_date']?.toString() ?? '',
      );

      final end = DateTime.tryParse(
        event['end_date']?.toString() ?? '',
      );

      if (start == null || end == null) {
        return false;
      }

      return !now.isBefore(start) && !now.isAfter(end);
    }).toList();
  }

  List<Map<String, dynamic>> get _upcomingEvents {
    final now = DateTime.now();

    return _myEvents.where((event) {
      final start = DateTime.tryParse(
        event['start_date']?.toString() ?? '',
      );

      if (start == null) {
        return false;
      }

      return start.isAfter(now);
    }).toList();
  }

  String _formatDate(String? date) {
    if (date == null || date.isEmpty) {
      return '-';
    }

    try {
      final parsedDate = DateTime.parse(date);
      return DateFormat('dd MMM yyyy').format(parsedDate);
    } catch (e) {
      return date;
    }
  }

  @override
  void initState() {
    super.initState();
    _loadMyEvents();
  }

  Future<void> _loadMyEvents() async {
    try {
      final events = await _eventService.getMyEvents();

      if (!mounted) return;

      setState(() {
        _myEvents = events;
        _isLoadingEvents = false;
        _eventError = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoadingEvents = false;
        _eventError = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Positioned.fill(
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [AppColor.primary, AppColor.secondary],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(color: Colors.white.withOpacity(0.98)),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 22,
                              backgroundImage: AssetImage(
                                "assets/images/Remielle Dan.jpg",
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "Hi! Welcome\nRemielle",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                        Text(
                          "Current Location\nBandung, IDN",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.event_available,
                                    color: Colors.green,
                                    size: 22,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                Text(
                                  "Current Event",
                                  style: GoogleFonts.poppins(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                ),

                                const SizedBox(height: 6),

                                Text(
                                  "1",
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.upcoming,
                                    color: Colors.orange,
                                    size: 22,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                Text(
                                  "Upcoming Event",
                                  style: GoogleFonts.poppins(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                ),

                                const SizedBox(height: 6),

                                Text(
                                  "3",
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    Container(
                      height: 300,
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              "assets/images/Add Event Pic.png",
                              height: 210,
                              fit: BoxFit.cover,
                            ),
                          ),

                          const SizedBox(height: 12),

                          SizedBox(
                            width: double.infinity,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const CreateEventPage(),
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: AppColor.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: const StadiumBorder(),
                              ),
                              child: const Text(
                                "Add Event",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 15),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Current Event",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            "VIEW ALL",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    if (_isLoadingEvents)
                      const Center(child: CircularProgressIndicator())
                    else if (_eventError != null)
                      Text("Gagal memuat event: $_eventError")
                    else if (_currentEvents.isEmpty)
                      const Text("Tidak ada current event")
                    else
                      ..._currentEvents.map((event) {
                        return EventListCard(
                          eventId: event['id'].toString(),
                          image: event['banner']?.toString() ?? '',
                          title: event['title']?.toString() ?? 'Untitled Event',
                          startDate: _formatDate(
                            event['start_date']?.toString(),
                          ),
                          endDate: _formatDate(event['end_date']?.toString()),
                          location: event['location']?.toString() ?? '-',
                        );
                      }),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Upcoming Event",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            "VIEW ALL",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    if (_isLoadingEvents)
                      const Center(child: CircularProgressIndicator())
                    else if (_eventError != null)
                      Text("Gagal memuat event: $_eventError")
                    else if (_upcomingEvents.isEmpty)
                      const Text("Tidak ada upcoming event")
                    else
                      ..._upcomingEvents.map((event) {
                        return EventListCard(
                          eventId: event['id'].toString(),
                          image: event['banner']?.toString() ?? '',
                          title: event['title']?.toString() ?? 'Untitled Event',
                          startDate: _formatDate(
                            event['start_date']?.toString(),
                          ),
                          endDate: _formatDate(event['end_date']?.toString()),
                          location: event['location']?.toString() ?? '-',
                        );
                      }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const NavBar(currentIndex: 0),
    );
  }
}
