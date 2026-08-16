import 'package:flutter/material.dart';
import '../../../shared/widgets/navbar_booth.dart';
import '../widgets/mybooth/header_card.dart';
import '../widgets/mybooth/current_card.dart';
import '../widgets/mybooth/booth_stats.dart';
import '../widgets/mybooth/booth_management.dart';
import '../widgets/mybooth/management_item.dart';
import '../../../core/theme/app_color.dart';
import '../../../core/services/booth_service.dart';
import 'product_screen/booth_products_page.dart';
import 'edit_booth_screen/edit_booth_page.dart';
import 'register_event_page.dart';

class MyBoothPage extends StatefulWidget {
  const MyBoothPage({super.key});

  @override
  State<MyBoothPage> createState() => _MyBoothPageState();
}

class _MyBoothPageState extends State<MyBoothPage> {
  int productCount = 0;
  final BoothService _boothService = BoothService();

  final PageController _pageController = PageController();
  int _currentIndex = 0;

  Map<String, dynamic>? booth;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadBooth();
  }

  Future<void> loadProductCount(String boothId) async {
    try {
      final count = await _boothService.getBoothProductCount(boothId);

      if (!mounted) return;

      setState(() {
        productCount = count;
      });
    } catch (e) {
      debugPrint("LOAD PRODUCT COUNT ERROR: $e");

      if (!mounted) return;

      setState(() {
        productCount = 0;
      });
    }
  }

  Future<void> loadBooth() async {
    try {
      final data = await _boothService.getMyBooths();

      if (!mounted) return;

      setState(() {
        _booths = data;
        isLoading = false;
        _isLoading = false;
        _error = null;

        if (_currentIndex >= _booths.length) {
          _currentIndex = 0;
        }
      });

      if (_booths.isNotEmpty) {
        await loadProductCount(_booths[_currentIndex]['id'].toString());
      }
    } catch (e) {
      debugPrint("LOAD MY BOOTHS ERROR: $e");

      if (!mounted) return;

      setState(() {
        isLoading = false;
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  List<Map<String, dynamic>> _booths = [];

  bool _isLoading = true;
  String? _error;

  Map<String, dynamic>? get _currentBooth {
    if (_booths.isEmpty) return null;

    final approved = _booths
        .where((booth) => booth['status']?.toString() == 'approved')
        .toList();

    if (approved.isNotEmpty) {
      return approved.first;
    }

    return _booths.first;
  }

  String _formatDate(dynamic value) {
    if (value == null) return "-";

    final date = DateTime.tryParse(value.toString());

    if (date == null) return "-";

    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];

    return "${date.day} ${months[date.month - 1]} ${date.year}";
  }

  String _formatDateRange(dynamic start, dynamic end) {
    final startDate = DateTime.tryParse(start?.toString() ?? "");

    final endDate = DateTime.tryParse(end?.toString() ?? "");

    if (startDate == null && endDate == null) {
      return "-";
    }

    if (startDate != null && endDate != null) {
      return "${_formatDate(start)} - ${_formatDate(end)}";
    }

    return _formatDate(start ?? end);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),

      appBar: AppBar(
        title: const Text("My Booth"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
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

      bottomNavigationBar: const NavBar(currentIndex: 3),

      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            "Gagal memuat booth.\n\n$_error",
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (_booths.isEmpty) {
      return RefreshIndicator(
        onRefresh: loadBooth,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 180),
            Icon(Icons.storefront_outlined, size: 70, color: Colors.grey),
            SizedBox(height: 20),
            Center(child: Text("You don't have any booth yet.")),
          ],
        ),
      );
    }

    final booth = _booths[_currentIndex];

    final event = booth['events'] as Map<String, dynamic>?;

    final status = booth['status']?.toString() ?? "pending";

    final isApproved = status == 'approved';

    return RefreshIndicator(
      onRefresh: loadBooth,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(
              height: 270,
              child: PageView.builder(
                controller: _pageController,
                itemCount: _booths.length,
                onPageChanged: (index) async {
                  setState(() {
                    _currentIndex = index;
                    productCount = 0;
                  });

                  await loadProductCount(_booths[index]['id'].toString());
                },
                itemBuilder: (context, index) {
                  final booth = _booths[index];

                  return BoothHeaderCard(
                    booth: BoothHeaderModel(
                      image: booth['logo']?.toString() ?? '',
                      name: booth['name']?.toString() ?? '-',
                      category: booth['description']?.toString() ?? '-',
                      isOpen: booth['status']?.toString() == 'approved',
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            if (_booths.length > 1)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _booths.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: index == _currentIndex ? 20 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: index == _currentIndex
                          ? AppColor.primary
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 24),

            CurrentEventCard(
              event: CurrentEventModel(
                eventName: event?['title']?.toString() ?? "No Event",

                boothNumber: booth['name']?.toString() ?? "-",

                date: _formatDateRange(
                  event?['start_date'],
                  event?['end_date'],
                ),

                location:
                    event?['location']?.toString() ??
                    event?['venue_name']?.toString() ??
                    "-",

                isActive: isApproved,
              ),

              onViewEvent: () {},

              onViewMap: () {},

              onShowQR: () {},
            ),

            const SizedBox(height: 30),

            BoothStatistics(
              stats: [
                BoothStatModel(
                  icon: Icons.star,
                  title: "Rating",
                  value: "0",
                  color: Colors.amber,
                ),

                BoothStatModel(
                  icon: Icons.reviews,
                  title: "Reviews",
                  value: "0",
                  color: Colors.blue,
                ),

                BoothStatModel(
                  icon: Icons.fastfood,
                  title: "Products",
                  value: productCount.toString(),
                  color: Colors.orange,
                ),

                BoothStatModel(
                  icon: Icons.bookmark,
                  title: "Bookmarks",
                  value: "0",
                  color: Colors.red,
                ),
              ],
            ),

            const SizedBox(height: 30),

            BoothManagementGrid(
              items: [
                BoothManagementModel(
                  icon: Icons.edit_outlined,
                  title: "Edit Booth",
                  color: Colors.blue,
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditBoothPage(booth: booth),
                      ),
                    );

                    if (result == true) {
                      await loadBooth();
                    }
                  },
                ),

                BoothManagementModel(
                  icon: Icons.fastfood_outlined,
                  title: "Products",
                  color: Colors.orange,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            BoothProductsPage(boothId: booth['id'].toString()),
                      ),
                    );
                  },
                ),

                BoothManagementModel(
                  icon: Icons.star_outline,
                  title: "Reviews",
                  color: Colors.amber,
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
