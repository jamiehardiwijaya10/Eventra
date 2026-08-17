import 'package:flutter/material.dart';

import '../../../core/theme/app_color.dart';
import '../../../../core/services/booth_service.dart';
import '../widgets/detail/bottom_bar.dart';
import '../widgets/detail/booth_header.dart';
import '../widgets/detail/booth_image.dart';
import '../widgets/detail/menu_card.dart';
import '../widgets/detail/payment_method.dart';

class BoothDetailPage extends StatefulWidget {
  final Map<String, dynamic> booth;
  final bool isManagement;

  const BoothDetailPage({
    super.key,
    required this.booth,
    this.isManagement = false,
  });

  @override
  State<BoothDetailPage> createState() => _BoothDetailPageState();
}

class _BoothDetailPageState extends State<BoothDetailPage> {
  final BoothService _boothService = BoothService();

  bool isBookmarked = false;
  int selectedTab = 0;

  List<Map<String, dynamic>> products = [];
  bool isLoadingProducts = true;

@override
void initState() {
  super.initState();

  debugPrint('========== BOOTH DETAIL ==========');
  debugPrint('BOOTH DATA: ${widget.booth}');
  debugPrint('BOOTH ID: ${widget.booth['id']}');
  debugPrint('BOOTH NAME: ${widget.booth['name']}');
  debugPrint('OPENING: ${widget.booth['opening_hours']}');
  debugPrint('CLOSING: ${widget.booth['closing_hours']}');
  debugPrint('==================================');

  _loadProducts();
}

  Future<void> _loadProducts() async {
  try {
    final boothId = widget.booth['id']?.toString();

    debugPrint('LOAD PRODUCTS');
    debugPrint('BOOTH ID: $boothId');

    if (boothId == null || boothId.isEmpty) {
      debugPrint('ERROR: BOOTH ID KOSONG');

      if (mounted) {
        setState(() {
          isLoadingProducts = false;
        });
      }

      return;
    }

    final result = await _boothService.getBoothProducts(boothId);

    debugPrint('PRODUCT RESULT: $result');
    debugPrint('PRODUCT RESULT LENGTH: ${result.length}');

    if (!mounted) return;

    setState(() {
      products = result;
      isLoadingProducts = false;
    });
  } catch (e, stackTrace) {
    debugPrint('LOAD PRODUCTS ERROR: $e');
    debugPrint('$stackTrace');

    if (!mounted) return;

    setState(() {
      isLoadingProducts = false;
    });
  }
}

  String _stringValue(dynamic value) {
    return value?.toString() ?? '';
  }

  String _formatPrice(num price) {
    final value = price.toInt();

    final formatted = value.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    );

