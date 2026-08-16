import 'package:flutter/material.dart';
import '../../../../core/services/booth_service.dart';
import '../../../../core/theme/app_color.dart';
import 'edit_products_page.dart';
import '../add_product_page.dart';

class BoothProductsPage extends StatefulWidget {
  final String boothId;

  const BoothProductsPage({
    super.key,
    required this.boothId,
  });

  @override
  State<BoothProductsPage> createState() => _BoothProductsPageState();
}

class _BoothProductsPageState extends State<BoothProductsPage> {
  final BoothService _boothService = BoothService();

  List<Map<String, dynamic>> products = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      final data = await _boothService.getBoothProducts(
        widget.boothId,
      );

      if (!mounted) return;

      setState(() {
        products = data;
        isLoading = false;
        error = null;
      });
    } catch (e) {
      debugPrint("LOAD BOOTH PRODUCTS ERROR: $e");

      if (!mounted) return;

      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> deleteProduct(
    Map<String, dynamic> product,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Product"),
          content: Text(
            'Hapus "${product['name']}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    try {
      await _boothService.deleteProduct(
        productId: product['id'].toString(),
        imageUrl: product['image']?.toString(),
      );

      await loadProducts();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Product berhasil dihapus"),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal menghapus product: $e"),
        ),
      );
    }
  }

  Future<void> openAddProduct() async {
    final added = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddProductPage(
          boothId: widget.boothId,
        ),
      ),
    );

    if (added == true) {
      await loadProducts();
    }
  }

  Future<void> openEditProduct(
    Map<String, dynamic> product,
  ) async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditProductPage(
          product: product,
        ),
      ),
    );

    if (updated == true) {
      await loadProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
        centerTitle: true,
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.primary,
        onPressed: () async {
          final added = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddProductPage(
                boothId: widget.boothId,
              ),
            ),
          );

          if (added != null) {
            await loadProducts();
          }
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),

      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (error != null) {
      return Center(
        child: Text(
          "Gagal memuat products\n\n$error",
          textAlign: TextAlign.center,
        ),
      );
    }

    if (products.isEmpty) {
      return RefreshIndicator(
        onRefresh: loadProducts,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 300),
            Center(
              child: Text("Belum ada product"),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: loadProducts,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              onTap: () => openEditProduct(product),

              contentPadding: const EdgeInsets.all(12),

              leading: _productImage(
                product['image']?.toString(),
              ),

              title: Text(
                product['name']?.toString() ?? '-',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              subtitle: Text(
                "${product['category'] ?? '-'}\n"
                "Rp${product['price'] ?? 0}",
              ),

              isThreeLine: true,

              trailing: PopupMenuButton<String>(
                onSelected: (value) async {
                  if (value == 'delete') {
                    await deleteProduct(product);
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        SizedBox(width: 8),
                        Text("Delete"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _productImage(String? image) {
    if (image == null || image.isEmpty) {
      return Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(
          Icons.fastfood_outlined,
          color: Colors.orange,
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        image,
        width: 60,
        height: 60,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return Container(
            width: 60,
            height: 60,
            color: Colors.grey.shade200,
            child: const Icon(
              Icons.broken_image,
            ),
          );
        },
      ),
    );
  }
}