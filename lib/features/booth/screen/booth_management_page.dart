import 'package:eventra/features/booth/screen/booth_management_detail_page.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_color.dart';
import 'booth_detail.dart';
import '../widgets/detail/booth_management_card.dart';
import 'booth_management_detail_page.dart';

class BoothManagementPage extends StatefulWidget {
  final String eventId;

  const BoothManagementPage({
    super.key,
    required this.eventId,
  });

  @override
  State<BoothManagementPage> createState() =>
      _BoothManagementPageState();
}

class _BoothManagementPageState
    extends State<BoothManagementPage> {

  final List<Map<String, dynamic>> booths = [
    {
      'id': 'booth-001',
      'name': "Stand McDonald's",
      'description': 'Fast Food',
      'location': 'Festival Kuliner Bandung',
      'rating': '4.6',
      'reviewCount': '128',
      'queue': '1-10 orang',
      'waitTime': '±5 menit',
      'stockStatus': 'Tersedia',
      'isOpen': true,
      'openHour': '20.00 - 22.00',
      'priceRange': '30K - 80K',
      'image': 'assets/images/burger.png',
    },
    {
      'id': 'booth-002',
      'name': 'Booth Burger Mantap',
      'description': 'Burger',
      'location': 'Festival Kuliner Bandung',
      'rating': '4.8',
      'reviewCount': '86',
      'queue': '11-20 orang',
      'waitTime': '±15 menit',
      'stockStatus': 'Terbatas',
      'isOpen': true,
      'openHour': '19.00 - 22.00',
      'priceRange': '25K - 60K',
      'image': 'assets/images/burger.png',
    },
    {
      'id': 'booth-003',
      'name': 'Booth Kopi Nusantara',
      'description': 'Coffee & Beverage',
      'location': 'Festival Kuliner Bandung',
      'rating': '4.5',
      'reviewCount': '64',
      'queue': 'Sepi',
      'waitTime': '±3 menit',
      'stockStatus': 'Hampir Habis',
      'isOpen': true,
      'openHour': '18.00 - 22.00',
      'priceRange': '15K - 40K',
      'image': 'assets/images/burger.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),

      appBar: AppBar(
        title: const Text(
          'Booth Management',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: booths.length,
        itemBuilder: (context, index) {
          final booth = booths[index];

          return BoothManagementCard(
            booth: booth,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BoothDetailPage(
                    booth: booth,
                    isManagement: true,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}