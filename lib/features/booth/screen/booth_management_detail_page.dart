import 'package:flutter/material.dart';

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

class _BoothManagementDetailPageState
    extends State<BoothManagementDetailPage> {

  QueueStatus queueStatus = QueueStatus.sepi;

  int estimatedWaitMinutes = 5;

  final List<_StockItem> stockItems = [
    _StockItem(
      id: '1',
      name: 'Big Mac',
      description: 'Burger sapi dengan saus spesial.',
      image: 'assets/images/burger.png',
      price: 'Rp45.000',
      status: StockStatus.tersedia,
    ),
    _StockItem(
      id: '2',
      name: 'French Fries',
      description: 'Kentang goreng renyah.',
      image: 'assets/images/burger.png',
      price: 'Rp20.000',
      status: StockStatus.tersedia,
    ),
    _StockItem(
      id: '3',
      name: 'McFlurry',
      description: 'Es krim dengan topping.',
      image: 'assets/images/burger.png',
      price: 'Rp15.000',
      status: StockStatus.terbatas,
    ),
    _StockItem(
      id: '4',
      name: 'Chicken Burger',
      description: 'Burger ayam crispy.',
      image: 'assets/images/burger.png',
      price: 'Rp35.000',
      status: StockStatus.habis,
    ),
  ];

  void _changeQueueStatus(QueueStatus status) {
    setState(() {
      queueStatus = status;

      switch (status) {
        case QueueStatus.sepi:
          estimatedWaitMinutes = 5;
          break;

        case QueueStatus.sedang:
          estimatedWaitMinutes = 15;
          break;

        case QueueStatus.ramai:
          estimatedWaitMinutes = 30;
          break;
      }
    });

    _showUpdateMessage(
      'Status antrian diperbarui.',
    );
  }

  void _changeStockStatus(
      int index,
      StockStatus status,
      ) {
    setState(() {
      stockItems[index].status = status;
    });

    _showUpdateMessage(
      '${stockItems[index].name}: ${_stockStatusLabel(status)}',
    );
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

  Widget _buildStockCard(
      int index,
      _StockItem item,
      ) {
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
                borderRadius:
                BorderRadius.circular(12),

                child: Image.asset(
                  item.image,
                  width: 62,
                  height: 62,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (_, __, ___) {
                    return Container(
                      width: 62,
                      height: 62,
                      color: Colors.grey.shade200,
                      child: const Icon(
                        Icons.image_outlined,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight:
                        FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      item.price,
                      style: TextStyle(
                        color: AppColor.primary,
                        fontSize: 13,
                        fontWeight:
                        FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      item.description,
                      maxLines: 1,
                      overflow:
                      TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              _stockStatusBadge(
                item.status,
              ),
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

  Widget _stockButton(
      int index,
      StockStatus status,
      String label,
      ) {
    final selected =
        stockItems[index].status == status;

    return GestureDetector(
      onTap: () {
        _changeStockStatus(
          index,
          status,
        );
      },

      child: AnimatedContainer(
        duration:
        const Duration(milliseconds: 180),

        padding:
        const EdgeInsets.symmetric(
          vertical: 10,
        ),

        decoration: BoxDecoration(
          color: selected
              ? _stockColor(status)
              : Colors.grey.shade100,

          borderRadius:
          BorderRadius.circular(10),

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

class _StockItem {
  final String id;
  final String name;
  final String description;
  final String image;
  final String price;

  StockStatus status;

  _StockItem({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.status,
  });
}