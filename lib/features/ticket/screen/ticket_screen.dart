import 'package:flutter/material.dart';
import 'package:eventra/core/theme/app_color.dart';

const Color kMutedTextColor = Color(0xFF5A6266);

/// Formats an int amount as Indonesian Rupiah, e.g. 150000 -> "Rp150.000"
String formatRupiah(num amount) {
  final str = amount.round().toString();
  final buffer = StringBuffer();
  final reversed = str.split('').reversed.toList();

  for (int i = 0; i < reversed.length; i++) {
    buffer.write(reversed[i]);
    final nextIsGroupBreak = (i + 1) % 3 == 0 && i + 1 != reversed.length;
    if (nextIsGroupBreak) buffer.write('.');
  }

  return 'Rp${buffer.toString().split('').reversed.join()}';
}

class TicketScreen extends StatefulWidget {
  final String eventName;

  const TicketScreen({
    super.key,
    required this.eventName,
  });

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  int selectedCategory = 0;

  final List<String> categories = [
    'Clown Show',
    'Aquatic Show',
  ];

  // Each category now has its own independent ticket list.
  late final List<List<TicketType>> ticketsByCategory = [
    // Clown Show
    const [
      TicketType(name: 'Adult (13-64)', price: 150000),
      TicketType(name: 'Child (4-12)', price: 100000),
      TicketType(name: 'Group Bundle (5+)', price: 500000),
      TicketType(name: 'VVIP Ticket', price: 1000000),
    ],
    // Aquatic Show
    const [
      TicketType(
        name: 'Adult (13-64)',
        price: 200000,
        description:
            'Valid for one aquatic show entry on the selected date and '
            'time slot. Ponchos provided at splash zones. Non-refundable '
            'but may be rescheduled up to 24 hours before your visit.',
      ),
      TicketType(
        name: 'Child (4-12)',
        price: 150000,
        description:
            'Valid for one aquatic show entry on the selected date and '
            'time slot. Ponchos provided at splash zones. Non-refundable '
            'but may be rescheduled up to 24 hours before your visit.',
      ),
      TicketType(name: 'Group Bundle (5+)', price: 700000),
      TicketType(name: 'VVIP Ticket', price: 1500000),
    ],
  ];

  // Quantities are tracked separately per category so switching tabs
  // doesn't wipe out what the user already selected elsewhere.
  late final List<List<int>> quantitiesByCategory = List.generate(
    ticketsByCategory.length,
    (i) => List.filled(ticketsByCategory[i].length, 0),
  );

  List<TicketType> get tickets => ticketsByCategory[selectedCategory];
  List<int> get quantities => quantitiesByCategory[selectedCategory];

  void increaseQuantity(int index) {
    setState(() {
      quantitiesByCategory[selectedCategory][index]++;
    });
  }

  void decreaseQuantity(int index) {
    if (quantitiesByCategory[selectedCategory][index] == 0) return;

    setState(() {
      quantitiesByCategory[selectedCategory][index]--;
    });
  }

  // Totals across ALL categories, so the checkout bar reflects the whole
  // cart even if tickets were picked under more than one category.
  num get totalPrice {
    num total = 0;

    for (int c = 0; c < ticketsByCategory.length; c++) {
      final catTickets = ticketsByCategory[c];
      final catQuantities = quantitiesByCategory[c];
      for (int i = 0; i < catTickets.length; i++) {
        total += catTickets[i].price * catQuantities[i];
      }
    }

    return total;
  }

