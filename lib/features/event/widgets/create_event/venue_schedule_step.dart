import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'event_type_selector.dart';
import 'datetime_picker_card.dart';
import 'floorplan_upload_card.dart';
import 'package:eventra/features/maps/screen/eo_location_picker_screen.dart';

class VenueScheduleStep extends StatelessWidget {
  final bool isIndoor;

  final ValueChanged<bool> onEventTypeChanged;

  final TextEditingController venueController;
  final TextEditingController addressController;

  final DateTime? startDate;
  final DateTime? endDate;

  final TimeOfDay? openingTime;
  final TimeOfDay? closingTime;

  final VoidCallback onStartDateTap;
  final VoidCallback onEndDateTap;

  final VoidCallback onOpeningTimeTap;
  final VoidCallback onClosingTimeTap;

  final Uint8List? floorplan;

  final VoidCallback onFloorplanTap;

  final void Function(
    String address,
    double latitude,
    double longitude,
  ) onLocationSelected;

  const VenueScheduleStep({
    super.key,
    required this.isIndoor,
    required this.onEventTypeChanged,
    required this.venueController,
    required this.addressController,
    required this.startDate,
    required this.endDate,
    required this.openingTime,
    required this.closingTime,
    required this.onStartDateTap,
    required this.onEndDateTap,
    required this.onOpeningTimeTap,
    required this.onClosingTimeTap,
    required this.floorplan,
    required this.onFloorplanTap,
    required this.onLocationSelected,
  });

  String formatDate(DateTime? date) {
    if (date == null) return "Select Date";

    return "${date.day}/${date.month}/${date.year}";
  }

  Future<void> _selectLocation(BuildContext context) async {
    final result = await Navigator.push<SelectedEventLocation>(
      context,
      MaterialPageRoute(
        builder: (_) => const EventLocationPickerScreen(),
      ),
    );

    if (result == null) return;

    onLocationSelected(
      result.address,
      result.latitude,
      result.longitude,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const Text(
          "Venue & Schedule",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 6),

        const Text(
          "Configure the location and operating schedule of your event.",
          style: TextStyle(
            color: Colors.grey,
          ),
        ),

        const SizedBox(height: 28),

        const Text(
          "Event Type",
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 10),

        EventTypeSelector(
          isIndoor: isIndoor,
          onChanged: onEventTypeChanged,
        ),

        const SizedBox(height: 25),

        TextField(
          controller: venueController,
          decoration: InputDecoration(
            labelText: "Venue Name",
            hintText: "Sabuga Convention Hall",
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),

        const SizedBox(height: 20),

        const Text(
          "Venue Address",
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 10,),
        
        TextField(
          controller: addressController,
          maxLines: 2,
          readOnly: true,
          onTap: () => _selectLocation(context),
          decoration: InputDecoration(
            hintText: "Select location on map",
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            suffixIcon: const Icon(
              Icons.location_on_outlined,
            ),
          ),
        ),

        const SizedBox(height: 12,),

        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton.icon(
            onPressed: () => _selectLocation(context),
            icon: const Icon(
              Icons.location_on_outlined,
            ),
            label: Text(
              addressController.text.isEmpty
                  ? "Choose Location on Map"
                  : "Change Location",
            ),
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),

        const SizedBox(height: 28,),        

        Row(
          children: [
            Expanded(
              child: DateTimePickerCard(
                title: "Start Date",
                value: formatDate(startDate),
                icon: Icons.calendar_today_outlined,
                onTap: onStartDateTap,
              ),
            ),

            const SizedBox(width: 15),

            Expanded(
              child: DateTimePickerCard(
                title: "End Date",
                value: formatDate(endDate),
                icon: Icons.calendar_today_outlined,
                onTap: onEndDateTap,
              ),
            ),

          ],
        ),

        const SizedBox(height: 20),

        Row(
          children: [

            Expanded(
              child: DateTimePickerCard(
                title: "Opening Time",
                value: openingTime == null
                    ? "Select Time"
                    : openingTime!.format(context),
                icon: Icons.schedule,
                onTap: onOpeningTimeTap,
              ),
            ),

            const SizedBox(width: 15),

            Expanded(
              child: DateTimePickerCard(
                title: "Closing Time",
                value: closingTime == null
                    ? "Select Time"
                    : closingTime!.format(context),
                icon: Icons.schedule,
                onTap: onClosingTimeTap,
              ),
            ),

          ],
        ),

        const SizedBox(height: 30),

        if (isIndoor) ...[

          const Text(
            "Venue Floorplan",
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 10),

          FloorplanUploadCard(
            image: floorplan,
            onTap: onFloorplanTap,
          ),

          const SizedBox(height: 10),

          const Text(
            "Upload the digital floorplan of your venue. "
                "This map will be used by visitors to navigate inside the building.",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 13,
            ),
          ),

        ] else ...[

          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.orange.shade100,
              ),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Icon(
                  Icons.map_outlined,
                  color: Colors.orange,
                ),

                SizedBox(width: 12),

                Expanded(
                  child: Text(
                    "Outdoor events will automatically use "
                        "OpenStreetMap navigation. Visitors can "
                        "navigate directly to booths without "
                        "uploading a floorplan.",
                    style: TextStyle(
                      height: 1.4,
                    ),
                  ),
                ),

              ],
            ),
          ),

        ],

        const SizedBox(height: 30),

      ],
    );
  }
}