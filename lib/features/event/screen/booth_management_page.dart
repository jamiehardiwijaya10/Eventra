import 'package:flutter/material.dart';
import '../../../core/services/event_service.dart';

class BoothManagementsPage extends StatefulWidget {
  final String eventId;

  const BoothManagementsPage({
    super.key,
    required this.eventId,
  });

  @override
  State<BoothManagementsPage> createState() => _BoothManagementsPageState();
}

class _BoothManagementsPageState extends State<BoothManagementsPage> {
  final EventService _eventService = EventService();

  List<Map<String, dynamic>> booths = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadBooths();
  }

  Future<void> loadBooths() async {
    try {
      final data = await _eventService.getEventBooths(
        widget.eventId,
      );

      debugPrint("BOOTHS: $data");

      if (!mounted) return;

      setState(() {
        booths = data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),
      appBar: AppBar(
        title: const Text("Booth Management"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : errorMessage != null
              ? Center(
                  child: Text(
                    "Gagal mengambil booth:\n$errorMessage",
                    textAlign: TextAlign.center,
                  ),
                )
              : booths.isEmpty
                  ? const Center(
                      child: Text(
                        "Belum ada booth yang terdaftar.",
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: booths.length,
                      itemBuilder: (context, index) {
                        final booth = booths[index];

                        return Card(
                          margin: const EdgeInsets.only(
                            bottom: 15,
                          ),
                          child: ListTile(
                            leading: const Icon(
                              Icons.storefront,
                            ),
                            title: Text(
                              booth['name']?.toString() ?? '-',
                            ),
                            subtitle: Text(
                              booth['description']?.toString() ?? '-',
                            ),
                            trailing: Text(
                              booth['status']?.toString() ?? '-',
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}