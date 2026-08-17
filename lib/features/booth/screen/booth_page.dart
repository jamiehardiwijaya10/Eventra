import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_color.dart';
import '../../../shared/widgets/navbar_costumer.dart';
import '../../../core/services/booth_service.dart';
import '../widgets/page/category_chip.dart';
import '../widgets/page/recommended_section.dart';
import '../widgets/page/popular_booth.dart';
import '../widgets/page/booth_card.dart';
import 'booth_detail.dart';

class BoothPage extends StatefulWidget {
  const BoothPage({super.key});

  @override
  State<BoothPage> createState() => _BoothPageState();
}

class _BoothPageState extends State<BoothPage> {
  final TextEditingController searchController = TextEditingController();

  final BoothService _boothService = BoothService();

  String selectedCategory = "All";

  bool isLoading = true;
  String? errorMessage;

  List<BoothModel> booths = [];

  final categories = const [
    "All",
    "Food",
    "Beverage",
    "Fashion",
    "Merchandise",
    "Game",
    "Art",
  ];

  @override
  void initState() {
    super.initState();
    loadBooths();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadBooths() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final result = await _boothService.getCustomerBooths();

      final mappedBooths = result.map((booth) {
        return BoothModel(
          id: booth['id']?.toString() ?? '',
          image: booth['logo']?.toString() ?? '',
          name: booth['name']?.toString() ?? '',
          category: booth['category']?.toString() ?? '',
          description: booth['description']?.toString() ?? '',
          rating: 0,
          totalEvent: 0,
          isPopular: false,
          data: Map<String, dynamic>.from(booth),
        );
      }).toList();

      if (!mounted) return;

      setState(() {
        booths = mappedBooths;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('LOAD CUSTOMER BOOTHS ERROR: $e');

      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  List<BoothModel> get filteredBooths {
    final query = searchController.text.trim().toLowerCase();

    return booths.where((booth) {
      final matchesCategory =
          selectedCategory == "All" ||
          booth.category.toLowerCase() == selectedCategory.toLowerCase();

      final matchesSearch =
          query.isEmpty ||
          booth.name.toLowerCase().contains(query) ||
          booth.category.toLowerCase().contains(query) ||
          booth.description.toLowerCase().contains(query);

      return matchesCategory && matchesSearch;
    }).toList();
  }

  void openBoothDetail(BoothModel booth) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            BoothDetailPage(booth: booth.data, isManagement: false),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      bottomNavigationBar: const NavBar(currentIndex: 3),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: loadBooths,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Explore Booths",
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Find interesting booths around events.",
                  style: GoogleFonts.poppins(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: searchController,
                  onChanged: (_) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    hintText: "Search booth...",
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: searchController.text.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              searchController.clear();
                              setState(() {});
                            },
                            icon: const Icon(Icons.clear),
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];

                      return BoothCategoryChip(
                        title: category,
                        selected: selectedCategory == category,
                        onTap: () {
                          setState(() {
                            selectedCategory = category;
                          });
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 30),
                if (isLoading)
                  _buildLoading()
                else if (errorMessage != null)
                  _buildError()
                else if (filteredBooths.isEmpty)
                  _buildEmpty()
                else
                  _buildBoothContent(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 80),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildError() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50),
      child: Center(
        child: Column(
          children: [
            const Icon(Icons.error_outline, size: 50, color: Colors.red),
            const SizedBox(height: 12),
            Text(
              "Gagal memuat booth",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              errorMessage ?? '',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: loadBooths,
              child: const Text("Coba Lagi"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.storefront_outlined,
              size: 60,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 12),
            Text(
              "Booth tidak ditemukan",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Coba gunakan kata kunci atau kategori lain.",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBoothContent() {
    final data = filteredBooths;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RecommendedBoothSection(
          booths: data,
          onBoothTap: (booth) {
            openBoothDetail(booth);
          },
        ),

        const SizedBox(height: 30),

        PopularBoothSection(
          booths: data,
          onBoothTap: (booth) {
            openBoothDetail(booth);
          },
        ),

        const SizedBox(height: 30),

        Text(
          "All Booths",
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 15),

        ...data.map((booth) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: BoothCard(
              booth: booth,
              onTap: () {
                openBoothDetail(booth);
              },
            ),
          );
        }),
      ],
    );
  }
}
