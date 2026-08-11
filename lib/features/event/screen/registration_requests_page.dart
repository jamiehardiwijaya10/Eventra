import 'package:flutter/material.dart';
import '../../../core/services/event_service.dart';

class RegistrationRequestsPage extends StatefulWidget {
  final String eventId;

  const RegistrationRequestsPage({
    super.key,
    required this.eventId,
  });

  @override
  State<RegistrationRequestsPage> createState() =>
      _RegistrationRequestsPageState();
}

class _RegistrationRequestsPageState
    extends State<RegistrationRequestsPage> {
  final EventService _eventService = EventService();

  List<Map<String, dynamic>> booths = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadRequests();
  }

  Future<void> loadRequests() async {
    try {
      final data = await _eventService.getPendingBooths(
        widget.eventId,
      );

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

  Future<void> updateStatus(
    String boothId,
    String status,
  ) async {
    try {
      await _eventService.updateBoothStatus(
        boothId: boothId,
        status: status,
      );

      if (!mounted) return;

      setState(() {
        booths.removeWhere(
          (booth) => booth['id'].toString() == boothId,
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            status == 'approved'
                ? 'Booth berhasil di-approve'
                : 'Booth berhasil di-reject',
          ),
        ),
      );
    } catch (e) {
      debugPrint('UPDATE STATUS ERROR: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengubah status: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),
      appBar: AppBar(
        title: const Text("Registration Requests"),
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
                    "Gagal mengambil request:\n$errorMessage",
                    textAlign: TextAlign.center,
                  ),
                )
              : booths.isEmpty
                  ? const Center(
                      child: Text(
                        "Belum ada registration request.",
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: booths.length,
                      itemBuilder: (context, index) {
                        final booth = booths[index];

                        final boothId =
                            booth['id'].toString();

                        return Card(
                          margin: const EdgeInsets.only(
                            bottom: 15,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  booth['name']
                                          ?.toString() ??
                                      '-',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  booth['description']
                                          ?.toString() ??
                                      '-',
                                ),
                                const SizedBox(height: 15),
                                Row(
                                  children: [
                                    Expanded(
                                      child:
                                          ElevatedButton(
                                        onPressed: () {
                                          updateStatus(
                                            boothId,
                                            'approved',
                                          );
                                        },
                                        child: const Text(
                                          "Approve",
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child:
                                          OutlinedButton(
                                        onPressed: () {
                                          updateStatus(
                                            boothId,
                                            'rejected',
                                          );
                                        },
                                        child: const Text(
                                          "Reject",
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}