  int get totalTickets {
    int total = 0;
    for (final catQuantities in quantitiesByCategory) {
      total += catQuantities.fold(0, (sum, quantity) => sum + quantity);
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xffF7F8FA),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 28,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.eventName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 104),
              children: [
                Row(
                  children: List.generate(
                    categories.length,
                    (index) {
                      final isSelected = selectedCategory == index;

                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: index == categories.length - 1 ? 0 : 8,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedCategory = index;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              curve: Curves.easeOut,
                              height: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColor.primary
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColor.primary
                                      : const Color(0xFFE1E3E5),
                                  width: 1,
                                ),
                              ),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: Text(
                                    categories[index],
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black87,
                                      fontSize: 14,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 18),

                // Keyed by ticket name so Flutter doesn't reuse/confuse
                // widget state when switching between categories.
                ...tickets.asMap().entries.map(
                  (entry) {
                    final index = entry.key;
                    final ticket = entry.value;

                    return Padding(
                      key: ValueKey('$selectedCategory-${ticket.name}'),
                      padding: const EdgeInsets.only(bottom: 12),
                      child: TicketCard(
                        ticket: ticket,
                        quantity: quantities[index],
                        onAdd: () {
                          increaseQuantity(index);
                        },
                        onRemove: () {
                          decreaseQuantity(index);
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),

      bottomNavigationBar: totalTickets > 0
          ? Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    offset: Offset(0, -3),
                    color: Color(0x14000000),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Checkout. Integration with supa or midtrans?
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Get It — ${formatRupiah(totalPrice)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ),
              ),
            )
          : null,
    );
  }
}

class TicketType {
  final String name;
  final num price;
  final String description;

  const TicketType({
    required this.name,
    required this.price,
    this.description =
        'Valid for one museum entry on the selected date and time slot. '
        'Includes access to all permanent exhibits. Non-refundable but '
        'may be rescheduled up to 24 hours before your visit.',
  });
}

class TicketCard extends StatefulWidget {
  final TicketType ticket;
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const TicketCard({
    super.key,
    required this.ticket,
    required this.quantity,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  State<TicketCard> createState() => _TicketCardState();
}

class _TicketCardState extends State<TicketCard> {
  bool expanded = false;

  bool get isActive => widget.quantity > 0;

  @override
  Widget build(BuildContext context) {
    final borderColor = isActive ? AppColor.primary : Color(0xFFD2D6D8);

    return _CornerFoldWrapper(
      showFold: isActive,
      radius: 14,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        constraints: const BoxConstraints(minHeight: 122),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: borderColor,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppColor.primary.withOpacity(0.14),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  const BoxShadow(
                    color: Color(0x08000000),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 58,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 14, 10, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.ticket.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15.5,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),

                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          setState(() {
                            expanded = !expanded;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                expanded ? 'Less info' : 'More info',
                                style: const TextStyle(
                                  color: AppColor.primaryTextColor,
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 3),
                              AnimatedRotation(
                                duration:
                                    const Duration(milliseconds: 180),
                                turns: expanded ? 0.5 : 0,
                                child: const Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 16,
                                  color: AppColor.primaryTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      if (expanded)
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 4,
                            bottom: 8,
                            right: 8,
                          ),
                          child: Text(
                            widget.ticket.description,
                            style: const TextStyle(
                              color: kMutedTextColor,
                              fontSize: 12,
                              height: 1.35,
                            ),
                          ),
                        ),

                      const SizedBox(height: 4),
                      Text(
                        formatRupiah(widget.ticket.price),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              _TicketDivider(
                color: borderColor,
              ),

              Expanded(
                flex: 42,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColor.primary.withOpacity(0.08)
                        : Colors.white,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Center(
                    child: QuantitySelector(
                      quantity: widget.quantity,
                      onAdd: widget.onAdd,
                      onRemove: widget.onRemove,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TicketDivider extends StatelessWidget {
  final Color color;

  const _TicketDivider({required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 12,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 11),
            child: CustomPaint(
              size: const Size(1, double.infinity),
              painter: _DashedLinePainter(color: color),
            ),
          ),
          const Positioned(
            top: -6,
            child: _Notch(),
          ),
          Positioned(
            top: -6,
            child: _NotchBorder(color: color),
          ),
          const Positioned(
            bottom: -6,
            child: _Notch(),
          ),
          Positioned(
            bottom: -6,
            child: _NotchBorder(color: color),
          ),
        ],
      ),
    );
  }
}

class _Notch extends StatelessWidget {
  const _Notch();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _NotchBorder extends StatelessWidget {
  final Color color;

  const _NotchBorder({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 1.3),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;
  static const double dashHeight = 4;
  static const double dashGap = 4;

  _DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5;

    double startY = 0;
    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashGap;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedLinePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class _CornerFoldWrapper extends StatelessWidget {
  final Widget child;
  final bool showFold;
  final double radius;

  const _CornerFoldWrapper({
    required this.child,
    required this.showFold,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    if (!showFold) return child;

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Stack(
        children: [
          child,
          Positioned(
            top: 0,
            right: 0,
            child: ClipPath(
              clipper: _CornerFoldClipper(),
              child: Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(
                  color: AppColor.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CornerFoldClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = quantity > 0;

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _RoundIconButton(
            icon: Icons.remove,
            enabled: isEnabled,
            onPressed: isEnabled ? onRemove : null,
          ),

          SizedBox(
            width: 30,
            child: Text(
              '$quantity',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          _RoundIconButton(
            icon: Icons.add,
            enabled: true,
            onPressed: onAdd,
          ),
        ],
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback? onPressed;

  const _RoundIconButton({
    required this.icon,
    required this.enabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: enabled ? AppColor.primary.withOpacity(0.16) : Color(0xFFEDEEEF),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 34,
          height: 34,
          child: Icon(
            icon,
            size: 18,
            color: enabled ? AppColor.primaryTextColor : Color(0xFFAAB0B3),
          ),
        ),
      ),
    );
  }
}