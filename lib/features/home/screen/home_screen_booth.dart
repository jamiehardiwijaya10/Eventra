import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_color.dart';
import '../../../shared/widgets/navbar_booth.dart';
import '../../../shared/widgets/category.dart';
import '../widgets/event_card.dart';
import '../widgets/event_card2.dart';
import 'package:eventra/features/booth/screen/register_event_page.dart';
import '../../../core/services/event_service.dart';
import '../../../core/services/profile_service.dart';
import '../../booth/widgets/event_card/features_event_card.dart';
import '../../booth/widgets/event_card/event_list_card.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../app/routes.dart';

class HomeScreenBooth extends StatefulWidget {
  const HomeScreenBooth({super.key});

  @override
  State<HomeScreenBooth> createState() => _HomeScreenBoothState();
}

class _HomeScreenBoothState extends State<HomeScreenBooth> {
  String? selectedCategoryId;
  List<Map<String, dynamic>> _categories = [];
  bool _isLoadingCategories = true;
  final ProfileService _profileService = ProfileService();
  Map<String, dynamic>? _profile;

  IconData _categoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'design':
        return Icons.palette;

      case 'food':
        return Icons.restaurant;

      case 'sport':
        return Icons.sports_soccer;

      case 'music':
        return Icons.music_note;

      case 'festival':
        return Icons.celebration;

      case 'market':
        return Icons.storefront;

      case 'expo':
        return Icons.business;

      default:
        return Icons.category;
    }
  }

  String _formatDateRange(dynamic startValue, dynamic endValue) {
    if (startValue == null || startValue.toString().isEmpty) {
      return '';
    }

    final start = DateTime.tryParse(startValue.toString());

    if (start == null) {
      return startValue.toString();
    }

    final end = endValue != null && endValue.toString().isNotEmpty
        ? DateTime.tryParse(endValue.toString())
        : null;

    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    final startText = '${start.day} ${months[start.month - 1]} ${start.year}';

    if (end == null) {
      return startText;
    }

    final endText = '${end.day} ${months[end.month - 1]} ${end.year}';

    if (start.year == end.year &&
        start.month == end.month &&
        start.day == end.day) {
      return startText;
    }

    return '$startText - $endText';
  }

  final EventService _eventService = EventService();
  List<Map<String, dynamic>> _events = [];
  bool _isLoadingEvents = true;
  String? _eventError;

  @override
  void initState() {
    super.initState();
    _loadEvents();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final response = await Supabase.instance.client
          .from('categories')
          .select('id, name')
          .order('name');

      if (!mounted) return;

      setState(() {
        _categories = List<Map<String, dynamic>>.from(response);
        _isLoadingCategories = false;
      });
    } catch (e) {
      debugPrint("CATEGORY ERROR: $e");

      if (!mounted) return;

      setState(() {
        _isLoadingCategories = false;
      });
    }
  }

  List<Map<String, dynamic>> get _filteredEvents {
    if (selectedCategoryId == null) {
      return _events;
    }

    return _events.where((event) {
      return event['category_id']?.toString() == selectedCategoryId;
    }).toList();
  }

  Future<void> _loadProfile() async {
    try {
      final profile = await _profileService.getProfile();

      if (!mounted) return;

      setState(() {
        _profile = profile;
      });
    } catch (e) {
      debugPrint("HOME PROFILE ERROR: $e");
    }
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
                            CircleAvatar(
                              radius: 22,
                              backgroundImage:
                                  _profile?['avatar_url'] != null &&
                                      _profile!['avatar_url']
                                          .toString()
                                          .isNotEmpty
                                  ? NetworkImage(
                                      _profile!['avatar_url'].toString(),
                                    )
                                  : null,
                              child:
                                  _profile?['avatar_url'] == null ||
                                      _profile!['avatar_url'].toString().isEmpty
                                  ? const Icon(Icons.person)
                                  : null,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "Hi! Welcome\n${_profile?['brand_name']?.toString() ?? 'Booth Owner'}",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                        Text(
                          "Current Location\nYour Location",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
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
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                              context,
                              AppRoutes.registerEventBooth,
                            );
                            },
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
                          SizedBox(width: 10),

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
                                child: FeaturedBoothEventCard(
                                  eventId: event['id'].toString(),
                                  image: event['banner']?.toString() ?? '',
                                  title:
                                      event['title']?.toString() ??
                                      'Untitled Event',
                                  date: _formatDateRange(
                                    event['start_date'],
                                    event['end_date'],
                                  ),
                                  location:
                                      event['location']?.toString() ?? '-',
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
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                              context,
                              AppRoutes.registerEventBooth,
                            );
                          },
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
                          if (_isLoadingCategories)
                            const SizedBox(
                              width: 30,
                              height: 30,
                              child: CircularProgressIndicator(),
                            )
                          else
                            ..._categories.asMap().entries.map((entry) {
                              final category = entry.value;

                              final categoryId = category['id']?.toString();

                              final categoryName =
                                  category['name']?.toString() ?? '';

                              return Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: CategoryChip(
                                  icon: _categoryIcon(categoryName),
                                  title: categoryName,
                                  selected: selectedCategoryId == categoryId,
                                  onTap: () {
                                    setState(() {
                                      if (selectedCategoryId == categoryId) {
                                        selectedCategoryId = null;
                                      } else {
                                        selectedCategoryId = categoryId;
                                      }
                                    });
                                  },
                                ),
                              );
                            }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),

                    if (_filteredEvents.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.event_busy_outlined,
                              size: 42,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "No events found",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "There are no events in this category.",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      ..._filteredEvents.map((event) {
                        final startDate = event['start_date']?.toString() ?? '';
                        final endDate = event['end_date']?.toString() ?? '';

                        return BoothEventListCard(
                          eventId: event['id'].toString(),
                          image: event['banner']?.toString() ?? '',
                          title: event['title']?.toString() ?? 'Untitled Event',
                          date: _formatDateRange(
                            event['start_date'],
                            event['end_date'],
                          ),
                          location: event['location']?.toString() ?? '-',
                          maximumBooth:
                              int.tryParse(
                                event['maximum_booth']?.toString() ?? '0',
                              ) ??
                              0,
                        );
                      }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: 72,
        height: 72,
        child: FloatingActionButton(
          elevation: 8,
          backgroundColor: AppColor.primary,
          shape: const CircleBorder(),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RegisterEventPage()),
            );
          },
          child: const Icon(Icons.add, color: Colors.white, size: 34),
        ),
      ),

      bottomNavigationBar: const NavBar(currentIndex: 0),
    );
  }
}
