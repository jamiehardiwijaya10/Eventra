import 'package:eventra/features/maps/screen/event_location_map_screen.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../../../app/routes.dart';
import 'package:eventra/features/event/widgets/detail/attendees_section.dart';
import 'package:eventra/features/event/widgets/detail/bottom_action.dart';
import 'package:eventra/features/event/widgets/detail/description.dart';
import 'package:eventra/features/event/widgets/detail/event_detail.dart';
import 'package:eventra/features/event/widgets/detail/event_header.dart';
import 'package:eventra/features/event/widgets/detail/event_title_card.dart';
import 'package:eventra/features/event/widgets/detail/organizer_card.dart';
import 'package:eventra/features/event/widgets/detail/event_top_bar.dart';
import '../../../core/services/event_service.dart';
import 'package:intl/intl.dart';
import 'package:eventra/features/ticket/screen/ticket_screen.dart';

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
  List<Map<String, dynamic>> _announcements = [];
  bool _isAnnouncementLoading = true;

  num _ticketPrice = 0;
  int _joined = 0;
  int _ticketsLeft = 0;

  String _organizerName = '-';
  String _organizerImage = '';

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
    _loadAnnouncements();
  }

  Future<void> _loadAnnouncements() async {
    try {
      final data = await _eventService.getEventAnnouncements(
        widget.eventId,
      );

      if (!mounted) return;

      setState(() {
        _announcements = data;
        _isAnnouncementLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isAnnouncementLoading = false;
      });
    }
  }

  Future<void> _loadEvent() async {
    try {
      final event = await _eventService.getEventById(
        widget.eventId,
      );

      final stats = await _eventService.getEventCustomerStats(
        widget.eventId,
      );

      if (!mounted) return;

      setState(() {
        _event = event;

        _ticketPrice =
            (stats['price'] as num?) ?? 0;

        _joined =
            (stats['joined'] as num?)?.toInt() ?? 0;

        _ticketsLeft =
            (stats['ticketsLeft'] as num?)?.toInt() ?? 0;

        final organizer = event['profiles'];

        if (organizer is Map<String, dynamic>) {
          final firstName =
              organizer['first_name']?.toString() ?? '';

          final lastName =
              organizer['last_name']?.toString() ?? '';

          _organizerName =
              '$firstName $lastName'.trim();

          _organizerImage =
              organizer['avatar_url']?.toString() ?? '';
        }

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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TicketScreen(
                eventId: widget.eventId,
                eventName: _event!['title']?.toString() ?? 'Event',
              ),
            ),
          );
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

                      price: 'Rp${_ticketPrice.round()}',

                      joined: _joined,

                      rating: 4.8,

                      ticketsLeft: _ticketsLeft,

                      latitude:
                          (_event!['latitude'] as num?)?.toDouble() ?? 0,

                      longitude:
                          (_event!['longitude'] as num?)?.toDouble() ?? 0,
                    ),

                    const SizedBox(height: 25),
                    if (_isAnnouncementLoading)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else if (_announcements.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Announcements",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 15),

                          ..._announcements.map(
                            (announcement) {
                              return Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(.08),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      announcement['title']?.toString() ?? '-',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 8),

                                    Text(
                                      announcement['message']?.toString() ?? '-',
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 10),
                        ],
                      ),

                    AttendeesSection(
                      totalMembers: _joined,
                      avatarImages: const [],
                      onViewAll: () {},
                    ),

                    const SizedBox(height: 25),

                    OrganizerCard(
                      image: _organizerImage,
                      name: _organizerName,
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
                            final latitude = (_event!['latitude'] as num).toDouble();
                            final longitude = (_event!['longitude'] as num).toDouble();

                            Navigator.push(context, MaterialPageRoute(
                              builder: (_) => EventLocationMapScreen(
                                eventName: _event!['title']?.toString() ?? 'Event',
                                eventLocation : _event!['location']?.toString() ?? '-',
                                eventLatLng: LatLng(
                                  (latitude as num).toDouble(),
                                  (longitude as num).toDouble(),
                                ),
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
                          icon: Icons.confirmation_number_outlined,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TicketScreen(
                                  eventId: widget.eventId,
                                  eventName: _event!['title']?.toString() ?? 'Event',
                                ),
                              ),
                            );
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
