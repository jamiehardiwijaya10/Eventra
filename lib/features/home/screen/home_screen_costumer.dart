import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_color.dart';
import '../../../shared/widgets/navbar_costumer.dart';
import '../../../shared/widgets/category.dart';
import '../widgets/event_card.dart';
import '../widgets/event_card2.dart';
import '../../../core/services/event_service.dart';
import 'package:intl/intl.dart';

class HomeScreenCostumer extends StatefulWidget {
  const HomeScreenCostumer({super.key});

  @override
  State<HomeScreenCostumer> createState() => _HomeScreenCostumerState();
}

class _HomeScreenCostumerState extends State<HomeScreenCostumer> {
  int selectedCategory = 0;

  String _formatDate(String? date) {
    if (date == null || date.isEmpty) {
      return '-';
    }

    try {
      final parsedDate = DateTime.parse(date);
      return DateFormat('dd MMMM yyyy').format(parsedDate);
    } catch (e) {
      return date;
    }
  }

  // String _formatDateRange(dynamic startValue, dynamic endValue) {
  //   if (startValue == null || startValue.toString().isEmpty) {
  //     return '';
  //   }

  //   final start = DateTime.tryParse(startValue.toString());

  //   if (start == null) {
  //     return startValue.toString();
  //   }

  //   final end = endValue != null && endValue.toString().isNotEmpty
  //       ? DateTime.tryParse(endValue.toString())
  //       : null;

  //   const months = [
  //     'January',
  //     'February',
  //     'March',
  //     'April',
  //     'May',
  //     'June',
  //     'July',
  //     'August',
  //     'September',
  //     'October',
  //     'November',
  //     'December',
  //   ];

  //   final startText = '${start.day} ${months[start.month - 1]} ${start.year}';

  //   if (end == null) {
  //     return startText;
  //   }

  //   final endText = '${end.day} ${months[end.month - 1]} ${end.year}';

  //   if (start.year == end.year &&
  //       start.month == end.month &&
  //       start.day == end.day) {
  //     return startText;
  //   }

  //   return '$startText - $endText';
  // }

  final EventService _eventService = EventService();
  List<Map<String, dynamic>> _events = [];
  bool _isLoadingEvents = true;
  String? _eventError;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    try {
      final events = await _eventService.getEvents();

      if (!mounted) return;

      setState(() {
        _events = events;
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
                      ],
                    ),

                    const SizedBox(height: 30),

                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search events...",
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.tune),
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Popular Events 🔥",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          const SizedBox(width: 100),

                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              "VIEW ALL",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 380,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        clipBehavior: Clip.none,
                        children: [
                          const SizedBox(width: 10),

                          if (_isLoadingEvents)
                            const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          else if (_eventError != null)
                            Text(
                              "Gagal memuat event",
                              style: GoogleFonts.poppins(color: Colors.white),
                            )
                          else if (_events.isEmpty)
                            Text(
                              "Belum ada event",
                              style: GoogleFonts.poppins(color: Colors.white),
                            )
                          else
                            ..._events.take(5).map((event) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child: FeaturedEventCard(
                                  eventId: event['id'].toString(),
                                  image: event['banner']?.toString() ?? '',
                                  title:
                                      event['title']?.toString() ??
                                      'Untitled Event',
                                  startDate: _formatDate(
                                    event['start_date']?.toString(),
                                  ),
                                  endDate: _formatDate(
                                    event['end_date']?.toString(),
                                  ),
                                  location: event['location']?.toString() ?? '',
                                ),
                              );
                            }),

                          SizedBox(width: 20),
                        ],
                      ),
                    ),

                    const SizedBox(height: 15),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Choose by Category ✨",
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

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      clipBehavior: Clip.none,
                      child: Row(
                        children: [
                          CategoryChip(
                            icon: Icons.palette,
                            title: "Design",
                            selected: selectedCategory == 0,
                            onTap: () {
                              setState(() {
                                selectedCategory = 0;
                              });
                            },
                          ),

                          const SizedBox(width: 12),

                          CategoryChip(
                            icon: Icons.restaurant,
                            title: "Food",
                            selected: selectedCategory == 1,
                            onTap: () {
                              setState(() {
                                selectedCategory = 1;
                              });
                            },
                          ),

                          const SizedBox(width: 12),

                          CategoryChip(
                            icon: Icons.sports_soccer,
                            title: "Sport",
                            selected: selectedCategory == 2,
                            onTap: () {
                              setState(() {
                                selectedCategory = 2;
                              });
                            },
                          ),

                          const SizedBox(width: 12),

                          CategoryChip(
                            icon: Icons.music_note,
                            title: "Music",
                            selected: selectedCategory == 3,
                            onTap: () {
                              setState(() {
                                selectedCategory = 3;
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    if (_isLoadingEvents)
                      const Center(child: CircularProgressIndicator())
                    else if (_events.isEmpty)
                      const Text("Belum ada event")
                    else
                      ..._events.map((event) {
                        return EventListCard(
                          eventId: event['id'].toString(),
                          image: event['banner']?.toString() ?? '',
                          title: event['title']?.toString() ?? 'Untitled Event',
                          startDate: _formatDate(
                            event['start_date']?.toString(),
                          ),
                          endDate: _formatDate(event['end_date']?.toString()),
                          location: event['location']?.toString() ?? '',
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