    return 'Rp$formatted';
  }

  num _parsePrice(dynamic value) {
    if (value is num) {
      return value;
    }

    return num.tryParse(value?.toString() ?? '') ?? 0;
  }

  String _getPriceRange() {
    if (products.isEmpty) {
      return '-';
    }

    final prices = products
        .map((product) => _parsePrice(product['price']))
        .where((price) => price > 0)
        .toList();

    if (prices.isEmpty) {
      return '-';
    }

    prices.sort();

    if (prices.length == 1) {
      return _formatPrice(prices.first);
    }

    return '${_formatPrice(prices.first)} - ${_formatPrice(prices.last)}';
  }

  List<String> _getImages() {
    final images = <String>[];

    final logo = _stringValue(widget.booth['logo']);
    final banner = _stringValue(widget.booth['banner']);
    final boothPhoto = _stringValue(widget.booth['booth_photo']);

    if (logo.isNotEmpty) {
      images.add(logo);
    }

    if (banner.isNotEmpty && !images.contains(banner)) {
      images.add(banner);
    }

    if (boothPhoto.isNotEmpty && !images.contains(boothPhoto)) {
      images.add(boothPhoto);
    }

    return images;
  }

  String _getLocation() {
    final events = widget.booth['events'];

    if (events is Map<String, dynamic>) {
      final venueName = _stringValue(events['venue_name']);

      if (venueName.isNotEmpty) {
        return venueName;
      }

      final location = _stringValue(events['location']);

      if (location.isNotEmpty) {
        return location;
      }
    }

    final location = _stringValue(widget.booth['location']);

    if (location.isNotEmpty) {
      return location;
    }

    final venueName = _stringValue(widget.booth['venue_name']);

    if (venueName.isNotEmpty) {
      return venueName;
    }

    return '-';
  }

  String _getOpeningHours() {
  final opening = _stringValue(widget.booth['opening_hours']);
  final closing = _stringValue(widget.booth['closing_hours']);

  if (opening.isEmpty && closing.isEmpty) {
    return '-';
  }

  String cleanTime(String value) {
     if (value.isEmpty) {
        return '';
      }

      final parts = value.split(':');

      if (parts.length >= 2) {
        return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
      }

      return value;
    }

    final start = cleanTime(opening);
    final end = cleanTime(closing);

    if (start.isEmpty) {
      return end;
    }

    if (end.isEmpty) {
      return start;
    }

    return '$start - $end';
  }

  bool _isOpen() {
    final status = _stringValue(
      widget.booth['open_close_status'],
    ).toLowerCase();

    if (status == 'open' ||
        status == 'buka' ||
        status == 'opened') {
      return true;
    }

    if (status == 'closed' ||
        status == 'tutup' ||
        status == 'close') {
      return false;
    }

    final opening = _stringValue(widget.booth['opening_hours']);
    final closing = _stringValue(widget.booth['closing_hours']);

    if (opening.isEmpty || closing.isEmpty) {
      return false;
    }

    final now = TimeOfDay.now();

    final openParts = opening.split(':');
    final closeParts = closing.split(':');

    if (openParts.length < 2 || closeParts.length < 2) {
      return false;
    }

    final openHour = int.tryParse(openParts[0]);
    final openMinute = int.tryParse(openParts[1]);
    final closeHour = int.tryParse(closeParts[0]);
    final closeMinute = int.tryParse(closeParts[1]);

    if (openHour == null ||
        openMinute == null ||
        closeHour == null ||
        closeMinute == null) {
      return false;
    }

    final currentMinutes =
        now.hour * 60 + now.minute;

    final openingMinutes =
        openHour * 60 + openMinute;

    final closingMinutes =
        closeHour * 60 + closeMinute;

    if (closingMinutes >= openingMinutes) {
      return currentMinutes >= openingMinutes &&
          currentMinutes <= closingMinutes;
    }

    return currentMinutes >= openingMinutes ||
        currentMinutes <= closingMinutes;
  }

  String _getStockStatus(Map<String, dynamic> product) {
    final stockStatus = _stringValue(
      product['stock_status'],
    ).toLowerCase();

    if (stockStatus.isNotEmpty) {
      if (stockStatus == 'available' ||
          stockStatus == 'tersedia' ||
          stockStatus == 'in_stock') {
        return 'TERSEDIA';
      }

      if (stockStatus == 'low' ||
          stockStatus == 'almost_empty' ||
          stockStatus == 'hampir habis') {
        return 'HAMPIR HABIS';
      }

      if (stockStatus == 'out_of_stock' ||
          stockStatus == 'habis' ||
          stockStatus == 'empty') {
        return 'HABIS';
      }
    }

    final stock = int.tryParse(
          product['available_stock']?.toString() ?? '',
        ) ??
        0;

    final isAvailable =
        product['is_available'] == true;

    if (!isAvailable || stock <= 0) {
      return 'HABIS';
    }

    if (stock <= 5) {
      return 'HAMPIR HABIS';
    }

    return 'TERSEDIA';
  }

  String _getQuantityText(Map<String, dynamic> product) {
    final stock = int.tryParse(
          product['available_stock']?.toString() ?? '',
        ) ??
        0;

    final status = _getStockStatus(product);

    if (status == 'HABIS') {
      return 'Tidak tersedia';
    }

    if (status == 'HAMPIR HABIS') {
      return 'Sisa $stock';
    }

    return 'Tersedia';
  }

  @override
  Widget build(BuildContext context) {
    final boothName = _stringValue(widget.booth['name']);
    final category = _stringValue(widget.booth['category']);
    final location = _getLocation();
    final openingHours = _getOpeningHours();
    final isOpen = _isOpen();
    final priceRange = _getPriceRange();
    final images = _getImages();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      bottomNavigationBar: BottomActionBar(onNavigate: () {}),
      body: Stack(
        children: [
          SizedBox(
            height: 350,
            width: double.infinity,
            child: BoothImageCarousel(
              images: images,
            ),
          ),

          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () {
                  setState(() {
                    isBookmarked = !isBookmarked;
                  });
                },
                icon: Icon(
                  isBookmarked
                      ? Icons.bookmark
                      : Icons.bookmark_border,
                  color: AppColor.primary,
                ),
              ),
            ),
          ),

          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: 16,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
            ),
          ),

          DraggableScrollableSheet(
            initialChildSize: 0.72,
            minChildSize: 0.65,
            maxChildSize: 0.95,
            builder: (
              context,
              scrollController,
            ) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(32),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 15,
                      offset: Offset(0, -5),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.only(
                    top: 20,
                    bottom: 120,
                  ),
                  child: Column(
                    children: [
                      BoothHeaderCard(
                        boothName: boothName,
                        category: category,
                        location: location,
                        rating: "4.6",
                        reviewCount: "128",
                        queue: "",
                        openHour: openingHours,
                        priceRange: priceRange,
                        isOpen: isOpen,
                      ),

                      const SizedBox(height: 16),

                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius:
                              BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            _TabButton(
                              title: "Menu",
                              isSelected:
                                  selectedTab == 0,
                              onTap: () {
                                setState(() {
                                  selectedTab = 0;
                                });
                              },
                            ),
                            _TabButton(
                              title: "Review",
                              isSelected:
                                  selectedTab == 1,
                              onTap: () {
                                setState(() {
                                  selectedTab = 1;
                                });
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 8),

                      if (selectedTab == 0)
                        _menuContent(),

                      if (selectedTab == 1)
                        _reviewContent(),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _menuContent() {
    return Column(
      children: [
        const _SectionTitle(
          title: "Ketersediaan Menu",
        ),

        if (isLoadingProducts)
          const Padding(
            padding: EdgeInsets.symmetric(
              vertical: 30,
            ),
            child: CircularProgressIndicator(),
          )
        else if (products.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 20,
            ),
            child: Text(
              "Belum ada menu tersedia.",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          )
        else
          ...products.map(
            (product) => _StockStatusCard(
              name: _stringValue(product['name']),
              status: _getStockStatus(product),
              quantityText:
                  _getQuantityText(product),
            ),
          ),

        const SizedBox(height: 8),

        PaymentMethodCard(
          paymentMethods: const [
            "Cash",
            "QRIS",
            "GoPay",
            "DANA",
            "BCA",
          ],
        ),

        const _SectionTitle(
          title: "Menu Booth",
        ),

        if (isLoadingProducts)
          const Padding(
            padding: EdgeInsets.symmetric(
              vertical: 30,
            ),
            child: CircularProgressIndicator(),
          )
        else if (products.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 20,
            ),
            child: Text(
              "Belum ada menu tersedia.",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          )
        else
          ...products.map(
            (product) {
              final image =
                  _stringValue(product['image']);

              final price =
                  _parsePrice(product['price']);

              return MenuCard(
                image: image,
                name: _stringValue(
                  product['name'],
                ),
                description: _stringValue(
                  product['description'],
                ),
                price: _formatPrice(price),
                rating: 4.8,
                isPopular: false,
              );
            },
          ),
      ],
    );
  }

  Widget _reviewContent() {
    return Column(
      children: [
        const _SectionTitle(
          title: "Review Pengunjung",
        ),

        ReviewBox(
          name: "Andi",
          rating: 5,
          comment:
              "Booth mudah ditemukan dan pelayanan cepat.",
        ),

        ReviewBox(
          name: "Budi",
          rating: 4,
          comment:
              "Navigasi Eventra sangat membantu.",
        ),

        ReviewBox(
          name: "Rina",
          rating: 5,
          comment:
              "Informasi booth cukup lengkap.",
        ),
      ],
    );
  }
}

class _TabButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.white
                : Colors.transparent,
            borderRadius:
                BorderRadius.circular(13),
            boxShadow: isSelected
                ? const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              color: isSelected
                  ? AppColor.primary
                  : Colors.grey,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _StockStatusCard extends StatelessWidget {
  final String name;
  final String status;
  final String quantityText;

  const _StockStatusCard({
    required this.name,
    required this.status,
    required this.quantityText,
  });

  @override
  Widget build(BuildContext context) {
    final bool available =
        status == "TERSEDIA";

    final bool almostEmpty =
        status == "HAMPIR HABIS";

    Color statusColor;

    if (available) {
      statusColor = Colors.green;
    } else if (almostEmpty) {
      statusColor = Colors.orange;
    } else {
      statusColor = Colors.red;
    }

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 5,
      ),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius:
            BorderRadius.circular(14),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color:
                  statusColor.withOpacity(0.10),
              borderRadius:
                  BorderRadius.circular(12),
            ),
            child: Icon(
              available
                  ? Icons.check_circle_outline
                  : almostEmpty
                      ? Icons.warning_amber_rounded
                      : Icons.cancel_outlined,
              color: statusColor,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  quantityText,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12.5,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color:
                  statusColor.withOpacity(0.10),
              borderRadius:
                  BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: statusColor,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        10,
        16,
        8,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class ReviewBox extends StatelessWidget {
  final String name;
  final double rating;
  final String comment;

  const ReviewBox({
    super.key,
    required this.name,
    required this.rating,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius:
            BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Spacer(),

              Text("⭐ $rating"),
            ],
          ),

          const SizedBox(height: 8),

          Text(comment),
        ],
      ),
    );
  }
}