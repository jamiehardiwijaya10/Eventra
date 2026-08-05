import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductSelectorModel {
  final String id;
  final String name;
  final String price;
  bool selected;

  ProductSelectorModel({
    required this.id,
    required this.name,
    required this.price,
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
  State<ProductSelector> createState() =>
      _ProductSelectorState();
}

class _ProductSelectorState
    extends State<ProductSelector> {

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

        ...widget.products.map((product) {

          return Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),

            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.grey.shade300,
                  ),
                ),

              child: CheckboxListTile(

                value: product.selected,

                activeColor: Colors.orange,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),

                title: Text(
                  product.name,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                subtitle: Text(
                  product.price,
                  style: GoogleFonts.poppins(
                    color: Colors.grey.shade600,
                  ),
                ),

                onChanged: (value) {

                  setState(() {

                    product.selected = value!;

                  });
                },
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