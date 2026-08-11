import 'package:eventra/features/maps/screen/event_location_map_screen.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../../../app/routes.dart';
import '../widgets/attendees_section.dart';
import '../widgets/bottom_action.dart';
import '../widgets/description.dart';
import '../widgets/event_detail.dart';
import '../widgets/event_header.dart';
import '../widgets/event_title_card.dart';
import '../widgets/event_top_bar.dart';
import '../widgets/organizer_card.dart';
import '../../../core/services/event_service.dart';
import 'package:intl/intl.dart';

class EventScreen extends StatefulWidget {
  final String eventId;

  const EventScreen({
    super.key,
    required this.eventId,
  });

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  bool bookmarked = false;

  final EventService _eventService = EventService();

  Map<String, dynamic>? _event;
  bool _isLoading = true;
  String? _error;

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

  @override
  void initState() {
    super.initState();
    _loadEvent();
  }

  Future<void> _loadEvent() async {
    try {
      final event = await _eventService.getEventById(
        widget.eventId,
      );

      if (!mounted) return;

      setState(() {
        _event = event;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
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

    if (_error != null || _event == null) {
      return Scaffold(
        body: Center(
          child: Text(
            _error ?? "Event tidak ditemukan",
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.75),

      bottomNavigationBar: EventActionBar(
        bookmarked: bookmarked,
        buttonText: "BUY TICKET",
        onBookmark: () {
          setState(() {
            bookmarked = !bookmarked;
          });
        },
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.ticket);
        },
      ),

      body: Stack(
        children: [
          Positioned.fill(
            child: EventHeaderImage(
              image: _event!['banner']?.toString() ?? '',
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.65,
            minChildSize: 0.65,
            maxChildSize: 0.93,

            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
                ),

                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),

                  children: [
                    Center(
                      child: Container(
                        width: 45,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    EventTitleCard(
                      title: _event!['title']?.toString() ?? 'Untitled Event',

                      location: _event!['location']?.toString() ?? '-',

                      date: _formatDate(
                        _event!['start_date']?.toString(),
                      ),

                      endDate: _formatDate(
                        _event!['end_date']?.toString(),
                      ),

                      price: "\$10 USD",
                      joined: 15782,
                      rating: 4.8,
                      ticketsLeft: 120,
                      longitude: 107.72537176669891, 
                      latitude: -6.940041591250152,
                    ),
                    const SizedBox(height: 25),

                    AttendeesSection(
                      totalMembers: 15782,
                      avatarImages: const [
                        "assets/images/Remielle Dan.jpg",
                        "assets/images/Remielle Dan.jpg",
                        "assets/images/Remielle Dan.jpg",
                        "assets/images/Remielle Dan.jpg",
                        "assets/images/Remielle Dan.jpg",
                      ],
                      onViewAll: () {},
                    ),

                    const SizedBox(height: 25),

                    OrganizerCard(
                      image: "assets/images/Remielle Dan.jpg",
                      name: "Remielle",
                      role: "Event Organizer",
                      onChat: () {},
                      onCall: () {},
                    ),

                    const SizedBox(height: 25),

                    EventMenuSection(
                      menus: [
                        EventMenu(
                          title: "Location",
                          icon: Icons.location_on_outlined,
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (_) => const EventLocationMapScreen(
                                eventName: "Fleet Snowfluff's Concert",
                                eventLocation : "Bandung, Jawa Barat",
                                eventLatLng: LatLng(-6.940041591250152, 107.72537176669891),
                              ),
                            ));
                          },
                        ),

                        EventMenu(
                          title: "Booth Map",
                          icon: Icons.map_outlined,
                          onTap: () {},
                        ),

                        EventMenu(
                          title: "Booths",
                          icon: Icons.store_outlined,
                          onTap: () {},
                        ),

                        EventMenu(
                          title: "Rundown",
                          icon: Icons.schedule_outlined,
                          onTap: () {},
                        ),

                        EventMenu(
                          title: "Tickets",
                          icon:
                          Icons.confirmation_number_outlined,
                          onTap: () {
                            Navigator.pushNamed(context, AppRoutes.ticket);
                          },
                        ),

                        EventMenu(
                          title: "More",
                          icon: Icons.info_outline,
                          onTap: () {},
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    DescriptionSection(
                      description:
                          _event!['description']?.toString() ??
                          'Tidak ada deskripsi event.',
                    ),
                  ],
                ),
              );
            },
          ),
          EventTopBar(onBack: () => Navigator.pop(context), onFavorite: () {}),
        ],
      ),
    );
  }
}
