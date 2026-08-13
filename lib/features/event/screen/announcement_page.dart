import 'package:flutter/material.dart';
import '../../../core/services/event_service.dart';

class AnnouncementPage extends StatefulWidget {
  final String eventId;

  const AnnouncementPage({
    super.key,
    required this.eventId,
  });

  @override
  State<AnnouncementPage> createState() =>
      _AnnouncementPageState();
}

class _AnnouncementPageState
    extends State<AnnouncementPage> {
  final EventService _eventService = EventService();

  final titleController = TextEditingController();
  final messageController = TextEditingController();

  List<Map<String, dynamic>> announcements = [];
  bool isLoading = true;
  bool isSubmitting = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadAnnouncements();
  }

  @override
  void dispose() {
    titleController.dispose();
    messageController.dispose();
    super.dispose();
  }

  Future<void> loadAnnouncements() async {
    try {
      final data =
          await _eventService.getEventAnnouncements(
        widget.eventId,
      );

      if (!mounted) return;

      setState(() {
        announcements = data;
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

  Future<void> createAnnouncement() async {
    final title = titleController.text.trim();
    final message = messageController.text.trim();

    if (title.isEmpty || message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Title dan message wajib diisi.",
          ),
        ),
      );
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    try {
      await _eventService.createAnnouncement(
        eventId: widget.eventId,
        title: title,
        message: message,
      );

      titleController.clear();
      messageController.clear();

      await loadAnnouncements();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Announcement berhasil dibuat.",
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Gagal membuat announcement: $e",
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),
      appBar: AppBar(
        title: const Text("Announcement"),
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
                    "Gagal mengambil announcement:\n$errorMessage",
                    textAlign: TextAlign.center,
                  ),
                )
              : RefreshIndicator(
                  onRefresh: loadAnnouncements,
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      TextField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          labelText: "Title",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: messageController,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          labelText: "Message",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: isSubmitting
                              ? null
                              : createAnnouncement,
                          child: isSubmitting
                              ? const CircularProgressIndicator()
                              : const Text(
                                  "Send Announcement",
                                ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        "Previous Announcements",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      if (announcements.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(30),
                          child: Center(
                            child: Text(
                              "Belum ada announcement.",
                            ),
                          ),
                        )
                      else
                        ...announcements.map(
                          (announcement) => Card(
                            margin: const EdgeInsets.only(
                              bottom: 12,
                            ),
                            child: ListTile(
                              title: Text(
                                announcement['title']
                                        ?.toString() ??
                                    '-',
                              ),
                              subtitle: Padding(
                                padding:
                                    const EdgeInsets.only(
                                  top: 8,
                                ),
                                child: Text(
                                  announcement['message']
                                          ?.toString() ??
                                      '-',
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
    );
  }
}