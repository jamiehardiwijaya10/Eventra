import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_color.dart';
import '../../../shared/widgets/image_picker.dart';
import '../widgets/registration/registration_dropdown.dart';
import '../widgets/registration/registration_textfield.dart';
import '../widgets/registration/upload_card.dart';
import '../widgets/registration/product_selector.dart';

class AddProductPage extends StatefulWidget {
  final String? boothId;

  const AddProductPage({
    super.key,
    this.boothId,
  });

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final SupabaseClient _client = Supabase.instance.client;

  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();

  String? selectedCategory;

  Uint8List? productImage;
  bool isSaving = false;

  Future<void> pickProductImage() async {
    final image = await ImagePickerService.pickFromGallery();

    if (image == null) return;

    setState(() {
      productImage = image;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<String?> uploadProductImage() async {
    if (productImage == null) return null;

    final user = _client.auth.currentUser;

    if (user == null) {
      throw Exception("User belum login");
    }

    final fileName =
        '${user.id}/${DateTime.now().millisecondsSinceEpoch}.jpg';

    await _client.storage
        .from('product_images')
        .uploadBinary(
          fileName,
          productImage!,
          fileOptions: const FileOptions(
            contentType: 'image/jpeg',
            upsert: false,
          ),
        );

    return _client.storage
        .from('product_images')
        .getPublicUrl(fileName);
  }

  Future<void> saveProduct() async {
    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Product name tidak boleh kosong"),
        ),
      );
      return;
    }

    if (selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Category wajib dipilih"),
        ),
      );
      return;
    }

    if (priceController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Price tidak boleh kosong"),
        ),
      );
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      final user = _client.auth.currentUser;

if (user == null) {
  throw Exception("User belum login");
}

final imageUrl = await uploadProductImage();

final response = await _client
    .from('products')
    .insert({
      'owner_id': user.id,
      'booth_id': widget.boothId,
      'name': nameController.text.trim(),
      'description': descriptionController.text.trim(),
      'price': int.tryParse(priceController.text.trim()) ?? 0,
      'available_stock': 0,
      'image': imageUrl,
      'is_available': true,
      'category': selectedCategory!,
    })
    .select()
    .single();

    final product = ProductSelectorModel(
      id: response['id'].toString(),
      name: response['name'].toString(),
      category: response['category']?.toString() ?? '',
      price: response['price'].toString(),
      description: response['description']?.toString() ?? '',
      image: response['image']?.toString() ?? '',
      availableStock:
          int.tryParse(response['available_stock'].toString()) ?? 0,
      isAvailable: response['is_available'] == true,
    );

    if (!mounted) return;
    Navigator.pop(context, product);

    } catch (e) {
      if (!mounted) return;

      setState(() {
        isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal menyimpan product: $e"),
        ),
      );
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),

      appBar: AppBar(
        title: const Text("Add Product"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
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

            UploadCard(
              title: "Upload Product Image",
              subtitle: "JPG, PNG (Max 5 MB)",
              image: productImage,
              onTap: pickProductImage,
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: isSaving ? null : saveProduct,

                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primary,
                  disabledBackgroundColor:
                      AppColor.primary.withOpacity(.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),

                child: isSaving
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
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