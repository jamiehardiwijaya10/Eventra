import 'package:flutter/material.dart';
import 'package:eventra/core/theme/app_color.dart';
import '../../ticket/services/ticket_service.dart';
import 'checkout_page.dart';

const Color kMutedTextColor = Color(0xFF5A6266);

String formatRupiah(num amount) {
  final str = amount.round().toString();
  final buffer = StringBuffer();
  final reversed = str.split('').reversed.toList();

  for (int i = 0; i < reversed.length; i++) {
    buffer.write(reversed[i]);

    final nextIsGroupBreak =
        (i + 1) % 3 == 0 && i + 1 != reversed.length;

    if (nextIsGroupBreak) {
      buffer.write('.');
    }
  }

  return 'Rp${buffer.toString().split('').reversed.join()}';
}

class TicketScreen extends StatefulWidget {
  final String eventId;
  final String eventName;

  const TicketScreen({
    super.key,
    required this.eventId,
    required this.eventName,
  });

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  final TicketService _ticketService = TicketService();

  List<TicketType> tickets = [];
  List<int> quantities = [];

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadTickets();
  }

  Future<void> loadTickets() async {
    try {
      if (mounted) {
        setState(() {
          isLoading = true;
          errorMessage = null;
        });
      }

      final data = await _ticketService.getTickets(
        widget.eventId,
      );

      final loadedTickets = data
          .where((ticket) {
        final status =
        ticket['calculated_status']?.toString();

        return status == 'on_sale';
      })
          .map((ticket) {
        return TicketType(
          id: ticket['id']?.toString() ?? '',
          name: ticket['name']?.toString() ?? '',
          price: _parsePrice(ticket['price']),
          description:
          ticket['description']?.toString() ?? '',
          quota: _parseInt(ticket['quota']),
          sold: _parseInt(ticket['sold']),
          maxPerUser: _parseInt(
            ticket['max_per_user'],
          ) >
              0
              ? _parseInt(ticket['max_per_user'])
              : 1,
        );
      })
          .toList();

      if (!mounted) return;

      setState(() {
        tickets = loadedTickets;

        quantities = List.filled(
          loadedTickets.length,
          0,
        );

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

  num _parsePrice(dynamic value) {
    if (value is num) {
      return value;
    }

    return num.tryParse(
      value?.toString() ?? '',
    ) ??
        0;
  }

  int _parseInt(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(
      value?.toString() ?? '',
    ) ??
        0;
  }

  void increaseQuantity(int index) {
    final ticket = tickets[index];
    final currentQuantity = quantities[index];

    if (currentQuantity >= ticket.maxPerUser) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Maximum ${ticket.maxPerUser} ticket(s) per user.',
          ),
        ),
      );
      return;
    }

    if (currentQuantity >= ticket.remaining) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Ticket quota is no longer available.',
          ),
        ),
      );
      return;
    }

    setState(() {
      quantities[index]++;
    });
  }

  void decreaseQuantity(int index) {
    if (quantities[index] <= 0) {
      return;
    }

    setState(() {
      quantities[index]--;
    });
  }

  num get totalPrice {
    num total = 0;

    for (int i = 0; i < tickets.length; i++) {
      total += tickets[i].price * quantities[i];
    }

    return total;
  }

  int get totalTickets {
    return quantities.fold(
      0,
          (sum, quantity) => sum + quantity,
    );
  }

  void proceedToCheckout() {
    final selectedItems = <CheckoutTicketItem>[];

    for (int i = 0; i < tickets.length; i++) {
      if (quantities[i] <= 0) {
        continue;
      }

      selectedItems.add(
        CheckoutTicketItem(
          ticketId: tickets[i].id,
          name: tickets[i].name,
          price: tickets[i].price,
          quantity: quantities[i],
        ),
      );
    }

    if (selectedItems.isEmpty) {
      return;
    }

    debugPrint(
      'EVENT ID: ${widget.eventId}',
    );

    debugPrint(
      'SELECTED ITEMS: ${selectedItems.length}',
    );

    debugPrint(
      'TOTAL TICKETS: $totalTickets',
    );

    debugPrint(
      'TOTAL PRICE: $totalPrice',
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CheckoutPage(
          eventId: widget.eventId,
          eventName: widget.eventName,
          items: selectedItems,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
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
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color(0xffF7F8FA),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
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
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 52,
                  color: Colors.red,
                ),

                const SizedBox(height: 16),

                const Text(
                  'Failed to load tickets',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: loadTickets,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Retry',
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (tickets.isEmpty) {
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
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.confirmation_number_outlined,
                  size: 56,
                  color: Colors.grey,
                ),

                SizedBox(height: 16),

                Text(
                  'No tickets available',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                SizedBox(height: 8),

                Text(
                  'There are currently no tickets '
                      'available for this event.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

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
              padding: const EdgeInsets.fromLTRB(
                20,
                16,
                20,
                104,
              ),
              children: [
                const Text(
                  'Available Tickets',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  'Choose your ticket for this event.',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 20),

                ...tickets.asMap().entries.map(
                      (entry) {
                    final index = entry.key;
                    final ticket = entry.value;

                    return Padding(
                      key: ValueKey(ticket.id),
                      padding: const EdgeInsets.only(
                        bottom: 12,
                      ),
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
        padding: const EdgeInsets.fromLTRB(
          20,
          12,
          20,
          16,
        ),
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
              onPressed: proceedToCheckout,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                AppColor.primary,
                foregroundColor: Colors.white,
                padding:
                const EdgeInsets.symmetric(
                  vertical: 14,
                ),
                shape:
                RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(10),
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
  final String id;
  final String name;
  final num price;
  final String description;
  final int quota;
  final int sold;
  final int maxPerUser;

  const TicketType({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.quota,
    required this.sold,
    required this.maxPerUser,
  });

  int get remaining {
    final value = quota - sold;

    return value < 0 ? 0 : value;
  }
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
  State<TicketCard> createState() =>
      _TicketCardState();
}

class _TicketCardState extends State<TicketCard> {
  bool expanded = false;

  bool get isActive {
    return widget.quantity > 0;
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = isActive
        ? AppColor.primary
        : const Color(0xFFD2D6D8);

    return _CornerFoldWrapper(
      showFold: isActive,
      radius: 14,
      child: AnimatedContainer(
        duration:
        const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        constraints:
        const BoxConstraints(minHeight: 122),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: borderColor,
            width: 1.5,
          ),
          borderRadius:
          BorderRadius.circular(14),
          boxShadow: isActive
              ? [
            BoxShadow(
              color: AppColor.primary
                  .withOpacity(0.14),
              blurRadius: 10,
              offset:
              const Offset(0, 4),
            ),
          ]
              : [
            const BoxShadow(
              color: Color(0x08000000),
              blurRadius: 6,
              offset:
              Offset(0, 2),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment:
            CrossAxisAlignment.stretch,
            children: [

              Expanded(
                flex: 58,
                child: Padding(
                  padding:
                  const EdgeInsets.fromLTRB(
                    18,
                    14,
                    10,
                    14,
                  ),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    mainAxisSize:
                    MainAxisSize.min,
                    children: [
                      Text(
                        widget.ticket.name,
                        maxLines: 2,
                        overflow:
                        TextOverflow.ellipsis,
                        style:
                        const TextStyle(
                          color: Colors.black,
                          fontSize: 15.5,
                          fontWeight:
                          FontWeight.w700,
                          height: 1.2,
                        ),
                      ),

                      const SizedBox(height: 4),

                      GestureDetector(
                        behavior:
                        HitTestBehavior.opaque,
                        onTap: () {
                          setState(() {
                            expanded =
                            !expanded;
                          });
                        },
                        child: Padding(
                          padding:
                          const EdgeInsets
                              .symmetric(
                            vertical: 2,
                          ),
                          child: Row(
                            mainAxisSize:
                            MainAxisSize.min,
                            children: [
                              Text(
                                expanded
                                    ? 'Less info'
                                    : 'More info',
                                style:
                                const TextStyle(
                                  color: AppColor
                                      .primaryTextColor,
                                  fontSize: 12.5,
                                  fontWeight:
                                  FontWeight.w600,
                                ),
                              ),

                              const SizedBox(
                                width: 3,
                              ),

                              AnimatedRotation(
                                duration:
                                const Duration(
                                  milliseconds: 180,
                                ),
                                turns:
                                expanded
                                    ? 0.5
                                    : 0,
                                child:
                                const Icon(
                                  Icons
                                      .keyboard_arrow_down,
                                  size: 16,
                                  color: AppColor
                                      .primaryTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      if (expanded)
                        Padding(
                          padding:
                          const EdgeInsets
                              .only(
                            top: 4,
                            bottom: 8,
                            right: 8,
                          ),
                          child: Text(
                            widget.ticket
                                .description
                                .isEmpty
                                ? 'No description available.'
                                : widget.ticket
                                .description,
                            style:
                            const TextStyle(
                              color:
                              kMutedTextColor,
                              fontSize: 12,
                              height: 1.35,
                            ),
                          ),
                        ),

                      const SizedBox(height: 4),

                      Text(
                        formatRupiah(
                          widget.ticket.price,
                        ),
                        style:
                        const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight:
                          FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        '${widget.ticket.remaining} tickets left',
                        style:
                        const TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
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
                  duration:
                  const Duration(
                    milliseconds: 180,
                  ),
                  decoration:
                  BoxDecoration(
                    color: isActive
                        ? AppColor.primary
                        .withOpacity(0.08)
                        : Colors.white,
                    borderRadius:
                    const BorderRadius.only(
                      topRight:
                      Radius.circular(12),
                      bottomRight:
                      Radius.circular(12),
                    ),
                  ),
                  padding:
                  const EdgeInsets
                      .symmetric(
                    horizontal: 4,
                  ),
                  child: Center(
                    child:
                    QuantitySelector(
                      quantity:
                      widget.quantity,
                      onAdd:
                      widget.onAdd,
                      onRemove:
                      widget.onRemove,
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

class _TicketDivider
    extends StatelessWidget {
  final Color color;

  const _TicketDivider({
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 12,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding:
            const EdgeInsets.symmetric(
              vertical: 11,
            ),
            child: CustomPaint(
              size:
              const Size(1, double.infinity),
              painter:
              _DashedLinePainter(
                color: color,
              ),
            ),
          ),

          const Positioned(
            top: -6,
            child: _Notch(),
          ),

          Positioned(
            top: -6,
            child: _NotchBorder(
              color: color,
            ),
          ),

          const Positioned(
            bottom: -6,
            child: _Notch(),
          ),

          Positioned(
            bottom: -6,
            child: _NotchBorder(
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _Notch
    extends StatelessWidget {
  const _Notch();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration:
      const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _NotchBorder
    extends StatelessWidget {
  final Color color;

  const _NotchBorder({
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: color,
          width: 1.3,
        ),
      ),
    );
  }
}

class _DashedLinePainter
    extends CustomPainter {
  final Color color;

  static const double dashHeight = 4;
  static const double dashGap = 4;

  _DashedLinePainter({
    required this.color,
  });

  @override
  void paint(
      Canvas canvas,
      Size size,
      ) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5;

    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(
          size.width / 2,
          startY,
        ),
        Offset(
          size.width / 2,
          startY + dashHeight,
        ),
        paint,
      );

      startY +=
          dashHeight + dashGap;
    }
  }

  @override
  bool shouldRepaint(
      covariant _DashedLinePainter
      oldDelegate,
      ) {
    return oldDelegate.color !=
        color;
  }
}

class _CornerFoldWrapper
    extends StatelessWidget {
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
    if (!showFold) {
      return child;
    }

    return ClipRRect(
      borderRadius:
      BorderRadius.circular(radius),
      child: Stack(
        children: [
          child,

          Positioned(
            top: 0,
            right: 0,
            child: ClipPath(
              clipper:
              _CornerFoldClipper(),
              child: Container(
                width: 16,
                height: 16,
                decoration:
                const BoxDecoration(
                  color:
                  AppColor.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CornerFoldClipper
    extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(
      size.width,
      0,
    );

    path.lineTo(
      size.width,
      size.height,
    );

    path.lineTo(
      0,
      0,
    );

    path.close();

    return path;
  }

  @override
  bool shouldReclip(
      covariant CustomClipper<Path>
      oldClipper,
      ) {
    return false;
  }
}

class QuantitySelector
    extends StatelessWidget {
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
    final isEnabled =
        quantity > 0;

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisSize:
        MainAxisSize.min,
        children: [
          _RoundIconButton(
            icon: Icons.remove,
            enabled: isEnabled,
            onPressed:
            isEnabled
                ? onRemove
                : null,
          ),

          SizedBox(
            width: 30,
            child: Text(
              '$quantity',
              textAlign:
              TextAlign.center,
              style:
              const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight:
                FontWeight.w600,
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

class _RoundIconButton
    extends StatelessWidget {
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
      color: enabled
          ? AppColor.primary
          .withOpacity(0.16)
          : const Color(0xFFEDEEEF),
      shape:
      const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder:
        const CircleBorder(),
        child: SizedBox(
          width: 34,
          height: 34,
          child: Icon(
            icon,
            size: 18,
            color: enabled
                ? AppColor
                .primaryTextColor
                : const Color(
              0xFFAAB0B3,
            ),
          ),
        ),
      ),
    );
  }
}