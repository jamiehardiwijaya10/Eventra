import 'dart:io';
import 'package:flutter/material.dart';
import '../../../core/theme/app_color.dart';
import '../widgets/registration/registration_dropdown.dart';
import '../widgets/registration/registration_textfield.dart';
import '../widgets/registration/upload_card.dart';
import '../widgets/registration/product_selector.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {

  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();

  String? selectedCategory;

  File? productImage;

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void saveProduct() {

    if (nameController.text.isEmpty) return;

    final product = ProductSelectorModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: nameController.text,
      price: priceController.text,
    );

    Navigator.pop(context, product);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xffF7F8FA),

      appBar: AppBar(
        title: const Text("Add Product"),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            RegistrationTextField(
              label: "Product Name",
              hint: "Cheeseburger",
              controller: nameController,
              requiredField: true,
            ),

            RegistrationDropdown<String>(
              label: "Category",
              hint: "Choose category",
              value: selectedCategory,

              items: const [

                DropdownMenuItem(
                  value: "Food",
                  child: Text("Food"),
                ),

                DropdownMenuItem(
                  value: "Drink",
                  child: Text("Drink"),
                ),

                DropdownMenuItem(
                  value: "Snack",
                  child: Text("Snack"),
                ),

              ],

              onChanged: (value) {

                setState(() {

                  selectedCategory = value;

                });

              },

              requiredField: true,
            ),

            RegistrationTextField(
              label: "Price",
              hint: "25000",
              controller: priceController,
              keyboardType: TextInputType.number,
              requiredField: true,
            ),

            RegistrationTextField(
              label: "Description",
              hint: "Describe your product...",
              controller: descriptionController,
              maxLines: 4,
            ),

            // UploadCard(
            //   title: "Upload Product Image",
            //   subtitle: "JPG, PNG (Max 5 MB)",
            //   image: productImage,
            //   onTap: () {},
            // ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(

                onPressed: saveProduct,

                style: ElevatedButton.styleFrom(

                  backgroundColor: AppColor.primary,

                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                  ),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),

                child: const Text(
                  "Save Product",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

          ],
        ),
      ),
    );
  }
}