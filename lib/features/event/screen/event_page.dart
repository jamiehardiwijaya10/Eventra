import 'package:flutter/material.dart';
import '../widgets/page/event_horizontal_card.dart';
import '../widgets/page/activity_summary.dart';
import '../widgets/page/current_event.dart';
import '../widgets/page/event_header.dart';
import '../widgets/page/search_event.dart';
import '../widgets/page/history_card.dart';
import '../widgets/page/history_section.dart';
import '../widgets/page/quick_access.dart';
import '../widgets/page/recommendation.dart';
import '../../../shared/widgets/navbar_costumer.dart';
import '../../../core/theme/app_color.dart';


class EventPage extends StatelessWidget {
  const EventPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            20,
            20,
            20,
            100,
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const EventHeader(),

              const SizedBox(height: 24),

              EventSearch(
                onChanged: (value) {},
                onFilter: () {},
              ),

              const SizedBox(height: 30),

              CurrentEventCard(
                image: "assets/images/konser.png",
                title: "Fleet Snowfluff Concert",
                location: "Bandung",
                date: "22 October 2026",
                joined: 15782,
                onOpenEvent: () {},
                onOpenMap: () {},
              ),

              const SizedBox(height: 30),

              QuickAccessSection(
                items: [
                  QuickAccessItem(
                    title: "My Ticket",
                    icon: Icons.confirmation_number_outlined,
                    onTap: () {},
                  ),

                  QuickAccessItem(
                    title: "Booth Map",
                    icon: Icons.map_outlined,
                    onTap: () {},
                  ),

                  QuickAccessItem(
                    title: "Saved Booth",
                    icon: Icons.favorite_outline,
                    onTap: () {},
                  ),

                  QuickAccessItem(
                    title: "Schedule",
                    icon: Icons.schedule_outlined,
                    onTap: () {},
                  ),
                ],
              ),

              const SizedBox(height: 30),

              RecommendedSection(
                events: [

                  RecommendedEvent(
                    image: "assets/images/konser.png",
                    title: "Bandung Food Festival",
                    location: "Bandung",
                    date: "27 October 2026",
                    rating: 4.9,
                  ),

                  RecommendedEvent(
                    image: "assets/images/konser.png",
                    title: "Anime Expo",
                    location: "Jakarta",
                    date: "4 November 2026",
                    rating: 4.8,
                  ),

                  RecommendedEvent(
                    image: "assets/images/konser.png",
                    title: "Coffee Festival",
                    location: "Bandung",
                    date: "10 November 2026",
                    rating: 4.7,
                  ),
                ],
              ),

              const SizedBox(height: 30),

              ActivitySummary(
                items: [

                  ActivityItem(
                    title: "Events",
                    value: "12",
                    icon: Icons.event_available,
                    color: AppColor.primary,
                  ),

                  ActivityItem(
                    title: "Booths",
                    value: "34",
                    icon: Icons.storefront_outlined,
                    color: Colors.blue,
                  ),

                  ActivityItem(
                    title: "Tickets",
                    value: "8",
                    icon: Icons.confirmation_number_outlined,
                    color: Colors.green,
                  ),

                  ActivityItem(
                    title: "Favorites",
                    value: "15",
                    icon: Icons.favorite_outline,
                    color: Colors.red,
                  ),
                ],
              ),

              const SizedBox(height: 30),

              HistorySection(
                events: [

                  HistoryEvent(
                    image: "assets/images/konser.png",
                    title: "Fleet Snowfluff Concert",
                    location: "Bandung",
                    date: "22 October 2026",
                    attended: true,
                  ),

                  HistoryEvent(
                    image: "assets/images/konser.png",
                    title: "Bandung Culinary Festival",
                    location: "Bandung",
                    date: "18 September 2026",
                    attended: true,
                  ),

                  HistoryEvent(
                    image: "assets/images/konser.png",
                    title: "Jakarta Music Expo",
                    location: "Jakarta",
                    date: "12 August 2026",
                    attended: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const NavBar(
        currentIndex: 1,
      ),
    );
  }
}