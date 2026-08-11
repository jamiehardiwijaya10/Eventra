import 'package:flutter/material.dart';
import '../../../core/services/event_service.dart';

class EventSettingsPage extends StatefulWidget {
  final String eventId;

  const EventSettingsPage({
    super.key,
    required this.eventId,
  });

  @override
  State<EventSettingsPage> createState() => _EventSettingsPageState();
}

class _EventSettingsPageState extends State<EventSettingsPage> {
  final EventService _eventService = EventService();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();
  final venueController = TextEditingController();
  final registrationFeeController = TextEditingController();
  final maximumBoothController = TextEditingController();

  bool isLoading = true;
  bool isSaving = false;

  DateTime? startDate;
  DateTime? endDate;
  DateTime? registrationDeadline;

  TimeOfDay? openingTime;
  TimeOfDay? closingTime;

  String eventType = 'Indoor';

  @override
  void initState() {
    super.initState();
    loadEvent();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    venueController.dispose();
    registrationFeeController.dispose();
    maximumBoothController.dispose();
    super.dispose();
  }

  Future<void> loadEvent() async {
    try {
      final event = await _eventService.getEventById(
        widget.eventId,
      );

      titleController.text =
          event['title']?.toString() ?? '';

      descriptionController.text =
          event['description']?.toString() ?? '';

      locationController.text =
          event['location']?.toString() ?? '';

      venueController.text =
          event['venue_name']?.toString() ?? '';

      registrationFeeController.text =
          event['registration_fee']?.toString() ?? '0';

      maximumBoothController.text =
          event['maximum_booth']?.toString() ?? '0';

      eventType =
          event['event_type']?.toString() ?? 'Indoor';

      startDate = DateTime.tryParse(
        event['start_date']?.toString() ?? '',
      );

      endDate = DateTime.tryParse(
        event['end_date']?.toString() ?? '',
      );

      registrationDeadline = DateTime.tryParse(
        event['registration_deadline']?.toString() ?? '',
      );

      openingTime = parseTime(
        event['opening_time']?.toString(),
      );

      closingTime = parseTime(
        event['closing_time']?.toString(),
      );

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      showMessage('Gagal mengambil event: $e');
    }
  }

  TimeOfDay? parseTime(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    final parts = value.split(':');

    if (parts.length < 2) {
      return null;
    }

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);

    if (hour == null || minute == null) {
      return null;
    }

    return TimeOfDay(
      hour: hour,
      minute: minute,
    );
  }

  Future<void> saveEvent() async {
    final registrationFee =
        int.tryParse(
          registrationFeeController.text.trim(),
        );

    final maximumBooth =
        int.tryParse(
          maximumBoothController.text.trim(),
        );

    if (registrationFee == null ||
        maximumBooth == null) {
      showMessage(
        'Registration fee dan maximum booth harus berupa angka.',
      );
      return;
    }

    if (startDate == null ||
        endDate == null ||
        registrationDeadline == null ||
        openingTime == null ||
        closingTime == null) {
      showMessage(
        'Tanggal dan waktu event harus lengkap.',
      );
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      await _eventService.updateEvent(
        eventId: widget.eventId,
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        location: locationController.text.trim(),
        venueName: venueController.text.trim(),
        eventType: eventType,
        startDate: startDate!,
        endDate: endDate!,
        openingTime: openingTime!,
        closingTime: closingTime!,
        registrationDeadline: registrationDeadline!,
        registrationFee: registrationFee,
        maximumBooth: maximumBooth,
      );

      if (!mounted) return;

      showMessage('Event berhasil diubah');
      Navigator.pop(context, true);

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      showMessage(
        'Gagal mengubah event: $e',
      );
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  Future<void> deleteEvent() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Event'),
          content: const Text(
            'Yakin ingin menghapus event ini?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    try {
      await _eventService.deleteEvent(
        widget.eventId,
      );

      if (!mounted) return;

      showMessage('Event berhasil dihapus');

      Navigator.pop(context, true);
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      showMessage(
        'Gagal menghapus event: $e',
      );
    }
  }

  Future<void> pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDate: startDate ?? DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        startDate = picked;
      });
    }
  }

  Future<void> pickEndDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: startDate ?? DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: endDate ?? startDate ?? DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        endDate = picked;
      });
    }
  }

  Future<void> pickDeadline() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: startDate ?? DateTime(2100),
      initialDate:
          registrationDeadline ?? DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        registrationDeadline = picked;
      });
    }
  }

  Future<void> pickOpeningTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime:
          openingTime ??
          const TimeOfDay(
            hour: 8,
            minute: 0,
          ),
    );

    if (picked != null) {
      setState(() {
        openingTime = picked;
      });
    }
  }

  Future<void> pickClosingTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime:
          closingTime ??
          const TimeOfDay(
            hour: 21,
            minute: 0,
          ),
    );

    if (picked != null) {
      setState(() {
        closingTime = picked;
      });
    }
  }

  String formatDate(DateTime? date) {
    if (date == null) {
      return '-';
    }

    return '${date.day}/${date.month}/${date.year}';
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: 'Event Name',
            ),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: descriptionController,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Description',
            ),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: venueController,
            decoration: const InputDecoration(
              labelText: 'Venue',
            ),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: locationController,
            decoration: const InputDecoration(
              labelText: 'Address',
            ),
          ),
          const SizedBox(height: 15),
          DropdownButtonFormField<String>(
            value: eventType,
            decoration: const InputDecoration(
              labelText: 'Event Type',
            ),
            items: const [
              DropdownMenuItem(
                value: 'Indoor',
                child: Text('Indoor'),
              ),
              DropdownMenuItem(
                value: 'Outdoor',
                child: Text('Outdoor'),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  eventType = value;
                });
              }
            },
          ),
          const SizedBox(height: 15),
          ListTile(
            title: const Text('Start Date'),
            subtitle: Text(formatDate(startDate)),
            trailing: const Icon(Icons.calendar_month),
            onTap: pickStartDate,
          ),
          ListTile(
            title: const Text('End Date'),
            subtitle: Text(formatDate(endDate)),
            trailing: const Icon(Icons.calendar_month),
            onTap: pickEndDate,
          ),
          ListTile(
            title: const Text('Opening Time'),
            subtitle: Text(
              openingTime?.format(context) ?? '-',
            ),
            trailing: const Icon(Icons.access_time),
            onTap: pickOpeningTime,
          ),
          ListTile(
            title: const Text('Closing Time'),
            subtitle: Text(
              closingTime?.format(context) ?? '-',
            ),
            trailing: const Icon(Icons.access_time),
            onTap: pickClosingTime,
          ),
          ListTile(
            title: const Text('Registration Deadline'),
            subtitle: Text(
              formatDate(registrationDeadline),
            ),
            trailing: const Icon(Icons.calendar_month),
            onTap: pickDeadline,
          ),
          const SizedBox(height: 10),
          TextField(
            controller: registrationFeeController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Registration Fee',
            ),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: maximumBoothController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Maximum Booth',
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: isSaving ? null : saveEvent,
            child: Text(
              isSaving
                  ? 'Menyimpan...'
                  : 'Simpan Perubahan',
            ),
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: deleteEvent,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus Event'),
          ),
        ],
      ),
    );
  }
}