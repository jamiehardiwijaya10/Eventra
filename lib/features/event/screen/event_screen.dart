import 'package:eventra/features/maps/screen/event_location_map_screen.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../widgets/attendees_section.dart';
import '../widgets/bottom_action.dart';
import '../widgets/description.dart';
import '../widgets/event_detail.dart';
import '../widgets/event_header.dart';
import '../widgets/event_title_card.dart';
import '../widgets/event_top_bar.dart';
import '../widgets/organizer_card.dart';
import '../../../app/routes.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  bool bookmarked = false;

  @override
  Widget build(BuildContext context) {
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

          const Positioned.fill(
            child: EventHeaderImage(
              image: "assets/images/konser.png",
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
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(35),
                  ),
                ),

                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(
                    24,
                    12,
                    24,
                    20,
                  ),

                  children: [

                    Center(
                      child: Container(
                        width: 45,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius:
                          BorderRadius.circular(50),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    const EventTitleCard(
                      title: "Fleet Snowfluff's Concert",
                      location: "Bandung",
                      date: "22 October 2026",
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
                      image:
                      "assets/images/Remielle Dan.jpg",
                      name: "Remielle",
                      role: "Event Organizer",
                      onChat: () {},
                      onCall: () {},
                    ),

                    const SizedBox(height:25),

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

                    const DescriptionSection(
                      description:
                      "Fleet Snowfluff's Concert merupakan salah satu festival musik terbesar yang menghadirkan berbagai artis terkenal, area kuliner, booth UMKM, merchandise resmi, dan berbagai aktivitas menarik lainnya.",
                    ),

                  ],
                ),
              );
            },
          ),
          EventTopBar(
            onBack: () => Navigator.pop(context),
            onFavorite: () {},
          ),
        ],
      ),
    );
  }
}