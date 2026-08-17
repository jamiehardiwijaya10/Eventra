import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_color.dart';

enum QueueStatus {
  sepi,
  sedang,
  ramai,
}

enum StockStatus {
  tersedia,
  terbatas,
  habis,
}

class BoothManagementDetailPage extends StatefulWidget {
  final String boothId;
  final String boothName;
  final String category;
  final String eventName;

  const BoothManagementDetailPage({
    super.key,
    required this.boothId,
    required this.boothName,
    required this.category,
    required this.eventName,
  });

  @override
  State<BoothManagementDetailPage> createState() =>
      _BoothManagementDetailPageState();
}

class _BoothManagementDetailPageState extends State<BoothManagementDetailPage> {
  final SupabaseClient _client = Supabase.instance.client;
  List<Map<String, dynamic>> stockItems = [];
  bool isLoading = true;
  String? error;

  String openCloseStatus = 'closed';
  TimeOfDay? openingTime;
  TimeOfDay? closingTime;

  QueueStatus queueStatus = QueueStatus.sepi;
  int estimatedWaitMinutes = 5;

  @override
  void initState() {
    super.initState();
    loadBoothDetail();
  }

  Future<void> loadBoothDetail() async {
    try {
      final boothResponse = await _client
          .from('booths')
          .select()
          .eq('id', widget.boothId)
          .single();

      final productResponse = await _client
          .from('products')
          .select()
          .eq('booth_id', widget.boothId)
          .order('name');

      if (!mounted) return;

      final opening = _parseTime(boothResponse['opening_hours']);
      final closing = _parseTime(boothResponse['closing_hours']);

      final autoStatus = _calculateOpenCloseStatus(
        opening,
        closing,
      );

      final savedQueueStatus = _parseQueueStatus(
        boothResponse['queue_status'],
      );

      setState(() {
        openingTime = opening;
        closingTime = closing;
        openCloseStatus = autoStatus;
        queueStatus = savedQueueStatus;
        estimatedWaitMinutes = _getWaitMinutes(savedQueueStatus);
        stockItems = List<Map<String, dynamic>>.from(productResponse);
        isLoading = false;
        error = null;
      });

      if (boothResponse['open_close_status'] != autoStatus) {
        await _client
            .from('booths')
            .update({
              'open_close_status': autoStatus,
            })
            .eq('id', widget.boothId);
      }
    } catch (e) {
      debugPrint("LOAD BOOTH DETAIL ERROR: $e");

      if (!mounted) return;

      setState(() {
        isLoading = false;
        error = e.toString();
      });
    }
  }

  QueueStatus _parseQueueStatus(dynamic value) {
    switch (value?.toString()) {
      case 'sedang':
        return QueueStatus.sedang;

      case 'ramai':
        return QueueStatus.ramai;

      case 'sepi':
      default:
        return QueueStatus.sepi;
    }
  }

  int _getWaitMinutes(QueueStatus status) {
    switch (status) {
      case QueueStatus.sepi:
        return 5;

      case QueueStatus.sedang:
        return 15;

      case QueueStatus.ramai:
        return 30;
    }
  }

