import 'package:flutter/material.dart';
import '../../../core/theme/app_color.dart';
import 'create_ticket_page.dart';
import '../../ticket/services/ticket_service.dart';
import 'edit_ticket_page.dart';

class TicketManagementPage extends StatefulWidget {
  final String eventId;

  const TicketManagementPage({
    super.key,
    required this.eventId,
  });

  @override
  State<TicketManagementPage> createState() =>
      _TicketManagementPageState();
}

class _TicketManagementPageState
    extends State<TicketManagementPage> {
  final TicketService _ticketService = TicketService();

  List<TicketTypeData> tickets = [];

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadTickets();
  }

  Future<void> loadTickets() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final data = await _ticketService.getTickets(
        widget.eventId,
      );

      final loadedTickets = data.map((ticket) {
        final saleStart = ticket['sale_start'] != null
            ? DateTime.parse(
          ticket['sale_start'].toString(),
        ).toLocal()
            : null;

        final saleEnd = ticket['sale_end'] != null
            ? DateTime.parse(
          ticket['sale_end'].toString(),
        ).toLocal()
            : null;

        final sold = int.tryParse(
          ticket['sold']?.toString() ?? '0',
        ) ??
            0;

        final quota = int.tryParse(
          ticket['quota']?.toString() ?? '0',
        ) ??
            0;

        return TicketTypeData(
          id: ticket['id']?.toString() ?? '',
          name: ticket['name']?.toString() ?? '',
          description:
          ticket['description']?.toString() ?? '',
          price: ticket['price'] ?? 0,
          quota: quota,
          sold: sold,
          maxPerUser: int.tryParse(
            ticket['max_per_user']?.toString() ?? '1',
          ) ??
              1,
          status: calculateTicketStatus(
            status: ticket['status']?.toString() ?? 'upcoming',
            saleStart: saleStart,
            saleEnd: saleEnd,
            sold: sold,
            quota: quota,
          ),
        );
      }).toList();

      if (!mounted) return;

      setState(() {
        tickets = loadedTickets;
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

  TicketStatus calculateTicketStatus({
    required String status,
    required DateTime? saleStart,
    required DateTime? saleEnd,
    required int sold,
    required int quota,
  }) {
    final now = DateTime.now();

    if (status == 'disabled') {
      return TicketStatus.ended;
    }

    if (quota > 0 && sold >= quota) {
      return TicketStatus.soldOut;
    }

    if (saleStart != null && now.isBefore(saleStart)) {
      return TicketStatus.upcoming;
    }

    if (saleEnd != null && now.isAfter(saleEnd)) {
      return TicketStatus.ended;
    }

    return TicketStatus.onSale;
  }

  String formatRupiah(num amount) {
    final value = amount.round().toString();
    final buffer = StringBuffer();

    final reversed = value.split('').reversed.toList();

    for (int i = 0; i < reversed.length; i++) {
      buffer.write(reversed[i]);

      if ((i + 1) % 3 == 0 &&
          i + 1 != reversed.length) {
        buffer.write('.');
      }
    }

    return 'Rp${buffer.toString().split('').reversed.join()}';
  }

  int get totalSold {
    return tickets.fold(
      0,
          (sum, ticket) => sum + ticket.sold,
    );
  }

  int get totalQuota {
    return tickets.fold(
      0,
          (sum, ticket) => sum + ticket.quota,
    );
  }

  Future<void> addTicket() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CreateTicketPage(
          eventId: widget.eventId,
        ),
      ),
    );

    if (result != true || !mounted) return;

    await loadTickets();
  }

  Future<void> editTicket(TicketTypeData ticket) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditTicketPage(
          ticket: ticket,
        ),
      ),
    );

    if (result != true || !mounted) return;

    await loadTickets();
  }

  void showTicketOptions(TicketTypeData ticket) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 12,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.edit_outlined,
                  ),
                  title: const Text('Edit Ticket'),
                  onTap: () {
                    Navigator.pop(context);
                    editTicket(ticket);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.visibility_outlined,
                  ),
                  title: const Text('View Details'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.delete_outline,
                    color: Colors.red.shade600,
                  ),
                  title: Text(
                    'Delete Ticket',
                    style: TextStyle(
                      color: Colors.red.shade600,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    deleteTicket(ticket);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> deleteTicket(TicketTypeData ticket) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Ticket?'),
          content: Text(
            'Are you sure you want to delete "${ticket.name}"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    try {
      await _ticketService.deleteTicket(ticket.id);

      if (!mounted) return;

      setState(() {
        tickets.removeWhere((item) => item.id == ticket.id);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ticket deleted successfully.'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete ticket: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xffF7F8FA),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        backgroundColor: const Color(0xffF7F8FA),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'Ticket Management',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Failed to load tickets:\n$errorMessage',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            title: const Text(
              'Ticket Management',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text(
                'Event Tickets',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'Create and manage tickets available '
                    'for your event.',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 20),

              _TicketSummaryCard(
                totalQuota: totalQuota,
                totalSold: totalSold,
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Ticket Types',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  Text(
                    '${tickets.length} types',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              if (tickets.isEmpty)
                _EmptyTicketState(
                  onAddTicket: addTicket,
                )
              else
                ...tickets.map(
                      (ticket) =>
                      Padding(
                        padding:
                        const EdgeInsets.only(bottom: 14),
                        child: _TicketManagementCard(
                          ticket: ticket,
                          formatRupiah: formatRupiah,
                          onEdit: () {
                            editTicket(ticket);
                          },
                          onMore: () {
                            showTicketOptions(ticket);
                          },
                        ),
                      ),
                ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: addTicket,
                  icon: const Icon(Icons.add),
                  label: const Text(
                    'Add Ticket Type',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding:
                    const EdgeInsets.symmetric(
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        );
      }
    }

      class _TicketManagementCard
          extends StatelessWidget {
        final TicketTypeData ticket;
        final String Function(num) formatRupiah;
        final VoidCallback onEdit;
        final VoidCallback onMore;

        const _TicketManagementCard({
          required this.ticket,
          required this.formatRupiah,
          required this.onEdit,
          required this.onMore,
        });

        @override
        Widget build(BuildContext context) {
          final remaining =
              ticket.quota - ticket.sold;

          final progress = ticket.quota == 0
              ? 0.0
              : ticket.sold / ticket.quota;

          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
              BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xffE5E7E9),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x08000000),
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.all(17),

            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  ticket.name,
                                  style:
                                  const TextStyle(
                                    fontSize: 17,
                                    fontWeight:
                                    FontWeight.w700,
                                  ),
                                ),
                              ),

                              const SizedBox(width: 8),

                              _StatusBadge(
                                status: ticket.status,
                              ),
                            ],
                          ),

                          const SizedBox(height: 6),

                          Text(
                            ticket.description,
                            maxLines: 2,
                            overflow:
                            TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),

                    IconButton(
                      onPressed: onMore,
                      icon: const Icon(
                        Icons.more_vert,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                Text(
                  formatRupiah(ticket.price),
                  style: TextStyle(
                    color: AppColor.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: _InfoItem(
                        label: 'Quota',
                        value:
                        '${ticket.quota}',
                      ),
                    ),
                    Expanded(
                      child: _InfoItem(
                        label: 'Sold',
                        value:
                        '${ticket.sold}',
                      ),
                    ),
                    Expanded(
                      child: _InfoItem(
                        label: 'Remaining',
                        value:
                        '$remaining',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                ClipRRect(
                  borderRadius:
                  BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress.clamp(
                      0.0,
                      1.0,
                    ),
                    minHeight: 7,
                    backgroundColor:
                    const Color(0xffECEEEF),
                    valueColor:
                    AlwaysStoppedAnimation<Color>(
                      AppColor.primary,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${ticket.sold} sold',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      '${(progress * 100).round()}% sold',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: onEdit,
                    icon: const Icon(
                      Icons.edit_outlined,
                      size: 18,
                    ),
                    label: const Text(
                      'Edit Ticket',
                    ),
                    style:
                    OutlinedButton.styleFrom(
                      foregroundColor:
                      AppColor.primary,
                      side: BorderSide(
                        color: AppColor.primary,
                      ),
                      padding:
                      const EdgeInsets.symmetric(
                        vertical: 12,
                      ),
                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      }

      class _TicketSummaryCard
          extends StatelessWidget {
        final int totalQuota;
        final int totalSold;

        const _TicketSummaryCard({
          required this.totalQuota,
          required this.totalSold,
        });

        @override
        Widget build(BuildContext context) {
          final remaining =
              totalQuota - totalSold;

          return Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColor.primary,
              borderRadius:
              BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ticket Overview',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  'Sales Performance',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 18),

                Row(
                  children: [
                    Expanded(
                      child: _SummaryItem(
                        label: 'Total Quota',
                        value:
                        '$totalQuota',
                      ),
                    ),
                    Expanded(
                      child: _SummaryItem(
                        label: 'Tickets Sold',
                        value:
                        '$totalSold',
                      ),
                    ),
                    Expanded(
                      child: _SummaryItem(
                        label: 'Remaining',
                        value:
                        '$remaining',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
      }

      class _SummaryItem
          extends StatelessWidget {
        final String label;
        final String value;

        const _SummaryItem({
          required this.label,
          required this.value,
        });

        @override
        Widget build(BuildContext context) {
          return Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                ),
              ),
            ],
          );
        }
      }

      class _InfoItem
          extends StatelessWidget {
        final String label;
        final String value;

        const _InfoItem({
          required this.label,
          required this.value,
        });

        @override
        Widget build(BuildContext context) {
          return Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          );
        }
      }

      class _StatusBadge
          extends StatelessWidget {
        final TicketStatus status;

        const _StatusBadge({
          required this.status,
        });

        @override
        Widget build(BuildContext context) {
          String text;
          Color color;

          switch (status) {
            case TicketStatus.onSale:
              text = 'On Sale';
              color = Colors.green;
              break;

            case TicketStatus.upcoming:
              text = 'Upcoming';
              color = Colors.orange;
              break;

            case TicketStatus.soldOut:
              text = 'Sold Out';
              color = Colors.red;
              break;

            case TicketStatus.ended:
              text = 'Ended';
              color = Colors.grey;
              break;
          }

          return Container(
            padding:
            const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: color.withOpacity(0.10),
              borderRadius:
              BorderRadius.circular(20),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          );
        }
      }

      class _EmptyTicketState
          extends StatelessWidget {
        final VoidCallback onAddTicket;

        const _EmptyTicketState({
          required this.onAddTicket,
        });

        @override
        Widget build(BuildContext context) {
          return Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
              BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xffE5E7E9),
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.confirmation_number_outlined,
                  size: 48,
                  color: Colors.grey.shade400,
                ),

                const SizedBox(height: 12),

                const Text(
                  'No Ticket Types Yet',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  'Create your first ticket type '
                      'for this event.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 18),

                ElevatedButton(
                  onPressed: onAddTicket,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    AppColor.primary,
                    foregroundColor:
                    Colors.white,
                    elevation: 0,
                  ),
                  child: const Text(
                    'Create Ticket',
                  ),
                ),
              ],
            ),
          );
        }
      }

      class TicketTypeData {
        final String id;
        final String name;
        final String description;
        final num price;
        final int quota;
        final int sold;
        final int maxPerUser;
        final TicketStatus status;

        TicketTypeData({
          required this.id,
          required this.name,
          required this.description,
          required this.price,
          required this.quota,
          required this.sold,
          required this.maxPerUser,
          required this.status,
        });
      }

      enum TicketStatus {
        upcoming,
        onSale,
        soldOut,
        ended,
      }