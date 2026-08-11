import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/theme/app_color.dart';
import '../../../core/services/event_service.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();

  final EventService _eventService = EventService();

  Uint8List? _bannerBytes;
  String? _bannerName;

  DateTime? _startDate;
  DateTime? _endDate;

  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickBanner() async {
    final picker = ImagePicker();

    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    final bytes = await image.readAsBytes();

    setState(() {
      _bannerBytes = bytes;
      _bannerName = image.name;
    });
  }

  Future<void> _pickDate({required bool isStart}) async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: isStart
          ? (_startDate ?? now)
          : (_endDate ?? _startDate ?? now),
      firstDate: now,
      lastDate: DateTime(2100),
    );

    if (picked == null) return;

    setState(() {
      if (isStart) {
        _startDate = picked;

        // Kalau end date sebelumnya sebelum start date
        if (_endDate != null && _endDate!.isBefore(picked)) {
          _endDate = null;
        }
      } else {
        _endDate = picked;
      }
    });
  }

  Future<void> _createEvent() async {
    if (_titleController.text.trim().isEmpty ||
      _locationController.text.trim().isEmpty ||
      _bannerBytes == null ||
      _startDate == null ||
      _endDate == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Title, location, banner, start date, dan end date wajib diisi",
        ),
      ),
    );
    return;
  }

    setState(() {
      _isLoading = true;
    });

    try {
      final bannerUrl = await _eventService.uploadEventBanner(
        bytes: _bannerBytes!,
        fileName: _bannerName ?? 'event-banner.jpg',
      );

      debugPrint("BANNER URL: $bannerUrl");

      // await _eventService.createEvent(
      //   title: _titleController.text.trim(),
      //   description: _descriptionController.text.trim(),
      //   banner: bannerUrl,
      //   location: _locationController.text.trim(),
      //   startDate: _startDate!,
      //   endDate: _endDate!,
      // );
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Banner berhasil di-upload!")),
      );
    } catch (e) {
      debugPrint("CREATE EVENT ERROR: $e");

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal: $e")));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Event")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Event Banner",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            GestureDetector(
              onTap: _pickBanner,

              child: Container(
                width: double.infinity,
                height: 200,

                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300),
                ),

                child: _bannerBytes == null
                    ? const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_photo_alternate_outlined, size: 50),
                          SizedBox(height: 10),
                          Text("Tap untuk memilih banner"),
                        ],
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.memory(_bannerBytes!, fit: BoxFit.cover),
                      ),
              ),
            ),

            const SizedBox(height: 25),

            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: "Event Title",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: "Location",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _pickDate(isStart: true),
                    icon: const Icon(Icons.calendar_today),
                    label: Text(
                      _startDate == null
                          ? "Start Date"
                          : "${_startDate!.day}/${_startDate!.month}/${_startDate!.year}",
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _startDate == null
                        ? null
                        : () => _pickDate(isStart: false),
                    icon: const Icon(Icons.event),
                    label: Text(
                      _endDate == null
                          ? "End Date"
                          : "${_endDate!.day}/${_endDate!.month}/${_endDate!.year}",
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _createEvent,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Create Event"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