  TimeOfDay? _parseTime(dynamic value) {
    if (value == null) return null;

    final text = value.toString();

    final parts = text.split(':');

    if (parts.length < 2) return null;

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

  String _calculateOpenCloseStatus(
    TimeOfDay? opening,
    TimeOfDay? closing,
  ) {
    if (opening == null || closing == null) {
      return 'closed';
    }

    final now = TimeOfDay.now();

    final nowMinutes =
        now.hour * 60 + now.minute;

    final openingMinutes =
        opening.hour * 60 + opening.minute;

    final closingMinutes =
        closing.hour * 60 + closing.minute;

    bool isOpen;

    if (openingMinutes < closingMinutes) {
      isOpen =
          nowMinutes >= openingMinutes &&
          nowMinutes < closingMinutes;
    }

    else {
      isOpen =
          nowMinutes >= openingMinutes ||
          nowMinutes < closingMinutes;
    }

    return isOpen ? 'open' : 'closed';
  }

  Future<void> loadProducts() async {
    try {
      final response = await _client
          .from('products')
          .select()
          .eq('booth_id', widget.boothId)
          .order('name');

      if (!mounted) return;

      setState(() {
        stockItems = List<Map<String, dynamic>>.from(response);
        isLoading = false;
        error = null;
      });
    } catch (e) {
      debugPrint("LOAD BOOTH PRODUCTS ERROR: $e");

      if (!mounted) return;

      setState(() {
        isLoading = false;
        error = e.toString();
      });
    }
  }

  Future<void> _changeQueueStatus(
    QueueStatus status,
  ) async {
    int waitMinutes;

    switch (status) {
      case QueueStatus.sepi:
        waitMinutes = 5;
        break;

      case QueueStatus.sedang:
        waitMinutes = 15;
        break;

      case QueueStatus.ramai:
        waitMinutes = 30;
        break;
    }

    try {
      await _client
          .from('booths')
          .update({
            'queue_status': status.name,
          })
          .eq('id', widget.boothId);

      if (!mounted) return;

      setState(() {
        queueStatus = status;
        estimatedWaitMinutes = waitMinutes;
      });

      _showUpdateMessage(
        'Status antrian diperbarui.',
      );
    } catch (e) {
      debugPrint("UPDATE QUEUE STATUS ERROR: $e");

      if (!mounted) return;

      _showUpdateMessage(
        'Gagal memperbarui status antrian.',
      );
    }
  }

  Future<void> _changeStockStatus(
    int index,
    StockStatus status,
  ) async {
    final product = stockItems[index];

    int availableStock;

    switch (status) {
      case StockStatus.tersedia:
        availableStock = 10;
        break;

      case StockStatus.terbatas:
        availableStock = 5;
        break;

      case StockStatus.habis:
        availableStock = 0;
        break;
    }

    try {
      await _client
          .from('products')
          .update({
            'stock_status': status.name,
            'available_stock': availableStock,
          })
          .eq('id', product['id']);

      if (!mounted) return;

      setState(() {
        stockItems[index]['stock_status'] = status.name;
        stockItems[index]['available_stock'] = availableStock;
      });

      _showUpdateMessage(
        '${product['name']}: ${_stockStatusLabel(status)}',
      );
    } catch (e) {
      debugPrint("UPDATE STOCK STATUS ERROR: $e");

      if (!mounted) return;

      _showUpdateMessage(
        'Gagal memperbarui status stok: $e',
      );
    }
  }

  void _showUpdateMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 1),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),

      appBar: AppBar(
        backgroundColor: Colors.white,
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

        title: const Text(
          'Booth Management',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),

        centerTitle: true,
      ),

      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          16,
          16,
          16,
          30,
        ),
        children: [

          _buildBoothHeader(),

          const SizedBox(height: 20),

          _buildSectionTitle(
            'Status Antrian',
            Icons.people_outline,
          ),

          const SizedBox(height: 10),

          _buildQueueCard(),

          const SizedBox(height: 24),

          _buildSectionTitle(
            'Status Stok',
            Icons.inventory_2_outlined,
          ),

          const SizedBox(height: 10),

          if (isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(30),
                child: CircularProgressIndicator(),
              ),
            )
          else if (error != null)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Gagal memuat product:\n$error',
                textAlign: TextAlign.center,
              ),
            )
          else if (stockItems.isEmpty)
            const Padding(
              padding: EdgeInsets.all(30),
              child: Center(
                child: Text('Belum ada product'),
              ),
            )
          else
            ...stockItems.asMap().entries.map(
              (entry) {
                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: 12,
                  ),
                  child: _buildStockCard(
                    entry.key,
                    entry.value,
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildBoothHeader() {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),

        border: Border.all(
          color: const Color(0xffE5E7EB),
        ),
      ),

      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,

            decoration: BoxDecoration(
              color: AppColor.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),

            child: Icon(
              Icons.storefront_outlined,
              color: AppColor.primary,
              size: 30,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [
                Text(
                  widget.boothName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  widget.category,
                  style: TextStyle(
                    color: AppColor.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  widget.eventName,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 8),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: openCloseStatus == 'open'
                        ? Colors.green.withOpacity(.12)
                        : Colors.red.withOpacity(.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    openCloseStatus == 'open'
                        ? 'OPEN'
                        : 'CLOSED',
                    style: TextStyle(
                      color: openCloseStatus == 'open'
                          ? Colors.green
                          : Colors.red,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),

                const SizedBox(height: 6),

              if (openingTime != null && closingTime != null)
                Text(
                  'Jam buka: ${openingTime!.format(context)} - ${closingTime!.format(context)}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(
      String title,
      IconData icon,
      ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 21,
          color: AppColor.primary,
        ),

        const SizedBox(width: 8),

        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  Widget _buildQueueCard() {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),

        border: Border.all(
          color: const Color(0xffE5E7EB),
        ),
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,

                decoration: BoxDecoration(
                  color: _queueColor(
                    queueStatus,
                  ).withOpacity(0.12),
                  borderRadius:
                  BorderRadius.circular(14),
                ),

                child: Icon(
                  Icons.people_alt_outlined,
                  color: _queueColor(
                    queueStatus,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [
                    Text(
                      _queueStatusLabel(
                        queueStatus,
                      ),
                      style: TextStyle(
                        color: _queueColor(
                          queueStatus,
                        ),
                        fontSize: 16,
                        fontWeight:
                        FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      'Estimasi tunggu ±$estimatedWaitMinutes menit',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          const Text(
            'Ubah status antrian',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: _queueButton(
                  status: QueueStatus.sepi,
                  label: 'SEPI',
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: _queueButton(
                  status: QueueStatus.sedang,
                  label: 'SEDANG',
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: _queueButton(
                  status: QueueStatus.ramai,
                  label: 'RAMAI',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _queueButton({
    required QueueStatus status,
    required String label,
  }) {
    final selected = queueStatus == status;

    return GestureDetector(
      onTap: () {
        _changeQueueStatus(status);
      },

      child: AnimatedContainer(
        duration:
        const Duration(milliseconds: 180),

        padding:
        const EdgeInsets.symmetric(
          vertical: 12,
        ),

        decoration: BoxDecoration(
          color: selected
              ? _queueColor(status)
              : Colors.grey.shade100,

          borderRadius:
          BorderRadius.circular(12),

          border: Border.all(
            color: selected
                ? _queueColor(status)
                : Colors.grey.shade300,
          ),
        ),

        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: selected
                  ? Colors.white
                  : Colors.grey.shade700,

              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }

  StockStatus _getStockStatus(Map<String, dynamic> product) {
    switch (product['stock_status']?.toString()) {
      case 'tersedia':
        return StockStatus.tersedia;

      case 'terbatas':
        return StockStatus.terbatas;

      case 'habis':
        return StockStatus.habis;

      default:
        final stock =
            int.tryParse(
              product['available_stock']?.toString() ?? '0',
            ) ??
            0;

        final isAvailable = product['is_available'] == true;

        if (!isAvailable || stock <= 0) {
          return StockStatus.habis;
        }

        if (stock <= 5) {
          return StockStatus.terbatas;
        }

        return StockStatus.tersedia;
    }
  }

  Widget _buildStockCard(
    int index,
    Map<String, dynamic> item,
  ) {
    final status = _getStockStatus(item);

    final image = item['image']?.toString() ?? '';
    final name = item['name']?.toString() ?? '-';
    final description = item['description']?.toString() ?? '';

    final price =
        int.tryParse(item['price']?.toString() ?? '0') ?? 0;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xffE5E7EB),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: image.isNotEmpty
                    ? Image.network(
                        image,
                        width: 62,
                        height: 62,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) {
                          return _imagePlaceholder();
                        },
                      )
                    : _imagePlaceholder(),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      'Rp${price.toString()}',
                      style: TextStyle(
                        color: AppColor.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              _stockStatusBadge(status),
            ],
          ),

          const SizedBox(height: 14),

          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Ubah status stok',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              Expanded(
                child: _stockButton(
                  index,
                  StockStatus.tersedia,
                  'TERSEDIA',
                ),
              ),

              const SizedBox(width: 6),

              Expanded(
                child: _stockButton(
                  index,
                  StockStatus.terbatas,
                  'TERBATAS',
                ),
              ),

              const SizedBox(width: 6),

              Expanded(
                child: _stockButton(
                  index,
                  StockStatus.habis,
                  'HABIS',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _imagePlaceholder() {
  return Container(
    width: 62,
    height: 62,
    color: Colors.grey.shade200,
    child: const Icon(
      Icons.image_outlined,
      color: Colors.grey,
    ),
  );
}

  Widget _stockButton(
    int index,
    StockStatus status,
    String label,
  ) {
    final selected =
        _getStockStatus(stockItems[index]) == status;

    return GestureDetector(
      onTap: () {
        _changeStockStatus(index, status);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: selected
              ? _stockColor(status)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected
                ? _stockColor(status)
                : Colors.grey.shade300,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: selected
                  ? Colors.white
                  : Colors.grey.shade700,
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }

  Widget _stockStatusBadge(
      StockStatus status,
      ) {
    return Container(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 6,
      ),

      decoration: BoxDecoration(
        color: _stockColor(status)
            .withOpacity(0.12),

        borderRadius:
        BorderRadius.circular(10),
      ),

      child: Text(
        _stockStatusLabel(status),
        style: TextStyle(
          color: _stockColor(status),
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Color _queueColor(
      QueueStatus status,
      ) {
    switch (status) {
      case QueueStatus.sepi:
        return Colors.green;

      case QueueStatus.sedang:
        return Colors.orange;

      case QueueStatus.ramai:
        return Colors.red;
    }
  }

  String _queueStatusLabel(
      QueueStatus status,
      ) {
    switch (status) {
      case QueueStatus.sepi:
        return 'Antrian Sepi';

      case QueueStatus.sedang:
        return 'Antrian Sedang';

      case QueueStatus.ramai:
        return 'Antrian Ramai';
    }
  }
  Color _stockColor(
      StockStatus status,
      ) {
    switch (status) {
      case StockStatus.tersedia:
        return Colors.green;

      case StockStatus.terbatas:
        return Colors.orange;

      case StockStatus.habis:
        return Colors.red;
    }
  }

  String _stockStatusLabel(
      StockStatus status,
      ) {
    switch (status) {
      case StockStatus.tersedia:
        return 'TERSEDIA';

      case StockStatus.terbatas:
        return 'TERBATAS';

      case StockStatus.habis:
        return 'HABIS';
    }
  }
}