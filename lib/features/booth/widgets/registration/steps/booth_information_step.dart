import 'package:flutter/material.dart';
import '../product_selector.dart';
import '../registration_dropdown.dart';
import '../registration_textfield.dart';
import '../section_titles.dart';

class BoothInformationStep extends StatelessWidget {
  final TextEditingController boothNameController;
  final TextEditingController descriptionController;

  final String? selectedCategory;
  final String? selectedBusinessType;

  final ValueChanged<String?> onCategoryChanged;
  final ValueChanged<String?> onBusinessTypeChanged;

  final List<ProductSelectorModel> products;

  final VoidCallback onAddProduct;

  const BoothInformationStep({
    super.key,
    required this.boothNameController,
    required this.descriptionController,
    required this.selectedCategory,
    required this.selectedBusinessType,
    required this.onCategoryChanged,
    required this.onBusinessTypeChanged,
    required this.products,
    required this.onAddProduct,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const RegistrationSectionTitle(
          title: "Booth Information",
          subtitle:
          "Complete your booth information before registering.",
        ),

        RegistrationTextField(
          label: "Booth Name",
          hint: "Enter your booth name",
          controller: boothNameController,
          requiredField: true,
        ),

        RegistrationDropdown<String>(
          label: "Category",
          hint: "Select booth category",
          value: selectedCategory,
          requiredField: true,
          onChanged: onCategoryChanged,
          items: const [

            DropdownMenuItem(
              value: "Food",
              child: Text("Food"),
            ),

            DropdownMenuItem(
              value: "Beverage",
              child: Text("Beverage"),
            ),

            DropdownMenuItem(
              value: "Fashion",
              child: Text("Fashion"),
            ),

            DropdownMenuItem(
              value: "Accessories",
              child: Text("Accessories"),
            ),

            DropdownMenuItem(
              value: "Craft",
              child: Text("Craft"),
            ),

          ],
        ),

        RegistrationDropdown<String>(
          label: "Business Type",
          hint: "Select business type",
          value: selectedBusinessType,
          requiredField: true,
          onChanged: onBusinessTypeChanged,
          items: const [

            DropdownMenuItem(
              value: "Individual",
              child: Text("Individual"),
            ),

            DropdownMenuItem(
              value: "UMKM",
              child: Text("UMKM"),
            ),

            DropdownMenuItem(
              value: "Company",
              child: Text("Company"),
            ),

          ],
        ),

        RegistrationTextField(
          label: "Description",
          hint: "Describe your booth...",
          controller: descriptionController,
          maxLines: 5,
          requiredField: true,
        ),

        ProductSelector(
          products: products,
          onAddProduct: onAddProduct,
        ),

        const SizedBox(height: 20),
      ],
    );
  }
}