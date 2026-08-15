import 'package:flutter/material.dart';
import '../../../core/theme/app_color.dart';
import '../../ticket/services/ticket_service.dart';

class CreateTicketPage extends StatefulWidget {
  final String eventId;

  const CreateTicketPage({
    super.key,
    required this.eventId,
  });

  @override
  State<CreateTicketPage> createState() =>
      _CreateTicketPageState();
}

class _CreateTicketPageState extends State<CreateTicketPage> {
  final _formKey = GlobalKey<FormState>();
  final TicketService _ticketService = TicketService();
  final ticketNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final quotaController = TextEditingController();
  final maxPerUserController = TextEditingController();

  DateTime? saleStart;
  DateTime? saleEnd;

  @override
  void dispose() {
    ticketNameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    quotaController.dispose();
    maxPerUserController.dispose();
    super.dispose();
  }

  Future<void> selectSaleStart() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: saleStart ?? DateTime.now(),
    );

    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time == null || !mounted) return;

    setState(() {
      saleStart = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<void> selectSaleEnd() async {
    final firstDate = saleStart ?? DateTime.now();

    final date = await showDatePicker(
      context: context,
      firstDate: firstDate,
      lastDate: DateTime(2100),
      initialDate: saleEnd ?? firstDate,
    );

    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time == null || !mounted) return;

    setState(() {
      saleEnd = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  String formatDateTime(DateTime? value) {
    if (value == null) {
      return 'Select date & time';
    }

    final date =
        '${value.day.toString().padLeft(2, '0')}/'
        '${value.month.toString().padLeft(2, '0')}/'
        '${value.year}';

    final hour =
    value.hour.toString().padLeft(2, '0');

    final minute =
    value.minute.toString().padLeft(2, '0');

    return '$date • $hour:$minute';
  }

  Future<void> createTicket() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (saleStart == null || saleEnd == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please select the ticket sale period.',
          ),
        ),
      );
      return;
    }

    if (saleEnd!.isBefore(saleStart!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Sale end must be after sale start.',
          ),
        ),
      );
      return;
    }

    try {
      await _ticketService.createTicket(
        eventId: widget.eventId,
        name: ticketNameController.text.trim(),
        description: descriptionController.text.trim(),
        price: double.tryParse(priceController.text) ?? 0,
        quota: int.tryParse(quotaController.text) ?? 0,
        maxPerUser:
        int.tryParse(maxPerUserController.text) ?? 1,
        saleStart: saleStart,
        saleEnd: saleEnd,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ticket created successfully.'),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to create ticket: $e',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Create Ticket',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Ticket Information',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Configure a ticket type for your event.',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 25),

            _FormLabel(
              label: 'Ticket Name',
              required: true,
            ),

            const SizedBox(height: 8),

            _TextInput(
              controller: ticketNameController,
              hint: 'e.g. Early Bird',
              icon: Icons.confirmation_number_outlined,
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty) {
                  return 'Ticket name is required';
                }

                return null;
              },
            ),

            const SizedBox(height: 20),

            _FormLabel(
              label: 'Description',
              required: false,
            ),

            const SizedBox(height: 8),

            _TextInput(
              controller: descriptionController,
              hint: 'Describe this ticket...',
              icon: Icons.description_outlined,
              maxLines: 4,
            ),

            const SizedBox(height: 20),

            _FormLabel(
              label: 'Price',
              required: true,
            ),

            const SizedBox(height: 8),

            _TextInput(
              controller: priceController,
              hint: '25000',
              icon: Icons.payments_outlined,
              keyboardType:
              TextInputType.number,
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty) {
                  return 'Price is required';
                }

                final price =
                double.tryParse(value);

                if (price == null ||
                    price < 0) {
                  return 'Enter a valid price';
                }

                return null;
              },
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      _FormLabel(
                        label: 'Ticket Quota',
                        required: true,
                      ),

                      const SizedBox(height: 8),

                      _TextInput(
                        controller:
                        quotaController,
                        hint: '200',
                        icon:
                        Icons.inventory_2_outlined,
                        keyboardType:
                        TextInputType.number,
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty) {
                            return 'Required';
                          }

                          final quota =
                          int.tryParse(value);

                          if (quota == null ||
                              quota <= 0) {
                            return 'Invalid quota';
                          }

                          return null;
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      _FormLabel(
                        label: 'Max / User',
                        required: true,
                      ),

                      const SizedBox(height: 8),

                      _TextInput(
                        controller:
                        maxPerUserController,
                        hint: '5',
                        icon:
                        Icons.person_outline,
                        keyboardType:
                        TextInputType.number,
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty) {
                            return 'Required';
                          }

                          final max =
                          int.tryParse(value);

                          if (max == null ||
                              max <= 0) {
                            return 'Invalid';
                          }

                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            const Text(
              'Sale Period',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 12),

            _DateTimeCard(
              title: 'Sale Start',
              value:
              formatDateTime(saleStart),
              icon: Icons.play_circle_outline,
              onTap: selectSaleStart,
            ),

            const SizedBox(height: 12),

            _DateTimeCard(
              title: 'Sale End',
              value:
              formatDateTime(saleEnd),
              icon: Icons.stop_circle_outlined,
              onTap: selectSaleEnd,
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: createTicket,
                style:
                ElevatedButton.styleFrom(
                  backgroundColor:
                  AppColor.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding:
                  const EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                  shape:
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Create Ticket',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                    FontWeight.w700,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _FormLabel extends StatelessWidget {
  final String label;
  final bool required;

  const _FormLabel({
    required this.label,
    required this.required,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (required)
          const Text(
            ' *',
            style: TextStyle(
              color: Colors.red,
            ),
          ),
      ],
    );
  }
}

class _TextInput extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final int maxLines;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _TextInput({
    required this.controller,
    required this.hint,
    required this.icon,
    this.maxLines = 1,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
        const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xffE1E3E5),
          ),
        ),
        enabledBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xffE1E3E5),
          ),
        ),
        focusedBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColor.primary,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}

class _DateTimeCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final VoidCallback onTap;

  const _DateTimeCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius:
      BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
          BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xffE1E3E5),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColor.primary
                    .withOpacity(0.10),
                borderRadius:
                BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: AppColor.primary,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}