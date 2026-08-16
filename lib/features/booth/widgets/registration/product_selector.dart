import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductSelectorModel {
  final String id;
  final String name;
  final String category;
  final String price;
  final String description;
  final String image;
  final int availableStock;
  final bool isAvailable;

  bool selected;

  ProductSelectorModel({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.image,
    required this.availableStock,
    required this.isAvailable,
    this.selected = false,
  });
}

class ProductSelector extends StatefulWidget {
  final List<ProductSelectorModel> products;
  final VoidCallback onAddProduct;

  const ProductSelector({
    super.key,
    required this.products,
    required this.onAddProduct,
  });

  @override
  State<ProductSelector> createState() => _ProductSelectorState();
}

class _ProductSelectorState extends State<ProductSelector> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Products",
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 14),

        if (widget.products.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.grey.shade300,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.inventory_2_outlined,
                  size: 40,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 10),
                Text(
                  "Belum ada produk",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Tambahkan produk terlebih dahulu.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          )
        else
          ...widget.products.map((product) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: product.selected
                          ? Colors.orange
                          : Colors.grey.shade300,
                    ),
                  ),
                  child: CheckboxListTile(
                    value: product.selected,
                    activeColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    secondary: product.image.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              product.image,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (_, __, ___) {
                                return const Icon(
                                  Icons.image_not_supported,
                                );
                              },
                            ),
                          )
                        : const Icon(
                            Icons.fastfood_outlined,
                            color: Colors.orange,
                          ),
                    title: Text(
                      product.name,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      "${product.category} • Rp${product.price}",
                      style: GoogleFonts.poppins(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                    onChanged: product.isAvailable
                        ? (value) {
                            setState(() {
                              product.selected = value ?? false;
                            });
                          }
                        : null,
                  ),
                ),
              ),
            );
          }),

        const SizedBox(height: 8),

        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: widget.onAddProduct,
            icon: const Icon(Icons.add),
            label: const Text("Add New Product"),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                vertical: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
      ],
    );
  }
}